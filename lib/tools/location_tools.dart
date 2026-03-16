/// Location tools for FlutterClaw agents.
///
/// Get the device's current GPS coordinates via geolocator.
library;

import 'package:geolocator/geolocator.dart';
import 'registry.dart';

/// Returns the device's current GPS location.
class GetLocationTool extends Tool {
  @override
  String get name => 'get_location';

  @override
  String get description =>
      'Get the device\'s current GPS location. '
      'Returns latitude, longitude, accuracy, altitude, speed, and a timestamp. '
      'Requires location permission (will prompt the user if not yet granted).';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'accuracy': {
            'type': 'string',
            'enum': ['low', 'medium', 'high'],
            'description':
                'Desired accuracy level. "high" uses GPS (more battery); '
                '"low" uses network/cell (faster, less accurate). Default: medium.',
          },
        },
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final accuracyStr = (args['accuracy'] as String?) ?? 'medium';

    final accuracy = switch (accuracyStr) {
      'low' => LocationAccuracy.low,
      'high' => LocationAccuracy.high,
      _ => LocationAccuracy.medium,
    };

    try {
      // Check if location services are enabled.
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return ToolResult.error(
          'Location services are disabled. '
          'Please enable Location in device Settings.',
        );
      }

      // Check / request permission.
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return ToolResult.error(
          'Location permission denied. '
          'Please grant location access in Settings.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: const Duration(seconds: 15),
        ),
      );

      return ToolResult.success(
        '{"lat":${position.latitude},'
        '"lng":${position.longitude},'
        '"accuracy_meters":${position.accuracy.toStringAsFixed(1)},'
        '"altitude_meters":${position.altitude.toStringAsFixed(1)},'
        '"speed_mps":${position.speed.toStringAsFixed(2)},'
        '"heading_degrees":${position.heading.toStringAsFixed(1)},'
        '"timestamp":"${position.timestamp.toIso8601String()}"}',
      );
    } catch (e) {
      return ToolResult.error('Location error: $e');
    }
  }
}
