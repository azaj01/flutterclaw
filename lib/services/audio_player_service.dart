/// Background audio service using audio_service + just_audio.
///
/// Provides lock-screen media controls and system media notifications.
/// Call [initAudioService] from main.dart before runApp().
library;

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

FlutterClawAudioHandler? _audioHandler;

/// Returns the active audio handler, or null if not initialized.
FlutterClawAudioHandler? get audioHandler => _audioHandler;

/// Initialize the audio service. Must be called before runApp().
Future<FlutterClawAudioHandler> initAudioService() async {
  _audioHandler = await AudioService.init(
    builder: () => FlutterClawAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'ai.flutterclaw.audio',
      androidNotificationChannelName: 'Audio',
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidNotificationOngoing: false,
      androidStopForegroundOnPause: true,
    ),
  );
  return _audioHandler!;
}

/// AudioHandler that wraps a just_audio AudioPlayer with lock-screen controls.
class FlutterClawAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  FlutterClawAudioHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  /// The underlying just_audio player (for direct control / state queries).
  AudioPlayer get player => _player;

  /// Load and start playback from a URL or local file path.
  Future<void> playUri(
    String uri, {
    String title = 'Audio',
    String? artist,
    Uri? artworkUri,
  }) async {
    mediaItem.add(MediaItem(
      id: uri,
      title: title,
      artist: artist,
      artUri: artworkUri,
    ));
    if (uri.startsWith('http://') || uri.startsWith('https://')) {
      await _player.setUrl(uri);
    } else {
      await _player.setFilePath(uri);
    }
    await _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> setVolume(double volume) => _player.setVolume(volume);

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
      ],
      systemActions: const {MediaAction.seek},
      androidCompactActionIndices: const [0, 1],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }
}
