// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => '聊天';

  @override
  String get channels => '频道';

  @override
  String get agent => '代理';

  @override
  String get settings => '设置';

  @override
  String get getStarted => '开始使用';

  @override
  String get yourPersonalAssistant => '您的个人AI助手';

  @override
  String get multiChannelChat => '多频道聊天';

  @override
  String get multiChannelChatDesc => 'Telegram、Discord、WebChat等';

  @override
  String get powerfulAIModels => '强大的AI模型';

  @override
  String get powerfulAIModelsDesc => 'OpenAI、Anthropic、Grok和免费模型';

  @override
  String get localGateway => '本地网关';

  @override
  String get localGatewayDesc => '在您的设备上运行,您的数据属于您';

  @override
  String get chooseProvider => '选择提供商';

  @override
  String get selectProviderDesc => '选择如何连接到AI模型。';

  @override
  String get startForFree => '免费开始';

  @override
  String get freeProvidersDesc => '这些提供商提供免费模型,让您零成本开始。';

  @override
  String get free => '免费';

  @override
  String get otherProviders => '其他提供商';

  @override
  String connectToProvider(String provider) {
    return '连接到$provider';
  }

  @override
  String get enterApiKeyDesc => '输入您的API密钥并选择一个模型。';

  @override
  String get dontHaveApiKey => '没有API密钥?';

  @override
  String get createAccountCopyKey => '创建账户并复制您的密钥。';

  @override
  String get signUp => '注册';

  @override
  String get apiKey => 'API密钥';

  @override
  String get pasteFromClipboard => '从剪贴板粘贴';

  @override
  String get apiBaseUrl => 'API基础URL';

  @override
  String get selectModel => '选择模型';

  @override
  String get modelId => '模型ID';

  @override
  String get validateKey => '验证密钥';

  @override
  String get validating => '验证中...';

  @override
  String get invalidApiKey => '无效的API密钥';

  @override
  String get gatewayConfiguration => '网关配置';

  @override
  String get gatewayConfigDesc => '网关是助手的本地控制平面。';

  @override
  String get defaultSettingsNote => '默认设置适用于大多数用户。仅在您知道需要什么时才更改。';

  @override
  String get host => '主机';

  @override
  String get port => '端口';

  @override
  String get autoStartGateway => '自动启动网关';

  @override
  String get autoStartGatewayDesc => '应用程序启动时自动启动网关。';

  @override
  String get channelsPageTitle => '频道';

  @override
  String get channelsPageDesc => '可选择连接消息频道。您可以稍后在设置中进行配置。';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => '连接Telegram机器人。';

  @override
  String get openBotFather => '打开BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => '连接Discord机器人。';

  @override
  String get developerPortal => '开发者门户';

  @override
  String get botToken => '机器人令牌';

  @override
  String telegramBotToken(String platform) {
    return '$platform机器人令牌';
  }

  @override
  String get readyToGo => '准备就绪';

  @override
  String get reviewConfiguration => '检查您的配置并启动FlutterClaw。';

  @override
  String get model => '模型';

  @override
  String viaProvider(String provider) {
    return '通过$provider';
  }

  @override
  String get gateway => '网关';

  @override
  String get webChatOnly => '仅WebChat(稍后可添加更多)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => '启动中...';

  @override
  String get startFlutterClaw => '启动FlutterClaw';

  @override
  String get newSession => '新会话';

  @override
  String get photoLibrary => '照片库';

  @override
  String get camera => '相机';

  @override
  String get whatDoYouSeeInImage => '您在这张图片中看到了什么?';

  @override
  String get imagePickerNotAvailable => '模拟器上无法使用图片选择器。请使用真实设备。';

  @override
  String get couldNotOpenImagePicker => '无法打开图片选择器。';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get attachImage => '附加图片';

  @override
  String get messageFlutterClaw => '给FlutterClaw发消息...';

  @override
  String get channelsAndGateway => '频道和网关';

  @override
  String get stop => '停止';

  @override
  String get start => '开始';

  @override
  String status(String status) {
    return '状态:$status';
  }

  @override
  String get builtInChatInterface => '内置聊天界面';

  @override
  String get notConfigured => '未配置';

  @override
  String get connected => '已连接';

  @override
  String get configuredStarting => '已配置(启动中...)';

  @override
  String get telegramConfiguration => 'Telegram配置';

  @override
  String get fromBotFather => '来自@BotFather';

  @override
  String get allowedUserIds => '允许的用户ID(用逗号分隔)';

  @override
  String get leaveEmptyToAllowAll => '留空以允许所有人';

  @override
  String get cancel => '取消';

  @override
  String get saveAndConnect => '保存并连接';

  @override
  String get discordConfiguration => 'Discord配置';

  @override
  String get pendingPairingRequests => '待处理的配对请求';

  @override
  String get approve => '批准';

  @override
  String get reject => '拒绝';

  @override
  String get expired => '已过期';

  @override
  String minutesLeft(int minutes) {
    return '剩余$minutes分钟';
  }

  @override
  String get workspaceFiles => '工作区文件';

  @override
  String get personalAIAssistant => '个人AI助手';

  @override
  String sessionsCount(int count) {
    return '会话($count)';
  }

  @override
  String get noActiveSessions => '无活动会话';

  @override
  String get startConversationToCreate => '开始对话以创建会话';

  @override
  String get startConversationToSee => '开始对话以查看会话';

  @override
  String get reset => '重置';

  @override
  String get cronJobs => '计划任务';

  @override
  String get noCronJobs => '无计划任务';

  @override
  String get addScheduledTasks => '为您的代理添加计划任务';

  @override
  String get runNow => '立即运行';

  @override
  String get enable => '启用';

  @override
  String get disable => '禁用';

  @override
  String get delete => '删除';

  @override
  String get skills => '技能';

  @override
  String get browseClawHub => '浏览ClawHub';

  @override
  String get noSkillsInstalled => '未安装技能';

  @override
  String get browseClawHubToAdd => '浏览ClawHub以添加技能';

  @override
  String removeSkillConfirm(String name) {
    return '从您的技能中移除\"$name\"?';
  }

  @override
  String get clawHubSkills => 'ClawHub技能';

  @override
  String get searchSkills => '搜索技能...';

  @override
  String get noSkillsFound => '未找到技能。尝试不同的搜索。';

  @override
  String installedSkill(String name) {
    return '已安装$name';
  }

  @override
  String failedToInstallSkill(String name) {
    return '安装$name失败';
  }

  @override
  String get addCronJob => '添加计划任务';

  @override
  String get jobName => '任务名称';

  @override
  String get dailySummaryExample => '例如:每日摘要';

  @override
  String get taskPrompt => '任务提示';

  @override
  String get whatShouldAgentDo => '代理应该做什么?';

  @override
  String get interval => '间隔';

  @override
  String get every5Minutes => '每5分钟';

  @override
  String get every15Minutes => '每15分钟';

  @override
  String get every30Minutes => '每30分钟';

  @override
  String get everyHour => '每小时';

  @override
  String get every6Hours => '每6小时';

  @override
  String get every12Hours => '每12小时';

  @override
  String get every24Hours => '每24小时';

  @override
  String get add => '添加';

  @override
  String get save => '保存';

  @override
  String get sessions => '会话';

  @override
  String messagesCount(int count) {
    return '$count条消息';
  }

  @override
  String tokensCount(int count) {
    return '$count个令牌';
  }

  @override
  String get compact => '压缩';

  @override
  String get models => '模型';

  @override
  String get noModelsConfigured => '未配置模型';

  @override
  String get addModelToStartChatting => '添加模型以开始聊天';

  @override
  String get addModel => '添加模型';

  @override
  String get default_ => '默认';

  @override
  String get autoStart => '自动启动';

  @override
  String get startGatewayWhenLaunches => '应用程序启动时启动网关';

  @override
  String get heartbeat => '心跳';

  @override
  String get enabled => '已启用';

  @override
  String get periodicAgentTasks => '来自HEARTBEAT.md的定期代理任务';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes分钟';
  }

  @override
  String get about => '关于';

  @override
  String get personalAIAssistantForIOS => 'iOS和Android的个人AI助手';

  @override
  String get version => '版本';

  @override
  String get basedOnOpenClaw => '基于OpenClaw';

  @override
  String get removeModel => '移除模型?';

  @override
  String removeModelConfirm(String name) {
    return '从您的模型中移除\"$name\"?';
  }

  @override
  String get remove => '移除';

  @override
  String get setAsDefault => '设为默认';

  @override
  String get paste => '粘贴';

  @override
  String get chooseProviderStep => '1. 选择提供商';

  @override
  String get selectModelStep => '2. 选择模型';

  @override
  String get apiKeyStep => '3. API密钥';

  @override
  String getApiKeyAt(String provider) {
    return '在$provider获取API密钥';
  }

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(int minutes) {
    return '$minutes分钟前';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours小时前';
  }

  @override
  String daysAgo(int days) {
    return '$days天前';
  }
}
