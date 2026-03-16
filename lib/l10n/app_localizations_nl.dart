// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Chat';

  @override
  String get channels => 'Kanalen';

  @override
  String get agent => 'Agent';

  @override
  String get settings => 'Instellingen';

  @override
  String get getStarted => 'Aan de slag';

  @override
  String get yourPersonalAssistant => 'Uw persoonlijke AI-assistent';

  @override
  String get multiChannelChat => 'Multikanaalchat';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat en meer';

  @override
  String get powerfulAIModels => 'Krachtige AI-modellen';

  @override
  String get powerfulAIModelsDesc =>
      'OpenAI, Anthropic, Grok en gratis modellen';

  @override
  String get localGateway => 'Lokale gateway';

  @override
  String get localGatewayDesc =>
      'Draait op uw apparaat, uw gegevens blijven van u';

  @override
  String get chooseProvider => 'Kies een Provider';

  @override
  String get selectProviderDesc =>
      'Selecteer hoe u verbinding wilt maken met AI-modellen.';

  @override
  String get startForFree => 'Start Gratis';

  @override
  String get freeProvidersDesc =>
      'Deze providers bieden gratis modellen om zonder kosten te beginnen.';

  @override
  String get free => 'GRATIS';

  @override
  String get otherProviders => 'Andere Providers';

  @override
  String connectToProvider(String provider) {
    return 'Verbind met $provider';
  }

  @override
  String get enterApiKeyDesc =>
      'Voer uw API-sleutel in en selecteer een model.';

  @override
  String get dontHaveApiKey => 'Heeft u geen API-sleutel?';

  @override
  String get createAccountCopyKey =>
      'Maak een account aan en kopieer uw sleutel.';

  @override
  String get signUp => 'Aanmelden';

  @override
  String get apiKey => 'API-sleutel';

  @override
  String get pasteFromClipboard => 'Plakken vanaf klembord';

  @override
  String get apiBaseUrl => 'API Basis-URL';

  @override
  String get selectModel => 'Selecteer Model';

  @override
  String get modelId => 'Model-ID';

  @override
  String get validateKey => 'Valideer Sleutel';

  @override
  String get validating => 'Valideren...';

  @override
  String get invalidApiKey => 'Ongeldige API-sleutel';

  @override
  String get gatewayConfiguration => 'Gateway Configuratie';

  @override
  String get gatewayConfigDesc =>
      'De gateway is het lokale controlevlak voor uw assistent.';

  @override
  String get defaultSettingsNote =>
      'De standaardinstellingen werken voor de meeste gebruikers. Wijzig alleen als u weet wat u nodig heeft.';

  @override
  String get host => 'Host';

  @override
  String get port => 'Poort';

  @override
  String get autoStartGateway => 'Gateway automatisch starten';

  @override
  String get autoStartGatewayDesc =>
      'Start de gateway automatisch wanneer de app wordt gestart.';

  @override
  String get channelsPageTitle => 'Kanalen';

  @override
  String get channelsPageDesc =>
      'Verbind optioneel berichtkanalen. U kunt deze altijd later configureren in Instellingen.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Verbind een Telegram-bot.';

  @override
  String get openBotFather => 'Open BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Verbind een Discord-bot.';

  @override
  String get developerPortal => 'Ontwikkelaarsportaal';

  @override
  String get botToken => 'Bot-token';

  @override
  String telegramBotToken(String platform) {
    return '$platform Bot-token';
  }

  @override
  String get readyToGo => 'Klaar om te Beginnen';

  @override
  String get reviewConfiguration =>
      'Controleer uw configuratie en start FlutterClaw.';

  @override
  String get model => 'Model';

  @override
  String viaProvider(String provider) {
    return 'via $provider';
  }

  @override
  String get gateway => 'Gateway';

  @override
  String get webChatOnly => 'Alleen WebChat (u kunt later meer toevoegen)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Starten...';

  @override
  String get startFlutterClaw => 'Start FlutterClaw';

  @override
  String get newSession => 'Nieuwe sessie';

  @override
  String get photoLibrary => 'Fotobibliotheek';

  @override
  String get camera => 'Camera';

  @override
  String get whatDoYouSeeInImage => 'Wat ziet u in deze afbeelding?';

  @override
  String get imagePickerNotAvailable =>
      'Afbeeldingskiezer niet beschikbaar op Simulator. Gebruik een echt apparaat.';

  @override
  String get couldNotOpenImagePicker => 'Kon afbeeldingskiezer niet openen.';

  @override
  String get copiedToClipboard => 'Gekopieerd naar klembord';

  @override
  String get attachImage => 'Afbeelding bijvoegen';

  @override
  String get messageFlutterClaw => 'Bericht aan FlutterClaw...';

  @override
  String get channelsAndGateway => 'Kanalen en Gateway';

  @override
  String get stop => 'Stop';

  @override
  String get start => 'Start';

  @override
  String status(String status) {
    return 'Status: $status';
  }

  @override
  String get builtInChatInterface => 'Ingebouwde chatinterface';

  @override
  String get notConfigured => 'Niet geconfigureerd';

  @override
  String get connected => 'Verbonden';

  @override
  String get configuredStarting => 'Geconfigureerd (starten...)';

  @override
  String get telegramConfiguration => 'Telegram Configuratie';

  @override
  String get fromBotFather => 'Van @BotFather';

  @override
  String get allowedUserIds => 'Toegestane Gebruikers-ID\'s (kommagescheiden)';

  @override
  String get leaveEmptyToAllowAll => 'Laat leeg om iedereen toe te staan';

  @override
  String get cancel => 'Annuleren';

  @override
  String get saveAndConnect => 'Opslaan en Verbinden';

  @override
  String get discordConfiguration => 'Discord Configuratie';

  @override
  String get pendingPairingRequests => 'Openstaande Koppelingaanvragen';

  @override
  String get approve => 'Goedkeuren';

  @override
  String get reject => 'Afwijzen';

  @override
  String get expired => 'Verlopen';

  @override
  String minutesLeft(int minutes) {
    return '${minutes}m over';
  }

  @override
  String get workspaceFiles => 'Werkruimtebestanden';

  @override
  String get personalAIAssistant => 'Persoonlijke AI-assistent';

  @override
  String sessionsCount(int count) {
    return 'Sessies ($count)';
  }

  @override
  String get noActiveSessions => 'Geen actieve sessies';

  @override
  String get startConversationToCreate =>
      'Start een gesprek om er een te maken';

  @override
  String get startConversationToSee =>
      'Start een gesprek om sessies hier te zien';

  @override
  String get reset => 'Resetten';

  @override
  String get cronJobs => 'Geplande Taken';

  @override
  String get noCronJobs => 'Geen geplande taken';

  @override
  String get addScheduledTasks => 'Voeg geplande taken toe voor uw agent';

  @override
  String get runNow => 'Nu Uitvoeren';

  @override
  String get enable => 'Inschakelen';

  @override
  String get disable => 'Uitschakelen';

  @override
  String get delete => 'Verwijderen';

  @override
  String get skills => 'Vaardigheden';

  @override
  String get browseClawHub => 'Blader door ClawHub';

  @override
  String get noSkillsInstalled => 'Geen vaardigheden geïnstalleerd';

  @override
  String get browseClawHubToAdd =>
      'Blader door ClawHub om vaardigheden toe te voegen';

  @override
  String removeSkillConfirm(String name) {
    return '\"$name\" verwijderen uit uw vaardigheden?';
  }

  @override
  String get clawHubSkills => 'ClawHub Vaardigheden';

  @override
  String get searchSkills => 'Zoek vaardigheden...';

  @override
  String get noSkillsFound =>
      'Geen vaardigheden gevonden. Probeer een andere zoekopdracht.';

  @override
  String installedSkill(String name) {
    return '$name geïnstalleerd';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'Installeren van $name mislukt';
  }

  @override
  String get addCronJob => 'Geplande Taak Toevoegen';

  @override
  String get jobName => 'Taaknaam';

  @override
  String get dailySummaryExample => 'bijv. Dagelijkse Samenvatting';

  @override
  String get taskPrompt => 'Taakprompt';

  @override
  String get whatShouldAgentDo => 'Wat moet de agent doen?';

  @override
  String get interval => 'Interval';

  @override
  String get every5Minutes => 'Elke 5 minuten';

  @override
  String get every15Minutes => 'Elke 15 minuten';

  @override
  String get every30Minutes => 'Elke 30 minuten';

  @override
  String get everyHour => 'Elk uur';

  @override
  String get every6Hours => 'Elke 6 uur';

  @override
  String get every12Hours => 'Elke 12 uur';

  @override
  String get every24Hours => 'Elke 24 uur';

  @override
  String get add => 'Toevoegen';

  @override
  String get save => 'Opslaan';

  @override
  String get sessions => 'Sessies';

  @override
  String messagesCount(int count) {
    return '$count berichten';
  }

  @override
  String tokensCount(int count) {
    return '$count tokens';
  }

  @override
  String get compact => 'Comprimeren';

  @override
  String get models => 'Modellen';

  @override
  String get noModelsConfigured => 'Geen modellen geconfigureerd';

  @override
  String get addModelToStartChatting =>
      'Voeg een model toe om te beginnen met chatten';

  @override
  String get addModel => 'Model Toevoegen';

  @override
  String get default_ => 'STANDAARD';

  @override
  String get autoStart => 'Automatisch starten';

  @override
  String get startGatewayWhenLaunches =>
      'Start gateway wanneer app wordt gestart';

  @override
  String get heartbeat => 'Hartslag';

  @override
  String get enabled => 'Ingeschakeld';

  @override
  String get periodicAgentTasks => 'Periodieke agenttaken van HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get about => 'Over';

  @override
  String get personalAIAssistantForIOS =>
      'Persoonlijke AI-assistent voor iOS en Android';

  @override
  String get version => 'Versie';

  @override
  String get basedOnOpenClaw => 'Gebaseerd op OpenClaw';

  @override
  String get removeModel => 'Model verwijderen?';

  @override
  String removeModelConfirm(String name) {
    return '\"$name\" verwijderen uit uw modellen?';
  }

  @override
  String get remove => 'Verwijderen';

  @override
  String get setAsDefault => 'Instellen als Standaard';

  @override
  String get paste => 'Plakken';

  @override
  String get chooseProviderStep => '1. Kies Provider';

  @override
  String get selectModelStep => '2. Selecteer Model';

  @override
  String get apiKeyStep => '3. API-sleutel';

  @override
  String getApiKeyAt(String provider) {
    return 'Verkrijg API-sleutel bij $provider';
  }

  @override
  String get justNow => 'zojuist';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m geleden';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}u geleden';
  }

  @override
  String daysAgo(int days) {
    return '${days}d geleden';
  }
}
