/// Health / fitness tools for FlutterClaw agents.
///
/// Read health data from Apple HealthKit (iOS) and Google Health Connect (Android).
library;

import 'dart:convert';

import 'package:health/health.dart';
import 'registry.dart';

const _typeMap = <String, HealthDataType>{
  'steps': HealthDataType.STEPS,
  'heart_rate': HealthDataType.HEART_RATE,
  'calories': HealthDataType.ACTIVE_ENERGY_BURNED,
  'sleep_in_bed': HealthDataType.SLEEP_IN_BED,
  'sleep_asleep': HealthDataType.SLEEP_ASLEEP,
  'blood_oxygen': HealthDataType.BLOOD_OXYGEN,
  'weight': HealthDataType.WEIGHT,
};

/// Reads health and fitness data from HealthKit / Health Connect.
class GetHealthDataTool extends Tool {
  @override
  String get name => 'get_health_data';

  @override
  String get description =>
      'Read health and fitness data from Apple HealthKit (iOS) or '
      'Google Health Connect (Android). '
      'Supported types: steps, heart_rate, calories, sleep_in_bed, '
      'sleep_asleep, blood_oxygen, weight. '
      'Returns an array of data points with value, unit, and timestamp.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'types': {
            'type': 'array',
            'items': {
              'type': 'string',
              'enum': [
                'steps',
                'heart_rate',
                'calories',
                'sleep_in_bed',
                'sleep_asleep',
                'blood_oxygen',
                'weight',
              ],
            },
            'description': 'List of health data types to retrieve.',
          },
          'start_date': {
            'type': 'string',
            'description': 'Start of the period (ISO 8601), e.g. "2025-03-07".',
          },
          'end_date': {
            'type': 'string',
            'description': 'End of the period (ISO 8601), e.g. "2025-03-14".',
          },
        },
        'required': ['types', 'start_date', 'end_date'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final rawTypes = (args['types'] as List?)?.cast<String>() ?? [];
    final startStr = (args['start_date'] as String?)?.trim() ?? '';
    final endStr = (args['end_date'] as String?)?.trim() ?? '';

    if (rawTypes.isEmpty) return ToolResult.error('types must not be empty');
    if (startStr.isEmpty) return ToolResult.error('start_date is required');
    if (endStr.isEmpty) return ToolResult.error('end_date is required');

    final startDate = DateTime.tryParse(startStr);
    final endDate = DateTime.tryParse(endStr);
    if (startDate == null) return ToolResult.error('Invalid start_date format');
    if (endDate == null) return ToolResult.error('Invalid end_date format');

    final types = rawTypes
        .map((t) => _typeMap[t])
        .whereType<HealthDataType>()
        .toList();

    if (types.isEmpty) {
      return ToolResult.error(
        'No valid health types specified. '
        'Valid values: ${_typeMap.keys.join(', ')}',
      );
    }

    try {
      final health = Health();
      await health.configure();

      final authorized = await health.requestAuthorization(types);
      if (!authorized) {
        return ToolResult.error(
          'Health permission denied. '
          'Please grant health access in Settings.',
        );
      }

      final data = await health.getHealthDataFromTypes(
        types: types,
        startTime: startDate,
        endTime: endDate,
      );

      final deduplicated = health.removeDuplicates(data);

      final result = deduplicated.map((d) => {
            'type': d.type.name,
            'value': d.value.toString(),
            'unit': d.unit.name,
            'date_from': d.dateFrom.toIso8601String(),
            'date_to': d.dateTo.toIso8601String(),
            'source': d.sourceName,
          }).toList();

      if (result.isEmpty) {
        return ToolResult.success(
          'No health data found for the requested period and types.',
        );
      }
      return ToolResult.success(jsonEncode(result));
    } catch (e) {
      return ToolResult.error('Health data error: $e');
    }
  }
}
