// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'แชท';

  @override
  String get channels => 'ช่องทาง';

  @override
  String get agent => 'ตัวแทน';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get getStarted => 'เริ่มต้น';

  @override
  String get yourPersonalAssistant => 'ผู้ช่วย AI ส่วนตัวของคุณ';

  @override
  String get multiChannelChat => 'แชทหลายช่องทาง';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat และอื่นๆ';

  @override
  String get powerfulAIModels => 'โมเดล AI ที่ทรงพลัง';

  @override
  String get powerfulAIModelsDesc => 'OpenAI, Anthropic, Grok และโมเดลฟรี';

  @override
  String get localGateway => 'เกตเวย์ในเครื่อง';

  @override
  String get localGatewayDesc => 'ทำงานบนอุปกรณ์ของคุณ ข้อมูลของคุณเป็นของคุณ';

  @override
  String get chooseProvider => 'เลือกผู้ให้บริการ';

  @override
  String get selectProviderDesc => 'เลือกวิธีการเชื่อมต่อกับโมเดล AI';

  @override
  String get startForFree => 'เริ่มใช้ฟรี';

  @override
  String get freeProvidersDesc =>
      'ผู้ให้บริการเหล่านี้เสนอโมเดลฟรีเพื่อเริ่มต้นโดยไม่มีค่าใช้จ่าย';

  @override
  String get free => 'ฟรี';

  @override
  String get otherProviders => 'ผู้ให้บริการอื่นๆ';

  @override
  String connectToProvider(String provider) {
    return 'เชื่อมต่อกับ $provider';
  }

  @override
  String get enterApiKeyDesc => 'ป้อนคีย์ API ของคุณและเลือกโมเดล';

  @override
  String get dontHaveApiKey => 'ไม่มีคีย์ API?';

  @override
  String get createAccountCopyKey => 'สร้างบัญชีและคัดลอกคีย์ของคุณ';

  @override
  String get signUp => 'ลงทะเบียน';

  @override
  String get apiKey => 'คีย์ API';

  @override
  String get pasteFromClipboard => 'วางจากคลิปบอร์ด';

  @override
  String get apiBaseUrl => 'URL ฐาน API';

  @override
  String get selectModel => 'เลือกโมเดล';

  @override
  String get modelId => 'ID โมเดล';

  @override
  String get validateKey => 'ตรวจสอบคีย์';

  @override
  String get validating => 'กำลังตรวจสอบ...';

  @override
  String get invalidApiKey => 'คีย์ API ไม่ถูกต้อง';

  @override
  String get gatewayConfiguration => 'การกำหนดค่าเกตเวย์';

  @override
  String get gatewayConfigDesc =>
      'เกตเวย์คือระดับควบคุมในเครื่องสำหรับผู้ช่วยของคุณ';

  @override
  String get defaultSettingsNote =>
      'การตั้งค่าเริ่มต้นใช้งานได้สำหรับผู้ใช้ส่วนใหญ่ เปลี่ยนเฉพาะเมื่อคุณรู้ว่าคุณต้องการอะไร';

  @override
  String get host => 'โฮสต์';

  @override
  String get port => 'พอร์ต';

  @override
  String get autoStartGateway => 'เริ่มเกตเวย์อัตโนมัติ';

  @override
  String get autoStartGatewayDesc => 'เริ่มเกตเวย์โดยอัตโนมัติเมื่อเปิดแอป';

  @override
  String get channelsPageTitle => 'ช่องทาง';

  @override
  String get channelsPageDesc =>
      'เชื่อมต่อช่องทางข้อความตามต้องการ คุณสามารถตั้งค่าได้ทีหลังในการตั้งค่า';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'เชื่อมต่อบอท Telegram';

  @override
  String get openBotFather => 'เปิด BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'เชื่อมต่อบอท Discord';

  @override
  String get developerPortal => 'พอร์ทัลนักพัฒนา';

  @override
  String get botToken => 'โทเค็นบอท';

  @override
  String telegramBotToken(String platform) {
    return 'โทเค็นบอท $platform';
  }

  @override
  String get readyToGo => 'พร้อมเริ่มต้น';

  @override
  String get reviewConfiguration =>
      'ตรวจสอบการกำหนดค่าของคุณและเริ่ม FlutterClaw';

  @override
  String get model => 'โมเดล';

  @override
  String viaProvider(String provider) {
    return 'ผ่าน $provider';
  }

  @override
  String get gateway => 'เกตเวย์';

  @override
  String get webChatOnly => 'WebChat เท่านั้น (คุณสามารถเพิ่มเติมได้ทีหลัง)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'กำลังเริ่มต้น...';

  @override
  String get startFlutterClaw => 'เริ่ม FlutterClaw';

  @override
  String get newSession => 'เซสชันใหม่';

  @override
  String get photoLibrary => 'ไลบรารีภาพถ่าย';

  @override
  String get camera => 'กล้อง';

  @override
  String get whatDoYouSeeInImage => 'คุณเห็นอะไรในภาพนี้?';

  @override
  String get imagePickerNotAvailable =>
      'ตัวเลือกภาพไม่พร้อมใช้งานบนซิมมูเลเตอร์ ใช้อุปกรณ์จริง';

  @override
  String get couldNotOpenImagePicker => 'ไม่สามารถเปิดตัวเลือกภาพได้';

  @override
  String get copiedToClipboard => 'คัดลอกไปยังคลิปบอร์ดแล้ว';

  @override
  String get attachImage => 'แนบภาพ';

  @override
  String get messageFlutterClaw => 'ส่งข้อความถึง FlutterClaw...';

  @override
  String get channelsAndGateway => 'ช่องทางและเกตเวย์';

  @override
  String get stop => 'หยุด';

  @override
  String get start => 'เริ่ม';

  @override
  String status(String status) {
    return 'สถานะ: $status';
  }

  @override
  String get builtInChatInterface => 'อินเทอร์เฟซแชทในตัว';

  @override
  String get notConfigured => 'ไม่ได้กำหนดค่า';

  @override
  String get connected => 'เชื่อมต่อแล้ว';

  @override
  String get configuredStarting => 'กำหนดค่าแล้ว (กำลังเริ่มต้น...)';

  @override
  String get telegramConfiguration => 'การกำหนดค่า Telegram';

  @override
  String get fromBotFather => 'จาก @BotFather';

  @override
  String get allowedUserIds => 'ID ผู้ใช้ที่อนุญาต (คั่นด้วยเครื่องหมายจุลภาค)';

  @override
  String get leaveEmptyToAllowAll => 'ปล่อยว่างเพื่ออนุญาตทั้งหมด';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get saveAndConnect => 'บันทึกและเชื่อมต่อ';

  @override
  String get discordConfiguration => 'การกำหนดค่า Discord';

  @override
  String get pendingPairingRequests => 'คำขอจับคู่ที่รอดำเนินการ';

  @override
  String get approve => 'อนุมัติ';

  @override
  String get reject => 'ปฏิเสธ';

  @override
  String get expired => 'หมดอายุ';

  @override
  String minutesLeft(int minutes) {
    return 'เหลืออีก $minutes นาที';
  }

  @override
  String get workspaceFiles => 'ไฟล์พื้นที่ทำงาน';

  @override
  String get personalAIAssistant => 'ผู้ช่วย AI ส่วนตัว';

  @override
  String sessionsCount(int count) {
    return 'เซสชัน ($count)';
  }

  @override
  String get noActiveSessions => 'ไม่มีเซสชันที่ใช้งานอยู่';

  @override
  String get startConversationToCreate => 'เริ่มการสนทนาเพื่อสร้าง';

  @override
  String get startConversationToSee => 'เริ่มการสนทนาเพื่อดูเซสชันที่นี่';

  @override
  String get reset => 'รีเซ็ต';

  @override
  String get cronJobs => 'งานที่กำหนดเวลา';

  @override
  String get noCronJobs => 'ไม่มีงานที่กำหนดเวลา';

  @override
  String get addScheduledTasks => 'เพิ่มงานที่กำหนดเวลาสำหรับตัวแทนของคุณ';

  @override
  String get runNow => 'เรียกใช้ตอนนี้';

  @override
  String get enable => 'เปิดใช้งาน';

  @override
  String get disable => 'ปิดใช้งาน';

  @override
  String get delete => 'ลบ';

  @override
  String get skills => 'ทักษะ';

  @override
  String get browseClawHub => 'เรียกดู ClawHub';

  @override
  String get noSkillsInstalled => 'ไม่มีทักษะที่ติดตั้ง';

  @override
  String get browseClawHubToAdd => 'เรียกดู ClawHub เพื่อเพิ่มทักษะ';

  @override
  String removeSkillConfirm(String name) {
    return 'ลบ \"$name\" ออกจากทักษะของคุณ?';
  }

  @override
  String get clawHubSkills => 'ทักษะ ClawHub';

  @override
  String get searchSkills => 'ค้นหาทักษะ...';

  @override
  String get noSkillsFound => 'ไม่พบทักษะ ลองค้นหาอื่น';

  @override
  String installedSkill(String name) {
    return 'ติดตั้ง $name แล้ว';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'ติดตั้ง $name ล้มเหลว';
  }

  @override
  String get addCronJob => 'เพิ่มงานที่กำหนดเวลา';

  @override
  String get jobName => 'ชื่องาน';

  @override
  String get dailySummaryExample => 'เช่น สรุปรายวัน';

  @override
  String get taskPrompt => 'คำสั่งงาน';

  @override
  String get whatShouldAgentDo => 'ตัวแทนควรทำอะไร?';

  @override
  String get interval => 'ช่วงเวลา';

  @override
  String get every5Minutes => 'ทุก 5 นาที';

  @override
  String get every15Minutes => 'ทุก 15 นาที';

  @override
  String get every30Minutes => 'ทุก 30 นาที';

  @override
  String get everyHour => 'ทุกชั่วโมง';

  @override
  String get every6Hours => 'ทุก 6 ชั่วโมง';

  @override
  String get every12Hours => 'ทุก 12 ชั่วโมง';

  @override
  String get every24Hours => 'ทุก 24 ชั่วโมง';

  @override
  String get add => 'เพิ่ม';

  @override
  String get save => 'บันทึก';

  @override
  String get sessions => 'เซสชัน';

  @override
  String messagesCount(int count) {
    return '$count ข้อความ';
  }

  @override
  String tokensCount(int count) {
    return '$count โทเค็น';
  }

  @override
  String get compact => 'บีบอัด';

  @override
  String get models => 'โมเดล';

  @override
  String get noModelsConfigured => 'ไม่มีโมเดลที่กำหนดค่า';

  @override
  String get addModelToStartChatting => 'เพิ่มโมเดลเพื่อเริ่มแชท';

  @override
  String get addModel => 'เพิ่มโมเดล';

  @override
  String get default_ => 'เริ่มต้น';

  @override
  String get autoStart => 'เริ่มอัตโนมัติ';

  @override
  String get startGatewayWhenLaunches => 'เริ่มเกตเวย์เมื่อเปิดแอป';

  @override
  String get heartbeat => 'ฮาร์ทบีท';

  @override
  String get enabled => 'เปิดใช้งาน';

  @override
  String get periodicAgentTasks => 'งานตัวแทนเป็นระยะจาก HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes นาที';
  }

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get personalAIAssistantForIOS =>
      'ผู้ช่วย AI ส่วนตัวสำหรับ iOS และ Android';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get basedOnOpenClaw => 'ใช้ OpenClaw เป็นฐาน';

  @override
  String get removeModel => 'ลบโมเดล?';

  @override
  String removeModelConfirm(String name) {
    return 'ลบ \"$name\" ออกจากโมเดลของคุณ?';
  }

  @override
  String get remove => 'ลบ';

  @override
  String get setAsDefault => 'ตั้งเป็นค่าเริ่มต้น';

  @override
  String get paste => 'วาง';

  @override
  String get chooseProviderStep => '1. เลือกผู้ให้บริการ';

  @override
  String get selectModelStep => '2. เลือกโมเดล';

  @override
  String get apiKeyStep => '3. คีย์ API';

  @override
  String getApiKeyAt(String provider) {
    return 'รับคีย์ API ที่ $provider';
  }

  @override
  String get justNow => 'เมื่อสักครู่';

  @override
  String minutesAgo(int minutes) {
    return '$minutes นาทีที่แล้ว';
  }

  @override
  String hoursAgo(int hours) {
    return '$hours ชั่วโมงที่แล้ว';
  }

  @override
  String daysAgo(int days) {
    return '$days วันที่แล้ว';
  }
}
