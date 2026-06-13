/// Bootstrap agent runtime for foreground-service / background isolates.
library;

import 'dart:async';

import 'package:flutterclaw/channels/channel_interface.dart';
import 'package:flutterclaw/channels/discord.dart';
import 'package:flutterclaw/channels/router.dart';
import 'package:flutterclaw/channels/signal.dart';
import 'package:flutterclaw/channels/slack.dart';
import 'package:flutterclaw/channels/telegram.dart';
import 'package:flutterclaw/channels/whatsapp.dart';
import 'package:flutterclaw/core/agent/agent_loop.dart';
import 'package:flutterclaw/core/agent/message_queue.dart';
import 'package:flutterclaw/core/agent/provider_router.dart';
import 'package:flutterclaw/core/agent/session_manager.dart';
import 'package:flutterclaw/core/agent/subagent_registry.dart';
import 'package:flutterclaw/core/gateway/gateway_server.dart';
import 'package:flutterclaw/core/providers/openai_provider.dart';
import 'package:flutterclaw/core/runtime/config_secrets.dart';
import 'package:flutterclaw/data/models/config.dart';
import 'package:flutterclaw/services/cron_service.dart';
import 'package:flutterclaw/services/overlay_service.dart';
import 'package:flutterclaw/services/pairing_service.dart';
import 'package:flutterclaw/tools/fs_tools.dart';
import 'package:flutterclaw/tools/http_tools.dart';
import 'package:flutterclaw/tools/memory_tools.dart';
import 'package:flutterclaw/tools/message_tool.dart';
import 'package:flutterclaw/tools/registry.dart';
import 'package:flutterclaw/tools/sandbox_tools.dart';
import 'package:flutterclaw/tools/session_tools.dart';
import 'package:flutterclaw/tools/tool_status_formatter.dart';
import 'package:flutterclaw/tools/web_tools.dart';
import 'package:flutterclaw/services/sandbox_service.dart';
import 'package:logging/logging.dart';

final _log = Logger('flutterclaw.isolate_runtime');

/// Fully wired runtime for background gateway + channels + agent loop.
class IsolateRuntime {
  IsolateRuntime({
    required this.configManager,
    required this.sessionManager,
    required this.toolRegistry,
    required this.agentLoop,
    required this.messageQueue,
    required this.gateway,
    required this.channelRouter,
    required this.cronService,
  });

  final ConfigManager configManager;
  final SessionManager sessionManager;
  final ToolRegistry toolRegistry;
  final AgentLoop agentLoop;
  final MessageQueue messageQueue;
  final GatewayServer gateway;
  final ChannelRouter channelRouter;
  final CronService cronService;

  Future<void> startChannels() async {
    await channelRouter.start();
  }

  Future<void> stop() async {
    await channelRouter.stop();
    cronService.stop();
    await gateway.stop();
    sessionManager.dispose();
  }

  /// Build and start gateway + channels in a non-UI isolate.
  static Future<IsolateRuntime> bootstrap({
    OverlayService? overlayService,
  }) async {
    final configManager = ConfigManager();
    wireConfigSecrets(configManager);
    await configManager.ensureDirectories();
    await configManager.load();
    await configManager.ensureGatewayToken();

    final sessionManager = SessionManager(configManager);
    await sessionManager.load();

    final toolRegistry = _buildToolRegistry(configManager);
    final providerRouter = FailoverProviderRouter(
      configManager: configManager,
      primary: OpenAiProvider(),
    );
    final overlay = overlayService ?? OverlayService();

    final agentLoop = AgentLoop(
      configManager: configManager,
      providerRouter: providerRouter,
      toolRegistry: toolRegistry,
      sessionManager: sessionManager,
      onToolStatus: (toolName, args, {bool isDone = false}) {
        if (isDone) return;
        overlay
            .show(formatFriendlyToolStatus(toolName, args))
            .catchError((_) {});
      },
    );

    final messageQueue = MessageQueue(
      onRun: (message) => agentLoop.processMessage(
        message.sessionKey,
        message.text,
        channelType: message.channelType,
        chatId: message.chatId,
        contentBlocks: message.contentBlocks,
        channelContext: message.channelContext,
        onIntermediateMessage: message.onIntermediateMessage,
      ),
    );

    SubagentLoopProxy.instance.bind((sessionKey, task) async {
      final response = await messageQueue.enqueueText(
        sessionKey: sessionKey,
        text: task,
      );
      return response.content;
    });

    final pairingService = PairingService(configManager: configManager);
    final channelRouter = _buildChannelRouter(
      configManager: configManager,
      messageQueue: messageQueue,
      pairingService: pairingService,
    );

    // Bind MessageTool send callback.
    toolRegistry.register(
      MessageTool(({
        required String channel,
        required String target,
        required String text,
        String? action,
        String? targetMessageId,
        String? emoji,
        String? participantId,
        bool? fromMe,
      }) async {
        await channelRouter.sendMessage(
          OutgoingMessage(
            channelType: channel,
            chatId: target,
            text: text,
            action: action,
            targetMessageId: targetMessageId,
            emoji: emoji,
            participantId: participantId,
            fromMe: fromMe,
          ),
        );
      }),
    );

    final cronService = CronService(configManager: configManager);
    await cronService.start();

    final gateway = GatewayServer(
      configManager: configManager,
      agentLoop: agentLoop,
      messageQueue: messageQueue,
      sessionManager: sessionManager,
      toolRegistry: toolRegistry,
      cronService: cronService,
    );
    await gateway.start();

    final runtime = IsolateRuntime(
      configManager: configManager,
      sessionManager: sessionManager,
      toolRegistry: toolRegistry,
      agentLoop: agentLoop,
      messageQueue: messageQueue,
      gateway: gateway,
      channelRouter: channelRouter,
      cronService: cronService,
    );

    await runtime.startChannels();
    _log.info('IsolateRuntime bootstrap complete');
    return runtime;
  }
}

