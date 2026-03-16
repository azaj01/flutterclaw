// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Chat';

  @override
  String get channels => 'Canaux';

  @override
  String get agent => 'Agent';

  @override
  String get settings => 'Paramètres';

  @override
  String get getStarted => 'Commencer';

  @override
  String get yourPersonalAssistant => 'Votre assistant personnel IA';

  @override
  String get multiChannelChat => 'Chat multicanal';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat et plus';

  @override
  String get powerfulAIModels => 'Modèles IA puissants';

  @override
  String get powerfulAIModelsDesc =>
      'OpenAI, Anthropic, Grok et modèles gratuits';

  @override
  String get localGateway => 'Passerelle locale';

  @override
  String get localGatewayDesc =>
      'Fonctionne sur votre appareil, vos données restent les vôtres';

  @override
  String get chooseProvider => 'Choisir un Fournisseur';

  @override
  String get selectProviderDesc =>
      'Sélectionnez comment vous souhaitez vous connecter aux modèles IA.';

  @override
  String get startForFree => 'Commencer Gratuitement';

  @override
  String get freeProvidersDesc =>
      'Ces fournisseurs offrent des modèles gratuits pour commencer sans frais.';

  @override
  String get free => 'GRATUIT';

  @override
  String get otherProviders => 'Autres Fournisseurs';

  @override
  String connectToProvider(String provider) {
    return 'Se connecter à $provider';
  }

  @override
  String get enterApiKeyDesc =>
      'Entrez votre clé API et sélectionnez un modèle.';

  @override
  String get dontHaveApiKey => 'Vous n\'avez pas de clé API?';

  @override
  String get createAccountCopyKey => 'Créez un compte et copiez votre clé.';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get apiKey => 'Clé API';

  @override
  String get pasteFromClipboard => 'Coller du presse-papiers';

  @override
  String get apiBaseUrl => 'URL de Base API';

  @override
  String get selectModel => 'Sélectionner Modèle';

  @override
  String get modelId => 'ID du Modèle';

  @override
  String get validateKey => 'Valider la Clé';

  @override
  String get validating => 'Validation...';

  @override
  String get invalidApiKey => 'Clé API invalide';

  @override
  String get gatewayConfiguration => 'Configuration de la Passerelle';

  @override
  String get gatewayConfigDesc =>
      'La passerelle est le plan de contrôle local pour votre assistant.';

  @override
  String get defaultSettingsNote =>
      'Les paramètres par défaut fonctionnent pour la plupart des utilisateurs. Ne les modifiez que si vous savez ce dont vous avez besoin.';

  @override
  String get host => 'Hôte';

  @override
  String get port => 'Port';

  @override
  String get autoStartGateway => 'Démarrage automatique de la passerelle';

  @override
  String get autoStartGatewayDesc =>
      'Démarrer la passerelle automatiquement au lancement de l\'application.';

  @override
  String get channelsPageTitle => 'Canaux';

  @override
  String get channelsPageDesc =>
      'Connectez des canaux de messagerie en option. Vous pouvez toujours les configurer plus tard dans les Paramètres.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Connectez un bot Telegram.';

  @override
  String get openBotFather => 'Ouvrir BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Connectez un bot Discord.';

  @override
  String get developerPortal => 'Portail Développeur';

  @override
  String get botToken => 'Jeton du Bot';

  @override
  String telegramBotToken(String platform) {
    return 'Jeton du Bot $platform';
  }

  @override
  String get readyToGo => 'Prêt à Démarrer';

  @override
  String get reviewConfiguration =>
      'Vérifiez votre configuration et démarrez FlutterClaw.';

  @override
  String get model => 'Modèle';

  @override
  String viaProvider(String provider) {
    return 'via $provider';
  }

  @override
  String get gateway => 'Passerelle';

  @override
  String get webChatOnly =>
      'WebChat uniquement (vous pouvez en ajouter plus tard)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Démarrage...';

  @override
  String get startFlutterClaw => 'Démarrer FlutterClaw';

  @override
  String get newSession => 'Nouvelle session';

  @override
  String get photoLibrary => 'Bibliothèque de photos';

  @override
  String get camera => 'Caméra';

  @override
  String get whatDoYouSeeInImage => 'Que voyez-vous dans cette image?';

  @override
  String get imagePickerNotAvailable =>
      'Le sélecteur d\'images n\'est pas disponible sur le Simulateur. Utilisez un appareil réel.';

  @override
  String get couldNotOpenImagePicker =>
      'Impossible d\'ouvrir le sélecteur d\'images.';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get attachImage => 'Joindre une image';

  @override
  String get messageFlutterClaw => 'Message à FlutterClaw...';

  @override
  String get channelsAndGateway => 'Canaux et Passerelle';

  @override
  String get stop => 'Arrêter';

  @override
  String get start => 'Démarrer';

  @override
  String status(String status) {
    return 'Statut: $status';
  }

  @override
  String get builtInChatInterface => 'Interface de chat intégrée';

  @override
  String get notConfigured => 'Non configuré';

  @override
  String get connected => 'Connecté';

  @override
  String get configuredStarting => 'Configuré (démarrage...)';

  @override
  String get telegramConfiguration => 'Configuration Telegram';

  @override
  String get fromBotFather => 'De @BotFather';

  @override
  String get allowedUserIds =>
      'IDs d\'utilisateurs autorisés (séparés par des virgules)';

  @override
  String get leaveEmptyToAllowAll => 'Laisser vide pour autoriser tous';

  @override
  String get cancel => 'Annuler';

  @override
  String get saveAndConnect => 'Enregistrer et Connecter';

  @override
  String get discordConfiguration => 'Configuration Discord';

  @override
  String get pendingPairingRequests => 'Demandes d\'Appairage en Attente';

  @override
  String get approve => 'Approuver';

  @override
  String get reject => 'Rejeter';

  @override
  String get expired => 'Expiré';

  @override
  String minutesLeft(int minutes) {
    return '${minutes}m restantes';
  }

  @override
  String get workspaceFiles => 'Fichiers de l\'Espace de Travail';

  @override
  String get personalAIAssistant => 'Assistant Personnel IA';

  @override
  String sessionsCount(int count) {
    return 'Sessions ($count)';
  }

  @override
  String get noActiveSessions => 'Aucune session active';

  @override
  String get startConversationToCreate =>
      'Démarrez une conversation pour en créer une';

  @override
  String get startConversationToSee =>
      'Démarrez une conversation pour voir les sessions ici';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get cronJobs => 'Tâches Planifiées';

  @override
  String get noCronJobs => 'Aucune tâche planifiée';

  @override
  String get addScheduledTasks =>
      'Ajoutez des tâches planifiées pour votre agent';

  @override
  String get runNow => 'Exécuter Maintenant';

  @override
  String get enable => 'Activer';

  @override
  String get disable => 'Désactiver';

  @override
  String get delete => 'Supprimer';

  @override
  String get skills => 'Compétences';

  @override
  String get browseClawHub => 'Parcourir ClawHub';

  @override
  String get noSkillsInstalled => 'Aucune compétence installée';

  @override
  String get browseClawHubToAdd =>
      'Parcourez ClawHub pour ajouter des compétences';

  @override
  String removeSkillConfirm(String name) {
    return 'Supprimer \"$name\" de vos compétences?';
  }

  @override
  String get clawHubSkills => 'Compétences ClawHub';

  @override
  String get searchSkills => 'Rechercher des compétences...';

  @override
  String get noSkillsFound =>
      'Aucune compétence trouvée. Essayez une recherche différente.';

  @override
  String installedSkill(String name) {
    return '$name installé';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'Échec de l\'installation de $name';
  }

  @override
  String get addCronJob => 'Ajouter une Tâche Planifiée';

  @override
  String get jobName => 'Nom de la Tâche';

  @override
  String get dailySummaryExample => 'ex. Résumé Quotidien';

  @override
  String get taskPrompt => 'Instruction de la Tâche';

  @override
  String get whatShouldAgentDo => 'Que doit faire l\'agent?';

  @override
  String get interval => 'Intervalle';

  @override
  String get every5Minutes => 'Toutes les 5 minutes';

  @override
  String get every15Minutes => 'Toutes les 15 minutes';

  @override
  String get every30Minutes => 'Toutes les 30 minutes';

  @override
  String get everyHour => 'Toutes les heures';

  @override
  String get every6Hours => 'Toutes les 6 heures';

  @override
  String get every12Hours => 'Toutes les 12 heures';

  @override
  String get every24Hours => 'Toutes les 24 heures';

  @override
  String get add => 'Ajouter';

  @override
  String get save => 'Enregistrer';

  @override
  String get sessions => 'Sessions';

  @override
  String messagesCount(int count) {
    return '$count messages';
  }

  @override
  String tokensCount(int count) {
    return '$count jetons';
  }

  @override
  String get compact => 'Compacter';

  @override
  String get models => 'Modèles';

  @override
  String get noModelsConfigured => 'Aucun modèle configuré';

  @override
  String get addModelToStartChatting =>
      'Ajoutez un modèle pour commencer à discuter';

  @override
  String get addModel => 'Ajouter un Modèle';

  @override
  String get default_ => 'PAR DÉFAUT';

  @override
  String get autoStart => 'Démarrage automatique';

  @override
  String get startGatewayWhenLaunches =>
      'Démarrer la passerelle au lancement de l\'application';

  @override
  String get heartbeat => 'Battement de Coeur';

  @override
  String get enabled => 'Activé';

  @override
  String get periodicAgentTasks =>
      'Tâches périodiques de l\'agent depuis HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get about => 'À Propos';

  @override
  String get personalAIAssistantForIOS =>
      'Assistant Personnel IA pour iOS et Android';

  @override
  String get version => 'Version';

  @override
  String get basedOnOpenClaw => 'Basé sur OpenClaw';

  @override
  String get removeModel => 'Supprimer le modèle?';

  @override
  String removeModelConfirm(String name) {
    return 'Supprimer \"$name\" de vos modèles?';
  }

  @override
  String get remove => 'Supprimer';

  @override
  String get setAsDefault => 'Définir par Défaut';

  @override
  String get paste => 'Coller';

  @override
  String get chooseProviderStep => '1. Choisir le Fournisseur';

  @override
  String get selectModelStep => '2. Sélectionner le Modèle';

  @override
  String get apiKeyStep => '3. Clé API';

  @override
  String getApiKeyAt(String provider) {
    return 'Obtenir la clé API chez $provider';
  }

  @override
  String get justNow => 'à l\'instant';

  @override
  String minutesAgo(int minutes) {
    return 'il y a ${minutes}m';
  }

  @override
  String hoursAgo(int hours) {
    return 'il y a ${hours}h';
  }

  @override
  String daysAgo(int days) {
    return 'il y a ${days}j';
  }
}
