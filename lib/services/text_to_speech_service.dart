/// Text-to-speech service using the system TTS engine (flutter_tts).
///
/// Wraps [FlutterTts] to provide a simple API for synthesizing text to an
/// audio file. Uses the platform's built-in voices — no API key required.
library;

import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

final _log = Logger('TextToSpeechService');

class TextToSpeechService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  /// Initialize TTS engine with sensible defaults.
  Future<void> init() async {
    if (_initialized) return;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      if (Platform.isIOS) {
        await _tts.setSharedInstance(true);
        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.ambient,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ],
        );
      }
      _initialized = true;
      _log.info('TTS initialized');
    } catch (e) {
      _log.warning('TTS init failed: $e');
    }
  }

  /// Synthesize [text] and write the result to a temp WAV file.
  ///
  /// Returns the file path on success, or null if synthesis failed.
  /// The caller is responsible for deleting the file after use.
  Future<String?> synthesizeToFile(String text) async {
    await init();
    try {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.wav';

      final completer = _CompletionCompleter();
      _tts.setCompletionHandler(() => completer.complete());
      _tts.setErrorHandler((msg) => completer.completeError(msg));

      final result = await _tts.synthesizeToFile(text, path);
      if (result != 1) {
        _log.warning('TTS synthesizeToFile returned $result');
        return null;
      }

      // Wait for completion (timeout after 30s)
      await completer.future.timeout(const Duration(seconds: 30));

      final file = File(path);
      if (!await file.exists()) {
        _log.warning('TTS output file not found: $path');
        return null;
      }

      _log.info('TTS synthesized ${text.length} chars → $path');
      return path;
    } catch (e) {
      _log.warning('TTS synthesis failed: $e');
      return null;
    }
  }

  /// Set the TTS language (BCP-47, e.g. 'es-ES', 'en-US').
  Future<void> setLanguage(String lang) async {
    await init();
    try {
      await _tts.setLanguage(lang);
    } catch (e) {
      _log.warning('TTS setLanguage failed: $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}

/// Simple completer wrapper to await TTS completion callbacks.
class _CompletionCompleter {
  final _c = <void Function()>[];
  final _e = <void Function(Object)>[];
  bool _done = false;
  Object? _error;

  void complete() {
    _done = true;
    for (final cb in _c) {
      cb();
    }
  }

  void completeError(Object err) {
    _error = err;
    for (final cb in _e) {
      cb(err);
    }
  }

  Future<void> get future async {
    if (_done) return;
    if (_error != null) throw _error!;
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_error != null) throw _error!;
      return !_done;
    });
  }
}
