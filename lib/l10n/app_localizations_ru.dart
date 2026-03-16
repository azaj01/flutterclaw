// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Чат';

  @override
  String get channels => 'Каналы';

  @override
  String get agent => 'Агент';

  @override
  String get settings => 'Настройки';

  @override
  String get getStarted => 'Начать';

  @override
  String get yourPersonalAssistant => 'Ваш личный ИИ-ассистент';

  @override
  String get multiChannelChat => 'Мультиканальный чат';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat и другие';

  @override
  String get powerfulAIModels => 'Мощные модели ИИ';

  @override
  String get powerfulAIModelsDesc =>
      'OpenAI, Anthropic, Grok и бесплатные модели';

  @override
  String get localGateway => 'Локальный шлюз';

  @override
  String get localGatewayDesc =>
      'Работает на вашем устройстве, ваши данные остаются вашими';

  @override
  String get chooseProvider => 'Выбрать Провайдера';

  @override
  String get selectProviderDesc =>
      'Выберите, как вы хотите подключиться к моделям ИИ.';

  @override
  String get startForFree => 'Начать Бесплатно';

  @override
  String get freeProvidersDesc =>
      'Эти провайдеры предлагают бесплатные модели для начала работы без затрат.';

  @override
  String get free => 'БЕСПЛАТНО';

  @override
  String get otherProviders => 'Другие Провайдеры';

  @override
  String connectToProvider(String provider) {
    return 'Подключиться к $provider';
  }

  @override
  String get enterApiKeyDesc => 'Введите ваш API-ключ и выберите модель.';

  @override
  String get dontHaveApiKey => 'Нет API-ключа?';

  @override
  String get createAccountCopyKey =>
      'Создайте учетную запись и скопируйте ключ.';

  @override
  String get signUp => 'Зарегистрироваться';

  @override
  String get apiKey => 'API-ключ';

  @override
  String get pasteFromClipboard => 'Вставить из буфера обмена';

  @override
  String get apiBaseUrl => 'Базовый URL API';

  @override
  String get selectModel => 'Выбрать Модель';

  @override
  String get modelId => 'ID Модели';

  @override
  String get validateKey => 'Проверить Ключ';

  @override
  String get validating => 'Проверка...';

  @override
  String get invalidApiKey => 'Недействительный API-ключ';

  @override
  String get gatewayConfiguration => 'Конфигурация Шлюза';

  @override
  String get gatewayConfigDesc =>
      'Шлюз - это локальная плоскость управления вашего ассистента.';

  @override
  String get defaultSettingsNote =>
      'Настройки по умолчанию работают для большинства пользователей. Изменяйте только если знаете, что вам нужно.';

  @override
  String get host => 'Хост';

  @override
  String get port => 'Порт';

  @override
  String get autoStartGateway => 'Автозапуск шлюза';

  @override
  String get autoStartGatewayDesc =>
      'Запускать шлюз автоматически при запуске приложения.';

  @override
  String get channelsPageTitle => 'Каналы';

  @override
  String get channelsPageDesc =>
      'Подключите каналы обмена сообщениями опционально. Вы всегда можете настроить их позже в Настройках.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Подключите бота Telegram.';

  @override
  String get openBotFather => 'Открыть BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Подключите бота Discord.';

  @override
  String get developerPortal => 'Портал Разработчика';

  @override
  String get botToken => 'Токен Бота';

  @override
  String telegramBotToken(String platform) {
    return 'Токен Бота $platform';
  }

  @override
  String get readyToGo => 'Готово к Запуску';

  @override
  String get reviewConfiguration =>
      'Проверьте конфигурацию и запустите FlutterClaw.';

  @override
  String get model => 'Модель';

  @override
  String viaProvider(String provider) {
    return 'через $provider';
  }

  @override
  String get gateway => 'Шлюз';

  @override
  String get webChatOnly => 'Только WebChat (можете добавить больше позже)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Запуск...';

  @override
  String get startFlutterClaw => 'Запустить FlutterClaw';

  @override
  String get newSession => 'Новая сессия';

  @override
  String get photoLibrary => 'Библиотека Фото';

  @override
  String get camera => 'Камера';

  @override
  String get whatDoYouSeeInImage => 'Что вы видите на этом изображении?';

  @override
  String get imagePickerNotAvailable =>
      'Выбор изображений недоступен в симуляторе. Используйте реальное устройство.';

  @override
  String get couldNotOpenImagePicker => 'Не удалось открыть выбор изображений.';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get attachImage => 'Прикрепить изображение';

  @override
  String get messageFlutterClaw => 'Сообщение FlutterClaw...';

  @override
  String get channelsAndGateway => 'Каналы и Шлюз';

  @override
  String get stop => 'Остановить';

  @override
  String get start => 'Запустить';

  @override
  String status(String status) {
    return 'Статус: $status';
  }

  @override
  String get builtInChatInterface => 'Встроенный интерфейс чата';

  @override
  String get notConfigured => 'Не настроено';

  @override
  String get connected => 'Подключено';

  @override
  String get configuredStarting => 'Настроено (запуск...)';

  @override
  String get telegramConfiguration => 'Конфигурация Telegram';

  @override
  String get fromBotFather => 'От @BotFather';

  @override
  String get allowedUserIds => 'Разрешенные ID пользователей (через запятую)';

  @override
  String get leaveEmptyToAllowAll => 'Оставьте пустым, чтобы разрешить всем';

  @override
  String get cancel => 'Отмена';

  @override
  String get saveAndConnect => 'Сохранить и Подключить';

  @override
  String get discordConfiguration => 'Конфигурация Discord';

  @override
  String get pendingPairingRequests => 'Ожидающие Запросы на Сопряжение';

  @override
  String get approve => 'Одобрить';

  @override
  String get reject => 'Отклонить';

  @override
  String get expired => 'Истекло';

  @override
  String minutesLeft(int minutes) {
    return 'Осталось $minutesм';
  }

  @override
  String get workspaceFiles => 'Файлы Рабочего Пространства';

  @override
  String get personalAIAssistant => 'Личный ИИ-Ассистент';

  @override
  String sessionsCount(int count) {
    return 'Сессии ($count)';
  }

  @override
  String get noActiveSessions => 'Нет активных сессий';

  @override
  String get startConversationToCreate => 'Начните разговор, чтобы создать';

  @override
  String get startConversationToSee =>
      'Начните разговор, чтобы увидеть сессии здесь';

  @override
  String get reset => 'Сбросить';

  @override
  String get cronJobs => 'Запланированные Задачи';

  @override
  String get noCronJobs => 'Нет запланированных задач';

  @override
  String get addScheduledTasks =>
      'Добавьте запланированные задачи для вашего агента';

  @override
  String get runNow => 'Выполнить Сейчас';

  @override
  String get enable => 'Включить';

  @override
  String get disable => 'Отключить';

  @override
  String get delete => 'Удалить';

  @override
  String get skills => 'Навыки';

  @override
  String get browseClawHub => 'Просмотреть ClawHub';

  @override
  String get noSkillsInstalled => 'Навыки не установлены';

  @override
  String get browseClawHubToAdd => 'Просмотрите ClawHub, чтобы добавить навыки';

  @override
  String removeSkillConfirm(String name) {
    return 'Удалить \"$name\" из ваших навыков?';
  }

  @override
  String get clawHubSkills => 'Навыки ClawHub';

  @override
  String get searchSkills => 'Поиск навыков...';

  @override
  String get noSkillsFound => 'Навыки не найдены. Попробуйте другой поиск.';

  @override
  String installedSkill(String name) {
    return '$name установлено';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'Не удалось установить $name';
  }

  @override
  String get addCronJob => 'Добавить Запланированную Задачу';

  @override
  String get jobName => 'Название Задачи';

  @override
  String get dailySummaryExample => 'напр. Ежедневная Сводка';

  @override
  String get taskPrompt => 'Описание Задачи';

  @override
  String get whatShouldAgentDo => 'Что должен делать агент?';

  @override
  String get interval => 'Интервал';

  @override
  String get every5Minutes => 'Каждые 5 минут';

  @override
  String get every15Minutes => 'Каждые 15 минут';

  @override
  String get every30Minutes => 'Каждые 30 минут';

  @override
  String get everyHour => 'Каждый час';

  @override
  String get every6Hours => 'Каждые 6 часов';

  @override
  String get every12Hours => 'Каждые 12 часов';

  @override
  String get every24Hours => 'Каждые 24 часа';

  @override
  String get add => 'Добавить';

  @override
  String get save => 'Сохранить';

  @override
  String get sessions => 'Сессии';

  @override
  String messagesCount(int count) {
    return '$count сообщений';
  }

  @override
  String tokensCount(int count) {
    return '$count токенов';
  }

  @override
  String get compact => 'Сжать';

  @override
  String get models => 'Модели';

  @override
  String get noModelsConfigured => 'Модели не настроены';

  @override
  String get addModelToStartChatting => 'Добавьте модель, чтобы начать общение';

  @override
  String get addModel => 'Добавить Модель';

  @override
  String get default_ => 'ПО УМОЛЧАНИЮ';

  @override
  String get autoStart => 'Автозапуск';

  @override
  String get startGatewayWhenLaunches =>
      'Запускать шлюз при запуске приложения';

  @override
  String get heartbeat => 'Сердцебиение';

  @override
  String get enabled => 'Включено';

  @override
  String get periodicAgentTasks =>
      'Периодические задачи агента из HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String get about => 'О Программе';

  @override
  String get personalAIAssistantForIOS =>
      'Личный ИИ-Ассистент для iOS и Android';

  @override
  String get version => 'Версия';

  @override
  String get basedOnOpenClaw => 'Основано на OpenClaw';

  @override
  String get removeModel => 'Удалить модель?';

  @override
  String removeModelConfirm(String name) {
    return 'Удалить \"$name\" из ваших моделей?';
  }

  @override
  String get remove => 'Удалить';

  @override
  String get setAsDefault => 'Установить По Умолчанию';

  @override
  String get paste => 'Вставить';

  @override
  String get chooseProviderStep => '1. Выбрать Провайдера';

  @override
  String get selectModelStep => '2. Выбрать Модель';

  @override
  String get apiKeyStep => '3. API-ключ';

  @override
  String getApiKeyAt(String provider) {
    return 'Получить API-ключ в $provider';
  }

  @override
  String get justNow => 'только что';

  @override
  String minutesAgo(int minutes) {
    return '$minutesм назад';
  }

  @override
  String hoursAgo(int hours) {
    return '$hoursч назад';
  }

  @override
  String daysAgo(int days) {
    return '$daysд назад';
  }
}
