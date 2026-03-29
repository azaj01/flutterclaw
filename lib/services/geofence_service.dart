/// Geofence Service — location-triggered automation for FlutterClaw.
///
/// Monitors the device's position stream and fires events when the user
/// enters or exits defined geofence regions. Events are published to the
/// [EventBus] so automation rules can react to them.
///
/// Uses geolocator's position stream with a distance filter to avoid
/// excessive battery drain. No native geofencing APIs are required.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutterclaw/data/models/config.dart';
import 'package:flutterclaw/services/event_bus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

final _log = Logger('flutterclaw.geofence');
const _uuid = Uuid();

// ---------------------------------------------------------------------------
// Geofence model
// ---------------------------------------------------------------------------

enum GeofenceState { unknown, inside, outside }

class Geofence {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  /// Radius in meters.
  final double radiusMeters;
  final bool enabled;
  final DateTime createdAt;
  GeofenceState lastState;
  DateTime? lastTriggeredAt;
  int triggerCount;

  Geofence({
    String? id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.radiusMeters = 200,
    this.enabled = true,
    DateTime? createdAt,
    this.lastState = GeofenceState.unknown,
    this.lastTriggeredAt,
    this.triggerCount = 0,
  })  : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'radius_meters': radiusMeters,
        'enabled': enabled,
        'created_at': createdAt.toIso8601String(),
        'last_state': lastState.name,
        if (lastTriggeredAt != null)
          'last_triggered_at': lastTriggeredAt!.toIso8601String(),
        'trigger_count': triggerCount,
      };

  factory Geofence.fromJson(Map<String, dynamic> json) => Geofence(
        id: json['id'] as String?,
        name: json['name'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        radiusMeters: (json['radius_meters'] as num?)?.toDouble() ?? 200,
        enabled: json['enabled'] as bool? ?? true,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        lastState: GeofenceState.values.firstWhere(
          (s) => s.name == (json['last_state'] as String? ?? 'unknown'),
          orElse: () => GeofenceState.unknown,
        ),
        lastTriggeredAt: json['last_triggered_at'] != null
            ? DateTime.parse(json['last_triggered_at'] as String)
            : null,
        triggerCount: json['trigger_count'] as int? ?? 0,
      );
}

// ---------------------------------------------------------------------------
// Geofence Service
// ---------------------------------------------------------------------------

class GeofenceService {
  final ConfigManager configManager;

  /// Event bus — set before calling [start].
  EventBus? eventBus;

  final List<Geofence> _fences = [];
  StreamSubscription<Position>? _positionSub;
  bool _running = false;

  /// Minimum distance (meters) the device must move before we re-check fences.
  /// Lower = more responsive but more battery. 50m is a good balance.
  static const int distanceFilterMeters = 50;

  /// Minimum interval between consecutive triggers of the same fence (debounce).
  static const Duration minTriggerInterval = Duration(minutes: 2);

  GeofenceService({required this.configManager});

  bool get isRunning => _running;
  List<Geofence> get fences => List.unmodifiable(_fences);

  Future<void> start() async {
    if (_running) return;
    _running = true;
    await _loadFences();

    if (_fences.isEmpty) {
      _log.info('Geofence service started (no fences defined — monitoring paused)');
      return;
    }

    await _startListening();
    _log.info('Geofence service started with ${_fences.length} fence(s)');
  }

  Future<void> stop() async {
    _running = false;
    await _positionSub?.cancel();
    _positionSub = null;
    await _saveFences();
    _log.info('Geofence service stopped');
  }

  // -------------------------------------------------------------------------
  // CRUD
  // -------------------------------------------------------------------------

  Future<Geofence> addFence(Geofence fence) async {
    _fences.add(fence);
    await _saveFences();
    _log.info('Added geofence: ${fence.name} (${fence.id}) '
        'at ${fence.latitude},${fence.longitude} r=${fence.radiusMeters}m');

    // Start listening if this is the first fence
    if (_running && _positionSub == null) {
      await _startListening();
    }
    return fence;
  }

  Future<void> removeFence(String id) async {
    _fences.removeWhere((f) => f.id == id);
    await _saveFences();
    _log.info('Removed geofence: $id');

    // Stop listening if no fences remain
    if (_fences.isEmpty) {
      await _positionSub?.cancel();
      _positionSub = null;
    }
  }

