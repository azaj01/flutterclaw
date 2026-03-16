// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Chat';

  @override
  String get channels => 'Kanály';

  @override
  String get agent => 'Agent';

  @override
  String get settings => 'Nastavení';

  @override
  String get getStarted => 'Začít';

  @override
  String get yourPersonalAssistant => 'Váš osobní AI asistent';

  @override
  String get multiChannelChat => 'Vícekanalový chat';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat a další';

  @override
  String get powerfulAIModels => 'Výkonné AI modely';

  @override
  String get powerfulAIModelsDesc =>
      'OpenAI, Anthropic, Grok a bezplatné modely';

  @override
  String get localGateway => 'Lokální brána';

  @override
  String get localGatewayDesc =>
      'Běží na vašem zařízení, vaše data zůstávají vaše';

  @override
  String get chooseProvider => 'Vyberte Poskytovatele';

  @override
  String get selectProviderDesc =>
      'Vyberte, jak se chcete připojit k AI modelům.';

  @override
  String get startForFree => 'Začít Zdarma';

  @override
  String get freeProvidersDesc =>
      'Tito poskytovatelé nabízejí bezplatné modely pro start bez nákladů.';

  @override
  String get free => 'ZDARMA';

  @override
  String get otherProviders => 'Další Poskytovatelé';

  @override
  String connectToProvider(String provider) {
    return 'Připojit k $provider';
  }

  @override
  String get enterApiKeyDesc => 'Zadejte svůj API klíč a vyberte model.';

  @override
  String get dontHaveApiKey => 'Nemáte API klíč?';

  @override
  String get createAccountCopyKey => 'Vytvořte účet a zkopírujte svůj klíč.';

  @override
  String get signUp => 'Zaregistrovat se';

  @override
  String get apiKey => 'API klíč';

  @override
  String get pasteFromClipboard => 'Vložit ze schránky';

  @override
  String get apiBaseUrl => 'Základní URL API';

  @override
  String get selectModel => 'Vybrat Model';

  @override
  String get modelId => 'ID Modelu';

  @override
  String get validateKey => 'Ověřit Klíč';

  @override
  String get validating => 'Ověřování...';

  @override
  String get invalidApiKey => 'Neplatný API klíč';

  @override
  String get gatewayConfiguration => 'Konfigurace Brány';

  @override
  String get gatewayConfigDesc =>
      'Brána je lokální řídicí rovina vašeho asistenta.';

  @override
  String get defaultSettingsNote =>
      'Výchozí nastavení funguje pro většinu uživatelů. Měňte pouze pokud víte, co potřebujete.';

  @override
  String get host => 'Hostitel';

  @override
  String get port => 'Port';

  @override
  String get autoStartGateway => 'Automatické spuštění brány';

  @override
  String get autoStartGatewayDesc =>
      'Spustit bránu automaticky při spuštění aplikace.';

  @override
  String get channelsPageTitle => 'Kanály';

  @override
  String get channelsPageDesc =>
      'Volitelně připojte kanály zpráv. Můžete je vždy nastavit později v Nastavení.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Připojte bota Telegram.';

  @override
  String get openBotFather => 'Otevřít BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Připojte bota Discord.';

  @override
  String get developerPortal => 'Portál Vývojáře';

  @override
  String get botToken => 'Token Bota';

  @override
  String telegramBotToken(String platform) {
    return 'Token Bota $platform';
  }

  @override
  String get readyToGo => 'Připraveno ke Spuštění';

  @override
  String get reviewConfiguration =>
      'Zkontrolujte svou konfiguraci a spusťte FlutterClaw.';

  @override
  String get model => 'Model';

  @override
  String viaProvider(String provider) {
    return 'přes $provider';
  }

  @override
  String get gateway => 'Brána';

  @override
  String get webChatOnly => 'Pouze WebChat (můžete přidat více později)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Spouštění...';

  @override
  String get startFlutterClaw => 'Spustit FlutterClaw';

  @override
  String get newSession => 'Nová relace';

  @override
  String get photoLibrary => 'Knihovna Fotek';

  @override
  String get camera => 'Fotoaparát';

  @override
  String get whatDoYouSeeInImage => 'Co vidíte na tomto obrázku?';

  @override
  String get imagePickerNotAvailable =>
      'Výběr obrázku není k dispozici na Simulátoru. Použijte skutečné zařízení.';

  @override
  String get couldNotOpenImagePicker => 'Nelze otevřít výběr obrázku.';

  @override
  String get copiedToClipboard => 'Zkopírováno do schránky';

  @override
  String get attachImage => 'Připojit obrázek';

  @override
  String get messageFlutterClaw => 'Zpráva pro FlutterClaw...';

  @override
  String get channelsAndGateway => 'Kanály a Brána';

  @override
  String get stop => 'Zastavit';

  @override
  String get start => 'Spustit';

  @override
  String status(String status) {
    return 'Stav: $status';
  }

  @override
  String get builtInChatInterface => 'Vestavěné rozhraní chatu';

  @override
  String get notConfigured => 'Není nakonfigurováno';

  @override
  String get connected => 'Připojeno';

  @override
  String get configuredStarting => 'Nakonfigurováno (spouštění...)';

  @override
  String get telegramConfiguration => 'Konfigurace Telegram';

  @override
  String get fromBotFather => 'Od @BotFather';

  @override
  String get allowedUserIds => 'Povolená ID uživatelů (oddělená čárkami)';

  @override
  String get leaveEmptyToAllowAll => 'Ponechte prázdné pro povolení všem';

  @override
  String get cancel => 'Zrušit';

  @override
  String get saveAndConnect => 'Uložit a Připojit';

  @override
  String get discordConfiguration => 'Konfigurace Discord';

  @override
  String get pendingPairingRequests => 'Čekající Žádosti o Párování';

  @override
  String get approve => 'Schválit';

  @override
  String get reject => 'Odmítnout';

  @override
  String get expired => 'Vypršelo';

  @override
  String minutesLeft(int minutes) {
    return 'Zbývá ${minutes}m';
  }

  @override
  String get workspaceFiles => 'Soubory Pracovního Prostoru';

  @override
  String get personalAIAssistant => 'Osobní AI Asistent';

  @override
  String sessionsCount(int count) {
    return 'Relace ($count)';
  }

  @override
  String get noActiveSessions => 'Žádné aktivní relace';

  @override
  String get startConversationToCreate => 'Začněte konverzaci pro vytvoření';

  @override
  String get startConversationToSee =>
      'Začněte konverzaci pro zobrazení relací zde';

  @override
  String get reset => 'Resetovat';

  @override
  String get cronJobs => 'Naplánované Úlohy';

  @override
  String get noCronJobs => 'Žádné naplánované úlohy';

  @override
  String get addScheduledTasks => 'Přidejte naplánované úlohy pro svého agenta';

  @override
  String get runNow => 'Spustit Nyní';

  @override
  String get enable => 'Povolit';

  @override
  String get disable => 'Zakázat';

  @override
  String get delete => 'Smazat';

  @override
  String get skills => 'Dovednosti';

  @override
  String get browseClawHub => 'Procházet ClawHub';

  @override
  String get noSkillsInstalled => 'Žádné nainstalované dovednosti';

  @override
  String get browseClawHubToAdd => 'Procházejte ClawHub pro přidání dovedností';

  @override
  String removeSkillConfirm(String name) {
    return 'Odstranit \"$name\" z vašich dovedností?';
  }

  @override
  String get clawHubSkills => 'Dovednosti ClawHub';

  @override
  String get searchSkills => 'Hledat dovednosti...';

  @override
  String get noSkillsFound =>
      'Žádné dovednosti nenalezeny. Zkuste jiné hledání.';

  @override
  String installedSkill(String name) {
    return '$name nainstalováno';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'Instalace $name selhala';
  }

  @override
  String get addCronJob => 'Přidat Naplánovanou Úlohu';

  @override
  String get jobName => 'Název Úlohy';

  @override
  String get dailySummaryExample => 'např. Denní Souhrn';

  @override
  String get taskPrompt => 'Popis Úlohy';

  @override
  String get whatShouldAgentDo => 'Co by měl agent dělat?';

  @override
  String get interval => 'Interval';

  @override
  String get every5Minutes => 'Každých 5 minut';

  @override
  String get every15Minutes => 'Každých 15 minut';

  @override
  String get every30Minutes => 'Každých 30 minut';

  @override
  String get everyHour => 'Každou hodinu';

  @override
  String get every6Hours => 'Každých 6 hodin';

  @override
  String get every12Hours => 'Každých 12 hodin';

  @override
  String get every24Hours => 'Každých 24 hodin';

  @override
  String get add => 'Přidat';

  @override
  String get save => 'Uložit';

  @override
  String get sessions => 'Relace';

  @override
  String messagesCount(int count) {
    return '$count zpráv';
  }

  @override
  String tokensCount(int count) {
    return '$count tokenů';
  }

  @override
  String get compact => 'Kompaktovat';

  @override
  String get models => 'Modely';

  @override
  String get noModelsConfigured => 'Žádné nakonfigurované modely';

  @override
  String get addModelToStartChatting => 'Přidejte model pro zahájení chatu';

  @override
  String get addModel => 'Přidat Model';

  @override
  String get default_ => 'VÝCHOZÍ';

  @override
  String get autoStart => 'Automatické spuštění';

  @override
  String get startGatewayWhenLaunches => 'Spustit bránu při spuštění aplikace';

  @override
  String get heartbeat => 'Tep Srdce';

  @override
  String get enabled => 'Povoleno';

  @override
  String get periodicAgentTasks => 'Periodické úlohy agenta z HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get about => 'O Aplikaci';

  @override
  String get personalAIAssistantForIOS =>
      'Osobní AI Asistent pro iOS a Android';

  @override
  String get version => 'Verze';

  @override
  String get basedOnOpenClaw => 'Založeno na OpenClaw';

  @override
  String get removeModel => 'Odstranit model?';

  @override
  String removeModelConfirm(String name) {
    return 'Odstranit \"$name\" z vašich modelů?';
  }

  @override
  String get remove => 'Odstranit';

  @override
  String get setAsDefault => 'Nastavit jako Výchozí';

  @override
  String get paste => 'Vložit';

  @override
  String get chooseProviderStep => '1. Vybrat Poskytovatele';

  @override
  String get selectModelStep => '2. Vybrat Model';

  @override
  String get apiKeyStep => '3. API klíč';

  @override
  String getApiKeyAt(String provider) {
    return 'Získat API klíč na $provider';
  }

  @override
  String get justNow => 'právě teď';

  @override
  String minutesAgo(int minutes) {
    return 'před ${minutes}m';
  }

  @override
  String hoursAgo(int hours) {
    return 'před ${hours}h';
  }

  @override
  String daysAgo(int days) {
    return 'před ${days}d';
  }
}
