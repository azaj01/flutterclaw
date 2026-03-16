// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Чат';

  @override
  String get channels => 'Канали';

  @override
  String get agent => 'Агент';

  @override
  String get settings => 'Налаштування';

  @override
  String get getStarted => 'Почати';

  @override
  String get yourPersonalAssistant => 'Ваш особистий AI-асистент';

  @override
  String get multiChannelChat => 'Багатоканальний чат';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat та інше';

  @override
  String get powerfulAIModels => 'Потужні моделі AI';

  @override
  String get powerfulAIModelsDesc =>
      'OpenAI, Anthropic, Grok та безкоштовні моделі';

  @override
  String get localGateway => 'Локальний шлюз';

  @override
  String get localGatewayDesc =>
      'Працює на вашому пристрої, ваші дані залишаються вашими';

  @override
  String get chooseProvider => 'Виберіть Провайдера';

  @override
  String get selectProviderDesc =>
      'Виберіть, як ви хочете підключитися до моделей AI.';

  @override
  String get startForFree => 'Почати Безкоштовно';

  @override
  String get freeProvidersDesc =>
      'Ці провайдери пропонують безкоштовні моделі для початку без витрат.';

  @override
  String get free => 'БЕЗКОШТОВНО';

  @override
  String get otherProviders => 'Інші Провайдери';

  @override
  String connectToProvider(String provider) {
    return 'Підключитися до $provider';
  }

  @override
  String get enterApiKeyDesc => 'Введіть ваш API-ключ і виберіть модель.';

  @override
  String get dontHaveApiKey => 'Немає API-ключа?';

  @override
  String get createAccountCopyKey =>
      'Створіть обліковий запис і скопіюйте ключ.';

  @override
  String get signUp => 'Зареєструватися';

  @override
  String get apiKey => 'API-ключ';

  @override
  String get pasteFromClipboard => 'Вставити з буфера обміну';

  @override
  String get apiBaseUrl => 'Базова URL API';

  @override
  String get selectModel => 'Вибрати Модель';

  @override
  String get modelId => 'ID Моделі';

  @override
  String get validateKey => 'Перевірити Ключ';

  @override
  String get validating => 'Перевірка...';

  @override
  String get invalidApiKey => 'Недійсний API-ключ';

  @override
  String get gatewayConfiguration => 'Конфігурація Шлюзу';

  @override
  String get gatewayConfigDesc =>
      'Шлюз - це локальна площина управління вашого асистента.';

  @override
  String get defaultSettingsNote =>
      'Налаштування за замовчуванням працюють для більшості користувачів. Змінюйте лише якщо знаєте, що вам потрібно.';

  @override
  String get host => 'Хост';

  @override
  String get port => 'Порт';

  @override
  String get autoStartGateway => 'Автозапуск шлюзу';

  @override
  String get autoStartGatewayDesc =>
      'Запускати шлюз автоматично при запуску додатку.';

  @override
  String get channelsPageTitle => 'Канали';

  @override
  String get channelsPageDesc =>
      'Підключіть канали обміну повідомленнями за бажанням. Ви завжди можете налаштувати їх пізніше в Налаштуваннях.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Підключіть бота Telegram.';

  @override
  String get openBotFather => 'Відкрити BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Підключіть бота Discord.';

  @override
  String get developerPortal => 'Портал Розробника';

  @override
  String get botToken => 'Токен Бота';

  @override
  String telegramBotToken(String platform) {
    return 'Токен Бота $platform';
  }

  @override
  String get readyToGo => 'Готово до Запуску';

  @override
  String get reviewConfiguration =>
      'Перевірте конфігурацію і запустіть FlutterClaw.';

  @override
  String get model => 'Модель';

  @override
  String viaProvider(String provider) {
    return 'через $provider';
  }

  @override
  String get gateway => 'Шлюз';

  @override
  String get webChatOnly => 'Тільки WebChat (можете додати більше пізніше)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Запуск...';

  @override
  String get startFlutterClaw => 'Запустити FlutterClaw';

  @override
  String get newSession => 'Нова сесія';

  @override
  String get photoLibrary => 'Бібліотека Фото';

  @override
  String get camera => 'Камера';

  @override
  String get whatDoYouSeeInImage => 'Що ви бачите на цьому зображенні?';

  @override
  String get imagePickerNotAvailable =>
      'Вибір зображень недоступний у симуляторі. Використовуйте реальний пристрій.';

  @override
  String get couldNotOpenImagePicker => 'Не вдалося відкрити вибір зображень.';

  @override
  String get copiedToClipboard => 'Скопійовано в буфер обміну';

  @override
  String get attachImage => 'Прикріпити зображення';

  @override
  String get messageFlutterClaw => 'Повідомлення FlutterClaw...';

  @override
  String get channelsAndGateway => 'Канали та Шлюз';

  @override
  String get stop => 'Зупинити';

  @override
  String get start => 'Запустити';

  @override
  String status(String status) {
    return 'Статус: $status';
  }

  @override
  String get builtInChatInterface => 'Вбудований інтерфейс чату';

  @override
  String get notConfigured => 'Не налаштовано';

  @override
  String get connected => 'Підключено';

  @override
  String get configuredStarting => 'Налаштовано (запуск...)';

  @override
  String get telegramConfiguration => 'Конфігурація Telegram';

  @override
  String get fromBotFather => 'Від @BotFather';

  @override
  String get allowedUserIds => 'Дозволені ID користувачів (через кому)';

  @override
  String get leaveEmptyToAllowAll => 'Залиште порожнім, щоб дозволити всім';

  @override
  String get cancel => 'Скасувати';

  @override
  String get saveAndConnect => 'Зберегти та Підключити';

  @override
  String get discordConfiguration => 'Конфігурація Discord';

  @override
  String get pendingPairingRequests => 'Очікувані Запити на Парування';

  @override
  String get approve => 'Затвердити';

  @override
  String get reject => 'Відхилити';

  @override
  String get expired => 'Закінчився';

  @override
  String minutesLeft(int minutes) {
    return 'Залишилось $minutesхв';
  }

  @override
  String get workspaceFiles => 'Файли Робочого Простору';

  @override
  String get personalAIAssistant => 'Особистий AI-Асистент';

  @override
  String sessionsCount(int count) {
    return 'Сесії ($count)';
  }

  @override
  String get noActiveSessions => 'Немає активних сесій';

  @override
  String get startConversationToCreate => 'Почніть розмову, щоб створити';

  @override
  String get startConversationToSee =>
      'Почніть розмову, щоб побачити сесії тут';

  @override
  String get reset => 'Скинути';

  @override
  String get cronJobs => 'Заплановані Завдання';

  @override
  String get noCronJobs => 'Немає запланованих завдань';

  @override
  String get addScheduledTasks =>
      'Додайте заплановані завдання для вашого агента';

  @override
  String get runNow => 'Виконати Зараз';

  @override
  String get enable => 'Увімкнути';

  @override
  String get disable => 'Вимкнути';

  @override
  String get delete => 'Видалити';

  @override
  String get skills => 'Навички';

  @override
  String get browseClawHub => 'Переглянути ClawHub';

  @override
  String get noSkillsInstalled => 'Навички не встановлені';

  @override
  String get browseClawHubToAdd => 'Перегляньте ClawHub, щоб додати навички';

  @override
  String removeSkillConfirm(String name) {
    return 'Видалити \"$name\" з ваших навичок?';
  }

  @override
  String get clawHubSkills => 'Навички ClawHub';

  @override
  String get searchSkills => 'Пошук навичок...';

  @override
  String get noSkillsFound => 'Навички не знайдені. Спробуйте інший пошук.';

  @override
  String installedSkill(String name) {
    return '$name встановлено';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'Не вдалося встановити $name';
  }

  @override
  String get addCronJob => 'Додати Заплановане Завдання';

  @override
  String get jobName => 'Назва Завдання';

  @override
  String get dailySummaryExample => 'напр. Щоденна Зведення';

  @override
  String get taskPrompt => 'Опис Завдання';

  @override
  String get whatShouldAgentDo => 'Що має робити агент?';

  @override
  String get interval => 'Інтервал';

  @override
  String get every5Minutes => 'Кожні 5 хвилин';

  @override
  String get every15Minutes => 'Кожні 15 хвилин';

  @override
  String get every30Minutes => 'Кожні 30 хвилин';

  @override
  String get everyHour => 'Щогодини';

  @override
  String get every6Hours => 'Кожні 6 годин';

  @override
  String get every12Hours => 'Кожні 12 годин';

  @override
  String get every24Hours => 'Кожні 24 години';

  @override
  String get add => 'Додати';

  @override
  String get save => 'Зберегти';

  @override
  String get sessions => 'Сесії';

  @override
  String messagesCount(int count) {
    return '$count повідомлень';
  }

  @override
  String tokensCount(int count) {
    return '$count токенів';
  }

  @override
  String get compact => 'Стиснути';

  @override
  String get models => 'Моделі';

  @override
  String get noModelsConfigured => 'Моделі не налаштовані';

  @override
  String get addModelToStartChatting =>
      'Додайте модель, щоб почати спілкування';

  @override
  String get addModel => 'Додати Модель';

  @override
  String get default_ => 'ЗА ЗАМОВЧУВАННЯМ';

  @override
  String get autoStart => 'Автозапуск';

  @override
  String get startGatewayWhenLaunches => 'Запускати шлюз при запуску додатку';

  @override
  String get heartbeat => 'Серцебиття';

  @override
  String get enabled => 'Увімкнено';

  @override
  String get periodicAgentTasks => 'Періодичні завдання агента з HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes хв';
  }

  @override
  String get about => 'Про Програму';

  @override
  String get personalAIAssistantForIOS =>
      'Особистий AI-Асистент для iOS та Android';

  @override
  String get version => 'Версія';

  @override
  String get basedOnOpenClaw => 'Засновано на OpenClaw';

  @override
  String get removeModel => 'Видалити модель?';

  @override
  String removeModelConfirm(String name) {
    return 'Видалити \"$name\" з ваших моделей?';
  }

  @override
  String get remove => 'Видалити';

  @override
  String get setAsDefault => 'Встановити За Замовчуванням';

  @override
  String get paste => 'Вставити';

  @override
  String get chooseProviderStep => '1. Вибрати Провайдера';

  @override
  String get selectModelStep => '2. Вибрати Модель';

  @override
  String get apiKeyStep => '3. API-ключ';

  @override
  String getApiKeyAt(String provider) {
    return 'Отримати API-ключ на $provider';
  }

  @override
  String get justNow => 'щойно';

  @override
  String minutesAgo(int minutes) {
    return '$minutesхв тому';
  }

  @override
  String hoursAgo(int hours) {
    return '$hoursгод тому';
  }

  @override
  String daysAgo(int days) {
    return '$daysд тому';
  }
}