  Future<void> updateFence(
    String id, {
    String? name,
    bool? enabled,
    double? radiusMeters,
  }) async {
    final idx = _fences.indexWhere((f) => f.id == id);
    if (idx == -1) return;
    final f = _fences[idx];
    _fences[idx] = Geofence(
      id: f.id,
      name: name ?? f.name,
      latitude: f.latitude,
      longitude: f.longitude,
      radiusMeters: radiusMeters ?? f.radiusMeters,
      enabled: enabled ?? f.enabled,
      createdAt: f.createdAt,
      lastState: f.lastState,
      lastTriggeredAt: f.lastTriggeredAt,
      triggerCount: f.triggerCount,
    );
    await _saveFences();
  }

  // -------------------------------------------------------------------------
  // Position monitoring
  // -------------------------------------------------------------------------

  Future<void> _startListening() async {
    // Check permissions first
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _log.warning('Location services disabled — geofence monitoring paused');
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _log.warning('Location permission denied — geofence monitoring paused');
      return;
    }

    _positionSub = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: distanceFilterMeters,
      ),
    ).listen(
      _onPosition,
      onError: (e) => _log.warning('Position stream error: $e'),
    );
  }

  void _onPosition(Position pos) {
    if (!_running) return;

    final now = DateTime.now();
    bool changed = false;

    for (final fence in _fences) {
      if (!fence.enabled) continue;

      final distance = _haversineDistance(
        pos.latitude,
        pos.longitude,
        fence.latitude,
        fence.longitude,
      );

      final isInside = distance <= fence.radiusMeters;
      final newState = isInside ? GeofenceState.inside : GeofenceState.outside;

      // Only fire on state transitions (not on first check from unknown)
      if (fence.lastState != GeofenceState.unknown &&
          newState != fence.lastState) {
        // Debounce
        if (fence.lastTriggeredAt != null &&
            now.difference(fence.lastTriggeredAt!) < minTriggerInterval) {
          continue;
        }

        final transition = newState == GeofenceState.inside ? 'enter' : 'exit';
        _log.info(
          'Geofence "$transition" for "${fence.name}" '
          '(distance: ${distance.toStringAsFixed(0)}m, radius: ${fence.radiusMeters}m)',
        );

        fence.triggerCount++;
        fence.lastTriggeredAt = now;
        changed = true;

        eventBus?.publish(AgentEvent(
          type: EventType.geofence,
          source: 'geofence:${fence.id}',
          summary: '${transition == "enter" ? "Entered" : "Exited"} geofence "${fence.name}"',
          payload: {
            'fence_id': fence.id,
            'fence_name': fence.name,
            'transition': transition,
            'latitude': pos.latitude,
            'longitude': pos.longitude,
            'distance_meters': distance.round(),
            'radius_meters': fence.radiusMeters,
          },
        ));
      }

      fence.lastState = newState;
      if (fence.lastState != newState) changed = true;
    }

    if (changed) _saveFences();
  }

  // -------------------------------------------------------------------------
  // Haversine distance (meters)
  // -------------------------------------------------------------------------

  static double _haversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000.0; // meters
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _toRadians(double degrees) => degrees * pi / 180;

  // -------------------------------------------------------------------------
  // Persistence
  // -------------------------------------------------------------------------

  Future<void> _loadFences() async {
    try {
      final ws = await configManager.workspacePath;
      final file = File('$ws/geofence/fences.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final list = jsonDecode(content) as List<dynamic>;
        _fences.clear();
        _fences.addAll(
          list.map((e) => Geofence.fromJson(e as Map<String, dynamic>)),
        );
      }
    } catch (e) {
      _log.warning('Failed to load geofences: $e');
    }
  }

  Future<void> _saveFences() async {
    try {
      final ws = await configManager.workspacePath;
      final dir = Directory('$ws/geofence');
      await dir.create(recursive: true);
      final file = File('${dir.path}/fences.json');
      final encoder = const JsonEncoder.withIndent('  ');
      await file.writeAsString(
        encoder.convert(_fences.map((f) => f.toJson()).toList()),
      );
    } catch (e) {
      _log.warning('Failed to save geofences: $e');
    }
  }
}
