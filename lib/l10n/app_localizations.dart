import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'FlutterClaw'**
  String get appTitle;

  /// Chat tab label
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Channels tab label
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get channels;

  /// Agent tab label
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get agent;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Welcome page button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// App tagline
  ///
  /// In en, this message translates to:
  /// **'Your personal AI assistant'**
  String get yourPersonalAssistant;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Multi-channel chat'**
  String get multiChannelChat;

  /// Multi-channel chat description
  ///
  /// In en, this message translates to:
  /// **'Telegram, Discord, WebChat and more'**
  String get multiChannelChatDesc;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Powerful AI models'**
  String get powerfulAIModels;

  /// AI models description
  ///
  /// In en, this message translates to:
  /// **'OpenAI, Anthropic, Grok, and free models'**
  String get powerfulAIModelsDesc;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Local gateway'**
  String get localGateway;

  /// Local gateway description
  ///
  /// In en, this message translates to:
  /// **'Runs on your device, your data stays yours'**
  String get localGatewayDesc;

  /// Provider selection page title
  ///
  /// In en, this message translates to:
  /// **'Choose a Provider'**
  String get chooseProvider;

  /// Provider selection description
  ///
  /// In en, this message translates to:
  /// **'Select how you want to connect to AI models.'**
  String get selectProviderDesc;

  /// Free providers section title
  ///
  /// In en, this message translates to:
  /// **'Start for Free'**
  String get startForFree;

  /// Free providers description
  ///
  /// In en, this message translates to:
  /// **'These providers offer free models to get you started with no cost.'**
  String get freeProvidersDesc;

  /// Free badge label
  ///
  /// In en, this message translates to:
  /// **'FREE'**
  String get free;

  /// Paid providers section title
  ///
  /// In en, this message translates to:
  /// **'Other Providers'**
  String get otherProviders;

  /// Auth page title
  ///
  /// In en, this message translates to:
  /// **'Connect to {provider}'**
  String connectToProvider(String provider);

  /// Auth page description
  ///
  /// In en, this message translates to:
  /// **'Enter your API key and select a model.'**
  String get enterApiKeyDesc;

  /// API key prompt
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an API key?'**
  String get dontHaveApiKey;

  /// API key instructions
  ///
  /// In en, this message translates to:
  /// **'Create an account and copy your key.'**
  String get createAccountCopyKey;

  /// Sign up button
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// API key field label
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// Paste button tooltip
  ///
  /// In en, this message translates to:
  /// **'Paste from clipboard'**
  String get pasteFromClipboard;

  /// API base URL field label
  ///
  /// In en, this message translates to:
  /// **'API Base URL'**
  String get apiBaseUrl;

  /// Model selection label
  ///
  /// In en, this message translates to:
  /// **'Select Model'**
  String get selectModel;

  /// Model ID field label
  ///
  /// In en, this message translates to:
  /// **'Model ID'**
  String get modelId;

  /// Validate button label
  ///
  /// In en, this message translates to:
  /// **'Validate Key'**
  String get validateKey;

  /// Validating status
  ///
  /// In en, this message translates to:
  /// **'Validating...'**
  String get validating;

  /// Invalid key error
  ///
  /// In en, this message translates to:
  /// **'Invalid API key'**
  String get invalidApiKey;

  /// Gateway page title
  ///
  /// In en, this message translates to:
  /// **'Gateway Configuration'**
  String get gatewayConfiguration;

  /// Gateway configuration description
  ///
  /// In en, this message translates to:
  /// **'The gateway is the local control plane for your assistant.'**
  String get gatewayConfigDesc;

  /// Gateway settings note
  ///
  /// In en, this message translates to:
  /// **'The default settings work for most users. Only change these if you know what you need.'**
  String get defaultSettingsNote;

  /// Host field label
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// Port field label
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// Auto-start toggle label
  ///
  /// In en, this message translates to:
  /// **'Auto-start gateway'**
  String get autoStartGateway;

  /// Auto-start description
  ///
  /// In en, this message translates to:
  /// **'Start the gateway automatically when the app launches.'**
  String get autoStartGatewayDesc;

  /// Channels page title
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get channelsPageTitle;

  /// Channels page description
  ///
  /// In en, this message translates to:
  /// **'Optionally connect messaging channels. You can always set these up later in Settings.'**
  String get channelsPageDesc;

  /// Telegram channel name
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get telegram;

  /// Telegram description
  ///
  /// In en, this message translates to:
  /// **'Connect a Telegram bot.'**
  String get connectTelegramBot;

  /// BotFather link label
  ///
  /// In en, this message translates to:
  /// **'Open BotFather'**
  String get openBotFather;

  /// Discord channel name
  ///
  /// In en, this message translates to:
  /// **'Discord'**
  String get discord;

  /// Discord description
  ///
  /// In en, this message translates to:
  /// **'Connect a Discord bot.'**
  String get connectDiscordBot;

  /// Discord developer portal link
  ///
  /// In en, this message translates to:
  /// **'Developer Portal'**
  String get developerPortal;

  /// Bot token field label
  ///
  /// In en, this message translates to:
  /// **'Bot Token'**
  String get botToken;

  /// Platform-specific bot token
  ///
  /// In en, this message translates to:
  /// **'{platform} Bot Token'**
  String telegramBotToken(String platform);

  /// Completion page title
  ///
  /// In en, this message translates to:
  /// **'Ready to Go'**
  String get readyToGo;

  /// Completion page description
  ///
  /// In en, this message translates to:
  /// **'Review your configuration and start FlutterClaw.'**
  String get reviewConfiguration;

  /// Model section label
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// Provider attribution
  ///
  /// In en, this message translates to:
  /// **'via {provider}'**
  String viaProvider(String provider);

  /// Gateway section label
  ///
  /// In en, this message translates to:
  /// **'Gateway'**
  String get gateway;

  /// Default channels message
  ///
  /// In en, this message translates to:
  /// **'WebChat only (you can add more later)'**
  String get webChatOnly;

  /// WebChat channel name
  ///
  /// In en, this message translates to:
  /// **'WebChat'**
  String get webChat;

  /// Starting status
  ///
  /// In en, this message translates to:
  /// **'Starting...'**
  String get starting;

  /// Start button label
  ///
  /// In en, this message translates to:
  /// **'Start FlutterClaw'**
  String get startFlutterClaw;

  /// New session tooltip
  ///
  /// In en, this message translates to:
  /// **'New session'**
  String get newSession;

  /// Photo library option
  ///
  /// In en, this message translates to:
  /// **'Photo Library'**
  String get photoLibrary;

  /// Camera option
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Default image caption
  ///
  /// In en, this message translates to:
  /// **'What do you see in this image?'**
  String get whatDoYouSeeInImage;

  /// Simulator error
  ///
  /// In en, this message translates to:
  /// **'Image picker not available on Simulator. Use a real device.'**
  String get imagePickerNotAvailable;

  /// Image picker error
  ///
  /// In en, this message translates to:
  /// **'Could not open image picker.'**
  String get couldNotOpenImagePicker;

  /// Copy confirmation
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// Attach button tooltip
  ///
  /// In en, this message translates to:
  /// **'Attach image'**
  String get attachImage;

  /// Chat input placeholder
  ///
  /// In en, this message translates to:
  /// **'Message FlutterClaw...'**
  String get messageFlutterClaw;

  /// Channels screen title
  ///
  /// In en, this message translates to:
  /// **'Channels & Gateway'**
  String get channelsAndGateway;

  /// Stop button
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// Start button
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String status(String status);

  /// WebChat description
  ///
  /// In en, this message translates to:
  /// **'Built-in chat interface'**
  String get builtInChatInterface;

  /// Channel status
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get notConfigured;

  /// Channel status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Channel status
  ///
  /// In en, this message translates to:
  /// **'Configured (starting...)'**
  String get configuredStarting;

  /// Telegram config dialog title
  ///
  /// In en, this message translates to:
  /// **'Telegram Configuration'**
  String get telegramConfiguration;

  /// Telegram token hint
  ///
  /// In en, this message translates to:
  /// **'From @BotFather'**
  String get fromBotFather;

  /// Allowed users field label
  ///
  /// In en, this message translates to:
  /// **'Allowed User IDs (comma separated)'**
  String get allowedUserIds;

  /// Allow all users hint
  ///
  /// In en, this message translates to:
  /// **'Leave empty to allow all'**
  String get leaveEmptyToAllowAll;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save and connect button
  ///
  /// In en, this message translates to:
  /// **'Save & Connect'**
  String get saveAndConnect;

  /// Discord config dialog title
  ///
  /// In en, this message translates to:
  /// **'Discord Configuration'**
  String get discordConfiguration;

  /// Pairing section title
  ///
  /// In en, this message translates to:
  /// **'Pending Pairing Requests'**
  String get pendingPairingRequests;

  /// Approve button tooltip
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// Reject button tooltip
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Expired status
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// Time remaining
  ///
  /// In en, this message translates to:
  /// **'{minutes}m left'**
  String minutesLeft(int minutes);

  /// Workspace section title
  ///
  /// In en, this message translates to:
  /// **'Workspace Files'**
  String get workspaceFiles;

  /// Agent subtitle
  ///
  /// In en, this message translates to:
  /// **'Personal AI Assistant'**
  String get personalAIAssistant;

  /// Sessions section title
  ///
  /// In en, this message translates to:
  /// **'Sessions ({count})'**
  String sessionsCount(int count);

  /// Empty sessions message
  ///
  /// In en, this message translates to:
  /// **'No active sessions'**
  String get noActiveSessions;

  /// Empty sessions hint
  ///
  /// In en, this message translates to:
  /// **'Start a conversation to create one'**
  String get startConversationToCreate;

  /// Empty sessions hint (alternative)
  ///
  /// In en, this message translates to:
  /// **'Start a conversation to see sessions here'**
  String get startConversationToSee;

  /// Reset action
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Cron jobs section title
  ///
  /// In en, this message translates to:
  /// **'Cron Jobs'**
  String get cronJobs;

  /// Empty cron jobs message
  ///
  /// In en, this message translates to:
  /// **'No cron jobs'**
  String get noCronJobs;

  /// Cron jobs hint
  ///
  /// In en, this message translates to:
  /// **'Add scheduled tasks for your agent'**
  String get addScheduledTasks;

  /// Run job action
  ///
  /// In en, this message translates to:
  /// **'Run Now'**
  String get runNow;

  /// Enable action
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// Disable action
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// Delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Skills section title
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// ClawHub button tooltip
  ///
  /// In en, this message translates to:
  /// **'Browse ClawHub'**
  String get browseClawHub;

  /// Empty skills message
  ///
  /// In en, this message translates to:
  /// **'No skills installed'**
  String get noSkillsInstalled;

  /// Skills hint
  ///
  /// In en, this message translates to:
  /// **'Browse ClawHub to add skills'**
  String get browseClawHubToAdd;

  /// Remove skill confirmation
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from your skills?'**
  String removeSkillConfirm(String name);

  /// ClawHub browser title
  ///
  /// In en, this message translates to:
  /// **'ClawHub Skills'**
  String get clawHubSkills;

  /// Search field hint
  ///
  /// In en, this message translates to:
  /// **'Search skills...'**
  String get searchSkills;

  /// No results message
  ///
  /// In en, this message translates to:
  /// **'No skills found. Try a different search.'**
  String get noSkillsFound;

  /// Install success message
  ///
  /// In en, this message translates to:
  /// **'Installed {name}'**
  String installedSkill(String name);

  /// Install failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to install {name}'**
  String failedToInstallSkill(String name);

  /// Add cron job dialog title
  ///
  /// In en, this message translates to:
  /// **'Add Cron Job'**
  String get addCronJob;

  /// Job name field label
  ///
  /// In en, this message translates to:
  /// **'Job Name'**
  String get jobName;

  /// Job name example
  ///
  /// In en, this message translates to:
  /// **'e.g. Daily Summary'**
  String get dailySummaryExample;

  /// Task prompt field label
  ///
  /// In en, this message translates to:
  /// **'Task Prompt'**
  String get taskPrompt;

  /// Task prompt hint
  ///
  /// In en, this message translates to:
  /// **'What should the agent do?'**
  String get whatShouldAgentDo;

  /// Interval field label
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get interval;

  /// Interval option
  ///
  /// In en, this message translates to:
  /// **'Every 5 minutes'**
  String get every5Minutes;

  /// Interval option
  ///
  /// In en, this message translates to:
  /// **'Every 15 minutes'**
  String get every15Minutes;

  /// Interval option
  ///
  /// In en, this message translates to:
  /// **'Every 30 minutes'**
  String get every30Minutes;

  /// Interval option
  ///
  /// In en, this message translates to:
  /// **'Every hour'**
  String get everyHour;

  /// Interval option
  ///
  /// In en, this message translates to:
  /// **'Every 6 hours'**
  String get every6Hours;

  /// Interval option
  ///
  /// In en, this message translates to:
  /// **'Every 12 hours'**
  String get every12Hours;

  /// Interval option
  ///
  /// In en, this message translates to:
  /// **'Every 24 hours'**
  String get every24Hours;

  /// Add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Sessions screen title
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// Message count
  ///
  /// In en, this message translates to:
  /// **'{count} messages'**
  String messagesCount(int count);

  /// Token count
  ///
  /// In en, this message translates to:
  /// **'{count} tokens'**
  String tokensCount(int count);

  /// Compact action
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get compact;

  /// Models section title
  ///
  /// In en, this message translates to:
  /// **'Models'**
  String get models;

  /// Empty models message
  ///
  /// In en, this message translates to:
  /// **'No models configured'**
  String get noModelsConfigured;

  /// Models hint
  ///
  /// In en, this message translates to:
  /// **'Add a model to start chatting'**
  String get addModelToStartChatting;

  /// Add model button
  ///
  /// In en, this message translates to:
  /// **'Add Model'**
  String get addModel;

  /// Default badge
  ///
  /// In en, this message translates to:
  /// **'DEFAULT'**
  String get default_;

  /// Auto-start label
  ///
  /// In en, this message translates to:
  /// **'Auto-start'**
  String get autoStart;

  /// Auto-start description
  ///
  /// In en, this message translates to:
  /// **'Start gateway when app launches'**
  String get startGatewayWhenLaunches;

  /// Heartbeat section title
  ///
  /// In en, this message translates to:
  /// **'Heartbeat'**
  String get heartbeat;

  /// Enabled toggle
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Heartbeat description
  ///
  /// In en, this message translates to:
  /// **'Periodic agent tasks from HEARTBEAT.md'**
  String get periodicAgentTasks;

  /// Interval display
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String intervalMinutes(int minutes);

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App description
  ///
  /// In en, this message translates to:
  /// **'Personal AI Assistant for iOS & Android'**
  String get personalAIAssistantForIOS;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Attribution
  ///
  /// In en, this message translates to:
  /// **'Based on OpenClaw'**
  String get basedOnOpenClaw;

  /// Remove model dialog title
  ///
  /// In en, this message translates to:
  /// **'Remove model?'**
  String get removeModel;

  /// Remove model confirmation
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from your models?'**
  String removeModelConfirm(String name);

  /// Remove button
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Set default button
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// Paste tooltip
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// Step 1 label
  ///
  /// In en, this message translates to:
  /// **'1. Choose Provider'**
  String get chooseProviderStep;

  /// Step 2 label
  ///
  /// In en, this message translates to:
  /// **'2. Select Model'**
  String get selectModelStep;

  /// Step 3 label
  ///
  /// In en, this message translates to:
  /// **'3. API Key'**
  String get apiKeyStep;

  /// API key link text
  ///
  /// In en, this message translates to:
  /// **'Get API key at {provider}'**
  String getApiKeyAt(String provider);

  /// Time ago format
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// Time ago format
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(int minutes);

  /// Time ago format
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(int hours);

  /// Time ago format
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgo(int days);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'nl',
    'pl',
    'pt',
    'ru',
    'th',
    'tr',
    'uk',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
