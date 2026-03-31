/// Non-blocking overlay for Gemini Live voice: animated rings and status over the
/// existing chat list. Transcript text streams into [chatProvider] via live agent
/// events; tool pills still arrive from [SessionManager.messageStream]. Session
/// persistence runs on [LiveTurnComplete] (and before tool rows when applicable).
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterclaw/core/app_providers.dart';
import 'package:flutterclaw/core/agent/live_agent_loop.dart';
import 'package:flutterclaw/generated/app_localizations.dart';
import 'package:flutterclaw/ui/theme/tokens.dart';
import 'package:just_audio/just_audio.dart';

/// Live call chrome heights — keep in sync with [LiveVoiceOverlay.listTopPaddingWhenLive].
const double _kLiveHeaderHeight = 52;
const double _kLiveHudHeight = 80;

class LiveVoiceOverlay extends ConsumerStatefulWidget {
  const LiveVoiceOverlay({super.key});

  /// Extra top padding for the chat [ListView] so messages sit below the live header + HUD.
  static const double listTopPaddingWhenLive =
      _kLiveHeaderHeight + _kLiveHudHeight;

  @override
  ConsumerState<LiveVoiceOverlay> createState() => _LiveVoiceOverlayState();
}

class _LiveVoiceOverlayState extends ConsumerState<LiveVoiceOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _ring1Controller;
  late final AnimationController _ring2Controller;
  late final AnimationController _ring3Controller;

  StreamSubscription? _eventSub;

  bool _modelSpeaking = false;
  bool _isConnecting = true;
  String? _activeTool;

  // --- Audio ---

  /// Accumulated PCM waiting to be flushed into a WAV segment.
  final _pcmBuffer = BytesBuilder(copy: false);

  /// Playlist of in-memory WAV segments for the current turn.
  ConcatenatingAudioSource? _livePlaylist;

  /// True once [play] has been called for this turn.
  bool _playerStarted = false;

  /// True once the playlist has been set as the player's audio source.
  bool _playlistLoadedIntoPlayer = false;

  /// Total PCM bytes accumulated for preroll check.
  int _prerollBytes = 0;

  /// Serializes async audio operations.
  Future<void> _audioChainTail = Future.value();

  /// Incremented on stop/clear so stale chain steps exit harmlessly.
  int _liveAudioGeneration = 0;

  /// True when the network has signalled [LiveTurnComplete] for this turn.
  bool _networkTurnComplete = false;

  /// Mic is cut for the current assistant audio stream.
  bool _micHoldForAssistantPcm = false;

  /// Playback must reach [PlayerState.playing] before we trust idle/completed
  /// as "done" (iOS briefly reports idle right after [play]).
  bool _sawPlayerAudibleThisArm = false;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription? _playerCompleteSub;

  bool _awaitingLocalPlaybackEnd = false;
  Timer? _playbackEndDebounce;

  /// True when the player ran out of segments mid-turn (went completed/idle
  /// before [_networkTurnComplete]). Next [_flushSegment] will resume playback.
  bool _playerDry = false;

  /// Safety: if the player hasn't produced audio within this duration after
  /// [play], force-unsuppress the mic to avoid permanent mute.
  Timer? _micSafetyTimer;
  static const _kMicSafetyTimeout = Duration(seconds: 6);

  /// Segment flush threshold: 2 s at 24 kHz / 16-bit / mono = 96 000 B.
  /// Uniform segment size ensures the next segment is accumulated in roughly
  /// the same time the current one takes to play.
  static const int _kFlushBytes = 96000;

  /// Preroll before first [play]: same as one segment (2 s).
  static const int _kPrerollBytes = 96000;

  /// Dedicated player: avoids audio_service main [AudioPlayer] contention.
  late final AudioPlayer _livePlayer;

  @override
  void initState() {
    super.initState();

    _livePlayer = AudioPlayer(
      handleAudioSessionActivation: false,
      audioLoadConfiguration: AudioLoadConfiguration(
        darwinLoadControl: DarwinLoadControl(
          automaticallyWaitsToMinimizeStalling: false,
          preferredForwardBufferDuration: Duration(seconds: 4),
        ),
        androidLoadControl: AndroidLoadControl(
          minBufferDuration: Duration(milliseconds: 2000),
          maxBufferDuration: Duration(seconds: 10),
          bufferForPlaybackDuration: Duration(milliseconds: 200),
          bufferForPlaybackAfterRebufferDuration: Duration(milliseconds: 500),
        ),
      ),
    );

    _ring1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _ring2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _ring2Controller.repeat(reverse: true);
    });

    _ring3Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ring3Controller.repeat(reverse: true);
    });

    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    final notifier = ref.read(liveSessionProvider.notifier);
    _eventSub = notifier.agentEvents.listen(
      (event) {
      if (!mounted) return;
      switch (event) {
        case LiveAudioOutput(:final pcmData):
          if (!_micHoldForAssistantPcm && mounted) {
            _micHoldForAssistantPcm = true;
            ref.read(liveSessionProvider.notifier).setLivePlaybackSuppressMic(true);
          }
          _handleAudioChunk(pcmData);
          if (!_modelSpeaking) {
            setState(() {
              _modelSpeaking = true;
              _isConnecting = false;
            });
          }

        case LiveUserTranscript():
          setState(() => _isConnecting = false);

        case LiveModelTranscript():
          setState(() => _isConnecting = false);

        case LiveToolStarted(:final name):
          setState(() => _activeTool = name);

        case LiveToolCompleted(:final name):
          if (_activeTool == name) setState(() => _activeTool = null);

        case LiveTurnComplete():
          _handleTurnComplete();
          setState(() => _modelSpeaking = false);

        case LiveInterrupted():
          _stopAndClearAudio();
          setState(() => _modelSpeaking = false);

        case LiveAgentError(:final message):
          final messenger = ScaffoldMessenger.maybeOf(context);
          messenger?.showSnackBar(SnackBar(content: Text(message)));

        case LiveSessionDisconnected():
          _stopAndClearAudio();

        case LiveSessionReady():
          setState(() => _isConnecting = false);
      }
      },
      onError: (Object error, StackTrace stack) {
        debugPrint('[LiveAudio] agent event stream error: $error');
        if (mounted) _stopAndClearAudio();
      },
    );
  }

  // --- Audio helpers ---

  void _handleAudioChunk(Uint8List pcmData) {
    final gen = _liveAudioGeneration;

    _pcmBuffer.add(pcmData);
    _prerollBytes += pcmData.length;

    // Create playlist on first chunk.
    if (_livePlaylist == null) {
      _livePlaylist = ConcatenatingAudioSource(
        children: [],
        useLazyPreparation: false,
      );
      _audioChainTail = _audioChainTail.then((_) async {
        if (gen != _liveAudioGeneration) return;
        try {
          await _livePlayer.setAudioSource(
            _livePlaylist!,
            preload: false,
          );
          _playlistLoadedIntoPlayer = true;
        } catch (e) {
          debugPrint('[LiveAudio] setAudioSource error: $e');
        }
      });
    }

    // Flush a segment when we have enough buffered PCM.
    if (_pcmBuffer.length >= _kFlushBytes) {
      _flushSegment(gen);
    }

    // Start playback once we've received enough total PCM (preroll).
    if (!_playerStarted && _prerollBytes >= _kPrerollBytes) {
      _startPlayback(gen);
    }
  }

  void _flushSegment(int gen) {
    if (_pcmBuffer.length == 0) return;

    final pcmBytes = Uint8List.fromList(_pcmBuffer.takeBytes());
    final wavBytes = _buildWav(pcmBytes, sampleRate: 24000);
    final source = _InMemoryWavSource(wavBytes);

    _audioChainTail = _audioChainTail.then((_) async {
      if (gen != _liveAudioGeneration) return;
      if (_livePlaylist == null) return;
      try {
        await _livePlaylist!.add(source);
      } catch (e) {
        debugPrint('[LiveAudio] segment add error: $e');
        return;
      }

      // Resume if the player ran dry waiting for this segment.
      if (_playerDry && gen == _liveAudioGeneration) {
        _playerDry = false;
        _sawPlayerAudibleThisArm = false; // re-arm audible guard
        try {
          final idx = _livePlaylist!.length - 1;
          await _livePlayer.seek(Duration.zero, index: idx);
          await _livePlayer.play();
        } catch (e) {
          debugPrint('[LiveAudio] resume-from-gap error: $e');
        }
      }
    });
  }

  void _startPlayback(int gen) {
    _playerStarted = true;

    // Flush whatever PCM we have into the first segment.
    _flushSegment(gen);

    _audioChainTail = _audioChainTail.then((_) async {
      if (gen != _liveAudioGeneration) return;
      if (!_playlistLoadedIntoPlayer) return;
      try {
        await _livePlayer.play();
        if (gen != _liveAudioGeneration) return;
        if (mounted) {
          ref.read(liveSessionProvider.notifier).setLivePlaybackSuppressMic(true);
        }
        _armPlaybackEndListener(gen);
        _startMicSafetyTimer();
      } catch (e) {
        debugPrint('[LiveAudio] play error: $e');
        _playerStarted = false;
        _unsuppressMic();
      }
    });
  }

  void _handleTurnComplete() {
    final gen = _liveAudioGeneration;
    _networkTurnComplete = true;

    // Flush any remaining buffered PCM.
    if (_pcmBuffer.length > 0) {
      _flushSegment(gen);
    }

    if (!_playerStarted) {
      if (_prerollBytes > 0) {
        // Short response — force play with whatever we have.
        _playerStarted = true;
        _flushSegment(gen);
        _audioChainTail = _audioChainTail.then((_) async {
          if (gen != _liveAudioGeneration) return;
          if (!_playlistLoadedIntoPlayer) return;
          try {
            await _livePlayer.play();
            if (gen != _liveAudioGeneration) return;
            _armPlaybackEndListener(gen);
            _startMicSafetyTimer();
          } catch (e) {
            debugPrint('[LiveAudio] short response play error: $e');
            _cleanupAfterPlayback();
          }
        });
      } else {
        // Turn complete with no audio at all — just unsuppress mic.
        _unsuppressMic();
      }
    } else if (_playerDry && _pcmBuffer.length == 0) {
      // Player was dry and there's nothing more to flush — truly done.
      // (If we DID flush above, _flushSegment's resume will handle playback
      // and the listener will detect completion after the final segment.)
      _audioChainTail = _audioChainTail.then((_) {
        if (gen != _liveAudioGeneration) return;
        _cleanupAfterPlayback();
      });
    }
  }

  void _armPlaybackEndListener(int gen) {
    _playerCompleteSub?.cancel();
    _playerStateSub?.cancel();
    _playbackEndDebounce?.cancel();
    _awaitingLocalPlaybackEnd = true;
    _sawPlayerAudibleThisArm = false;

    _playerStateSub = _livePlayer.playerStateStream.listen((ps) {
      if (!mounted || gen != _liveAudioGeneration) return;
      if (ps.playing) {
        _sawPlayerAudibleThisArm = true;
        _cancelMicSafetyTimer();
      }
    });

    _playerCompleteSub = _livePlayer.processingStateStream.listen((state) {
      if (!mounted || gen != _liveAudioGeneration || !_awaitingLocalPlaybackEnd) {
        return;
      }
      if (!_sawPlayerAudibleThisArm) return;

      final playerStopped = state == ProcessingState.completed ||
          (state == ProcessingState.idle && !_livePlayer.playing);
      if (!playerStopped) return;

      // Player ran out of segments. Is it truly done or just waiting for more?
      final trulyDone = _networkTurnComplete && _pcmBuffer.length == 0;
      if (!trulyDone) {
        // Mid-turn gap — next _flushSegment will resume playback.
        _playerDry = true;
        return;
      }

      _playbackEndDebounce?.cancel();
      _playbackEndDebounce = Timer(const Duration(milliseconds: 80), () {
        _playbackEndDebounce = null;
        if (!mounted || gen != _liveAudioGeneration || !_awaitingLocalPlaybackEnd) {
          return;
        }
        _cleanupAfterPlayback();
      });
    });
  }

  void _startMicSafetyTimer() {
    _micSafetyTimer?.cancel();
    _micSafetyTimer = Timer(_kMicSafetyTimeout, () {
      _micSafetyTimer = null;
      if (!mounted) return;
      if (!_sawPlayerAudibleThisArm && _micHoldForAssistantPcm) {
        debugPrint('[LiveAudio] mic safety timeout — force unsuppress');
        _unsuppressMic();
      }
    });
  }

  void _cancelMicSafetyTimer() {
    _micSafetyTimer?.cancel();
    _micSafetyTimer = null;
  }

  void _unsuppressMic() {
    _micHoldForAssistantPcm = false;
    if (mounted) {
      ref.read(liveSessionProvider.notifier).setLivePlaybackSuppressMic(false);
    }
  }

  void _cleanupAfterPlayback() {
    _awaitingLocalPlaybackEnd = false;
    _playerStarted = false;
    _playlistLoadedIntoPlayer = false;
    _micHoldForAssistantPcm = false;
    _networkTurnComplete = false;
    _playerDry = false;
    _prerollBytes = 0;
    _livePlaylist = null;
    _playerStateSub?.cancel();
    _playerStateSub = null;
    _playerCompleteSub?.cancel();
    _playerCompleteSub = null;
    _cancelMicSafetyTimer();
    // Stop the player so it fully releases the audio route — otherwise its
    // lingering "playback" state can degrade mic quality / echo cancellation.
    unawaited(_livePlayer.stop().catchError((_) {}));
    ref
        .read(liveSessionProvider.notifier)
        .scheduleMicUnsuppressAfterLocalPlayback(
          delay: const Duration(milliseconds: 150),
        );
  }

  void _stopAndClearAudio() {
    _liveAudioGeneration++;
    _audioChainTail = Future.value();
    _playbackEndDebounce?.cancel();
    _playbackEndDebounce = null;
    _awaitingLocalPlaybackEnd = false;
    _micHoldForAssistantPcm = false;
    _networkTurnComplete = false;
    _prerollBytes = 0;
    _pcmBuffer.clear();
    _playerStateSub?.cancel();
    _playerStateSub = null;
    _playerCompleteSub?.cancel();
    _playerCompleteSub = null;
    _livePlaylist = null;
    _playerStarted = false;
    _playlistLoadedIntoPlayer = false;
    _playerDry = false;
    _cancelMicSafetyTimer();
    unawaited(_livePlayer.stop().catchError((_) {}));
    if (mounted) {
      ref.read(liveSessionProvider.notifier).setLivePlaybackSuppressMic(false);
    }
  }

  Future<void> _endSession() async {
    _stopAndClearAudio();
    await ref.read(liveSessionProvider.notifier).stopSession();
    if (mounted) {
      await ref.read(chatProvider.notifier).reloadHistory();
    }
  }

  @override
  void dispose() {
    _liveAudioGeneration++;
    _audioChainTail = Future.value();
    _ring1Controller.dispose();
    _ring2Controller.dispose();
    _ring3Controller.dispose();
    _eventSub?.cancel();
    _playbackEndDebounce?.cancel();
    _playerStateSub?.cancel();
    _playerCompleteSub?.cancel();
    _cancelMicSafetyTimer();
    unawaited(_livePlayer.dispose().catchError((_) {}));
    super.dispose();
  }

  // --- WAV builder ---

  static Uint8List _buildWav(Uint8List pcmData, {int sampleRate = 24000}) {
    const channels = 1;
    const bitsPerSample = 16;
    final byteRate = sampleRate * channels * (bitsPerSample ~/ 8);
    final blockAlign = channels * (bitsPerSample ~/ 8);
    final dataSize = pcmData.length;

    final wav = Uint8List(44 + dataSize);
    final hdr = ByteData.sublistView(wav, 0, 44);

    void s(int o, int v) => hdr.setUint8(o, v);
    void u16(int o, int v) => hdr.setUint16(o, v, Endian.little);
    void u32(int o, int v) => hdr.setUint32(o, v, Endian.little);

    // RIFF
    s(0, 0x52); s(1, 0x49); s(2, 0x46); s(3, 0x46);
    u32(4, 36 + dataSize);
    // WAVE
    s(8, 0x57); s(9, 0x41); s(10, 0x56); s(11, 0x45);
    // fmt
    s(12, 0x66); s(13, 0x6D); s(14, 0x74); s(15, 0x20);
    u32(16, 16); u16(20, 1); u16(22, channels);
    u32(24, sampleRate); u32(28, byteRate); u16(32, blockAlign);
    u16(34, bitsPerSample);
    // data
    s(36, 0x64); s(37, 0x61); s(38, 0x74); s(39, 0x61);
    u32(40, dataSize);

    wav.setRange(44, 44 + dataSize, pcmData);
    return wav;
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final agent = ref.watch(activeAgentProvider);
    final topBarColor = theme.colorScheme.surface.withValues(alpha: 0.97);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: topBarColor,
        elevation: 2,
        shadowColor: Colors.black26,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _kLiveHeaderHeight,
              child: _buildHeader(theme, agent),
            ),
            SizedBox(
              height: _kLiveHudHeight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTokens.spacingMD,
                  0,
                  AppTokens.spacingMD,
                  AppTokens.spacingSM,
                ),
                child: _buildCompactHud(theme, agent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, dynamic agent) {
    final agentName =
        (agent != null && (agent.name as String).isNotEmpty) ? agent.name as String : 'Live';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.spacingMD),
      child: Row(
        children: [
          Text(
            agentName,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppTokens.spacingSM),
          _LiveBadge(theme: theme),
          const Spacer(),
          IconButton(
            onPressed: _endSession,
            iconSize: 20,
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.onErrorContainer,
            ),
            icon: const Icon(Icons.call_end),
            tooltip: 'End conversation',
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHud(ThemeData theme, dynamic agent) {
    final agentEmoji =
        (agent != null && (agent.emoji as String).isNotEmpty) ? agent.emoji as String : '🎙';

    final Color ringColor;
    final double minScale;
    final double maxScale;
    final double minOpacity;
    final double maxOpacity;
    final Duration pulseDuration;

    if (_isConnecting) {
      ringColor = theme.colorScheme.outline;
      minScale = 0.95;
      maxScale = 1.05;
      minOpacity = 0.12;
      maxOpacity = 0.32;
      pulseDuration = const Duration(milliseconds: 1200);
    } else if (_modelSpeaking) {
      ringColor = theme.colorScheme.tertiary;
      minScale = 0.88;
      maxScale = 1.12;
      minOpacity = 0.28;
      maxOpacity = 0.65;
      pulseDuration = const Duration(milliseconds: 700);
    } else {
      ringColor = theme.colorScheme.primary;
      minScale = 0.95;
      maxScale = 1.05;
      minOpacity = 0.18;
      maxOpacity = 0.38;
      pulseDuration = const Duration(milliseconds: 1400);
    }

    if (_ring1Controller.duration != pulseDuration) {
      _ring1Controller.duration = pulseDuration;
      _ring2Controller.duration = pulseDuration;
      _ring3Controller.duration = pulseDuration;
    }

    final statusText = _isConnecting
        ? 'Connecting…'
        : _modelSpeaking
            ? 'Speaking…'
            : 'Listening…';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              _AnimatedRing(
                controller: _ring3Controller,
                size: 56,
                color: ringColor,
                minScale: minScale,
                maxScale: maxScale,
                minOpacity: minOpacity * 0.6,
                maxOpacity: maxOpacity * 0.6,
              ),
              _AnimatedRing(
                controller: _ring2Controller,
                size: 44,
                color: ringColor,
                minScale: minScale,
                maxScale: maxScale,
                minOpacity: minOpacity * 0.85,
                maxOpacity: maxOpacity * 0.85,
              ),
              _AnimatedRing(
                controller: _ring1Controller,
                size: 32,
                color: ringColor,
                minScale: minScale,
                maxScale: maxScale,
                minOpacity: minOpacity,
                maxOpacity: maxOpacity,
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ringColor.withValues(alpha: 0.18),
                  border: Border.all(
                    color: ringColor.withValues(alpha: 0.45),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    agentEmoji,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppTokens.spacingSM),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                statusText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_modelSpeaking && !_isConnecting) ...[
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)!.liveVoiceBargeInHint,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    height: 1.15,
                  ),
                ),
              ],
              if (_activeTool != null) ...[
                const SizedBox(height: 4),
                Text(
                  _activeTool!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// --- In-memory WAV segment source ---

/// A [StreamAudioSource] that serves a complete in-memory WAV file.
/// Returns the full byte payload on every [request] — no file I/O, no
/// progressive streaming, just instant bytes.
// ignore: experimental_member_use
class _InMemoryWavSource extends StreamAudioSource {
  final Uint8List _wav;
  _InMemoryWavSource(this._wav);

  @override
  // ignore: experimental_member_use
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final effectiveStart = start ?? 0;
    final effectiveEnd = end ?? _wav.length;
    // ignore: experimental_member_use
    return StreamAudioResponse(
      sourceLength: _wav.length,
      contentLength: effectiveEnd - effectiveStart,
      offset: effectiveStart,
      stream: Stream.value(_wav.sublist(effectiveStart, effectiveEnd)),
      contentType: 'audio/wav',
    );
  }
}

// --- Subwidgets ---

class _LiveBadge extends StatelessWidget {
  final ThemeData theme;
  const _LiveBadge({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTokens.radiusPill),
        border: Border.all(
          color: Colors.deepPurple.withValues(alpha: 0.4),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.spatial_audio, size: 10, color: Colors.deepPurple.shade300),
          const SizedBox(width: 3),
          Text(
            'LIVE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.deepPurple.shade300,
              fontWeight: FontWeight.w700,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedRing extends AnimatedWidget {
  final double size;
  final Color color;
  final double minScale;
  final double maxScale;
  final double minOpacity;
  final double maxOpacity;

  const _AnimatedRing({
    required AnimationController controller,
    required this.size,
    required this.color,
    required this.minScale,
    required this.maxScale,
    required this.minOpacity,
    required this.maxOpacity,
  }) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    final t = (listenable as AnimationController).value;
    final scale = minScale + (maxScale - minScale) * t;
    final opacity = minOpacity + (maxOpacity - minOpacity) * t;
    return Transform.scale(
      scale: scale,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}
