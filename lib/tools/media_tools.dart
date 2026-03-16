/// Media playback tools for FlutterClaw agents.
///
/// Play audio/music with background playback and lock-screen controls
/// via the FlutterClawAudioHandler (audio_service + just_audio).
library;

import 'package:flutterclaw/services/audio_player_service.dart';
import 'registry.dart';

/// Play an audio file or URL with background + lock-screen support.
class MediaPlayTool extends Tool {
  @override
  String get name => 'media_play';

  @override
  String get description =>
      'Play an audio file or stream URL with background playback and '
      'lock-screen media controls. '
      'Accepts local file paths or https:// URLs. '
      'Returns playback status and duration.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'url': {
            'type': 'string',
            'description':
                'Local file path or https:// URL of the audio to play.',
          },
          'title': {
            'type': 'string',
            'description': 'Track title shown on lock screen (default: "Audio").',
          },
          'artist': {
            'type': 'string',
            'description': 'Artist name shown on lock screen.',
          },
        },
        'required': ['url'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final url = (args['url'] as String?)?.trim() ?? '';
    if (url.isEmpty) return ToolResult.error('url is required');

    final title = (args['title'] as String?) ?? 'Audio';
    final artist = args['artist'] as String?;

    final handler = audioHandler;
    if (handler == null) {
      return ToolResult.error(
        'Audio service not initialized. '
        'This is a startup issue — please restart the app.',
      );
    }

    try {
      await handler.playUri(url, title: title, artist: artist);
      final duration = handler.player.duration;
      final durationStr = duration != null
          ? '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}'
          : 'unknown';
      return ToolResult.success(
        'Playing: "$title"  |  duration: $durationStr  |  url: $url',
      );
    } catch (e) {
      return ToolResult.error('Playback error: $e');
    }
  }
}

/// Control currently playing audio (play/pause/stop/seek/volume).
class MediaControlTool extends Tool {
  @override
  String get name => 'media_control';

  @override
  String get description =>
      'Control the currently playing audio. '
      'Actions: play, pause, stop, seek (jump to position), set_volume. '
      'Returns the current playback state.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'action': {
            'type': 'string',
            'enum': ['play', 'pause', 'stop', 'seek', 'set_volume'],
            'description': 'Playback action to perform.',
          },
          'position_seconds': {
            'type': 'number',
            'description': 'Seek target in seconds (required for "seek" action).',
          },
          'volume': {
            'type': 'number',
            'description':
                'Volume level 0.0–1.0 (required for "set_volume" action).',
            'minimum': 0.0,
            'maximum': 1.0,
          },
        },
        'required': ['action'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final action = (args['action'] as String?)?.trim() ?? '';
    if (action.isEmpty) return ToolResult.error('action is required');

    final handler = audioHandler;
    if (handler == null) {
      return ToolResult.error('Audio service not initialized.');
    }

    final player = handler.player;

    try {
      switch (action) {
        case 'play':
          await handler.play();
        case 'pause':
          await handler.pause();
        case 'stop':
          await handler.stop();
        case 'seek':
          final secs = (args['position_seconds'] as num?)?.toDouble();
          if (secs == null) return ToolResult.error('position_seconds required for seek');
          await handler.seek(Duration(milliseconds: (secs * 1000).round()));
        case 'set_volume':
          final vol = (args['volume'] as num?)?.toDouble();
          if (vol == null) return ToolResult.error('volume required for set_volume');
          await handler.setVolume(vol.clamp(0.0, 1.0));
        default:
          return ToolResult.error('Unknown action: $action');
      }

      final pos = player.position;
      final dur = player.duration;
      final posStr =
          '${pos.inMinutes}:${(pos.inSeconds % 60).toString().padLeft(2, '0')}';
      final durStr = dur != null
          ? '${dur.inMinutes}:${(dur.inSeconds % 60).toString().padLeft(2, '0')}'
          : 'unknown';

      return ToolResult.success(
        'action=$action  |  '
        'playing=${player.playing}  |  '
        'position=$posStr  |  '
        'duration=$durStr',
      );
    } catch (e) {
      return ToolResult.error('Media control error: $e');
    }
  }
}
