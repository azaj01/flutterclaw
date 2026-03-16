// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Sohbet';

  @override
  String get channels => 'Kanallar';

  @override
  String get agent => 'Ajan';

  @override
  String get settings => 'Ayarlar';

  @override
  String get getStarted => 'Başla';

  @override
  String get yourPersonalAssistant => 'Kişisel AI asistanınız';

  @override
  String get multiChannelChat => 'Çok kanallı sohbet';

  @override
  String get multiChannelChatDesc =>
      'Telegram, Discord, WebChat ve daha fazlası';

  @override
  String get powerfulAIModels => 'Güçlü AI modelleri';

  @override
  String get powerfulAIModelsDesc =>
      'OpenAI, Anthropic, Grok ve ücretsiz modeller';

  @override
  String get localGateway => 'Yerel ağ geçidi';

  @override
  String get localGatewayDesc => 'Cihazınızda çalışır, verileriniz sizin kalır';

  @override
  String get chooseProvider => 'Sağlayıcı Seç';

  @override
  String get selectProviderDesc =>
      'AI modellerine nasıl bağlanmak istediğinizi seçin.';

  @override
  String get startForFree => 'Ücretsiz Başla';

  @override
  String get freeProvidersDesc =>
      'Bu sağlayıcılar ücretsiz modeller sunarak başlamanızı sağlar.';

  @override
  String get free => 'ÜCRETSİZ';

  @override
  String get otherProviders => 'Diğer Sağlayıcılar';

  @override
  String connectToProvider(String provider) {
    return '$provider\'a bağlan';
  }

  @override
  String get enterApiKeyDesc => 'API anahtarınızı girin ve bir model seçin.';

  @override
  String get dontHaveApiKey => 'API anahtarınız yok mu?';

  @override
  String get createAccountCopyKey =>
      'Bir hesap oluşturun ve anahtarınızı kopyalayın.';

  @override
  String get signUp => 'Kayıt Ol';

  @override
  String get apiKey => 'API Anahtarı';

  @override
  String get pasteFromClipboard => 'Panodan yapıştır';

  @override
  String get apiBaseUrl => 'API Temel URL';

  @override
  String get selectModel => 'Model Seç';

  @override
  String get modelId => 'Model ID';

  @override
  String get validateKey => 'Anahtarı Doğrula';

  @override
  String get validating => 'Doğrulanıyor...';

  @override
  String get invalidApiKey => 'Geçersiz API anahtarı';

  @override
  String get gatewayConfiguration => 'Ağ Geçidi Yapılandırması';

  @override
  String get gatewayConfigDesc =>
      'Ağ geçidi, asistanınız için yerel kontrol düzlemidir.';

  @override
  String get defaultSettingsNote =>
      'Varsayılan ayarlar çoğu kullanıcı için çalışır. Yalnızca neye ihtiyacınız olduğunu biliyorsanız değiştirin.';

  @override
  String get host => 'Ana Bilgisayar';

  @override
  String get port => 'Port';

  @override
  String get autoStartGateway => 'Ağ geçidini otomatik başlat';

  @override
  String get autoStartGatewayDesc =>
      'Uygulama başlatıldığında ağ geçidini otomatik olarak başlat.';

  @override
  String get channelsPageTitle => 'Kanallar';

  @override
  String get channelsPageDesc =>
      'İsteğe bağlı olarak mesajlaşma kanallarını bağlayın. Bunları daha sonra Ayarlar\'da her zaman yapılandırabilirsiniz.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Bir Telegram botu bağlayın.';

  @override
  String get openBotFather => 'BotFather\'ı Aç';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Bir Discord botu bağlayın.';

  @override
  String get developerPortal => 'Geliştirici Portalı';

  @override
  String get botToken => 'Bot Tokeni';

  @override
  String telegramBotToken(String platform) {
    return '$platform Bot Tokeni';
  }

  @override
  String get readyToGo => 'Başlamaya Hazır';

  @override
  String get reviewConfiguration =>
      'Yapılandırmanızı gözden geçirin ve FlutterClaw\'ı başlatın.';

  @override
  String get model => 'Model';

  @override
  String viaProvider(String provider) {
    return '$provider üzerinden';
  }

  @override
  String get gateway => 'Ağ Geçidi';

  @override
  String get webChatOnly =>
      'Yalnızca WebChat (daha sonra daha fazla ekleyebilirsiniz)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Başlatılıyor...';

  @override
  String get startFlutterClaw => 'FlutterClaw\'ı Başlat';

  @override
  String get newSession => 'Yeni oturum';

  @override
  String get photoLibrary => 'Fotoğraf Kitaplığı';

  @override
  String get camera => 'Kamera';

  @override
  String get whatDoYouSeeInImage => 'Bu resimde ne görüyorsunuz?';

  @override
  String get imagePickerNotAvailable =>
      'Simülatörde resim seçici kullanılamıyor. Gerçek bir cihaz kullanın.';

  @override
  String get couldNotOpenImagePicker => 'Resim seçici açılamadı.';

  @override
  String get copiedToClipboard => 'Panoya kopyalandı';

  @override
  String get attachImage => 'Resim ekle';

  @override
  String get messageFlutterClaw => 'FlutterClaw\'a mesaj...';

  @override
  String get channelsAndGateway => 'Kanallar ve Ağ Geçidi';

  @override
  String get stop => 'Durdur';

  @override
  String get start => 'Başlat';

  @override
  String status(String status) {
    return 'Durum: $status';
  }

  @override
  String get builtInChatInterface => 'Yerleşik sohbet arayüzü';

  @override
  String get notConfigured => 'Yapılandırılmamış';

  @override
  String get connected => 'Bağlı';

  @override
  String get configuredStarting => 'Yapılandırıldı (başlatılıyor...)';

  @override
  String get telegramConfiguration => 'Telegram Yapılandırması';

  @override
  String get fromBotFather => '@BotFather\'dan';

  @override
  String get allowedUserIds =>
      'İzin Verilen Kullanıcı ID\'leri (virgülle ayrılmış)';

  @override
  String get leaveEmptyToAllowAll => 'Herkese izin vermek için boş bırakın';

  @override
  String get cancel => 'İptal';

  @override
  String get saveAndConnect => 'Kaydet ve Bağlan';

  @override
  String get discordConfiguration => 'Discord Yapılandırması';

  @override
  String get pendingPairingRequests => 'Bekleyen Eşleştirme İstekleri';

  @override
  String get approve => 'Onayla';

  @override
  String get reject => 'Reddet';

  @override
  String get expired => 'Süresi Doldu';

  @override
  String minutesLeft(int minutes) {
    return '${minutes}dk kaldı';
  }

  @override
  String get workspaceFiles => 'Çalışma Alanı Dosyaları';

  @override
  String get personalAIAssistant => 'Kişisel AI Asistanı';

  @override
  String sessionsCount(int count) {
    return 'Oturumlar ($count)';
  }

  @override
  String get noActiveSessions => 'Aktif oturum yok';

  @override
  String get startConversationToCreate => 'Oluşturmak için bir sohbet başlatın';

  @override
  String get startConversationToSee =>
      'Oturumları görmek için bir sohbet başlatın';

  @override
  String get reset => 'Sıfırla';

  @override
  String get cronJobs => 'Zamanlanmış Görevler';

  @override
  String get noCronJobs => 'Zamanlanmış görev yok';

  @override
  String get addScheduledTasks => 'Ajanınız için zamanlanmış görevler ekleyin';

  @override
  String get runNow => 'Şimdi Çalıştır';

  @override
  String get enable => 'Etkinleştir';

  @override
  String get disable => 'Devre Dışı Bırak';

  @override
  String get delete => 'Sil';

  @override
  String get skills => 'Beceriler';

  @override
  String get browseClawHub => 'ClawHub\'a Göz At';

  @override
  String get noSkillsInstalled => 'Yüklü beceri yok';

  @override
  String get browseClawHubToAdd => 'Beceri eklemek için ClawHub\'a göz atın';

  @override
  String removeSkillConfirm(String name) {
    return '\"$name\" becerilerinizden kaldırılsın mı?';
  }

  @override
  String get clawHubSkills => 'ClawHub Becerileri';

  @override
  String get searchSkills => 'Becerileri ara...';

  @override
  String get noSkillsFound => 'Beceri bulunamadı. Farklı bir arama deneyin.';

  @override
  String installedSkill(String name) {
    return '$name yüklendi';
  }

  @override
  String failedToInstallSkill(String name) {
    return '$name yüklenemedi';
  }

  @override
  String get addCronJob => 'Zamanlanmış Görev Ekle';

  @override
  String get jobName => 'Görev Adı';

  @override
  String get dailySummaryExample => 'ör. Günlük Özet';

  @override
  String get taskPrompt => 'Görev İstemi';

  @override
  String get whatShouldAgentDo => 'Ajan ne yapmalı?';

  @override
  String get interval => 'Aralık';

  @override
  String get every5Minutes => 'Her 5 dakika';

  @override
  String get every15Minutes => 'Her 15 dakika';

  @override
  String get every30Minutes => 'Her 30 dakika';

  @override
  String get everyHour => 'Her saat';

  @override
  String get every6Hours => 'Her 6 saat';

  @override
  String get every12Hours => 'Her 12 saat';

  @override
  String get every24Hours => 'Her 24 saat';

  @override
  String get add => 'Ekle';

  @override
  String get save => 'Kaydet';

  @override
  String get sessions => 'Oturumlar';

  @override
  String messagesCount(int count) {
    return '$count mesaj';
  }

  @override
  String tokensCount(int count) {
    return '$count token';
  }

  @override
  String get compact => 'Sıkıştır';

  @override
  String get models => 'Modeller';

  @override
  String get noModelsConfigured => 'Yapılandırılmış model yok';

  @override
  String get addModelToStartChatting =>
      'Sohbete başlamak için bir model ekleyin';

  @override
  String get addModel => 'Model Ekle';

  @override
  String get default_ => 'VARSAYILAN';

  @override
  String get autoStart => 'Otomatik başlatma';

  @override
  String get startGatewayWhenLaunches =>
      'Uygulama başladığında ağ geçidini başlat';

  @override
  String get heartbeat => 'Kalp Atışı';

  @override
  String get enabled => 'Etkin';

  @override
  String get periodicAgentTasks => 'HEARTBEAT.md\'den periyodik ajan görevleri';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String get about => 'Hakkında';

  @override
  String get personalAIAssistantForIOS =>
      'iOS ve Android için Kişisel AI Asistanı';

  @override
  String get version => 'Sürüm';

  @override
  String get basedOnOpenClaw => 'OpenClaw tabanlı';

  @override
  String get removeModel => 'Model kaldırılsın mı?';

  @override
  String removeModelConfirm(String name) {
    return '\"$name\" modellerinizden kaldırılsın mı?';
  }

  @override
  String get remove => 'Kaldır';

  @override
  String get setAsDefault => 'Varsayılan Olarak Ayarla';

  @override
  String get paste => 'Yapıştır';

  @override
  String get chooseProviderStep => '1. Sağlayıcı Seç';

  @override
  String get selectModelStep => '2. Model Seç';

  @override
  String get apiKeyStep => '3. API Anahtarı';

  @override
  String getApiKeyAt(String provider) {
    return '$provider adresinden API anahtarı alın';
  }

  @override
  String get justNow => 'şimdi';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}dk önce';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}sa önce';
  }

  @override
  String daysAgo(int days) {
    return '${days}g önce';
  }
}
