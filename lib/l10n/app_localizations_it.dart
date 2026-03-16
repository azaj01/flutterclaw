// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Chat';

  @override
  String get channels => 'Canali';

  @override
  String get agent => 'Agente';

  @override
  String get settings => 'Impostazioni';

  @override
  String get getStarted => 'Inizia';

  @override
  String get yourPersonalAssistant => 'Il tuo assistente personale IA';

  @override
  String get multiChannelChat => 'Chat multicanale';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat e altro';

  @override
  String get powerfulAIModels => 'Modelli IA potenti';

  @override
  String get powerfulAIModelsDesc =>
      'OpenAI, Anthropic, Grok e modelli gratuiti';

  @override
  String get localGateway => 'Gateway locale';

  @override
  String get localGatewayDesc =>
      'Funziona sul tuo dispositivo, i tuoi dati restano tuoi';

  @override
  String get chooseProvider => 'Scegli un Fornitore';

  @override
  String get selectProviderDesc =>
      'Seleziona come vuoi connetterti ai modelli IA.';

  @override
  String get startForFree => 'Inizia Gratuitamente';

  @override
  String get freeProvidersDesc =>
      'Questi fornitori offrono modelli gratuiti per iniziare senza costi.';

  @override
  String get free => 'GRATIS';

  @override
  String get otherProviders => 'Altri Fornitori';

  @override
  String connectToProvider(String provider) {
    return 'Connetti a $provider';
  }

  @override
  String get enterApiKeyDesc =>
      'Inserisci la tua chiave API e seleziona un modello.';

  @override
  String get dontHaveApiKey => 'Non hai una chiave API?';

  @override
  String get createAccountCopyKey => 'Crea un account e copia la tua chiave.';

  @override
  String get signUp => 'Registrati';

  @override
  String get apiKey => 'Chiave API';

  @override
  String get pasteFromClipboard => 'Incolla dagli appunti';

  @override
  String get apiBaseUrl => 'URL Base API';

  @override
  String get selectModel => 'Seleziona Modello';

  @override
  String get modelId => 'ID Modello';

  @override
  String get validateKey => 'Valida Chiave';

  @override
  String get validating => 'Validazione...';

  @override
  String get invalidApiKey => 'Chiave API non valida';

  @override
  String get gatewayConfiguration => 'Configurazione Gateway';

  @override
  String get gatewayConfigDesc =>
      'Il gateway è il piano di controllo locale per il tuo assistente.';

  @override
  String get defaultSettingsNote =>
      'Le impostazioni predefinite funzionano per la maggior parte degli utenti. Modificale solo se sai cosa ti serve.';

  @override
  String get host => 'Host';

  @override
  String get port => 'Porta';

  @override
  String get autoStartGateway => 'Avvio automatico gateway';

  @override
  String get autoStartGatewayDesc =>
      'Avvia il gateway automaticamente all\'avvio dell\'app.';

  @override
  String get channelsPageTitle => 'Canali';

  @override
  String get channelsPageDesc =>
      'Connetti canali di messaggistica opzionalmente. Puoi sempre configurarli più tardi nelle Impostazioni.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Connetti un bot Telegram.';

  @override
  String get openBotFather => 'Apri BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Connetti un bot Discord.';

  @override
  String get developerPortal => 'Portale Sviluppatore';

  @override
  String get botToken => 'Token Bot';

  @override
  String telegramBotToken(String platform) {
    return 'Token Bot $platform';
  }

  @override
  String get readyToGo => 'Pronto per Iniziare';

  @override
  String get reviewConfiguration =>
      'Rivedi la tua configurazione e avvia FlutterClaw.';

  @override
  String get model => 'Modello';

  @override
  String viaProvider(String provider) {
    return 'tramite $provider';
  }

  @override
  String get gateway => 'Gateway';

  @override
  String get webChatOnly => 'Solo WebChat (puoi aggiungerne altri dopo)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Avvio...';

  @override
  String get startFlutterClaw => 'Avvia FlutterClaw';

  @override
  String get newSession => 'Nuova sessione';

  @override
  String get photoLibrary => 'Libreria Foto';

  @override
  String get camera => 'Fotocamera';

  @override
  String get whatDoYouSeeInImage => 'Cosa vedi in questa immagine?';

  @override
  String get imagePickerNotAvailable =>
      'Selettore immagini non disponibile sul Simulatore. Usa un dispositivo reale.';

  @override
  String get couldNotOpenImagePicker =>
      'Impossibile aprire il selettore immagini.';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get attachImage => 'Allega immagine';

  @override
  String get messageFlutterClaw => 'Messaggio a FlutterClaw...';

  @override
  String get channelsAndGateway => 'Canali e Gateway';

  @override
  String get stop => 'Ferma';

  @override
  String get start => 'Avvia';

  @override
  String status(String status) {
    return 'Stato: $status';
  }

  @override
  String get builtInChatInterface => 'Interfaccia chat integrata';

  @override
  String get notConfigured => 'Non configurato';

  @override
  String get connected => 'Connesso';

  @override
  String get configuredStarting => 'Configurato (avvio...)';

  @override
  String get telegramConfiguration => 'Configurazione Telegram';

  @override
  String get fromBotFather => 'Da @BotFather';

  @override
  String get allowedUserIds => 'ID Utente Consentiti (separati da virgola)';

  @override
  String get leaveEmptyToAllowAll => 'Lascia vuoto per consentire tutti';

  @override
  String get cancel => 'Annulla';

  @override
  String get saveAndConnect => 'Salva e Connetti';

  @override
  String get discordConfiguration => 'Configurazione Discord';

  @override
  String get pendingPairingRequests => 'Richieste di Abbinamento in Sospeso';

  @override
  String get approve => 'Approva';

  @override
  String get reject => 'Rifiuta';

  @override
  String get expired => 'Scaduto';

  @override
  String minutesLeft(int minutes) {
    return '${minutes}m rimanenti';
  }

  @override
  String get workspaceFiles => 'File dell\'Area di Lavoro';

  @override
  String get personalAIAssistant => 'Assistente Personale IA';

  @override
  String sessionsCount(int count) {
    return 'Sessioni ($count)';
  }

  @override
  String get noActiveSessions => 'Nessuna sessione attiva';

  @override
  String get startConversationToCreate =>
      'Avvia una conversazione per crearne una';

  @override
  String get startConversationToSee =>
      'Avvia una conversazione per vedere le sessioni qui';

  @override
  String get reset => 'Reimposta';

  @override
  String get cronJobs => 'Attività Programmate';

  @override
  String get noCronJobs => 'Nessuna attività programmata';

  @override
  String get addScheduledTasks =>
      'Aggiungi attività programmate per il tuo agente';

  @override
  String get runNow => 'Esegui Ora';

  @override
  String get enable => 'Abilita';

  @override
  String get disable => 'Disabilita';

  @override
  String get delete => 'Elimina';

  @override
  String get skills => 'Abilità';

  @override
  String get browseClawHub => 'Sfoglia ClawHub';

  @override
  String get noSkillsInstalled => 'Nessuna abilità installata';

  @override
  String get browseClawHubToAdd => 'Sfoglia ClawHub per aggiungere abilità';

  @override
  String removeSkillConfirm(String name) {
    return 'Rimuovere \"$name\" dalle tue abilità?';
  }

  @override
  String get clawHubSkills => 'Abilità ClawHub';

  @override
  String get searchSkills => 'Cerca abilità...';

  @override
  String get noSkillsFound =>
      'Nessuna abilità trovata. Prova una ricerca diversa.';

  @override
  String installedSkill(String name) {
    return '$name installato';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'Installazione di $name non riuscita';
  }

  @override
  String get addCronJob => 'Aggiungi Attività Programmata';

  @override
  String get jobName => 'Nome Attività';

  @override
  String get dailySummaryExample => 'es. Riepilogo Giornaliero';

  @override
  String get taskPrompt => 'Istruzione Attività';

  @override
  String get whatShouldAgentDo => 'Cosa dovrebbe fare l\'agente?';

  @override
  String get interval => 'Intervallo';

  @override
  String get every5Minutes => 'Ogni 5 minuti';

  @override
  String get every15Minutes => 'Ogni 15 minuti';

  @override
  String get every30Minutes => 'Ogni 30 minuti';

  @override
  String get everyHour => 'Ogni ora';

  @override
  String get every6Hours => 'Ogni 6 ore';

  @override
  String get every12Hours => 'Ogni 12 ore';

  @override
  String get every24Hours => 'Ogni 24 ore';

  @override
  String get add => 'Aggiungi';

  @override
  String get save => 'Salva';

  @override
  String get sessions => 'Sessioni';

  @override
  String messagesCount(int count) {
    return '$count messaggi';
  }

  @override
  String tokensCount(int count) {
    return '$count token';
  }

  @override
  String get compact => 'Compatta';

  @override
  String get models => 'Modelli';

  @override
  String get noModelsConfigured => 'Nessun modello configurato';

  @override
  String get addModelToStartChatting =>
      'Aggiungi un modello per iniziare a chattare';

  @override
  String get addModel => 'Aggiungi Modello';

  @override
  String get default_ => 'PREDEFINITO';

  @override
  String get autoStart => 'Avvio automatico';

  @override
  String get startGatewayWhenLaunches => 'Avvia gateway all\'avvio dell\'app';

  @override
  String get heartbeat => 'Battito Cardiaco';

  @override
  String get enabled => 'Abilitato';

  @override
  String get periodicAgentTasks =>
      'Attività periodiche dell\'agente da HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get about => 'Informazioni';

  @override
  String get personalAIAssistantForIOS =>
      'Assistente Personale IA per iOS e Android';

  @override
  String get version => 'Versione';

  @override
  String get basedOnOpenClaw => 'Basato su OpenClaw';

  @override
  String get removeModel => 'Rimuovere modello?';

  @override
  String removeModelConfirm(String name) {
    return 'Rimuovere \"$name\" dai tuoi modelli?';
  }

  @override
  String get remove => 'Rimuovi';

  @override
  String get setAsDefault => 'Imposta come Predefinito';

  @override
  String get paste => 'Incolla';

  @override
  String get chooseProviderStep => '1. Scegli Fornitore';

  @override
  String get selectModelStep => '2. Seleziona Modello';

  @override
  String get apiKeyStep => '3. Chiave API';

  @override
  String getApiKeyAt(String provider) {
    return 'Ottieni chiave API su $provider';
  }

  @override
  String get justNow => 'proprio ora';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m fa';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h fa';
  }

  @override
  String daysAgo(int days) {
    return '${days}g fa';
  }
}