ToolRegistry _buildToolRegistry(ConfigManager configManager) {
  final registry = ToolRegistry();
  registry.setConfigManager(configManager);
  registry.setDisabledTools(configManager.config.tools.disabled);

  Future<String> wsPath() => configManager.workspacePath;

  registry.register(ReadFileTool(wsPath));
  registry.register(WriteFileTool(wsPath));
  registry.register(EditFileTool(wsPath));
  registry.register(ListDirTool(wsPath));
  registry.register(AppendFileTool(wsPath));
  registry.register(WebSearchTool(config: configManager.config));
  registry.register(HttpRequestTool());
  registry.register(MemorySearchTool(wsPath));
  registry.register(MemoryGetTool(wsPath));
  registry.register(MemoryWriteTool(wsPath));
  registry.register(SessionStatusTool((_) async => null));
  registry.register(SessionsListTool(({int? limit}) async => []));
  registry.register(RunShellCommandTool(SandboxService()));

  return registry;
}

ChannelRouter _buildChannelRouter({
  required ConfigManager configManager,
  required MessageQueue messageQueue,
  required PairingService pairingService,
}) {
  late final ChannelRouter router;
  router = ChannelRouter(
    agentHandler: (IncomingMessage msg) async {
      final response = await messageQueue.enqueue(
        QueuedMessage(
          sessionKey: msg.sessionKey,
          text: msg.text,
          channelType: msg.channelType,
          chatId: msg.chatId,
          contentBlocks: msg.contentBlocks,
          channelContext: msg.channelContext,
          onIntermediateMessage: (text) => router.sendMessage(
            OutgoingMessage(
              channelType: msg.channelType,
              chatId: msg.chatId,
              text: text,
            ),
          ),
        ),
      );
      await router.sendMessage(
        OutgoingMessage(
          channelType: msg.channelType,
          chatId: msg.chatId,
          text: response.content,
        ),
      );
    },
  );

  final config = configManager.config;
  final telegram = config.channels.telegram;
  if (telegram.enabled &&
      telegram.token != null &&
      telegram.token!.isNotEmpty) {
    router.registerAdapter(
      TelegramChannelAdapter(
        token: telegram.token!,
        allowedUserIds: telegram.allowFrom,
        dmPolicy: telegram.dmPolicy,
        pairingService: pairingService,
        typingMode: config.agents.defaults.typingMode,
      ),
    );
  }

  final discord = config.channels.discord;
  if (discord.enabled && discord.token != null && discord.token!.isNotEmpty) {
    router.registerAdapter(
      DiscordChannelAdapter(
        token: discord.token!,
        allowedUserIds: discord.allowFrom,
        dmPolicy: discord.dmPolicy,
        pairingService: pairingService,
      ),
    );
  }

  final slack = config.channels.slack;
  if (slack.enabled &&
      slack.botToken != null &&
      slack.botToken!.isNotEmpty &&
      slack.appToken != null &&
      slack.appToken!.isNotEmpty) {
    router.registerAdapter(
      SlackChannelAdapter(
        botToken: slack.botToken!,
        appToken: slack.appToken!,
        allowedUserIds: slack.allowFrom,
      ),
    );
  }

  final signal = config.channels.signal;
  if (signal.enabled &&
      signal.apiUrl != null &&
      signal.apiUrl!.isNotEmpty &&
      signal.account != null &&
      signal.account!.isNotEmpty) {
    router.registerAdapter(
      SignalChannelAdapter(
        apiUrl: signal.apiUrl!,
        account: signal.account!,
        allowedNumbers: signal.allowFrom,
      ),
    );
  }

  final whatsapp = config.channels.whatsapp;
  if (whatsapp.enabled) {
    unawaited(() async {
      if (await WhatsAppChannelAdapter.hasLinkedAuth(whatsapp.authDir)) {
        router.registerAdapter(
          WhatsAppChannelAdapter(
            authDir: whatsapp.authDir,
            allowedUserIds: whatsapp.allowFrom,
            dmPolicy: whatsapp.dmPolicy,
            selfChatMode: whatsapp.selfChatMode,
            pairingService: pairingService,
          ),
        );
      }
    }());
  }

  return router;
}
