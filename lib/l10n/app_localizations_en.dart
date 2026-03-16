// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Chat';

  @override
  String get channels => 'Channels';

  @override
  String get agent => 'Agent';

  @override
  String get settings => 'Settings';

  @override
  String get getStarted => 'Get Started';

  @override
  String get yourPersonalAssistant => 'Your personal AI assistant';

  @override
  String get multiChannelChat => 'Multi-channel chat';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat and more';

  @override
  String get powerfulAIModels => 'Powerful AI models';

  @override
  String get powerfulAIModelsDesc => 'OpenAI, Anthropic, Grok, and free models';

  @override
  String get localGateway => 'Local gateway';

  @override
  String get localGatewayDesc => 'Runs on your device, your data stays yours';

  @override
  String get chooseProvider => 'Choose a Provider';

  @override
  String get selectProviderDesc =>
      'Select how you want to connect to AI models.';

  @override
  String get startForFree => 'Start for Free';

  @override
  String get freeProvidersDesc =>
      'These providers offer free models to get you started with no cost.';

  @override
  String get free => 'FREE';

  @override
  String get otherProviders => 'Other Providers';

  @override
  String connectToProvider(String provider) {
    return 'Connect to $provider';
  }

  @override
  String get enterApiKeyDesc => 'Enter your API key and select a model.';

  @override
  String get dontHaveApiKey => 'Don\'t have an API key?';

  @override
  String get createAccountCopyKey => 'Create an account and copy your key.';

  @override
  String get signUp => 'Sign up';

  @override
  String get apiKey => 'API Key';

  @override
  String get pasteFromClipboard => 'Paste from clipboard';

  @override
  String get apiBaseUrl => 'API Base URL';

  @override
  String get selectModel => 'Select Model';

  @override
  String get modelId => 'Model ID';

  @override
  String get validateKey => 'Validate Key';

  @override
  String get validating => 'Validating...';

  @override
  String get invalidApiKey => 'Invalid API key';

  @override
  String get gatewayConfiguration => 'Gateway Configuration';

  @override
  String get gatewayConfigDesc =>
      'The gateway is the local control plane for your assistant.';

  @override
  String get defaultSettingsNote =>
      'The default settings work for most users. Only change these if you know what you need.';

  @override
  String get host => 'Host';

  @override
  String get port => 'Port';

  @override
  String get autoStartGateway => 'Auto-start gateway';

  @override
  String get autoStartGatewayDesc =>
      'Start the gateway automatically when the app launches.';

  @override
  String get channelsPageTitle => 'Channels';

  @override
  String get channelsPageDesc =>
      'Optionally connect messaging channels. You can always set these up later in Settings.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Connect a Telegram bot.';

  @override
  String get openBotFather => 'Open BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Connect a Discord bot.';

  @override
  String get developerPortal => 'Developer Portal';

  @override
  String get botToken => 'Bot Token';

  @override
  String telegramBotToken(String platform) {
    return '$platform Bot Token';
  }

  @override
  String get readyToGo => 'Ready to Go';

  @override
  String get reviewConfiguration =>
      'Review your configuration and start FlutterClaw.';

  @override
  String get model => 'Model';

  @override
  String viaProvider(String provider) {
    return 'via $provider';
  }

  @override
  String get gateway => 'Gateway';

  @override
  String get webChatOnly => 'WebChat only (you can add more later)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Starting...';

  @override
  String get startFlutterClaw => 'Start FlutterClaw';

  @override
  String get newSession => 'New session';

  @override
  String get photoLibrary => 'Photo Library';

  @override
  String get camera => 'Camera';

  @override
  String get whatDoYouSeeInImage => 'What do you see in this image?';

  @override
  String get imagePickerNotAvailable =>
      'Image picker not available on Simulator. Use a real device.';

  @override
  String get couldNotOpenImagePicker => 'Could not open image picker.';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get attachImage => 'Attach image';

  @override
  String get messageFlutterClaw => 'Message FlutterClaw...';

  @override
  String get channelsAndGateway => 'Channels & Gateway';

  @override
  String get stop => 'Stop';

  @override
  String get start => 'Start';

  @override
  String status(String status) {
    return 'Status: $status';
  }

  @override
  String get builtInChatInterface => 'Built-in chat interface';

  @override
  String get notConfigured => 'Not configured';

  @override
  String get connected => 'Connected';

  @override
  String get configuredStarting => 'Configured (starting...)';

  @override
  String get telegramConfiguration => 'Telegram Configuration';

  @override
  String get fromBotFather => 'From @BotFather';

  @override
  String get allowedUserIds => 'Allowed User IDs (comma separated)';

  @override
  String get leaveEmptyToAllowAll => 'Leave empty to allow all';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveAndConnect => 'Save & Connect';

  @override
  String get discordConfiguration => 'Discord Configuration';

  @override
  String get pendingPairingRequests => 'Pending Pairing Requests';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get expired => 'Expired';

  @override
  String minutesLeft(int minutes) {
    return '${minutes}m left';
  }

  @override
  String get workspaceFiles => 'Workspace Files';

  @override
  String get personalAIAssistant => 'Personal AI Assistant';

  @override
  String sessionsCount(int count) {
    return 'Sessions ($count)';
  }

  @override
  String get noActiveSessions => 'No active sessions';

  @override
  String get startConversationToCreate => 'Start a conversation to create one';

  @override
  String get startConversationToSee =>
      'Start a conversation to see sessions here';

  @override
  String get reset => 'Reset';

  @override
  String get cronJobs => 'Cron Jobs';

  @override
  String get noCronJobs => 'No cron jobs';

  @override
  String get addScheduledTasks => 'Add scheduled tasks for your agent';

  @override
  String get runNow => 'Run Now';

  @override
  String get enable => 'Enable';

  @override
  String get disable => 'Disable';

  @override
  String get delete => 'Delete';

  @override
  String get skills => 'Skills';

  @override
  String get browseClawHub => 'Browse ClawHub';

  @override
  String get noSkillsInstalled => 'No skills installed';

  @override
  String get browseClawHubToAdd => 'Browse ClawHub to add skills';

  @override
  String removeSkillConfirm(String name) {
    return 'Remove \"$name\" from your skills?';
  }

  @override
  String get clawHubSkills => 'ClawHub Skills';

  @override
  String get searchSkills => 'Search skills...';

  @override
  String get noSkillsFound => 'No skills found. Try a different search.';

  @override
  String installedSkill(String name) {
    return 'Installed $name';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'Failed to install $name';
  }

  @override
  String get addCronJob => 'Add Cron Job';

  @override
  String get jobName => 'Job Name';

  @override
  String get dailySummaryExample => 'e.g. Daily Summary';

  @override
  String get taskPrompt => 'Task Prompt';

  @override
  String get whatShouldAgentDo => 'What should the agent do?';

  @override
  String get interval => 'Interval';

  @override
  String get every5Minutes => 'Every 5 minutes';

  @override
  String get every15Minutes => 'Every 15 minutes';

  @override
  String get every30Minutes => 'Every 30 minutes';

  @override
  String get everyHour => 'Every hour';

  @override
  String get every6Hours => 'Every 6 hours';

  @override
  String get every12Hours => 'Every 12 hours';

  @override
  String get every24Hours => 'Every 24 hours';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get sessions => 'Sessions';

  @override
  String messagesCount(int count) {
    return '$count messages';
  }

  @override
  String tokensCount(int count) {
    return '$count tokens';
  }

  @override
  String get compact => 'Compact';

  @override
  String get models => 'Models';

  @override
  String get noModelsConfigured => 'No models configured';

  @override
  String get addModelToStartChatting => 'Add a model to start chatting';

  @override
  String get addModel => 'Add Model';

  @override
  String get default_ => 'DEFAULT';

  @override
  String get autoStart => 'Auto-start';

  @override
  String get startGatewayWhenLaunches => 'Start gateway when app launches';

  @override
  String get heartbeat => 'Heartbeat';

  @override
  String get enabled => 'Enabled';

  @override
  String get periodicAgentTasks => 'Periodic agent tasks from HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get about => 'About';

  @override
  String get personalAIAssistantForIOS =>
      'Personal AI Assistant for iOS & Android';

  @override
  String get version => 'Version';

  @override
  String get basedOnOpenClaw => 'Based on OpenClaw';

  @override
  String get removeModel => 'Remove model?';

  @override
  String removeModelConfirm(String name) {
    return 'Remove \"$name\" from your models?';
  }

  @override
  String get remove => 'Remove';

  @override
  String get setAsDefault => 'Set as Default';

  @override
  String get paste => 'Paste';

  @override
  String get chooseProviderStep => '1. Choose Provider';

  @override
  String get selectModelStep => '2. Select Model';

  @override
  String get apiKeyStep => '3. API Key';

  @override
  String getApiKeyAt(String provider) {
    return 'Get API key at $provider';
  }

  @override
  String get justNow => 'just now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }
}
