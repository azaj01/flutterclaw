// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Czat';

  @override
  String get channels => 'Kanały';

  @override
  String get agent => 'Agent';

  @override
  String get settings => 'Ustawienia';

  @override
  String get getStarted => 'Rozpocznij';

  @override
  String get yourPersonalAssistant => 'Twój osobisty asystent AI';

  @override
  String get multiChannelChat => 'Czat wielokanałowy';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat i więcej';

  @override
  String get powerfulAIModels => 'Potężne modele AI';

  @override
  String get powerfulAIModelsDesc => 'OpenAI, Anthropic, Grok i darmowe modele';

  @override
  String get localGateway => 'Lokalna brama';

  @override
  String get localGatewayDesc =>
      'Działa na Twoim urządzeniu, Twoje dane pozostają Twoje';

  @override
  String get chooseProvider => 'Wybierz Dostawcę';

  @override
  String get selectProviderDesc =>
      'Wybierz, jak chcesz połączyć się z modelami AI.';

  @override
  String get startForFree => 'Zacznij Za Darmo';

  @override
  String get freeProvidersDesc =>
      'Ci dostawcy oferują darmowe modele, aby rozpocząć bez kosztów.';

  @override
  String get free => 'DARMOWE';

  @override
  String get otherProviders => 'Inni Dostawcy';

  @override
  String connectToProvider(String provider) {
    return 'Połącz z $provider';
  }

  @override
  String get enterApiKeyDesc => 'Wprowadź swój klucz API i wybierz model.';

  @override
  String get dontHaveApiKey => 'Nie masz klucza API?';

  @override
  String get createAccountCopyKey => 'Utwórz konto i skopiuj swój klucz.';

  @override
  String get signUp => 'Zarejestruj się';

  @override
  String get apiKey => 'Klucz API';

  @override
  String get pasteFromClipboard => 'Wklej ze schowka';

  @override
  String get apiBaseUrl => 'Bazowy URL API';

  @override
  String get selectModel => 'Wybierz Model';

  @override
  String get modelId => 'ID Modelu';

  @override
  String get validateKey => 'Sprawdź Klucz';

  @override
  String get validating => 'Sprawdzanie...';

  @override
  String get invalidApiKey => 'Nieprawidłowy klucz API';

  @override
  String get gatewayConfiguration => 'Konfiguracja Bramy';

  @override
  String get gatewayConfigDesc =>
      'Brama jest lokalną płaszczyzną kontroli Twojego asystenta.';

  @override
  String get defaultSettingsNote =>
      'Domyślne ustawienia działają dla większości użytkowników. Zmieniaj tylko jeśli wiesz, czego potrzebujesz.';

  @override
  String get host => 'Host';

  @override
  String get port => 'Port';

  @override
  String get autoStartGateway => 'Automatyczne uruchamianie bramy';

  @override
  String get autoStartGatewayDesc =>
      'Uruchom bramę automatycznie po uruchomieniu aplikacji.';

  @override
  String get channelsPageTitle => 'Kanały';

  @override
  String get channelsPageDesc =>
      'Opcjonalnie podłącz kanały komunikacyjne. Zawsze możesz je skonfigurować później w Ustawieniach.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Podłącz bota Telegram.';

  @override
  String get openBotFather => 'Otwórz BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Podłącz bota Discord.';

  @override
  String get developerPortal => 'Portal Dewelopera';

  @override
  String get botToken => 'Token Bota';

  @override
  String telegramBotToken(String platform) {
    return 'Token Bota $platform';
  }

  @override
  String get readyToGo => 'Gotowe do Startu';

  @override
  String get reviewConfiguration =>
      'Przejrzyj konfigurację i uruchom FlutterClaw.';

  @override
  String get model => 'Model';

  @override
  String viaProvider(String provider) {
    return 'przez $provider';
  }

  @override
  String get gateway => 'Brama';

  @override
  String get webChatOnly => 'Tylko WebChat (możesz dodać więcej później)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Uruchamianie...';

  @override
  String get startFlutterClaw => 'Uruchom FlutterClaw';

  @override
  String get newSession => 'Nowa sesja';

  @override
  String get photoLibrary => 'Biblioteka Zdjęć';

  @override
  String get camera => 'Kamera';

  @override
  String get whatDoYouSeeInImage => 'Co widzisz na tym obrazie?';

  @override
  String get imagePickerNotAvailable =>
      'Wybór obrazu niedostępny na Symulatorze. Użyj prawdziwego urządzenia.';

  @override
  String get couldNotOpenImagePicker => 'Nie można otworzyć wyboru obrazu.';

  @override
  String get copiedToClipboard => 'Skopiowano do schowka';

  @override
  String get attachImage => 'Dołącz obraz';

  @override
  String get messageFlutterClaw => 'Wiadomość do FlutterClaw...';

  @override
  String get channelsAndGateway => 'Kanały i Brama';

  @override
  String get stop => 'Zatrzymaj';

  @override
  String get start => 'Uruchom';

  @override
  String status(String status) {
    return 'Status: $status';
  }

  @override
  String get builtInChatInterface => 'Wbudowany interfejs czatu';

  @override
  String get notConfigured => 'Nieskonfigurowane';

  @override
  String get connected => 'Połączono';

  @override
  String get configuredStarting => 'Skonfigurowane (uruchamianie...)';

  @override
  String get telegramConfiguration => 'Konfiguracja Telegram';

  @override
  String get fromBotFather => 'Od @BotFather';

  @override
  String get allowedUserIds =>
      'Dozwolone ID Użytkowników (oddzielone przecinkami)';

  @override
  String get leaveEmptyToAllowAll => 'Pozostaw puste, aby zezwolić wszystkim';

  @override
  String get cancel => 'Anuluj';

  @override
  String get saveAndConnect => 'Zapisz i Połącz';

  @override
  String get discordConfiguration => 'Konfiguracja Discord';

  @override
  String get pendingPairingRequests => 'Oczekujące Żądania Parowania';

  @override
  String get approve => 'Zatwierdź';

  @override
  String get reject => 'Odrzuć';

  @override
  String get expired => 'Wygasło';

  @override
  String minutesLeft(int minutes) {
    return 'Pozostało ${minutes}m';
  }

  @override
  String get workspaceFiles => 'Pliki Przestrzeni Roboczej';

  @override
  String get personalAIAssistant => 'Osobisty Asystent AI';

  @override
  String sessionsCount(int count) {
    return 'Sesje ($count)';
  }

  @override
  String get noActiveSessions => 'Brak aktywnych sesji';

  @override
  String get startConversationToCreate => 'Rozpocznij rozmowę, aby utworzyć';

  @override
  String get startConversationToSee =>
      'Rozpocznij rozmowę, aby zobaczyć sesje tutaj';

  @override
  String get reset => 'Resetuj';

  @override
  String get cronJobs => 'Zadania Zaplanowane';

  @override
  String get noCronJobs => 'Brak zaplanowanych zadań';

  @override
  String get addScheduledTasks =>
      'Dodaj zaplanowane zadania dla swojego agenta';

  @override
  String get runNow => 'Uruchom Teraz';

  @override
  String get enable => 'Włącz';

  @override
  String get disable => 'Wyłącz';

  @override
  String get delete => 'Usuń';

  @override
  String get skills => 'Umiejętności';

  @override
  String get browseClawHub => 'Przeglądaj ClawHub';

  @override
  String get noSkillsInstalled => 'Brak zainstalowanych umiejętności';

  @override
  String get browseClawHubToAdd => 'Przeglądaj ClawHub, aby dodać umiejętności';

  @override
  String removeSkillConfirm(String name) {
    return 'Usunąć \"$name\" z Twoich umiejętności?';
  }

  @override
  String get clawHubSkills => 'Umiejętności ClawHub';

  @override
  String get searchSkills => 'Szukaj umiejętności...';

  @override
  String get noSkillsFound =>
      'Nie znaleziono umiejętności. Spróbuj innego wyszukiwania.';

  @override
  String installedSkill(String name) {
    return 'Zainstalowano $name';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'Nie udało się zainstalować $name';
  }

  @override
  String get addCronJob => 'Dodaj Zadanie Zaplanowane';

  @override
  String get jobName => 'Nazwa Zadania';

  @override
  String get dailySummaryExample => 'np. Codzienne Podsumowanie';

  @override
  String get taskPrompt => 'Polecenie Zadania';

  @override
  String get whatShouldAgentDo => 'Co powinien zrobić agent?';

  @override
  String get interval => 'Interwał';

  @override
  String get every5Minutes => 'Co 5 minut';

  @override
  String get every15Minutes => 'Co 15 minut';

  @override
  String get every30Minutes => 'Co 30 minut';

  @override
  String get everyHour => 'Co godzinę';

  @override
  String get every6Hours => 'Co 6 godzin';

  @override
  String get every12Hours => 'Co 12 godzin';

  @override
  String get every24Hours => 'Co 24 godziny';

  @override
  String get add => 'Dodaj';

  @override
  String get save => 'Zapisz';

  @override
  String get sessions => 'Sesje';

  @override
  String messagesCount(int count) {
    return '$count wiadomości';
  }

  @override
  String tokensCount(int count) {
    return '$count tokenów';
  }

  @override
  String get compact => 'Kompaktuj';

  @override
  String get models => 'Modele';

  @override
  String get noModelsConfigured => 'Brak skonfigurowanych modeli';

  @override
  String get addModelToStartChatting => 'Dodaj model, aby rozpocząć czat';

  @override
  String get addModel => 'Dodaj Model';

  @override
  String get default_ => 'DOMYŚLNY';

  @override
  String get autoStart => 'Automatyczne uruchamianie';

  @override
  String get startGatewayWhenLaunches =>
      'Uruchom bramę po uruchomieniu aplikacji';

  @override
  String get heartbeat => 'Bicie Serca';

  @override
  String get enabled => 'Włączone';

  @override
  String get periodicAgentTasks => 'Okresowe zadania agenta z HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get about => 'O Programie';

  @override
  String get personalAIAssistantForIOS =>
      'Osobisty Asystent AI dla iOS i Android';

  @override
  String get version => 'Wersja';

  @override
  String get basedOnOpenClaw => 'Oparty na OpenClaw';

  @override
  String get removeModel => 'Usunąć model?';

  @override
  String removeModelConfirm(String name) {
    return 'Usunąć \"$name\" z Twoich modeli?';
  }

  @override
  String get remove => 'Usuń';

  @override
  String get setAsDefault => 'Ustaw jako Domyślny';

  @override
  String get paste => 'Wklej';

  @override
  String get chooseProviderStep => '1. Wybierz Dostawcę';

  @override
  String get selectModelStep => '2. Wybierz Model';

  @override
  String get apiKeyStep => '3. Klucz API';

  @override
  String getApiKeyAt(String provider) {
    return 'Uzyskaj klucz API na $provider';
  }

  @override
  String get justNow => 'właśnie teraz';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m temu';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}g temu';
  }

  @override
  String daysAgo(int days) {
    return '${days}d temu';
  }
}
