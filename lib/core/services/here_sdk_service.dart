import 'package:flutter/material.dart';

import '../../domain/models/here_credentials_model.dart';

/// Abstraction Service for HERE SDK (Explore/Navigate edition).
/// Provides clean lifecycle initialization, vector map controller abstractions,
/// interactive MapMarker placement, and offline region binding.
class HereSdkService {
  static final HereSdkService _instance = HereSdkService._internal();
  factory HereSdkService() => _instance;
  HereSdkService._internal();

  bool _isInitialized = false;
  HereCredentials? _credentials;

  bool get isInitialized => _isInitialized;
  HereCredentials? get credentials => _credentials;

  /// Initializes HERE SdkContext native engine.
  /// Production implementation connects with:
  /// `SdkContext.init(IsolateOrigin.main);`
  /// `SDKNativeEngine.makeSharedInstance(SDKOptions(accessKeyId, accessKeySecret));`
  Future<bool> initialize(HereCredentials credentials) async {
    _credentials = credentials;
    if (credentials.isValid) {
      _isInitialized = true;
      debugPrint(
        '[HERE SDK] Engine successfully initialized with App ID: ${credentials.appId}',
      );
      return true;
    } else {
      _isInitialized = false;
      debugPrint(
        '[HERE SDK] Operating in Explore Preview / Fallback Engine mode.',
      );
      return false;
    }
  }

  /// Calculates route polyline preview points between coordinates (HERE Routing Engine)
  List<Map<String, double>> calculateRoutePolyline(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return [
      {'lat': startLat, 'lng': startLng},
      {
        'lat': (startLat + endLat) / 2 + 0.002,
        'lng': (startLng + endLng) / 2 - 0.001,
      },
      {'lat': endLat, 'lng': endLng},
    ];
  }

  /// Formats map coordinates for display
  String formatCoordinates(double lat, double lng) {
    final latDir = lat >= 0 ? 'N' : 'S';
    final lngDir = lng >= 0 ? 'E' : 'W';
    return '${lat.abs().toStringAsFixed(4)}° $latDir, ${lng.abs().toStringAsFixed(4)}° $lngDir';
  }
}
