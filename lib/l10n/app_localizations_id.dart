// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'FlutterClaw';

  @override
  String get chat => 'Obrolan';

  @override
  String get channels => 'Saluran';

  @override
  String get agent => 'Agen';

  @override
  String get settings => 'Pengaturan';

  @override
  String get getStarted => 'Mulai';

  @override
  String get yourPersonalAssistant => 'Asisten AI pribadi Anda';

  @override
  String get multiChannelChat => 'Obrolan multi-saluran';

  @override
  String get multiChannelChatDesc => 'Telegram, Discord, WebChat dan lainnya';

  @override
  String get powerfulAIModels => 'Model AI yang kuat';

  @override
  String get powerfulAIModelsDesc => 'OpenAI, Anthropic, Grok dan model gratis';

  @override
  String get localGateway => 'Gateway lokal';

  @override
  String get localGatewayDesc =>
      'Berjalan di perangkat Anda, data Anda tetap milik Anda';

  @override
  String get chooseProvider => 'Pilih Penyedia';

  @override
  String get selectProviderDesc =>
      'Pilih cara Anda ingin terhubung ke model AI.';

  @override
  String get startForFree => 'Mulai Gratis';

  @override
  String get freeProvidersDesc =>
      'Penyedia ini menawarkan model gratis untuk memulai tanpa biaya.';

  @override
  String get free => 'GRATIS';

  @override
  String get otherProviders => 'Penyedia Lain';

  @override
  String connectToProvider(String provider) {
    return 'Hubungkan ke $provider';
  }

  @override
  String get enterApiKeyDesc => 'Masukkan kunci API Anda dan pilih model.';

  @override
  String get dontHaveApiKey => 'Tidak punya kunci API?';

  @override
  String get createAccountCopyKey => 'Buat akun dan salin kunci Anda.';

  @override
  String get signUp => 'Daftar';

  @override
  String get apiKey => 'Kunci API';

  @override
  String get pasteFromClipboard => 'Tempel dari papan klip';

  @override
  String get apiBaseUrl => 'URL Dasar API';

  @override
  String get selectModel => 'Pilih Model';

  @override
  String get modelId => 'ID Model';

  @override
  String get validateKey => 'Validasi Kunci';

  @override
  String get validating => 'Memvalidasi...';

  @override
  String get invalidApiKey => 'Kunci API tidak valid';

  @override
  String get gatewayConfiguration => 'Konfigurasi Gateway';

  @override
  String get gatewayConfigDesc =>
      'Gateway adalah bidang kontrol lokal untuk asisten Anda.';

  @override
  String get defaultSettingsNote =>
      'Pengaturan default berfungsi untuk sebagian besar pengguna. Hanya ubah jika Anda tahu apa yang Anda butuhkan.';

  @override
  String get host => 'Host';

  @override
  String get port => 'Port';

  @override
  String get autoStartGateway => 'Mulai gateway otomatis';

  @override
  String get autoStartGatewayDesc =>
      'Mulai gateway secara otomatis saat aplikasi diluncurkan.';

  @override
  String get channelsPageTitle => 'Saluran';

  @override
  String get channelsPageDesc =>
      'Secara opsional hubungkan saluran pesan. Anda selalu dapat mengatur ini nanti di Pengaturan.';

  @override
  String get telegram => 'Telegram';

  @override
  String get connectTelegramBot => 'Hubungkan bot Telegram.';

  @override
  String get openBotFather => 'Buka BotFather';

  @override
  String get discord => 'Discord';

  @override
  String get connectDiscordBot => 'Hubungkan bot Discord.';

  @override
  String get developerPortal => 'Portal Pengembang';

  @override
  String get botToken => 'Token Bot';

  @override
  String telegramBotToken(String platform) {
    return 'Token Bot $platform';
  }

  @override
  String get readyToGo => 'Siap Memulai';

  @override
  String get reviewConfiguration =>
      'Tinjau konfigurasi Anda dan mulai FlutterClaw.';

  @override
  String get model => 'Model';

  @override
  String viaProvider(String provider) {
    return 'melalui $provider';
  }

  @override
  String get gateway => 'Gateway';

  @override
  String get webChatOnly =>
      'Hanya WebChat (Anda dapat menambah lebih banyak nanti)';

  @override
  String get webChat => 'WebChat';

  @override
  String get starting => 'Memulai...';

  @override
  String get startFlutterClaw => 'Mulai FlutterClaw';

  @override
  String get newSession => 'Sesi baru';

  @override
  String get photoLibrary => 'Perpustakaan Foto';

  @override
  String get camera => 'Kamera';

  @override
  String get whatDoYouSeeInImage => 'Apa yang Anda lihat dalam gambar ini?';

  @override
  String get imagePickerNotAvailable =>
      'Pemilih gambar tidak tersedia di Simulator. Gunakan perangkat nyata.';

  @override
  String get couldNotOpenImagePicker => 'Tidak dapat membuka pemilih gambar.';

  @override
  String get copiedToClipboard => 'Disalin ke papan klip';

  @override
  String get attachImage => 'Lampirkan gambar';

  @override
  String get messageFlutterClaw => 'Pesan ke FlutterClaw...';

  @override
  String get channelsAndGateway => 'Saluran dan Gateway';

  @override
  String get stop => 'Berhenti';

  @override
  String get start => 'Mulai';

  @override
  String status(String status) {
    return 'Status: $status';
  }

  @override
  String get builtInChatInterface => 'Antarmuka obrolan bawaan';

  @override
  String get notConfigured => 'Tidak dikonfigurasi';

  @override
  String get connected => 'Terhubung';

  @override
  String get configuredStarting => 'Dikonfigurasi (memulai...)';

  @override
  String get telegramConfiguration => 'Konfigurasi Telegram';

  @override
  String get fromBotFather => 'Dari @BotFather';

  @override
  String get allowedUserIds => 'ID Pengguna yang Diizinkan (dipisahkan koma)';

  @override
  String get leaveEmptyToAllowAll => 'Biarkan kosong untuk mengizinkan semua';

  @override
  String get cancel => 'Batal';

  @override
  String get saveAndConnect => 'Simpan dan Hubungkan';

  @override
  String get discordConfiguration => 'Konfigurasi Discord';

  @override
  String get pendingPairingRequests => 'Permintaan Pemasangan Tertunda';

  @override
  String get approve => 'Setujui';

  @override
  String get reject => 'Tolak';

  @override
  String get expired => 'Kedaluwarsa';

  @override
  String minutesLeft(int minutes) {
    return 'Tersisa ${minutes}m';
  }

  @override
  String get workspaceFiles => 'File Ruang Kerja';

  @override
  String get personalAIAssistant => 'Asisten AI Pribadi';

  @override
  String sessionsCount(int count) {
    return 'Sesi ($count)';
  }

  @override
  String get noActiveSessions => 'Tidak ada sesi aktif';

  @override
  String get startConversationToCreate => 'Mulai percakapan untuk membuat';

  @override
  String get startConversationToSee =>
      'Mulai percakapan untuk melihat sesi di sini';

  @override
  String get reset => 'Atur Ulang';

  @override
  String get cronJobs => 'Tugas Terjadwal';

  @override
  String get noCronJobs => 'Tidak ada tugas terjadwal';

  @override
  String get addScheduledTasks => 'Tambahkan tugas terjadwal untuk agen Anda';

  @override
  String get runNow => 'Jalankan Sekarang';

  @override
  String get enable => 'Aktifkan';

  @override
  String get disable => 'Nonaktifkan';

  @override
  String get delete => 'Hapus';

  @override
  String get skills => 'Keterampilan';

  @override
  String get browseClawHub => 'Jelajahi ClawHub';

  @override
  String get noSkillsInstalled => 'Tidak ada keterampilan terinstal';

  @override
  String get browseClawHubToAdd =>
      'Jelajahi ClawHub untuk menambah keterampilan';

  @override
  String removeSkillConfirm(String name) {
    return 'Hapus \"$name\" dari keterampilan Anda?';
  }

  @override
  String get clawHubSkills => 'Keterampilan ClawHub';

  @override
  String get searchSkills => 'Cari keterampilan...';

  @override
  String get noSkillsFound =>
      'Tidak ditemukan keterampilan. Coba pencarian yang berbeda.';

  @override
  String installedSkill(String name) {
    return '$name terinstal';
  }

  @override
  String failedToInstallSkill(String name) {
    return 'Gagal menginstal $name';
  }

  @override
  String get addCronJob => 'Tambahkan Tugas Terjadwal';

  @override
  String get jobName => 'Nama Tugas';

  @override
  String get dailySummaryExample => 'mis. Ringkasan Harian';

  @override
  String get taskPrompt => 'Prompt Tugas';

  @override
  String get whatShouldAgentDo => 'Apa yang harus dilakukan agen?';

  @override
  String get interval => 'Interval';

  @override
  String get every5Minutes => 'Setiap 5 menit';

  @override
  String get every15Minutes => 'Setiap 15 menit';

  @override
  String get every30Minutes => 'Setiap 30 menit';

  @override
  String get everyHour => 'Setiap jam';

  @override
  String get every6Hours => 'Setiap 6 jam';

  @override
  String get every12Hours => 'Setiap 12 jam';

  @override
  String get every24Hours => 'Setiap 24 jam';

  @override
  String get add => 'Tambah';

  @override
  String get save => 'Simpan';

  @override
  String get sessions => 'Sesi';

  @override
  String messagesCount(int count) {
    return '$count pesan';
  }

  @override
  String tokensCount(int count) {
    return '$count token';
  }

  @override
  String get compact => 'Padatkan';

  @override
  String get models => 'Model';

  @override
  String get noModelsConfigured => 'Tidak ada model yang dikonfigurasi';

  @override
  String get addModelToStartChatting => 'Tambahkan model untuk mulai mengobrol';

  @override
  String get addModel => 'Tambah Model';

  @override
  String get default_ => 'DEFAULT';

  @override
  String get autoStart => 'Mulai otomatis';

  @override
  String get startGatewayWhenLaunches =>
      'Mulai gateway saat aplikasi diluncurkan';

  @override
  String get heartbeat => 'Detak Jantung';

  @override
  String get enabled => 'Diaktifkan';

  @override
  String get periodicAgentTasks => 'Tugas agen berkala dari HEARTBEAT.md';

  @override
  String intervalMinutes(int minutes) {
    return '$minutes mnt';
  }

  @override
  String get about => 'Tentang';

  @override
  String get personalAIAssistantForIOS =>
      'Asisten AI Pribadi untuk iOS dan Android';

  @override
  String get version => 'Versi';

  @override
  String get basedOnOpenClaw => 'Berdasarkan OpenClaw';

  @override
  String get removeModel => 'Hapus model?';

  @override
  String removeModelConfirm(String name) {
    return 'Hapus \"$name\" dari model Anda?';
  }

  @override
  String get remove => 'Hapus';

  @override
  String get setAsDefault => 'Atur sebagai Default';

  @override
  String get paste => 'Tempel';

  @override
  String get chooseProviderStep => '1. Pilih Penyedia';

  @override
  String get selectModelStep => '2. Pilih Model';

  @override
  String get apiKeyStep => '3. Kunci API';

  @override
  String getApiKeyAt(String provider) {
    return 'Dapatkan kunci API di $provider';
  }

  @override
  String get justNow => 'baru saja';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m yang lalu';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}j yang lalu';
  }

  @override
  String daysAgo(int days) {
    return '${days}h yang lalu';
  }
}
