// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'चैट';

  @override
  String get channels => 'चैनल';

  @override
  String get agent => 'एजेंट';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get yourPersonalAssistant => 'आपका व्यक्तिगत AI सहायक';

  @override
  String get multiChannelChat => 'मल्टी-चैनल चैट';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat और अधिक';

  @override
  String get powerfulAIModels => 'शक्तिशाली AI मॉडल';

  @override
  String get powerfulAIModelsDesc => 'OpenAI, Anthropic, Grok और मुफ्त मॉडल';

  @override
  String get localGateway => 'स्थानीय गेटवे';

  @override
  String get localGatewayDesc =>
      'आपके डिवाइस पर चलता है, आपका डेटा आपका रहता है';

  @override
  String get chooseProvider => 'प्रदाता चुनें';

  @override
  String get selectProviderDesc =>
      'चुनें कि आप AI मॉडल से कैसे कनेक्ट करना चाहते हैं।';

  @override
  String get startForFree => 'मुफ्त में शुरू करें';

  @override
  String get freeProvidersDesc =>
      'ये प्रदाता बिना किसी लागत के शुरू करने के लिए मुफ्त मॉडल प्रदान करते हैं।';

  @override
  String get free => 'मुफ्त';

  @override
  String get otherProviders => 'अन्य प्रदाता';

  @override
  String connectToProvider(String provider) {
    return '$provider से कनेक्ट करें';
  }

  @override
  String get enterApiKeyDesc => 'अपनी API कुंजी दर्ज करें और एक मॉडल चुनें।';

  @override
  String get dontHaveApiKey => 'API कुंजी नहीं है?';

  @override
  String get createAccountCopyKey => 'एक खाता बनाएं और अपनी कुंजी कॉपी करें।';

  @override
  String get signUp => 'साइन अप करें';

  @override
  String get apiKey => 'API कुंजी';

  @override
  String get pasteFromClipboard => 'क्लिपबोर्ड से पेस्ट करें';

  @override
  String get apiBaseUrl => 'API आधार URL';

  @override
  String get selectModel => 'मॉडल चुनें';

  @override
  String get modelId => 'मॉडल ID';

  @override
  String get validateKey => 'कुंजी सत्यापित करें';

  @override
  String get validating => 'सत्यापित कर रहा है...';

  @override
  String get invalidApiKey => 'अमान्य API कुंजी';

  @override
  String get gatewayConfiguration => 'गेटवे कॉन्फ़िगरेशन';

  @override
  String get gatewayConfigDesc =>
      'गेटवे आपके सहायक के लिए स्थानीय नियंत्रण तल है।';

  @override
  String get defaultSettingsNote =>
      'डिफ़ॉल्ट सेटिंग्स अधिकांश उपयोगकर्ताओं के लिए काम करती हैं। केवल तभी बदलें जब आप जानते हों कि आपको क्या चाहिए।';

  @override
  String get host => 'होस्ट';

  @override
  String get port => 'पोर्ट';

  @override
  String get autoStartGateway => 'गेटवे स्वचालित रूप से शुरू करें';

  @override
  String get autoStartGatewayDesc =>
      'ऐप शुरू होने पर गेटवे को स्वचालित रूप से शुरू करें।';

  @override
  String get channelsPageTitle => 'चैनल';

  @override
  String get channelsPageDesc =>
      'वैकल्पिक रूप से मैसेजिंग चैनल कनेक्ट करें। आप हमेशा इन्हें सेटिंग्स में बाद में सेट कर सकते हैं।';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Telegram बॉट कनेक्ट करें।';

  @override
  String get openBotFather => 'BotFather खोलें';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Discord बॉट कनेक्ट करें।';

  @override
  String get developerPortal => 'डेवलपर पोर्टल';

  @override
  String get botToken => 'बॉट टोकन';

  @override
  String telegramBotToken(String platform) {
    return '$platform बॉट टोकन';
  }

  @override
  String get readyToGo => 'शुरू करने के लिए तैयार';

  @override
  String get reviewConfiguration =>
      'अपने कॉन्फ़िगरेशन की समीक्षा करें और FlutterClaw शुरू करें।';

  @override
  String get model => 'मॉडल';

  @override
  String viaProvider(String provider) {
    return '$provider के माध्यम से';
  }

  @override
  String get gateway => 'गेटवे';

  @override
  String get webChatOnly => 'केवल WebChat (आप बाद में और जोड़ सकते हैं)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'शुरू हो रहा है...';

  @override
  String get startFlutterClaw => 'FlutterClaw शुरू करें';

  @override
  String get newSession => 'नया सत्र';

  @override
  String get photoLibrary => 'फोटो लाइब्रेरी';

  @override
  String get camera => 'कैमरा';

  @override
  String get whatDoYouSeeInImage => 'आप इस छवि में क्या देखते हैं?';

  @override
  String get imagePickerNotAvailable =>
      'सिम्युलेटर पर इमेज पिकर उपलब्ध नहीं है। एक वास्तविक डिवाइस का उपयोग करें।';

  @override
  String get couldNotOpenImagePicker => 'इमेज पिकर नहीं खोल सका।';

  @override
  String get copiedToClipboard => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get attachImage => 'छवि संलग्न करें';

  @override
  String get messageFlutterClaw => 'FlutterClaw को संदेश...';

  @override
  String get channelsAndGateway => 'चैनल और गेटवे';

  @override
  String get stop => 'रोकें';

  @override
  String get start => 'शुरू करें';

  @override
  String status(String status) {
    return 'स्थिति: $status';
  }

  @override
  String get builtInChatInterface => 'अंतर्निहित चैट इंटरफेस';

  @override
  String get notConfigured => 'कॉन्फ़िगर नहीं किया गया';

  @override
  String get connected => 'कनेक्टेड';

  @override
  String get configuredStarting => 'कॉन्फ़िगर किया गया (शुरू हो रहा है...)';

  @override
  String get telegramConfiguration => 'Telegram कॉन्फ़िगरेशन';

  @override
  String get fromBotFather => '@BotFather से';

  @override
  String get allowedUserIds => 'अनुमत उपयोगकर्ता ID (कॉमा द्वारा अलग)';

  @override
  String get leaveEmptyToAllowAll => 'सभी को अनुमति देने के लिए खाली छोड़ दें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get saveAndConnect => 'सहेजें और कनेक्ट करें';

  @override
  String get discordConfiguration => 'Discord कॉन्फ़िगरेशन';

  @override
  String get pendingPairingRequests => 'लंबित पेयरिंग अनुरोध';

  @override
  String get approve => 'स्वीकृत करें';

  @override
  String get reject => 'अस्वीकार करें';

  @override
  String get expired => 'समाप्त हो गया';

  @override
  String minutesLeft(int minutes) {
    return '$minutesमिनट शेष';
  }

  @override
  String get workspaceFiles => 'कार्यक्षेत्र फ़ाइलें';

  @override
  String get personalAIAssistant => 'व्यक्तिगत AI सहायक';

  @override
  String sessionsCount(int count) {
    return 'सत्र ($count)';
  }

  @override
  String get noActiveSessions => 'कोई सक्रिय सत्र नहीं';

  @override
  String get startConversationToCreate => 'बनाने के लिए एक वार्तालाप शुरू करें';

  @override
  String get startConversationToSee =>
      'यहां सत्र देखने के लिए एक वार्तालाप शुरू करें';

  @override
  String get reset => 'रीसेट करें';

  @override
  String get cronJobs => 'निर्धारित कार्य';

  @override
  String get noCronJobs => 'कोई निर्धारित कार्य नहीं';

  @override
  String get addScheduledTasks => 'अपने एजेंट के लिए निर्धारित कार्य जोड़ें';

  @override
  String get runNow => 'अभी चलाएं';

  @override
  String get enable => 'सक्षम करें';

  @override
  String get disable => 'अक्षम करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get skills => 'कौशल';

  @override
  String get browseClawHub => 'ClawHub ब्राउज़ करें';

  @override
  String get noSkillsInstalled => 'कोई कौशल इंस्टॉल नहीं';

  @override
  String get browseClawHubToAdd => 'कौशल जोड़ने के लिए ClawHub ब्राउज़ करें';

  @override
  String removeSkillConfirm(String name) {
    return '\"$name\" को अपने कौशल से हटाएं?';
  }

  @override
  String get clawHubSkills => 'ClawHub कौशल';

  @override
  String get searchSkills => 'कौशल खोजें...';

  @override
  String get noSkillsFound => 'कोई कौशल नहीं मिला। एक अलग खोज प्रयास करें।';

  @override
  String installedSkill(String name) {
    return '$name इंस्टॉल किया गया';
  }

  @override
  String failedToInstallSkill(String name) {
    return '$name को इंस्टॉल करने में विफल';
  }

  @override
  String get addCronJob => 'निर्धारित कार्य जोड़ें';

  @override
  String get jobName => 'कार्य नाम';

  @override
  String get dailySummaryExample => 'उदा. दैनिक सारांश';

  @override
  String get taskPrompt => 'कार्य संकेत';

  @override
  String get whatShouldAgentDo => 'एजेंट को क्या करना चाहिए?';

  @override
  String get interval => 'अंतराल';

  @override
  String get every5Minutes => 'हर 5 मिनट';

  @override
  String get every15Minutes => 'हर 15 मिनट';

  @override
  String get every30Minutes => 'हर 30 मिनट';

  @override
  String get everyHour => 'हर घंटे';

  @override
  String get every6Hours => 'हर 6 घंटे';

  @override
  String get every12Hours => 'हर 12 घंटे';

  @override
  String get every24Hours => 'हर 24 घंटे';

  @override
  String get add => 'जोड़ें';

  @override
  String get save => 'सहेजें';

  @override
  String get sessions => 'सत्र';

  @override
  String messagesCount(int count) {
    return '$count संदेश';
  }

  @override
  String tokensCount(int count) {
    return '$count टोकन';
  }

  @override
  String get compact => 'संक्षिप्त करें';

  @override
  String get models => 'मॉडल';

  @override
  String get noModelsConfigured => 'कोई मॉडल कॉन्फ़िगर नहीं किया गया';

  @override
  String get addModelToStartChatting => 'चैट शुरू करने के लिए एक मॉडल जोड़ें';

  @override
  String get addModel => 'मॉडल जोड़ें';

  @override
  String get default_ => 'डिफ़ॉल्ट';

  @override
  String get autoStart => 'स्वचालित प्रारंभ';

  @override
  String get startGatewayWhenLaunches => 'ऐप शुरू होने पर गेटवे शुरू करें';

  @override
  String get heartbeat => 'हार्टबीट';

  @override
  String get enabled => 'सक्षम';

  @override
  String get periodicAgentTasks => 'HEARTBEAT.md से आवधिक एजेंट कार्य';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get about => 'के बारे में';

  @override
  String get personalAIAssistantForIOS =>
      'iOS और Android के लिए व्यक्तिगत AI सहायक';

  @override
  String get version => 'संस्करण';

  @override
  String get basedOnOpenClaw => 'OpenClaw पर आधारित';

  @override
  String get removeModel => 'मॉडल हटाएं?';

  @override
  String removeModelConfirm(String name) {
    return '\"$name\" को अपने मॉडल से हटाएं?';
  }

  @override
  String get remove => 'हटाएं';

  @override
  String get setAsDefault => 'डिफ़ॉल्ट के रूप में सेट करें';

  @override
  String get paste => 'पेस्ट करें';

  @override
  String get chooseProviderStep => '1. प्रदाता चुनें';

  @override
  String get selectModelStep => '2. मॉडल चुनें';

  @override
  String get apiKeyStep => '3. API कुंजी';

  @override
  String getApiKeyAt(String provider) {
    return '$provider पर API कुंजी प्राप्त करें';
  }

  @override
  String get justNow => 'अभी-अभी';

  @override
  String minutesAgo(int minutes) {
    return '$minutesमिनट पहले';
  }

  @override
  String hoursAgo(int hours) {
    return '$hoursघंटे पहले';
  }

  @override
  String daysAgo(int days) {
    return '$daysदिन पहले';
  }
}
