// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Trò chuyện';

  @override
  String get channels => 'Kênh';

  @override
  String get agent => 'Tác nhân';

  @override
  String get settings => 'Cài đặt';

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get yourPersonalAssistant => 'Trợ lý AI cá nhân của bạn';

  @override
  String get multiChannelChat => 'Trò chuyện đa kênh';

  @override
  String get multiChannelChatDesc =>
      'Telegram, Discord, WebChat và hơn thế nữa';

  @override
  String get powerfulAIModels => 'Mô hình AI mạnh mẽ';

  @override
  String get powerfulAIModelsDesc =>
      'OpenAI, Anthropic, Grok và mô hình miễn phí';

  @override
  String get localGateway => 'Cổng cục bộ';

  @override
  String get localGatewayDesc =>
      'Chạy trên thiết bị của bạn, dữ liệu của bạn thuộc về bạn';

  @override
  String get chooseProvider => 'Chọn Nhà cung cấp';

  @override
  String get selectProviderDesc => 'Chọn cách bạn muốn kết nối với mô hình AI.';

  @override
  String get startForFree => 'Bắt đầu Miễn phí';

  @override
  String get freeProvidersDesc =>
      'Các nhà cung cấp này cung cấp mô hình miễn phí để bạn bắt đầu không mất chi phí.';

  @override
  String get free => 'MIỄN PHÍ';

  @override
  String get otherProviders => 'Nhà cung cấp Khác';

  @override
  String connectToProvider(String provider) {
    return 'Kết nối với $provider';
  }

  @override
  String get enterApiKeyDesc => 'Nhập khóa API của bạn và chọn mô hình.';

  @override
  String get dontHaveApiKey => 'Không có khóa API?';

  @override
  String get createAccountCopyKey => 'Tạo tài khoản và sao chép khóa của bạn.';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get apiKey => 'Khóa API';

  @override
  String get pasteFromClipboard => 'Dán từ khay nhớ tạm';

  @override
  String get apiBaseUrl => 'URL Cơ sở API';

  @override
  String get selectModel => 'Chọn Mô hình';

  @override
  String get modelId => 'ID Mô hình';

  @override
  String get validateKey => 'Xác thực Khóa';

  @override
  String get validating => 'Đang xác thực...';

  @override
  String get invalidApiKey => 'Khóa API không hợp lệ';

  @override
  String get gatewayConfiguration => 'Cấu hình Cổng';

  @override
  String get gatewayConfigDesc =>
      'Cổng là mặt phẳng điều khiển cục bộ cho trợ lý của bạn.';

  @override
  String get defaultSettingsNote =>
      'Cài đặt mặc định hoạt động cho hầu hết người dùng. Chỉ thay đổi nếu bạn biết bạn cần gì.';

  @override
  String get host => 'Máy chủ';

  @override
  String get port => 'Cổng';

  @override
  String get autoStartGateway => 'Tự động khởi động cổng';

  @override
  String get autoStartGatewayDesc =>
      'Khởi động cổng tự động khi ứng dụng khởi chạy.';

  @override
  String get channelsPageTitle => 'Kênh';

  @override
  String get channelsPageDesc =>
      'Tùy chọn kết nối các kênh nhắn tin. Bạn luôn có thể thiết lập chúng sau trong Cài đặt.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Kết nối bot Telegram.';

  @override
  String get openBotFather => 'Mở BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Kết nối bot Discord.';

  @override
  String get developerPortal => 'Cổng Nhà phát triển';

  @override
  String get botToken => 'Token Bot';

  @override
  String telegramBotToken(String platform) {
    return 'Token Bot $platform';
  }

  @override
  String get readyToGo => 'Sẵn sàng Bắt đầu';

  @override
  String get reviewConfiguration =>
      'Xem lại cấu hình của bạn và khởi động FlutterClaw.';

  @override
  String get model => 'Mô hình';

  @override
  String viaProvider(String provider) {
    return 'qua $provider';
  }

  @override
  String get gateway => 'Cổng';

  @override
  String get webChatOnly => 'Chỉ WebChat (bạn có thể thêm sau)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Đang khởi động...';

  @override
  String get startFlutterClaw => 'Khởi động FlutterClaw';

  @override
  String get newSession => 'Phiên mới';

  @override
  String get photoLibrary => 'Thư viện Ảnh';

  @override
  String get camera => 'Máy ảnh';

  @override
  String get whatDoYouSeeInImage => 'Bạn thấy gì trong hình ảnh này?';

  @override
  String get imagePickerNotAvailable =>
      'Trình chọn hình ảnh không khả dụng trên Trình mô phỏng. Sử dụng thiết bị thật.';

  @override
  String get couldNotOpenImagePicker => 'Không thể mở trình chọn hình ảnh.';

  @override
  String get copiedToClipboard => 'Đã sao chép vào khay nhớ tạm';

  @override
  String get attachImage => 'Đính kèm hình ảnh';

  @override
  String get messageFlutterClaw => 'Tin nhắn cho FlutterClaw...';

  @override
  String get channelsAndGateway => 'Kênh và Cổng';

  @override
  String get stop => 'Dừng';

  @override
  String get start => 'Bắt đầu';

  @override
  String status(String status) {
    return 'Trạng thái: $status';
  }

  @override
  String get builtInChatInterface => 'Giao diện trò chuyện tích hợp';

  @override
  String get notConfigured => 'Chưa được cấu hình';

  @override
  String get connected => 'Đã kết nối';

  @override
  String get configuredStarting => 'Đã cấu hình (đang khởi động...)';

  @override
  String get telegramConfiguration => 'Cấu hình Telegram';

  @override
  String get fromBotFather => 'Từ @BotFather';

  @override
  String get allowedUserIds =>
      'ID Người dùng được phép (phân cách bằng dấu phẩy)';

  @override
  String get leaveEmptyToAllowAll => 'Để trống để cho phép tất cả';

  @override
  String get cancel => 'Hủy';

  @override
  String get saveAndConnect => 'Lưu và Kết nối';

  @override
  String get discordConfiguration => 'Cấu hình Discord';

  @override
  String get pendingPairingRequests => 'Yêu cầu Ghép nối Đang chờ';

  @override
  String get approve => 'Phê duyệt';

  @override
  String get reject => 'Từ chối';

  @override
  String get expired => 'Đã hết hạn';

  @override
  String minutesLeft(int minutes) {
    return 'Còn $minutes phút';
  }

  @override
  String get workspaceFiles => 'Tệp Không gian làm việc';

  @override
  String get personalAIAssistant => 'Trợ lý AI Cá nhân';

  @override
  String sessionsCount(int count) {
    return 'Phiên ($count)';
  }

  @override
  String get noActiveSessions => 'Không có phiên hoạt động';

  @override
  String get startConversationToCreate => 'Bắt đầu cuộc trò chuyện để tạo';

  @override
  String get startConversationToSee =>
      'Bắt đầu cuộc trò chuyện để xem phiên ở đây';

  @override
  String get reset => 'Đặt lại';

  @override
  String get cronJobs => 'Công việc Đã lập lịch';

  @override
  String get noCronJobs => 'Không có công việc đã lập lịch';

  @override
  String get addScheduledTasks =>
      'Thêm công việc đã lập lịch cho tác nhân của bạn';

  @override
  String get runNow => 'Chạy Ngay';

  @override
  String get enable => 'Bật';

  @override
  String get disable => 'Tắt';

  @override
  String get delete => 'Xóa';

  @override
  String get skills => 'Kỹ năng';

  @override
  String get browseClawHub => 'Duyệt ClawHub';

  @override
  String get noSkillsInstalled => 'Không có kỹ năng nào được cài đặt';

  @override
  String get browseClawHubToAdd => 'Duyệt ClawHub để thêm kỹ năng';

  @override
  String removeSkillConfirm(String name) {
    return 'Xóa \"$name\" khỏi kỹ năng của bạn?';
  }

  @override
  String get clawHubSkills => 'Kỹ năng ClawHub';

  @override
  String get searchSkills => 'Tìm kiếm kỹ năng...';

  @override
  String get noSkillsFound => 'Không tìm thấy kỹ năng. Thử tìm kiếm khác.';

  @override
  String installedSkill(String name) {
    return 'Đã cài đặt $name';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'Không cài đặt được $name';
  }

  @override
  String get addCronJob => 'Thêm Công việc Đã lập lịch';

  @override
  String get jobName => 'Tên Công việc';

  @override
  String get dailySummaryExample => 'ví dụ: Tóm tắt Hàng ngày';

  @override
  String get taskPrompt => 'Lời nhắc Nhiệm vụ';

  @override
  String get whatShouldAgentDo => 'Tác nhân nên làm gì?';

  @override
  String get interval => 'Khoảng thời gian';

  @override
  String get every5Minutes => 'Mỗi 5 phút';

  @override
  String get every15Minutes => 'Mỗi 15 phút';

  @override
  String get every30Minutes => 'Mỗi 30 phút';

  @override
  String get everyHour => 'Mỗi giờ';

  @override
  String get every6Hours => 'Mỗi 6 giờ';

  @override
  String get every12Hours => 'Mỗi 12 giờ';

  @override
  String get every24Hours => 'Mỗi 24 giờ';

  @override
  String get add => 'Thêm';

  @override
  String get save => 'Lưu';

  @override
  String get sessions => 'Phiên';

  @override
  String messagesCount(int count) {
    return '$count tin nhắn';
  }

  @override
  String tokensCount(int count) {
    return '$count token';
  }

  @override
  String get compact => 'Nén';

  @override
  String get models => 'Mô hình';

  @override
  String get noModelsConfigured => 'Không có mô hình nào được cấu hình';

  @override
  String get addModelToStartChatting => 'Thêm mô hình để bắt đầu trò chuyện';

  @override
  String get addModel => 'Thêm Mô hình';

  @override
  String get default_ => 'MẶC ĐỊNH';

  @override
  String get autoStart => 'Tự động khởi động';

  @override
  String get startGatewayWhenLaunches =>
      'Khởi động cổng khi ứng dụng khởi chạy';

  @override
  String get heartbeat => 'Nhịp tim';

  @override
  String get enabled => 'Đã bật';

  @override
  String get periodicAgentTasks => 'Công việc tác nhân định kỳ từ HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String get about => 'Giới thiệu';

  @override
  String get personalAIAssistantForIOS =>
      'Trợ lý AI Cá nhân cho iOS và Android';

  @override
  String get version => 'Phiên bản';

  @override
  String get basedOnOpenClaw => 'Dựa trên OpenClaw';

  @override
  String get removeModel => 'Xóa mô hình?';

  @override
  String removeModelConfirm(String name) {
    return 'Xóa \"$name\" khỏi mô hình của bạn?';
  }

  @override
  String get remove => 'Xóa';

  @override
  String get setAsDefault => 'Đặt làm Mặc định';

  @override
  String get paste => 'Dán';

  @override
  String get chooseProviderStep => '1. Chọn Nhà cung cấp';

  @override
  String get selectModelStep => '2. Chọn Mô hình';

  @override
  String get apiKeyStep => '3. Khóa API';

  @override
  String getApiKeyAt(String provider) {
    return 'Lấy khóa API tại $provider';
  }

  @override
  String get justNow => 'vừa xong';

  @override
  String minutesAgo(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours giờ trước';
  }

  @override
  String daysAgo(int days) {
    return '$days ngày trước';
  }
}
