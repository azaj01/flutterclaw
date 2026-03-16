// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => '채팅';

  @override
  String get channels => '채널';

  @override
  String get agent => '에이전트';

  @override
  String get settings => '설정';

  @override
  String get getStarted => '시작하기';

  @override
  String get yourPersonalAssistant => '당신의 개인 AI 비서';

  @override
  String get multiChannelChat => '멀티 채널 채팅';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat 등';

  @override
  String get powerfulAIModels => '강력한 AI 모델';

  @override
  String get powerfulAIModelsDesc => 'OpenAI, Anthropic, Grok 및 무료 모델';

  @override
  String get localGateway => '로컬 게이트웨이';

  @override
  String get localGatewayDesc => '기기에서 실행, 데이터는 당신의 것';

  @override
  String get chooseProvider => '제공자 선택';

  @override
  String get selectProviderDesc => 'AI 모델에 연결하는 방법을 선택하세요.';

  @override
  String get startForFree => '무료로 시작';

  @override
  String get freeProvidersDesc => '이러한 제공자는 무료 모델을 제공합니다.';

  @override
  String get free => '무료';

  @override
  String get otherProviders => '기타 제공자';

  @override
  String connectToProvider(String provider) {
    return '$provider에 연결';
  }

  @override
  String get enterApiKeyDesc => 'API 키를 입력하고 모델을 선택하세요.';

  @override
  String get dontHaveApiKey => 'API 키가 없으신가요?';

  @override
  String get createAccountCopyKey => '계정을 만들고 키를 복사하세요.';

  @override
  String get signUp => '가입하기';

  @override
  String get apiKey => 'API 키';

  @override
  String get pasteFromClipboard => '클립보드에서 붙여넣기';

  @override
  String get apiBaseUrl => 'API 기본 URL';

  @override
  String get selectModel => '모델 선택';

  @override
  String get modelId => '모델 ID';

  @override
  String get validateKey => '키 검증';

  @override
  String get validating => '검증 중...';

  @override
  String get invalidApiKey => '유효하지 않은 API 키';

  @override
  String get gatewayConfiguration => '게이트웨이 구성';

  @override
  String get gatewayConfigDesc => '게이트웨이는 비서의 로컬 제어 평면입니다.';

  @override
  String get defaultSettingsNote => '기본 설정은 대부분의 사용자에게 적합합니다. 필요한 경우에만 변경하세요.';

  @override
  String get host => '호스트';

  @override
  String get port => '포트';

  @override
  String get autoStartGateway => '게이트웨이 자동 시작';

  @override
  String get autoStartGatewayDesc => '앱 시작 시 게이트웨이를 자동으로 시작합니다.';

  @override
  String get channelsPageTitle => '채널';

  @override
  String get channelsPageDesc => '선택적으로 메시징 채널을 연결하세요. 나중에 설정에서 구성할 수 있습니다.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Telegram 봇을 연결하세요.';

  @override
  String get openBotFather => 'BotFather 열기';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Discord 봇을 연결하세요.';

  @override
  String get developerPortal => '개발자 포털';

  @override
  String get botToken => '봇 토큰';

  @override
  String telegramBotToken(String platform) {
    return '$platform 봇 토큰';
  }

  @override
  String get readyToGo => '준비 완료';

  @override
  String get reviewConfiguration => '구성을 검토하고 FlutterClaw를 시작하세요.';

  @override
  String get model => '모델';

  @override
  String viaProvider(String provider) {
    return '$provider를 통해';
  }

  @override
  String get gateway => '게이트웨이';

  @override
  String get webChatOnly => 'WebChat만 (나중에 더 추가 가능)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => '시작 중...';

  @override
  String get startFlutterClaw => 'FlutterClaw 시작';

  @override
  String get newSession => '새 세션';

  @override
  String get photoLibrary => '사진 라이브러리';

  @override
  String get camera => '카메라';

  @override
  String get whatDoYouSeeInImage => '이 이미지에서 무엇을 보시나요?';

  @override
  String get imagePickerNotAvailable =>
      '시뮬레이터에서는 이미지 선택기를 사용할 수 없습니다. 실제 기기를 사용하세요.';

  @override
  String get couldNotOpenImagePicker => '이미지 선택기를 열 수 없습니다.';

  @override
  String get copiedToClipboard => '클립보드에 복사됨';

  @override
  String get attachImage => '이미지 첨부';

  @override
  String get messageFlutterClaw => 'FlutterClaw에 메시지...';

  @override
  String get channelsAndGateway => '채널 및 게이트웨이';

  @override
  String get stop => '중지';

  @override
  String get start => '시작';

  @override
  String status(String status) {
    return '상태: $status';
  }

  @override
  String get builtInChatInterface => '내장 채팅 인터페이스';

  @override
  String get notConfigured => '구성되지 않음';

  @override
  String get connected => '연결됨';

  @override
  String get configuredStarting => '구성됨 (시작 중...)';

  @override
  String get telegramConfiguration => 'Telegram 구성';

  @override
  String get fromBotFather => '@BotFather에서';

  @override
  String get allowedUserIds => '허용된 사용자 ID (쉼표로 구분)';

  @override
  String get leaveEmptyToAllowAll => '모두 허용하려면 비워두세요';

  @override
  String get cancel => '취소';

  @override
  String get saveAndConnect => '저장 및 연결';

  @override
  String get discordConfiguration => 'Discord 구성';

  @override
  String get pendingPairingRequests => '대기 중인 페어링 요청';

  @override
  String get approve => '승인';

  @override
  String get reject => '거부';

  @override
  String get expired => '만료됨';

  @override
  String minutesLeft(int minutes) {
    return '$minutes분 남음';
  }

  @override
  String get workspaceFiles => '작업 공간 파일';

  @override
  String get personalAIAssistant => '개인 AI 비서';

  @override
  String sessionsCount(int count) {
    return '세션 ($count)';
  }

  @override
  String get noActiveSessions => '활성 세션 없음';

  @override
  String get startConversationToCreate => '대화를 시작하여 생성하세요';

  @override
  String get startConversationToSee => '대화를 시작하여 세션을 확인하세요';

  @override
  String get reset => '재설정';

  @override
  String get cronJobs => '예약된 작업';

  @override
  String get noCronJobs => '예약된 작업 없음';

  @override
  String get addScheduledTasks => '에이전트에 대한 예약된 작업 추가';

  @override
  String get runNow => '지금 실행';

  @override
  String get enable => '활성화';

  @override
  String get disable => '비활성화';

  @override
  String get delete => '삭제';

  @override
  String get skills => '스킬';

  @override
  String get browseClawHub => 'ClawHub 둘러보기';

  @override
  String get noSkillsInstalled => '설치된 스킬 없음';

  @override
  String get browseClawHubToAdd => 'ClawHub를 둘러보고 스킬 추가';

  @override
  String removeSkillConfirm(String name) {
    return '스킬에서 \"$name\"을(를) 제거하시겠습니까?';
  }

  @override
  String get clawHubSkills => 'ClawHub 스킬';

  @override
  String get searchSkills => '스킬 검색...';

  @override
  String get noSkillsFound => '스킬을 찾을 수 없습니다. 다른 검색어를 시도하세요.';

  @override
  String installedSkill(String name) {
    return '$name 설치됨';
  }

  @override
  String failedToInstallSkill(String name) {
    return '$name 설치 실패';
  }

  @override
  String get addCronJob => '예약된 작업 추가';

  @override
  String get jobName => '작업 이름';

  @override
  String get dailySummaryExample => '예: 일일 요약';

  @override
  String get taskPrompt => '작업 프롬프트';

  @override
  String get whatShouldAgentDo => '에이전트가 무엇을 해야 하나요?';

  @override
  String get interval => '간격';

  @override
  String get every5Minutes => '5분마다';

  @override
  String get every15Minutes => '15분마다';

  @override
  String get every30Minutes => '30분마다';

  @override
  String get everyHour => '매시간';

  @override
  String get every6Hours => '6시간마다';

  @override
  String get every12Hours => '12시간마다';

  @override
  String get every24Hours => '24시간마다';

  @override
  String get add => '추가';

  @override
  String get save => '저장';

  @override
  String get sessions => '세션';

  @override
  String messagesCount(int count) {
    return '$count개의 메시지';
  }

  @override
  String tokensCount(int count) {
    return '$count개의 토큰';
  }

  @override
  String get compact => '압축';

  @override
  String get models => '모델';

  @override
  String get noModelsConfigured => '구성된 모델 없음';

  @override
  String get addModelToStartChatting => '채팅을 시작하려면 모델 추가';

  @override
  String get addModel => '모델 추가';

  @override
  String get default_ => '기본값';

  @override
  String get autoStart => '자동 시작';

  @override
  String get startGatewayWhenLaunches => '앱 시작 시 게이트웨이 시작';

  @override
  String get heartbeat => '하트비트';

  @override
  String get enabled => '활성화됨';

  @override
  String get periodicAgentTasks => 'HEARTBEAT.md의 주기적인 에이전트 작업';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String get about => '정보';

  @override
  String get personalAIAssistantForIOS => 'iOS 및 Android용 개인 AI 비서';

  @override
  String get version => '버전';

  @override
  String get basedOnOpenClaw => 'OpenClaw 기반';

  @override
  String get removeModel => '모델을 제거하시겠습니까?';

  @override
  String removeModelConfirm(String name) {
    return '모델에서 \"$name\"을(를) 제거하시겠습니까?';
  }

  @override
  String get remove => '제거';

  @override
  String get setAsDefault => '기본값으로 설정';

  @override
  String get paste => '붙여넣기';

  @override
  String get chooseProviderStep => '1. 제공자 선택';

  @override
  String get selectModelStep => '2. 모델 선택';

  @override
  String get apiKeyStep => '3. API 키';

  @override
  String getApiKeyAt(String provider) {
    return '$provider에서 API 키 받기';
  }

  @override
  String get justNow => '방금';

  @override
  String minutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours시간 전';
  }

  @override
  String daysAgo(int days) {
    return '$days일 전';
  }
}
