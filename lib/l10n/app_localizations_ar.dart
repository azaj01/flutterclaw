// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'محادثة';

  @override
  String get channels => 'القنوات';

  @override
  String get agent => 'الوكيل';

  @override
  String get settings => 'الإعدادات';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get yourPersonalAssistant => 'مساعدك الشخصي بالذكاء الاصطناعي';

  @override
  String get multiChannelChat => 'محادثة متعددة القنوات';

  @override
  String get multiChannelChatDesc => 'Telegram و Discord و WebChat والمزيد';

  @override
  String get powerfulAIModels => 'نماذج ذكاء اصطناعي قوية';

  @override
  String get powerfulAIModelsDesc => 'OpenAI و Anthropic و Grok ونماذج مجانية';

  @override
  String get localGateway => 'بوابة محلية';

  @override
  String get localGatewayDesc => 'يعمل على جهازك، بياناتك تبقى ملكك';

  @override
  String get chooseProvider => 'اختر مزود الخدمة';

  @override
  String get selectProviderDesc =>
      'اختر كيف تريد الاتصال بنماذج الذكاء الاصطناعي.';

  @override
  String get startForFree => 'ابدأ مجاناً';

  @override
  String get freeProvidersDesc =>
      'يقدم هؤلاء المزودون نماذج مجانية للبدء بدون تكلفة.';

  @override
  String get free => 'مجاني';

  @override
  String get otherProviders => 'مزودو خدمة آخرون';

  @override
  String connectToProvider(String provider) {
    return 'الاتصال بـ $provider';
  }

  @override
  String get enterApiKeyDesc => 'أدخل مفتاح API الخاص بك واختر نموذجاً.';

  @override
  String get dontHaveApiKey => 'ليس لديك مفتاح API؟';

  @override
  String get createAccountCopyKey => 'أنشئ حساباً وانسخ مفتاحك.';

  @override
  String get signUp => 'تسجيل';

  @override
  String get apiKey => 'مفتاح API';

  @override
  String get pasteFromClipboard => 'لصق من الحافظة';

  @override
  String get apiBaseUrl => 'عنوان URL الأساسي لـ API';

  @override
  String get selectModel => 'اختر النموذج';

  @override
  String get modelId => 'معرف النموذج';

  @override
  String get validateKey => 'التحقق من المفتاح';

  @override
  String get validating => 'جارٍ التحقق...';

  @override
  String get invalidApiKey => 'مفتاح API غير صالح';

  @override
  String get gatewayConfiguration => 'إعداد البوابة';

  @override
  String get gatewayConfigDesc => 'البوابة هي مستوى التحكم المحلي لمساعدك.';

  @override
  String get defaultSettingsNote =>
      'الإعدادات الافتراضية تعمل لمعظم المستخدمين. قم بتغييرها فقط إذا كنت تعرف ما تحتاجه.';

  @override
  String get host => 'المضيف';

  @override
  String get port => 'المنفذ';

  @override
  String get autoStartGateway => 'تشغيل البوابة تلقائياً';

  @override
  String get autoStartGatewayDesc => 'تشغيل البوابة تلقائياً عند بدء التطبيق.';

  @override
  String get channelsPageTitle => 'القنوات';

  @override
  String get channelsPageDesc =>
      'اربط قنوات المراسلة اختيارياً. يمكنك دائماً إعدادها لاحقاً في الإعدادات.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'اربط بوت Telegram.';

  @override
  String get openBotFather => 'افتح BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'اربط بوت Discord.';

  @override
  String get developerPortal => 'بوابة المطور';

  @override
  String get botToken => 'رمز البوت';

  @override
  String telegramBotToken(String platform) {
    return 'رمز بوت $platform';
  }

  @override
  String get readyToGo => 'جاهز للبدء';

  @override
  String get reviewConfiguration => 'راجع إعداداتك وابدأ FlutterClaw.';

  @override
  String get model => 'النموذج';

  @override
  String viaProvider(String provider) {
    return 'عبر $provider';
  }

  @override
  String get gateway => 'البوابة';

  @override
  String get webChatOnly => 'WebChat فقط (يمكنك إضافة المزيد لاحقاً)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'جارٍ البدء...';

  @override
  String get startFlutterClaw => 'ابدأ FlutterClaw';

  @override
  String get newSession => 'جلسة جديدة';

  @override
  String get photoLibrary => 'مكتبة الصور';

  @override
  String get camera => 'الكاميرا';

  @override
  String get whatDoYouSeeInImage => 'ماذا ترى في هذه الصورة؟';

  @override
  String get imagePickerNotAvailable =>
      'منتقي الصور غير متاح على المحاكي. استخدم جهازاً حقيقياً.';

  @override
  String get couldNotOpenImagePicker => 'تعذر فتح منتقي الصور.';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get attachImage => 'إرفاق صورة';

  @override
  String get messageFlutterClaw => 'رسالة إلى FlutterClaw...';

  @override
  String get channelsAndGateway => 'القنوات والبوابة';

  @override
  String get stop => 'إيقاف';

  @override
  String get start => 'ابدأ';

  @override
  String status(String status) {
    return 'الحالة: $status';
  }

  @override
  String get builtInChatInterface => 'واجهة محادثة مدمجة';

  @override
  String get notConfigured => 'غير مُعد';

  @override
  String get connected => 'متصل';

  @override
  String get configuredStarting => 'مُعد (جارٍ البدء...)';

  @override
  String get telegramConfiguration => 'إعداد Telegram';

  @override
  String get fromBotFather => 'من @BotFather';

  @override
  String get allowedUserIds => 'معرفات المستخدمين المسموح بها (مفصولة بفواصل)';

  @override
  String get leaveEmptyToAllowAll => 'اتركه فارغاً للسماح للجميع';

  @override
  String get cancel => 'إلغاء';

  @override
  String get saveAndConnect => 'حفظ والاتصال';

  @override
  String get discordConfiguration => 'إعداد Discord';

  @override
  String get pendingPairingRequests => 'طلبات الاقتران المعلقة';

  @override
  String get approve => 'موافقة';

  @override
  String get reject => 'رفض';

  @override
  String get expired => 'منتهي الصلاحية';

  @override
  String minutesLeft(int minutes) {
    return '$minutes دقيقة متبقية';
  }

  @override
  String get workspaceFiles => 'ملفات مساحة العمل';

  @override
  String get personalAIAssistant => 'مساعد شخصي بالذكاء الاصطناعي';

  @override
  String sessionsCount(int count) {
    return 'الجلسات ($count)';
  }

  @override
  String get noActiveSessions => 'لا توجد جلسات نشطة';

  @override
  String get startConversationToCreate => 'ابدأ محادثة لإنشاء واحدة';

  @override
  String get startConversationToSee => 'ابدأ محادثة لرؤية الجلسات هنا';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get cronJobs => 'المهام المجدولة';

  @override
  String get noCronJobs => 'لا توجد مهام مجدولة';

  @override
  String get addScheduledTasks => 'أضف مهام مجدولة لوكيلك';

  @override
  String get runNow => 'تشغيل الآن';

  @override
  String get enable => 'تفعيل';

  @override
  String get disable => 'تعطيل';

  @override
  String get delete => 'حذف';

  @override
  String get skills => 'المهارات';

  @override
  String get browseClawHub => 'تصفح ClawHub';

  @override
  String get noSkillsInstalled => 'لم يتم تثبيت مهارات';

  @override
  String get browseClawHubToAdd => 'تصفح ClawHub لإضافة مهارات';

  @override
  String removeSkillConfirm(String name) {
    return 'إزالة \"$name\" من مهاراتك؟';
  }

  @override
  String get clawHubSkills => 'مهارات ClawHub';

  @override
  String get searchSkills => 'البحث عن مهارات...';

  @override
  String get noSkillsFound => 'لم يتم العثور على مهارات. جرب بحثاً مختلفاً.';

  @override
  String installedSkill(String name) {
    return 'تم تثبيت $name';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'فشل تثبيت $name';
  }

  @override
  String get addCronJob => 'إضافة مهمة مجدولة';

  @override
  String get jobName => 'اسم المهمة';

  @override
  String get dailySummaryExample => 'مثال: ملخص يومي';

  @override
  String get taskPrompt => 'تعليمات المهمة';

  @override
  String get whatShouldAgentDo => 'ماذا يجب أن يفعل الوكيل؟';

  @override
  String get interval => 'الفاصل الزمني';

  @override
  String get every5Minutes => 'كل 5 دقائق';

  @override
  String get every15Minutes => 'كل 15 دقيقة';

  @override
  String get every30Minutes => 'كل 30 دقيقة';

  @override
  String get everyHour => 'كل ساعة';

  @override
  String get every6Hours => 'كل 6 ساعات';

  @override
  String get every12Hours => 'كل 12 ساعة';

  @override
  String get every24Hours => 'كل 24 ساعة';

  @override
  String get add => 'إضافة';

  @override
  String get save => 'حفظ';

  @override
  String get sessions => 'الجلسات';

  @override
  String messagesCount(int count) {
    return '$count رسالة';
  }

  @override
  String tokensCount(int count) {
    return '$count رمز';
  }

  @override
  String get compact => 'ضغط';

  @override
  String get models => 'النماذج';

  @override
  String get noModelsConfigured => 'لم يتم إعداد نماذج';

  @override
  String get addModelToStartChatting => 'أضف نموذجاً لبدء المحادثة';

  @override
  String get addModel => 'إضافة نموذج';

  @override
  String get default_ => 'افتراضي';

  @override
  String get autoStart => 'بدء تلقائي';

  @override
  String get startGatewayWhenLaunches => 'بدء البوابة عند تشغيل التطبيق';

  @override
  String get heartbeat => 'نبض القلب';

  @override
  String get enabled => 'مُفعَّل';

  @override
  String get periodicAgentTasks => 'مهام الوكيل الدورية من HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get about => 'حول';

  @override
  String get personalAIAssistantForIOS =>
      'مساعد شخصي بالذكاء الاصطناعي لـ iOS و Android';

  @override
  String get version => 'الإصدار';

  @override
  String get basedOnOpenClaw => 'مبني على OpenClaw';

  @override
  String get removeModel => 'إزالة النموذج؟';

  @override
  String removeModelConfirm(String name) {
    return 'إزالة \"$name\" من نماذجك؟';
  }

  @override
  String get remove => 'إزالة';

  @override
  String get setAsDefault => 'تعيين كافتراضي';

  @override
  String get paste => 'لصق';

  @override
  String get chooseProviderStep => '1. اختيار المزود';

  @override
  String get selectModelStep => '2. اختيار النموذج';

  @override
  String get apiKeyStep => '3. مفتاح API';

  @override
  String getApiKeyAt(String provider) {
    return 'احصل على مفتاح API من $provider';
  }

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(int minutes) {
    return 'منذ $minutes دقيقة';
  }

  @override
  String hoursAgo(int hours) {
    return 'منذ $hours ساعة';
  }

  @override
  String daysAgo(int days) {
    return 'منذ $days يوم';
  }
}
