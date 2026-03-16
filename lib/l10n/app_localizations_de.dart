// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Chat';

  @override
  String get channels => 'Kanäle';

  @override
  String get agent => 'Agent';

  @override
  String get settings => 'Einstellungen';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get yourPersonalAssistant => 'Ihr persönlicher KI-Assistent';

  @override
  String get multiChannelChat => 'Multi-Kanal-Chat';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat und mehr';

  @override
  String get powerfulAIModels => 'Leistungsstarke KI-Modelle';

  @override
  String get powerfulAIModelsDesc =>
      'OpenAI, Anthropic, Grok und kostenlose Modelle';

  @override
  String get localGateway => 'Lokales Gateway';

  @override
  String get localGatewayDesc =>
      'Läuft auf Ihrem Gerät, Ihre Daten bleiben Ihre';

  @override
  String get chooseProvider => 'Anbieter Wählen';

  @override
  String get selectProviderDesc =>
      'Wählen Sie aus, wie Sie sich mit KI-Modellen verbinden möchten.';

  @override
  String get startForFree => 'Kostenlos Starten';

  @override
  String get freeProvidersDesc =>
      'Diese Anbieter bieten kostenlose Modelle zum kostenlosen Einstieg.';

  @override
  String get free => 'KOSTENLOS';

  @override
  String get otherProviders => 'Andere Anbieter';

  @override
  String connectToProvider(String provider) {
    return 'Verbinden mit $provider';
  }

  @override
  String get enterApiKeyDesc =>
      'Geben Sie Ihren API-Schlüssel ein und wählen Sie ein Modell.';

  @override
  String get dontHaveApiKey => 'Haben Sie keinen API-Schlüssel?';

  @override
  String get createAccountCopyKey =>
      'Erstellen Sie ein Konto und kopieren Sie Ihren Schlüssel.';

  @override
  String get signUp => 'Registrieren';

  @override
  String get apiKey => 'API-Schlüssel';

  @override
  String get pasteFromClipboard => 'Aus Zwischenablage einfügen';

  @override
  String get apiBaseUrl => 'API-Basis-URL';

  @override
  String get selectModel => 'Modell Auswählen';

  @override
  String get modelId => 'Modell-ID';

  @override
  String get validateKey => 'Schlüssel Validieren';

  @override
  String get validating => 'Validierung...';

  @override
  String get invalidApiKey => 'Ungültiger API-Schlüssel';

  @override
  String get gatewayConfiguration => 'Gateway-Konfiguration';

  @override
  String get gatewayConfigDesc =>
      'Das Gateway ist die lokale Steuerungsebene für Ihren Assistenten.';

  @override
  String get defaultSettingsNote =>
      'Die Standardeinstellungen funktionieren für die meisten Benutzer. Ändern Sie sie nur, wenn Sie wissen, was Sie brauchen.';

  @override
  String get host => 'Host';

  @override
  String get port => 'Port';

  @override
  String get autoStartGateway => 'Gateway automatisch starten';

  @override
  String get autoStartGatewayDesc =>
      'Gateway automatisch starten, wenn die App gestartet wird.';

  @override
  String get channelsPageTitle => 'Kanäle';

  @override
  String get channelsPageDesc =>
      'Verbinden Sie optional Messaging-Kanäle. Sie können diese später in den Einstellungen einrichten.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Verbinden Sie einen Telegram-Bot.';

  @override
  String get openBotFather => 'BotFather Öffnen';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Verbinden Sie einen Discord-Bot.';

  @override
  String get developerPortal => 'Entwicklerportal';

  @override
  String get botToken => 'Bot-Token';

  @override
  String telegramBotToken(String platform) {
    return '$platform Bot-Token';
  }

  @override
  String get readyToGo => 'Bereit zum Start';

  @override
  String get reviewConfiguration =>
      'Überprüfen Sie Ihre Konfiguration und starten Sie FlutterClaw.';

  @override
  String get model => 'Modell';

  @override
  String viaProvider(String provider) {
    return 'über $provider';
  }

  @override
  String get gateway => 'Gateway';

  @override
  String get webChatOnly => 'Nur WebChat (Sie können später mehr hinzufügen)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Startet...';

  @override
  String get startFlutterClaw => 'FlutterClaw Starten';

  @override
  String get newSession => 'Neue Sitzung';

  @override
  String get photoLibrary => 'Fotobibliothek';

  @override
  String get camera => 'Kamera';

  @override
  String get whatDoYouSeeInImage => 'Was sehen Sie in diesem Bild?';

  @override
  String get imagePickerNotAvailable =>
      'Bildauswahl im Simulator nicht verfügbar. Verwenden Sie ein echtes Gerät.';

  @override
  String get couldNotOpenImagePicker =>
      'Bildauswahl konnte nicht geöffnet werden.';

  @override
  String get copiedToClipboard => 'In Zwischenablage kopiert';

  @override
  String get attachImage => 'Bild anhängen';

  @override
  String get messageFlutterClaw => 'Nachricht an FlutterClaw...';

  @override
  String get channelsAndGateway => 'Kanäle und Gateway';

  @override
  String get stop => 'Stoppen';

  @override
  String get start => 'Starten';

  @override
  String status(String status) {
    return 'Status: $status';
  }

  @override
  String get builtInChatInterface => 'Integrierte Chat-Oberfläche';

  @override
  String get notConfigured => 'Nicht konfiguriert';

  @override
  String get connected => 'Verbunden';

  @override
  String get configuredStarting => 'Konfiguriert (startet...)';

  @override
  String get telegramConfiguration => 'Telegram-Konfiguration';

  @override
  String get fromBotFather => 'Von @BotFather';

  @override
  String get allowedUserIds => 'Erlaubte Benutzer-IDs (durch Komma getrennt)';

  @override
  String get leaveEmptyToAllowAll => 'Leer lassen, um alle zuzulassen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get saveAndConnect => 'Speichern und Verbinden';

  @override
  String get discordConfiguration => 'Discord-Konfiguration';

  @override
  String get pendingPairingRequests => 'Ausstehende Kopplungsanfragen';

  @override
  String get approve => 'Genehmigen';

  @override
  String get reject => 'Ablehnen';

  @override
  String get expired => 'Abgelaufen';

  @override
  String minutesLeft(int minutes) {
    return '${minutes}m übrig';
  }

  @override
  String get workspaceFiles => 'Arbeitsbereich-Dateien';

  @override
  String get personalAIAssistant => 'Persönlicher KI-Assistent';

  @override
  String sessionsCount(int count) {
    return 'Sitzungen ($count)';
  }

  @override
  String get noActiveSessions => 'Keine aktiven Sitzungen';

  @override
  String get startConversationToCreate =>
      'Starten Sie eine Konversation, um eine zu erstellen';

  @override
  String get startConversationToSee =>
      'Starten Sie eine Konversation, um Sitzungen hier zu sehen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get cronJobs => 'Geplante Aufgaben';

  @override
  String get noCronJobs => 'Keine geplanten Aufgaben';

  @override
  String get addScheduledTasks =>
      'Fügen Sie geplante Aufgaben für Ihren Agenten hinzu';

  @override
  String get runNow => 'Jetzt Ausführen';

  @override
  String get enable => 'Aktivieren';

  @override
  String get disable => 'Deaktivieren';

  @override
  String get delete => 'Löschen';

  @override
  String get skills => 'Fähigkeiten';

  @override
  String get browseClawHub => 'ClawHub Durchsuchen';

  @override
  String get noSkillsInstalled => 'Keine Fähigkeiten installiert';

  @override
  String get browseClawHubToAdd =>
      'Durchsuchen Sie ClawHub, um Fähigkeiten hinzuzufügen';

  @override
  String removeSkillConfirm(String name) {
    return '\"$name\" aus Ihren Fähigkeiten entfernen?';
  }

  @override
  String get clawHubSkills => 'ClawHub-Fähigkeiten';

  @override
  String get searchSkills => 'Fähigkeiten suchen...';

  @override
  String get noSkillsFound =>
      'Keine Fähigkeiten gefunden. Versuchen Sie eine andere Suche.';

  @override
  String installedSkill(String name) {
    return '$name installiert';
  }

  @override
  String failedToInstallSkill(String name) {
    return '$name konnte nicht installiert werden';
  }

  @override
  String get addCronJob => 'Geplante Aufgabe Hinzufügen';

  @override
  String get jobName => 'Aufgabenname';

  @override
  String get dailySummaryExample => 'z.B. Tägliche Zusammenfassung';

  @override
  String get taskPrompt => 'Aufgabenanweisung';

  @override
  String get whatShouldAgentDo => 'Was soll der Agent tun?';

  @override
  String get interval => 'Intervall';

  @override
  String get every5Minutes => 'Alle 5 Minuten';

  @override
  String get every15Minutes => 'Alle 15 Minuten';

  @override
  String get every30Minutes => 'Alle 30 Minuten';

  @override
  String get everyHour => 'Jede Stunde';

  @override
  String get every6Hours => 'Alle 6 Stunden';

  @override
  String get every12Hours => 'Alle 12 Stunden';

  @override
  String get every24Hours => 'Alle 24 Stunden';

  @override
  String get add => 'Hinzufügen';

  @override
  String get save => 'Speichern';

  @override
  String get sessions => 'Sitzungen';

  @override
  String messagesCount(int count) {
    return '$count Nachrichten';
  }

  @override
  String tokensCount(int count) {
    return '$count Token';
  }

  @override
  String get compact => 'Kompaktieren';

  @override
  String get models => 'Modelle';

  @override
  String get noModelsConfigured => 'Keine Modelle konfiguriert';

  @override
  String get addModelToStartChatting =>
      'Fügen Sie ein Modell hinzu, um mit dem Chatten zu beginnen';

  @override
  String get addModel => 'Modell Hinzufügen';

  @override
  String get default_ => 'STANDARD';

  @override
  String get autoStart => 'Autostart';

  @override
  String get startGatewayWhenLaunches => 'Gateway beim App-Start starten';

  @override
  String get heartbeat => 'Herzschlag';

  @override
  String get enabled => 'Aktiviert';

  @override
  String get periodicAgentTasks =>
      'Periodische Agenten-Aufgaben aus HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes Min';
  }

  @override
  String get about => 'Über';

  @override
  String get personalAIAssistantForIOS =>
      'Persönlicher KI-Assistent für iOS und Android';

  @override
  String get version => 'Version';

  @override
  String get basedOnOpenClaw => 'Basierend auf OpenClaw';

  @override
  String get removeModel => 'Modell entfernen?';

  @override
  String removeModelConfirm(String name) {
    return '\"$name\" aus Ihren Modellen entfernen?';
  }

  @override
  String get remove => 'Entfernen';

  @override
  String get setAsDefault => 'Als Standard Festlegen';

  @override
  String get paste => 'Einfügen';

  @override
  String get chooseProviderStep => '1. Anbieter Wählen';

  @override
  String get selectModelStep => '2. Modell Auswählen';

  @override
  String get apiKeyStep => '3. API-Schlüssel';

  @override
  String getApiKeyAt(String provider) {
    return 'API-Schlüssel bei $provider erhalten';
  }

  @override
  String get justNow => 'gerade eben';

  @override
  String minutesAgo(int minutes) {
    return 'vor ${minutes}m';
  }

  @override
  String hoursAgo(int hours) {
    return 'vor ${hours}h';
  }

  @override
  String daysAgo(int days) {
    return 'vor ${days}T';
  }
}
