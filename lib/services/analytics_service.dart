import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsProvider = Provider<FirebaseAnalytics>((ref) {
  return FirebaseAnalytics.instance;
});

class AnalyticsService {
  AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) {
    return _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  Future<void> logTap({
    required String name,
    Map<String, Object>? parameters,
  }) {
    return _analytics.logEvent(
      name: 'tap_$name',
      parameters: parameters,
    );
  }

  Future<void> logAction({
    required String name,
    Map<String, Object>? parameters,
  }) {
    return _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final analytics = ref.watch(analyticsProvider);
  return AnalyticsService(analytics);
});

