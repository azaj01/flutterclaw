/// Headless browser tool for FlutterClaw.
///
/// Uses flutter_inappwebview's HeadlessInAppWebView to navigate web pages
/// with full JavaScript support, without any visible UI.
///
/// Provides a persistent browser session with actions: navigate, js, click,
/// type, get_content, scroll, back, forward, close.
library;

import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'registry.dart';

/// Headless browser tool — full JS-capable web navigation without UI.
///
/// The agent can open pages, execute JavaScript, interact with elements,
/// and extract rendered content from SPAs and JS-heavy sites.
class HeadlessBrowserTool extends Tool {
  HeadlessInAppWebView? _headless;
  InAppWebViewController? _controller;
  Completer<void>? _pageLoadCompleter;
  String? _currentUrl;
  String? _lastError;

  @override
  String get name => 'web_browse';

  @override
  String get description =>
      'Headless browser with full JavaScript support. Navigate web pages, '
      'execute JS, click elements, type text, and extract rendered content '
      'from SPAs and JS-heavy sites. Maintains a persistent browser session.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'action': {
            'type': 'string',
            'enum': [
              'navigate',
              'js',
              'click',
              'type',
              'get_content',
              'get_html',
              'scroll',
              'back',
              'forward',
              'close',
            ],
            'description':
                'Action to perform.\n'
                '- navigate: Load a URL (params: url, wait_ms)\n'
                '- js: Execute JavaScript (params: script)\n'
                '- click: Click element by CSS selector (params: selector)\n'
                '- type: Type text into element (params: selector, text)\n'
                '- get_content: Get page text content as markdown\n'
                '- get_html: Get raw HTML of current page\n'
                '- scroll: Scroll the page (params: direction, amount)\n'
                '- back: Navigate back\n'
                '- forward: Navigate forward\n'
                '- close: Close the browser session',
          },
          'url': {
            'type': 'string',
            'description': 'URL to navigate to (for "navigate" action).',
          },
          'script': {
            'type': 'string',
            'description': 'JavaScript code to execute (for "js" action).',
          },
          'selector': {
            'type': 'string',
            'description':
                'CSS selector for target element (for "click"/"type" actions).',
          },
          'text': {
            'type': 'string',
            'description': 'Text to type (for "type" action).',
          },
          'wait_ms': {
            'type': 'integer',
            'description':
                'Extra milliseconds to wait after page load for JS to settle '
                '(default: 2000). Use higher values for heavy SPAs.',
          },
          'direction': {
            'type': 'string',
            'enum': ['down', 'up'],
            'description': 'Scroll direction (default: down).',
          },
          'amount': {
            'type': 'integer',
            'description': 'Scroll amount in pixels (default: 500).',
          },
          'max_chars': {
            'type': 'integer',
            'description':
                'Maximum characters to return for content/html (default: 50000).',
          },
        },
        'required': ['action'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final action = args['action'] as String?;
    if (action == null) return ToolResult.error('action is required');

    try {
      return switch (action) {
        'navigate' => await _navigate(args),
        'js' => await _executeJs(args),
        'click' => await _click(args),
        'type' => await _typeText(args),
        'get_content' => await _getContent(args),
        'get_html' => await _getHtml(args),
        'scroll' => await _scroll(args),
        'back' => await _goBack(),
        'forward' => await _goForward(),
        'close' => await _close(),
        _ => ToolResult.error('Unknown action: $action'),
      };
    } catch (e) {
      return ToolResult.error('Browser error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<ToolResult> _navigate(Map<String, dynamic> args) async {
    final urlStr = args['url'] as String?;
    if (urlStr == null || urlStr.isEmpty) {
      return ToolResult.error('url is required for navigate action');
    }
    final waitMs = args['wait_ms'] as int? ?? 2000;

    await _ensureBrowser();

    _pageLoadCompleter = Completer<void>();
    _lastError = null;

    await _controller!.loadUrl(
      urlRequest: URLRequest(url: WebUri(urlStr)),
    );

    // Wait for page load with timeout
    await _pageLoadCompleter!.future
        .timeout(const Duration(seconds: 30), onTimeout: () {});

    // Extra wait for JS frameworks to render
    if (waitMs > 0) {
      await Future<void>.delayed(Duration(milliseconds: waitMs));
    }

    _currentUrl = (await _controller!.getUrl())?.toString() ?? urlStr;
    final title = await _controller!.getTitle() ?? '';

    final result = StringBuffer();
    result.writeln('Navigated to: $_currentUrl');
    if (title.isNotEmpty) result.writeln('Title: $title');
    if (_lastError != null) result.writeln('Page error: $_lastError');

    return ToolResult.success(result.toString().trim());
  }

  Future<ToolResult> _executeJs(Map<String, dynamic> args) async {
    final script = args['script'] as String?;
    if (script == null || script.isEmpty) {
      return ToolResult.error('script is required for js action');
    }

    if (_controller == null) {
      return ToolResult.error('No browser session. Use navigate first.');
    }

    final result = await _controller!.evaluateJavascript(source: script);
    final output = result?.toString() ?? 'null';
    return ToolResult.success(output);
  }

  Future<ToolResult> _click(Map<String, dynamic> args) async {
    final selector = args['selector'] as String?;
    if (selector == null || selector.isEmpty) {
      return ToolResult.error('selector is required for click action');
    }

    if (_controller == null) {
      return ToolResult.error('No browser session. Use navigate first.');
    }

    final escaped = selector.replaceAll("'", "\\'");
    final result = await _controller!.evaluateJavascript(source: '''
      (function() {
        var el = document.querySelector('$escaped');
        if (!el) return 'ERROR: Element not found: $escaped';
        el.click();
        return 'Clicked: ' + (el.tagName || '') + ' ' + (el.textContent || '').substring(0, 100).trim();
      })();
    ''');

    final output = result?.toString() ?? 'null';
    if (output.startsWith('ERROR:')) return ToolResult.error(output);
    return ToolResult.success(output);
  }

  Future<ToolResult> _typeText(Map<String, dynamic> args) async {
    final selector = args['selector'] as String?;
    final text = args['text'] as String?;
    if (selector == null || selector.isEmpty) {
      return ToolResult.error('selector is required for type action');
    }
    if (text == null) {
      return ToolResult.error('text is required for type action');
    }

    if (_controller == null) {
      return ToolResult.error('No browser session. Use navigate first.');
    }

    final escapedSelector = selector.replaceAll("'", "\\'");
    final escapedText = text.replaceAll("'", "\\'").replaceAll('\n', '\\n');
    final result = await _controller!.evaluateJavascript(source: '''
      (function() {
        var el = document.querySelector('$escapedSelector');
        if (!el) return 'ERROR: Element not found: $escapedSelector';
        el.focus();
        el.value = '$escapedText';
        el.dispatchEvent(new Event('input', {bubbles: true}));
        el.dispatchEvent(new Event('change', {bubbles: true}));
        return 'Typed ' + '${text.length}' + ' chars into: ' + (el.tagName || '');
      })();
    ''');

    final output = result?.toString() ?? 'null';
    if (output.startsWith('ERROR:')) return ToolResult.error(output);
    return ToolResult.success(output);
  }

  Future<ToolResult> _getContent(Map<String, dynamic> args) async {
    if (_controller == null) {
      return ToolResult.error('No browser session. Use navigate first.');
    }
    final maxChars = args['max_chars'] as int? ?? 50000;

    // Extract readable text content via JS, converting to markdown-like format
    final result = await _controller!.evaluateJavascript(source: '''
      (function() {
        function nodeToMd(node) {
          if (node.nodeType === 3) return node.textContent;
          if (node.nodeType !== 1) return '';
          var tag = node.tagName.toLowerCase();
          if (['script','style','noscript','svg','path'].includes(tag)) return '';
          if (tag === 'br') return '\\n';
          var children = Array.from(node.childNodes).map(nodeToMd).join('');
          switch(tag) {
            case 'h1': return '\\n# ' + children.trim() + '\\n';
            case 'h2': return '\\n## ' + children.trim() + '\\n';
            case 'h3': return '\\n### ' + children.trim() + '\\n';
            case 'h4': return '\\n#### ' + children.trim() + '\\n';
            case 'h5': return '\\n##### ' + children.trim() + '\\n';
            case 'h6': return '\\n###### ' + children.trim() + '\\n';
            case 'p': return '\\n' + children.trim() + '\\n';
            case 'li': return '- ' + children.trim() + '\\n';
            case 'a':
              var href = node.getAttribute('href') || '';
              var text = children.trim();
              return href ? '[' + text + '](' + href + ')' : text;
            case 'img':
              var alt = node.getAttribute('alt') || '';
              var src = node.getAttribute('src') || '';
              return alt ? '![' + alt + '](' + src + ')' : '';
            case 'code': return '`' + children + '`';
            case 'pre': return '\\n```\\n' + children.trim() + '\\n```\\n';
            case 'blockquote': return '\\n> ' + children.trim() + '\\n';
            case 'strong': case 'b': return '**' + children.trim() + '**';
            case 'em': case 'i': return '*' + children.trim() + '*';
            case 'div': case 'section': case 'article': case 'main':
              return '\\n' + children;
            default: return children;
          }
        }
        var body = document.body || document.documentElement;
        if (!body) return '';
        return nodeToMd(body)
          .replace(/\\n{3,}/g, '\\n\\n')
          .trim();
      })();
    ''');

    var content = result?.toString() ?? '';
    if (content.length > maxChars) {
      content = '${content.substring(0, maxChars)}\n\n[... truncated]';
    }

    final url = (await _controller!.getUrl())?.toString() ?? '';
    final title = await _controller!.getTitle() ?? '';

    final buf = StringBuffer();
    if (url.isNotEmpty) buf.writeln('URL: $url');
    if (title.isNotEmpty) buf.writeln('Title: $title');
    buf.writeln('---');
    buf.write(content);
    return ToolResult.success(buf.toString());
  }

  Future<ToolResult> _getHtml(Map<String, dynamic> args) async {
    if (_controller == null) {
      return ToolResult.error('No browser session. Use navigate first.');
    }
    final maxChars = args['max_chars'] as int? ?? 50000;

    final result = await _controller!.evaluateJavascript(
      source: 'document.documentElement.outerHTML;',
    );

    var html = result?.toString() ?? '';
    if (html.length > maxChars) {
      html = '${html.substring(0, maxChars)}\n\n[... truncated]';
    }
    return ToolResult.success(html);
  }

  Future<ToolResult> _scroll(Map<String, dynamic> args) async {
    if (_controller == null) {
      return ToolResult.error('No browser session. Use navigate first.');
    }
    final direction = args['direction'] as String? ?? 'down';
    final amount = args['amount'] as int? ?? 500;
    final pixels = direction == 'up' ? -amount : amount;

    await _controller!.evaluateJavascript(
      source: 'window.scrollBy(0, $pixels);',
    );

    final pos = await _controller!.evaluateJavascript(
      source: 'Math.round(window.scrollY) + "/" + Math.round(document.body.scrollHeight)',
    );
    return ToolResult.success('Scrolled ${direction == "up" ? "up" : "down"} ${amount}px. Position: $pos');
  }

  Future<ToolResult> _goBack() async {
    if (_controller == null) {
      return ToolResult.error('No browser session. Use navigate first.');
    }
    if (await _controller!.canGoBack()) {
      await _controller!.goBack();
      await Future<void>.delayed(const Duration(seconds: 1));
      _currentUrl = (await _controller!.getUrl())?.toString();
      return ToolResult.success('Navigated back to: $_currentUrl');
    }
    return ToolResult.error('Cannot go back — no history.');
  }

  Future<ToolResult> _goForward() async {
    if (_controller == null) {
      return ToolResult.error('No browser session. Use navigate first.');
    }
    if (await _controller!.canGoForward()) {
      await _controller!.goForward();
      await Future<void>.delayed(const Duration(seconds: 1));
      _currentUrl = (await _controller!.getUrl())?.toString();
      return ToolResult.success('Navigated forward to: $_currentUrl');
    }
    return ToolResult.error('Cannot go forward — no forward history.');
  }

  Future<ToolResult> _close() async {
    if (_headless != null) {
      await _headless!.dispose();
      _headless = null;
      _controller = null;
      _currentUrl = null;
      _lastError = null;
      return ToolResult.success('Browser session closed.');
    }
    return ToolResult.success('No browser session to close.');
  }

  // ---------------------------------------------------------------------------
  // Browser lifecycle
  // ---------------------------------------------------------------------------

  Future<void> _ensureBrowser() async {
    if (_headless != null && _controller != null) return;

    // Dispose any stale instance
    if (_headless != null) {
      await _headless!.dispose();
      _headless = null;
      _controller = null;
    }

    final completer = Completer<void>();

    _headless = HeadlessInAppWebView(
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        domStorageEnabled: true,
        databaseEnabled: true,
        userAgent:
            'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) '
            'AppleWebKit/605.1.15 (KHTML, like Gecko) '
            'Version/17.0 Mobile/15E148 Safari/604.1',
        // Allow mixed content for compatibility
        mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
        // Disable media autoplay
        mediaPlaybackRequiresUserGesture: true,
      ),
      onWebViewCreated: (controller) {
        _controller = controller;
        if (!completer.isCompleted) completer.complete();
      },
      onLoadStop: (controller, url) {
        if (_pageLoadCompleter != null && !_pageLoadCompleter!.isCompleted) {
          _pageLoadCompleter!.complete();
        }
      },
      onReceivedError: (controller, request, error) {
        _lastError = '${error.type}: ${error.description}';
        if (_pageLoadCompleter != null && !_pageLoadCompleter!.isCompleted) {
          _pageLoadCompleter!.complete();
        }
      },
      onConsoleMessage: (controller, message) {
        // Silently ignore console messages
      },
    );

    await _headless!.run();
    await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {},
    );
  }

  /// Dispose the browser when the tool is no longer needed.
  Future<void> dispose() async {
    await _close();
  }
}
