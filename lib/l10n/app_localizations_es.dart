// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Chat';

  @override
  String get channels => 'Canales';

  @override
  String get agent => 'Agente';

  @override
  String get settings => 'Ajustes';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get yourPersonalAssistant => 'Tu asistente personal de IA';

  @override
  String get multiChannelChat => 'Chat multicanal';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat y más';

  @override
  String get powerfulAIModels => 'Modelos de IA potentes';

  @override
  String get powerfulAIModelsDesc =>
      'OpenAI, Anthropic, Grok y modelos gratuitos';

  @override
  String get localGateway => 'Gateway local';

  @override
  String get localGatewayDesc =>
      'Se ejecuta en tu dispositivo, tus datos son tuyos';

  @override
  String get chooseProvider => 'Elige un Proveedor';

  @override
  String get selectProviderDesc =>
      'Selecciona cómo quieres conectarte a modelos de IA.';

  @override
  String get startForFree => 'Comienza Gratis';

  @override
  String get freeProvidersDesc =>
      'Estos proveedores ofrecen modelos gratuitos para que empieces sin costo.';

  @override
  String get free => 'GRATIS';

  @override
  String get otherProviders => 'Otros Proveedores';

  @override
  String connectToProvider(String provider) {
    return 'Conectar a $provider';
  }

  @override
  String get enterApiKeyDesc => 'Ingresa tu clave API y selecciona un modelo.';

  @override
  String get dontHaveApiKey => '¿No tienes una clave API?';

  @override
  String get createAccountCopyKey => 'Crea una cuenta y copia tu clave.';

  @override
  String get signUp => 'Registrarse';

  @override
  String get apiKey => 'Clave API';

  @override
  String get pasteFromClipboard => 'Pegar del portapapeles';

  @override
  String get apiBaseUrl => 'URL Base de API';

  @override
  String get selectModel => 'Seleccionar Modelo';

  @override
  String get modelId => 'ID del Modelo';

  @override
  String get validateKey => 'Validar Clave';

  @override
  String get validating => 'Validando...';

  @override
  String get invalidApiKey => 'Clave API inválida';

  @override
  String get gatewayConfiguration => 'Configuración del Gateway';

  @override
  String get gatewayConfigDesc =>
      'El gateway es el plano de control local para tu asistente.';

  @override
  String get defaultSettingsNote =>
      'La configuración predeterminada funciona para la mayoría de los usuarios. Cámbiala solo si sabes qué necesitas.';

  @override
  String get host => 'Host';

  @override
  String get port => 'Puerto';

  @override
  String get autoStartGateway => 'Iniciar gateway automáticamente';

  @override
  String get autoStartGatewayDesc =>
      'Iniciar el gateway automáticamente cuando la aplicación se inicie.';

  @override
  String get channelsPageTitle => 'Canales';

  @override
  String get channelsPageDesc =>
      'Conecta canales de mensajería opcionalmente. Siempre puedes configurarlos más tarde en Ajustes.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Conecta un bot de Telegram.';

  @override
  String get openBotFather => 'Abrir BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Conecta un bot de Discord.';

  @override
  String get developerPortal => 'Portal de Desarrolladores';

  @override
  String get botToken => 'Token del Bot';

  @override
  String telegramBotToken(String platform) {
    return 'Token del Bot de $platform';
  }

  @override
  String get readyToGo => 'Listo para Empezar';

  @override
  String get reviewConfiguration =>
      'Revisa tu configuración e inicia FlutterClaw.';

  @override
  String get model => 'Modelo';

  @override
  String viaProvider(String provider) {
    return 'vía $provider';
  }

  @override
  String get gateway => 'Gateway';

  @override
  String get webChatOnly => 'Solo WebChat (puedes agregar más después)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Iniciando...';

  @override
  String get startFlutterClaw => 'Iniciar FlutterClaw';

  @override
  String get newSession => 'Nueva sesión';

  @override
  String get photoLibrary => 'Biblioteca de Fotos';

  @override
  String get camera => 'Cámara';

  @override
  String get whatDoYouSeeInImage => '¿Qué ves en esta imagen?';

  @override
  String get imagePickerNotAvailable =>
      'El selector de imágenes no está disponible en el Simulador. Usa un dispositivo real.';

  @override
  String get couldNotOpenImagePicker =>
      'No se pudo abrir el selector de imágenes.';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get attachImage => 'Adjuntar imagen';

  @override
  String get messageFlutterClaw => 'Mensaje a FlutterClaw...';

  @override
  String get channelsAndGateway => 'Canales y Gateway';

  @override
  String get stop => 'Detener';

  @override
  String get start => 'Iniciar';

  @override
  String status(String status) {
    return 'Estado: $status';
  }

  @override
  String get builtInChatInterface => 'Interfaz de chat integrada';

  @override
  String get notConfigured => 'No configurado';

  @override
  String get connected => 'Conectado';

  @override
  String get configuredStarting => 'Configurado (iniciando...)';

  @override
  String get telegramConfiguration => 'Configuración de Telegram';

  @override
  String get fromBotFather => 'De @BotFather';

  @override
  String get allowedUserIds =>
      'IDs de Usuario Permitidos (separados por comas)';

  @override
  String get leaveEmptyToAllowAll => 'Dejar vacío para permitir todos';

  @override
  String get cancel => 'Cancelar';

  @override
  String get saveAndConnect => 'Guardar y Conectar';

  @override
  String get discordConfiguration => 'Configuración de Discord';

  @override
  String get pendingPairingRequests =>
      'Solicitudes de Emparejamiento Pendientes';

  @override
  String get approve => 'Aprobar';

  @override
  String get reject => 'Rechazar';

  @override
  String get expired => 'Expirado';

  @override
  String minutesLeft(int minutes) {
    return '${minutes}m restantes';
  }

  @override
  String get workspaceFiles => 'Archivos del Espacio de Trabajo';

  @override
  String get personalAIAssistant => 'Asistente Personal de IA';

  @override
  String sessionsCount(int count) {
    return 'Sesiones ($count)';
  }

  @override
  String get noActiveSessions => 'No hay sesiones activas';

  @override
  String get startConversationToCreate =>
      'Inicia una conversación para crear una';

  @override
  String get startConversationToSee =>
      'Inicia una conversación para ver sesiones aquí';

  @override
  String get reset => 'Restablecer';

  @override
  String get cronJobs => 'Tareas Programadas';

  @override
  String get noCronJobs => 'No hay tareas programadas';

  @override
  String get addScheduledTasks => 'Agrega tareas programadas para tu agente';

  @override
  String get runNow => 'Ejecutar Ahora';

  @override
  String get enable => 'Habilitar';

  @override
  String get disable => 'Deshabilitar';

  @override
  String get delete => 'Eliminar';

  @override
  String get skills => 'Habilidades';

  @override
  String get browseClawHub => 'Explorar ClawHub';

  @override
  String get noSkillsInstalled => 'No hay habilidades instaladas';

  @override
  String get browseClawHubToAdd => 'Explora ClawHub para agregar habilidades';

  @override
  String removeSkillConfirm(String name) {
    return '¿Eliminar \"$name\" de tus habilidades?';
  }

  @override
  String get clawHubSkills => 'Habilidades de ClawHub';

  @override
  String get searchSkills => 'Buscar habilidades...';

  @override
  String get noSkillsFound =>
      'No se encontraron habilidades. Intenta con una búsqueda diferente.';

  @override
  String installedSkill(String name) {
    return 'Se instaló $name';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'No se pudo instalar $name';
  }

  @override
  String get addCronJob => 'Agregar Tarea Programada';

  @override
  String get jobName => 'Nombre de la Tarea';

  @override
  String get dailySummaryExample => 'ej. Resumen Diario';

  @override
  String get taskPrompt => 'Instrucción de la Tarea';

  @override
  String get whatShouldAgentDo => '¿Qué debería hacer el agente?';

  @override
  String get interval => 'Intervalo';

  @override
  String get every5Minutes => 'Cada 5 minutos';

  @override
  String get every15Minutes => 'Cada 15 minutos';

  @override
  String get every30Minutes => 'Cada 30 minutos';

  @override
  String get everyHour => 'Cada hora';

  @override
  String get every6Hours => 'Cada 6 horas';

  @override
  String get every12Hours => 'Cada 12 horas';

  @override
  String get every24Hours => 'Cada 24 horas';

  @override
  String get add => 'Agregar';

  @override
  String get save => 'Guardar';

  @override
  String get sessions => 'Sesiones';

  @override
  String messagesCount(int count) {
    return '$count mensajes';
  }

  @override
  String tokensCount(int count) {
    return '$count tokens';
  }

  @override
  String get compact => 'Compactar';

  @override
  String get models => 'Modelos';

  @override
  String get noModelsConfigured => 'No hay modelos configurados';

  @override
  String get addModelToStartChatting =>
      'Agrega un modelo para empezar a chatear';

  @override
  String get addModel => 'Agregar Modelo';

  @override
  String get default_ => 'PREDETERMINADO';

  @override
  String get autoStart => 'Inicio automático';

  @override
  String get startGatewayWhenLaunches =>
      'Iniciar gateway cuando la aplicación se inicie';

  @override
  String get heartbeat => 'Latido';

  @override
  String get enabled => 'Habilitado';

  @override
  String get periodicAgentTasks =>
      'Tareas periódicas del agente desde HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get about => 'Acerca de';

  @override
  String get personalAIAssistantForIOS =>
      'Asistente Personal de IA para iOS y Android';

  @override
  String get version => 'Versión';

  @override
  String get basedOnOpenClaw => 'Basado en OpenClaw';

  @override
  String get removeModel => '¿Eliminar modelo?';

  @override
  String removeModelConfirm(String name) {
    return '¿Eliminar \"$name\" de tus modelos?';
  }

  @override
  String get remove => 'Eliminar';

  @override
  String get setAsDefault => 'Establecer como Predeterminado';

  @override
  String get paste => 'Pegar';

  @override
  String get chooseProviderStep => '1. Elegir Proveedor';

  @override
  String get selectModelStep => '2. Seleccionar Modelo';

  @override
  String get apiKeyStep => '3. Clave API';

  @override
  String getApiKeyAt(String provider) {
    return 'Obtener clave API en $provider';
  }

  @override
  String get justNow => 'justo ahora';

  @override
  String minutesAgo(int minutes) {
    return 'hace ${minutes}m';
  }

  @override
  String hoursAgo(int hours) {
    return 'hace ${hours}h';
  }

  @override
  String daysAgo(int days) {
    return 'hace ${days}d';
  }
}
