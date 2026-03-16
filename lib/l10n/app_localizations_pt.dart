// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Chat';

  @override
  String get channels => 'Canais';

  @override
  String get agent => 'Agente';

  @override
  String get settings => 'Configurações';

  @override
  String get getStarted => 'Começar';

  @override
  String get yourPersonalAssistant => 'Seu assistente pessoal de IA';

  @override
  String get multiChannelChat => 'Chat multicanal';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat e mais';

  @override
  String get powerfulAIModels => 'Modelos de IA poderosos';

  @override
  String get powerfulAIModelsDesc =>
      'OpenAI, Anthropic, Grok e modelos gratuitos';

  @override
  String get localGateway => 'Gateway local';

  @override
  String get localGatewayDesc =>
      'Executa no seu dispositivo, seus dados permanecem seus';

  @override
  String get chooseProvider => 'Escolha um Provedor';

  @override
  String get selectProviderDesc =>
      'Selecione como você deseja se conectar aos modelos de IA.';

  @override
  String get startForFree => 'Comece Gratuitamente';

  @override
  String get freeProvidersDesc =>
      'Estes provedores oferecem modelos gratuitos para você começar sem custo.';

  @override
  String get free => 'GRÁTIS';

  @override
  String get otherProviders => 'Outros Provedores';

  @override
  String connectToProvider(String provider) {
    return 'Conectar ao $provider';
  }

  @override
  String get enterApiKeyDesc => 'Digite sua chave API e selecione um modelo.';

  @override
  String get dontHaveApiKey => 'Não tem uma chave API?';

  @override
  String get createAccountCopyKey => 'Crie uma conta e copie sua chave.';

  @override
  String get signUp => 'Cadastrar-se';

  @override
  String get apiKey => 'Chave API';

  @override
  String get pasteFromClipboard => 'Colar da área de transferência';

  @override
  String get apiBaseUrl => 'URL Base da API';

  @override
  String get selectModel => 'Selecionar Modelo';

  @override
  String get modelId => 'ID do Modelo';

  @override
  String get validateKey => 'Validar Chave';

  @override
  String get validating => 'Validando...';

  @override
  String get invalidApiKey => 'Chave API inválida';

  @override
  String get gatewayConfiguration => 'Configuração do Gateway';

  @override
  String get gatewayConfigDesc =>
      'O gateway é o plano de controle local para seu assistente.';

  @override
  String get defaultSettingsNote =>
      'As configurações padrão funcionam para a maioria dos usuários. Altere apenas se souber o que precisa.';

  @override
  String get host => 'Host';

  @override
  String get port => 'Porta';

  @override
  String get autoStartGateway => 'Iniciar gateway automaticamente';

  @override
  String get autoStartGatewayDesc =>
      'Iniciar o gateway automaticamente quando o aplicativo for iniciado.';

  @override
  String get channelsPageTitle => 'Canais';

  @override
  String get channelsPageDesc =>
      'Conecte canais de mensagens opcionalmente. Você sempre pode configurá-los mais tarde nas Configurações.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Conecte um bot do Telegram.';

  @override
  String get openBotFather => 'Abrir BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Conecte um bot do Discord.';

  @override
  String get developerPortal => 'Portal do Desenvolvedor';

  @override
  String get botToken => 'Token do Bot';

  @override
  String telegramBotToken(String platform) {
    return 'Token do Bot $platform';
  }

  @override
  String get readyToGo => 'Pronto para Começar';

  @override
  String get reviewConfiguration =>
      'Revise sua configuração e inicie o FlutterClaw.';

  @override
  String get model => 'Modelo';

  @override
  String viaProvider(String provider) {
    return 'via $provider';
  }

  @override
  String get gateway => 'Gateway';

  @override
  String get webChatOnly => 'Apenas WebChat (você pode adicionar mais depois)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Iniciando...';

  @override
  String get startFlutterClaw => 'Iniciar FlutterClaw';

  @override
  String get newSession => 'Nova sessão';

  @override
  String get photoLibrary => 'Biblioteca de Fotos';

  @override
  String get camera => 'Câmera';

  @override
  String get whatDoYouSeeInImage => 'O que você vê nesta imagem?';

  @override
  String get imagePickerNotAvailable =>
      'Seletor de imagens não disponível no Simulador. Use um dispositivo real.';

  @override
  String get couldNotOpenImagePicker =>
      'Não foi possível abrir o seletor de imagens.';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get attachImage => 'Anexar imagem';

  @override
  String get messageFlutterClaw => 'Mensagem para FlutterClaw...';

  @override
  String get channelsAndGateway => 'Canais e Gateway';

  @override
  String get stop => 'Parar';

  @override
  String get start => 'Iniciar';

  @override
  String status(String status) {
    return 'Status: $status';
  }

  @override
  String get builtInChatInterface => 'Interface de chat integrada';

  @override
  String get notConfigured => 'Não configurado';

  @override
  String get connected => 'Conectado';

  @override
  String get configuredStarting => 'Configurado (iniciando...)';

  @override
  String get telegramConfiguration => 'Configuração do Telegram';

  @override
  String get fromBotFather => 'Do @BotFather';

  @override
  String get allowedUserIds =>
      'IDs de Usuário Permitidos (separados por vírgula)';

  @override
  String get leaveEmptyToAllowAll => 'Deixe vazio para permitir todos';

  @override
  String get cancel => 'Cancelar';

  @override
  String get saveAndConnect => 'Salvar e Conectar';

  @override
  String get discordConfiguration => 'Configuração do Discord';

  @override
  String get pendingPairingRequests =>
      'Solicitações de Emparelhamento Pendentes';

  @override
  String get approve => 'Aprovar';

  @override
  String get reject => 'Rejeitar';

  @override
  String get expired => 'Expirado';

  @override
  String minutesLeft(int minutes) {
    return '${minutes}m restantes';
  }

  @override
  String get workspaceFiles => 'Arquivos do Espaço de Trabalho';

  @override
  String get personalAIAssistant => 'Assistente Pessoal de IA';

  @override
  String sessionsCount(int count) {
    return 'Sessões ($count)';
  }

  @override
  String get noActiveSessions => 'Nenhuma sessão ativa';

  @override
  String get startConversationToCreate => 'Inicie uma conversa para criar uma';

  @override
  String get startConversationToSee =>
      'Inicie uma conversa para ver sessões aqui';

  @override
  String get reset => 'Redefinir';

  @override
  String get cronJobs => 'Tarefas Agendadas';

  @override
  String get noCronJobs => 'Nenhuma tarefa agendada';

  @override
  String get addScheduledTasks => 'Adicione tarefas agendadas para seu agente';

  @override
  String get runNow => 'Executar Agora';

  @override
  String get enable => 'Ativar';

  @override
  String get disable => 'Desativar';

  @override
  String get delete => 'Excluir';

  @override
  String get skills => 'Habilidades';

  @override
  String get browseClawHub => 'Explorar ClawHub';

  @override
  String get noSkillsInstalled => 'Nenhuma habilidade instalada';

  @override
  String get browseClawHubToAdd =>
      'Explore o ClawHub para adicionar habilidades';

  @override
  String removeSkillConfirm(String name) {
    return 'Remover \"$name\" de suas habilidades?';
  }

  @override
  String get clawHubSkills => 'Habilidades do ClawHub';

  @override
  String get searchSkills => 'Pesquisar habilidades...';

  @override
  String get noSkillsFound =>
      'Nenhuma habilidade encontrada. Tente uma pesquisa diferente.';

  @override
  String installedSkill(String name) {
    return '$name instalado';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'Falha ao instalar $name';
  }

  @override
  String get addCronJob => 'Adicionar Tarefa Agendada';

  @override
  String get jobName => 'Nome da Tarefa';

  @override
  String get dailySummaryExample => 'ex. Resumo Diário';

  @override
  String get taskPrompt => 'Instrução da Tarefa';

  @override
  String get whatShouldAgentDo => 'O que o agente deve fazer?';

  @override
  String get interval => 'Intervalo';

  @override
  String get every5Minutes => 'A cada 5 minutos';

  @override
  String get every15Minutes => 'A cada 15 minutos';

  @override
  String get every30Minutes => 'A cada 30 minutos';

  @override
  String get everyHour => 'A cada hora';

  @override
  String get every6Hours => 'A cada 6 horas';

  @override
  String get every12Hours => 'A cada 12 horas';

  @override
  String get every24Hours => 'A cada 24 horas';

  @override
  String get add => 'Adicionar';

  @override
  String get save => 'Salvar';

  @override
  String get sessions => 'Sessões';

  @override
  String messagesCount(int count) {
    return '$count mensagens';
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
  String get noModelsConfigured => 'Nenhum modelo configurado';

  @override
  String get addModelToStartChatting =>
      'Adicione um modelo para começar a conversar';

  @override
  String get addModel => 'Adicionar Modelo';

  @override
  String get default_ => 'PADRÃO';

  @override
  String get autoStart => 'Início automático';

  @override
  String get startGatewayWhenLaunches =>
      'Iniciar gateway quando o aplicativo for iniciado';

  @override
  String get heartbeat => 'Batimento';

  @override
  String get enabled => 'Ativado';

  @override
  String get periodicAgentTasks =>
      'Tarefas periódicas do agente do HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get about => 'Sobre';

  @override
  String get personalAIAssistantForIOS =>
      'Assistente Pessoal de IA para iOS e Android';

  @override
  String get version => 'Versão';

  @override
  String get basedOnOpenClaw => 'Baseado em OpenClaw';

  @override
  String get removeModel => 'Remover modelo?';

  @override
  String removeModelConfirm(String name) {
    return 'Remover \"$name\" de seus modelos?';
  }

  @override
  String get remove => 'Remover';

  @override
  String get setAsDefault => 'Definir como Padrão';

  @override
  String get paste => 'Colar';

  @override
  String get chooseProviderStep => '1. Escolher Provedor';

  @override
  String get selectModelStep => '2. Selecionar Modelo';

  @override
  String get apiKeyStep => '3. Chave API';

  @override
  String getApiKeyAt(String provider) {
    return 'Obter chave API em $provider';
  }

  @override
  String get justNow => 'agora mesmo';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m atrás';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h atrás';
  }

  @override
  String daysAgo(int days) {
    return '${days}d atrás';
  }
}
