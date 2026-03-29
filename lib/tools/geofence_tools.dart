/// Geofence CRUD tools for FlutterClaw agents.
///
/// geofence_create / geofence_list / geofence_delete / geofence_update.
/// Geofences trigger events on the EventBus when the user enters/exits a region.
library;

import 'dart:convert';

import 'package:flutterclaw/services/geofence_service.dart';
import 'package:flutterclaw/tools/registry.dart';

// ---------------------------------------------------------------------------
// geofence_create
// ---------------------------------------------------------------------------

class GeofenceCreateTool extends Tool {
  final GeofenceService geofenceService;

  GeofenceCreateTool({required this.geofenceService});

  @override
  String get name => 'geofence_create';

  @override
  String get description =>
      'Create a geofence that fires events when the user enters or exits a '
      'location. Combine with automation_create to trigger tasks on arrival/departure.\n\n'
      'Example: geofence "Office" at lat/lng with 200m radius → '
      'automation rule on geofence enter → "Show today\'s calendar and pending tasks".\n\n'
      'The geofence monitors the device GPS with a 50m distance filter to '
      'balance responsiveness with battery life. Requires location permission.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'name': {
            'type': 'string',
            'description':
                'Human-readable name for the geofence (e.g. "Office", "Home", "Gym")',
          },
          'latitude': {
            'type': 'number',
            'description': 'Latitude of the center point',
          },
          'longitude': {
            'type': 'number',
            'description': 'Longitude of the center point',
          },
          'radius_meters': {
            'type': 'number',
            'minimum': 50,
            'maximum': 10000,
            'description':
                'Radius in meters (default 200). Min 50m, max 10km.',
            'default': 200,
          },
        },
        'required': ['name', 'latitude', 'longitude'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final fenceName = (args['name'] as String?)?.trim() ?? '';
    if (fenceName.isEmpty) return ToolResult.error('name is required');

    final lat = args['latitude'];
    final lng = args['longitude'];
    if (lat == null || lng == null) {
      return ToolResult.error('latitude and longitude are required');
    }

    final latitude = (lat as num).toDouble();
    final longitude = (lng as num).toDouble();

    if (latitude < -90 || latitude > 90) {
      return ToolResult.error('latitude must be between -90 and 90');
    }
    if (longitude < -180 || longitude > 180) {
      return ToolResult.error('longitude must be between -180 and 180');
    }

    final radiusRaw = args['radius_meters'];
    final radius = radiusRaw != null ? (radiusRaw as num).toDouble() : 200.0;
    if (radius < 50 || radius > 10000) {
      return ToolResult.error('radius_meters must be between 50 and 10000');
    }

    final fence = Geofence(
      name: fenceName,
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radius,
    );

    final stored = await geofenceService.addFence(fence);

    return ToolResult.success(jsonEncode({
      'ok': true,
      'id': stored.id,
      'name': stored.name,
      'latitude': stored.latitude,
      'longitude': stored.longitude,
      'radius_meters': stored.radiusMeters,
      'message':
          'Geofence "${stored.name}" created at ${stored.latitude},${stored.longitude} '
              'with ${stored.radiusMeters.round()}m radius. '
              'Create an automation rule with event_type "geofence" and '
              'source_pattern "${stored.id}" to trigger tasks on enter/exit.',
    }));
  }
}

// ---------------------------------------------------------------------------
// geofence_list
// ---------------------------------------------------------------------------

class GeofenceListTool extends Tool {
  final GeofenceService geofenceService;

  GeofenceListTool({required this.geofenceService});

  @override
  String get name => 'geofence_list';

  @override
  String get description =>
      'List all geofences with their location, radius, state, and trigger history.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {},
        'required': [],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final fences = geofenceService.fences;

    final list = fences.map((f) {
      return {
        'id': f.id,
        'name': f.name,
        'latitude': f.latitude,
        'longitude': f.longitude,
        'radius_meters': f.radiusMeters,
        'enabled': f.enabled,
        'current_state': f.lastState.name,
        'trigger_count': f.triggerCount,
        'last_triggered': f.lastTriggeredAt?.toIso8601String(),
      };
    }).toList();

    return ToolResult.success(jsonEncode({
      'ok': true,
      'count': list.length,
      'monitoring': geofenceService.isRunning,
      'fences': list,
    }));
  }
}

// ---------------------------------------------------------------------------
// geofence_delete
// ---------------------------------------------------------------------------

class GeofenceDeleteTool extends Tool {
  final GeofenceService geofenceService;

  GeofenceDeleteTool({required this.geofenceService});

  @override
  String get name => 'geofence_delete';

  @override
  String get description =>
      'Delete a geofence by id. Use geofence_list to find the id first.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'id': {
            'type': 'string',
            'description': 'The id of the geofence to delete',
          },
        },
        'required': ['id'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final id = (args['id'] as String?)?.trim() ?? '';
    if (id.isEmpty) return ToolResult.error('id is required');

    final existing =
        geofenceService.fences.where((f) => f.id == id).firstOrNull;
    if (existing == null) {
      return ToolResult.error('No geofence found with id "$id"');
    }

    await geofenceService.removeFence(id);

    return ToolResult.success(jsonEncode({
      'ok': true,
      'deleted_id': id,
      'deleted_name': existing.name,
      'message': 'Geofence "${existing.name}" deleted.',
    }));
  }
}

// ---------------------------------------------------------------------------
// geofence_update
// ---------------------------------------------------------------------------

class GeofenceUpdateTool extends Tool {
  final GeofenceService geofenceService;

  GeofenceUpdateTool({required this.geofenceService});

  @override
  String get name => 'geofence_update';

  @override
  String get description =>
      'Enable, disable, rename, or resize an existing geofence. '
      'Use geofence_list to find the id first.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'id': {
            'type': 'string',
            'description': 'The id of the geofence to update',
          },
          'name': {
            'type': 'string',
            'description': 'New name for the geofence',
          },
          'enabled': {
            'type': 'boolean',
            'description': 'true to enable, false to disable',
          },
          'radius_meters': {
            'type': 'number',
            'minimum': 50,
            'maximum': 10000,
            'description': 'New radius in meters',
          },
        },
        'required': ['id'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final id = (args['id'] as String?)?.trim() ?? '';
    if (id.isEmpty) return ToolResult.error('id is required');

    final existing =
        geofenceService.fences.where((f) => f.id == id).firstOrNull;
    if (existing == null) {
      return ToolResult.error('No geofence found with id "$id"');
    }

    final newName = (args['name'] as String?)?.trim();
    final enabled = args['enabled'] as bool?;
    final radiusRaw = args['radius_meters'];
    final radius = radiusRaw != null ? (radiusRaw as num).toDouble() : null;

    if (radius != null && (radius < 50 || radius > 10000)) {
      return ToolResult.error('radius_meters must be between 50 and 10000');
    }

    if (newName == null && enabled == null && radius == null) {
      return ToolResult.error(
        'Provide at least one of: name, enabled, radius_meters',
      );
    }

    await geofenceService.updateFence(
      id,
      name: newName,
      enabled: enabled,
      radiusMeters: radius,
    );

    return ToolResult.success(jsonEncode({
      'ok': true,
      'id': id,
      'name': newName ?? existing.name,
      'enabled': enabled ?? existing.enabled,
      'message': 'Geofence "${newName ?? existing.name}" updated.',
    }));
  }
}
