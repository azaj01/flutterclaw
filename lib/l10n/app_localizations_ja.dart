// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'チャット';

  @override
  String get channels => 'チャンネル';

  @override
  String get agent => 'エージェント';

  @override
  String get settings => '設定';

  @override
  String get getStarted => '始める';

  @override
  String get yourPersonalAssistant => 'あなた個人のAIアシスタント';

  @override
  String get multiChannelChat => 'マルチチャンネルチャット';

  @override
  String get multiChannelChatDesc => 'Telegram、Discord、WebChatなど';

  @override
  String get powerfulAIModels => '強力なAIモデル';

  @override
  String get powerfulAIModelsDesc => 'OpenAI、Anthropic、Grok、無料モデル';

  @override
  String get localGateway => 'ローカルゲートウェイ';

  @override
  String get localGatewayDesc => 'デバイス上で実行、データはあなたのもの';

  @override
  String get chooseProvider => 'プロバイダーを選択';

  @override
  String get selectProviderDesc => 'AIモデルへの接続方法を選択してください。';

  @override
  String get startForFree => '無料で始める';

  @override
  String get freeProvidersDesc => 'これらのプロバイダーは無料モデルを提供しています。';

  @override
  String get free => '無料';

  @override
  String get otherProviders => 'その他のプロバイダー';

  @override
  String connectToProvider(String provider) {
    return '$providerに接続';
  }

  @override
  String get enterApiKeyDesc => 'APIキーを入力し、モデルを選択してください。';

  @override
  String get dontHaveApiKey => 'APIキーをお持ちではありませんか?';

  @override
  String get createAccountCopyKey => 'アカウントを作成してキーをコピーしてください。';

  @override
  String get signUp => 'サインアップ';

  @override
  String get apiKey => 'APIキー';

  @override
  String get pasteFromClipboard => 'クリップボードから貼り付け';

  @override
  String get apiBaseUrl => 'APIベースURL';

  @override
  String get selectModel => 'モデルを選択';

  @override
  String get modelId => 'モデルID';

  @override
  String get validateKey => 'キーを検証';

  @override
  String get validating => '検証中...';

  @override
  String get invalidApiKey => '無効なAPIキー';

  @override
  String get gatewayConfiguration => 'ゲートウェイ設定';

  @override
  String get gatewayConfigDesc => 'ゲートウェイはアシスタントのローカル制御プレーンです。';

  @override
  String get defaultSettingsNote => 'デフォルト設定はほとんどのユーザーに適しています。必要な場合のみ変更してください。';

  @override
  String get host => 'ホスト';

  @override
  String get port => 'ポート';

  @override
  String get autoStartGateway => 'ゲートウェイを自動起動';

  @override
  String get autoStartGatewayDesc => 'アプリ起動時にゲートウェイを自動起動します。';

  @override
  String get channelsPageTitle => 'チャンネル';

  @override
  String get channelsPageDesc => 'オプションでメッセージングチャンネルを接続できます。後で設定で構成できます。';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Telegramボットを接続します。';

  @override
  String get openBotFather => 'BotFatherを開く';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Discordボットを接続します。';

  @override
  String get developerPortal => '開発者ポータル';

  @override
  String get botToken => 'ボットトークン';

  @override
  String telegramBotToken(String platform) {
    return '$platformボットトークン';
  }

  @override
  String get readyToGo => '準備完了';

  @override
  String get reviewConfiguration => '設定を確認してFlutterClawを起動します。';

  @override
  String get model => 'モデル';

  @override
  String viaProvider(String provider) {
    return '$provider経由';
  }

  @override
  String get gateway => 'ゲートウェイ';

  @override
  String get webChatOnly => 'WebChatのみ(後で追加可能)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => '起動中...';

  @override
  String get startFlutterClaw => 'FlutterClawを起動';

  @override
  String get newSession => '新しいセッション';

  @override
  String get photoLibrary => 'フォトライブラリ';

  @override
  String get camera => 'カメラ';

  @override
  String get whatDoYouSeeInImage => 'この画像に何が見えますか?';

  @override
  String get imagePickerNotAvailable => 'シミュレータでは画像ピッカーは使用できません。実機を使用してください。';

  @override
  String get couldNotOpenImagePicker => '画像ピッカーを開けませんでした。';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get attachImage => '画像を添付';

  @override
  String get messageFlutterClaw => 'FlutterClawにメッセージ...';

  @override
  String get channelsAndGateway => 'チャンネルとゲートウェイ';

  @override
  String get stop => '停止';

  @override
  String get start => '開始';

  @override
  String status(String status) {
    return '状態: $status';
  }

  @override
  String get builtInChatInterface => '内蔵チャットインターフェース';

  @override
  String get notConfigured => '未設定';

  @override
  String get connected => '接続済み';

  @override
  String get configuredStarting => '設定済み(起動中...)';

  @override
  String get telegramConfiguration => 'Telegram設定';

  @override
  String get fromBotFather => '@BotFatherから';

  @override
  String get allowedUserIds => '許可されたユーザーID(カンマ区切り)';

  @override
  String get leaveEmptyToAllowAll => 'すべて許可する場合は空欄';

  @override
  String get cancel => 'キャンセル';

  @override
  String get saveAndConnect => '保存して接続';

  @override
  String get discordConfiguration => 'Discord設定';

  @override
  String get pendingPairingRequests => '保留中のペアリングリクエスト';

  @override
  String get approve => '承認';

  @override
  String get reject => '拒否';

  @override
  String get expired => '期限切れ';

  @override
  String minutesLeft(int minutes) {
    return '残り$minutes分';
  }

  @override
  String get workspaceFiles => 'ワークスペースファイル';

  @override
  String get personalAIAssistant => '個人AIアシスタント';

  @override
  String sessionsCount(int count) {
    return 'セッション($count)';
  }

  @override
  String get noActiveSessions => 'アクティブなセッションはありません';

  @override
  String get startConversationToCreate => '会話を開始してセッションを作成';

  @override
  String get startConversationToSee => '会話を開始してセッションを表示';

  @override
  String get reset => 'リセット';

  @override
  String get cronJobs => 'スケジュールタスク';

  @override
  String get noCronJobs => 'スケジュールタスクはありません';

  @override
  String get addScheduledTasks => 'エージェントのスケジュールタスクを追加';

  @override
  String get runNow => '今すぐ実行';

  @override
  String get enable => '有効化';

  @override
  String get disable => '無効化';

  @override
  String get delete => '削除';

  @override
  String get skills => 'スキル';

  @override
  String get browseClawHub => 'ClawHubを閲覧';

  @override
  String get noSkillsInstalled => 'インストールされたスキルはありません';

  @override
  String get browseClawHubToAdd => 'ClawHubを閲覧してスキルを追加';

  @override
  String removeSkillConfirm(String name) {
    return '\"$name\"をスキルから削除しますか?';
  }

  @override
  String get clawHubSkills => 'ClawHubスキル';

  @override
  String get searchSkills => 'スキルを検索...';

  @override
  String get noSkillsFound => 'スキルが見つかりません。別の検索をお試しください。';

  @override
  String installedSkill(String name) {
    return '$nameをインストールしました';
  }

  @override
  String failedToInstallSkill(String name) {
    return '$nameのインストールに失敗しました';
  }

  @override
  String get addCronJob => 'スケジュールタスクを追加';

  @override
  String get jobName => 'タスク名';

  @override
  String get dailySummaryExample => '例: 日次サマリー';

  @override
  String get taskPrompt => 'タスクプロンプト';

  @override
  String get whatShouldAgentDo => 'エージェントは何をすべきですか?';

  @override
  String get interval => '間隔';

  @override
  String get every5Minutes => '5分ごと';

  @override
  String get every15Minutes => '15分ごと';

  @override
  String get every30Minutes => '30分ごと';

  @override
  String get everyHour => '1時間ごと';

  @override
  String get every6Hours => '6時間ごと';

  @override
  String get every12Hours => '12時間ごと';

  @override
  String get every24Hours => '24時間ごと';

  @override
  String get add => '追加';

  @override
  String get save => '保存';

  @override
  String get sessions => 'セッション';

  @override
  String messagesCount(int count) {
    return '$count件のメッセージ';
  }

  @override
  String tokensCount(int count) {
    return '$countトークン';
  }

  @override
  String get compact => '圧縮';

  @override
  String get models => 'モデル';

  @override
  String get noModelsConfigured => '設定されたモデルはありません';

  @override
  String get addModelToStartChatting => 'チャットを開始するにはモデルを追加';

  @override
  String get addModel => 'モデルを追加';

  @override
  String get default_ => 'デフォルト';

  @override
  String get autoStart => '自動起動';

  @override
  String get startGatewayWhenLaunches => 'アプリ起動時にゲートウェイを起動';

  @override
  String get heartbeat => 'ハートビート';

  @override
  String get enabled => '有効';

  @override
  String get periodicAgentTasks => 'HEARTBEAT.mdからの定期的なエージェントタスク';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String get about => 'について';

  @override
  String get personalAIAssistantForIOS => 'iOS & Android用個人AIアシスタント';

  @override
  String get version => 'バージョン';

  @override
  String get basedOnOpenClaw => 'OpenClawベース';

  @override
  String get removeModel => 'モデルを削除しますか?';

  @override
  String removeModelConfirm(String name) {
    return '\"$name\"をモデルから削除しますか?';
  }

  @override
  String get remove => '削除';

  @override
  String get setAsDefault => 'デフォルトに設定';

  @override
  String get paste => '貼り付け';

  @override
  String get chooseProviderStep => '1. プロバイダーを選択';

  @override
  String get selectModelStep => '2. モデルを選択';

  @override
  String get apiKeyStep => '3. APIキー';

  @override
  String getApiKeyAt(String provider) {
    return '$providerでAPIキーを取得';
  }

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(int minutes) {
    return '$minutes分前';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours時間前';
  }

  @override
  String daysAgo(int days) {
    return '$days日前';
  }
}
