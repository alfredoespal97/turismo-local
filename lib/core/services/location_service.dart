import 'dart:math';
import 'package:geolocator/geolocator.dart';
import '../../domain/models/poi_model.dart';

class LocationService {
  /// Requests location permissions and returns the current GPS position.
  /// Returns null if permissions are denied or GPS is unavailable.
  static Future<Position?> requestAndGetCurrentLocation() async {
    // 1. Check if location services are enabled on device
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled — nothing we can do from here
      return null;
    }

    // 2. Check / request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null; // User denied permission
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions permanently denied — user must go to Settings
      return null;
    }

    // 3. Get current GPS position
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  /// Starts a continuous stream of location updates.
  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20, // Update every 20 metres
      ),
    );
  }

  /// Calculates distance in meters between two geographical points using Haversine formula.
  static double calculateDistanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c * 1000.0; // Return in meters
  }

  static double _toRadians(double degree) {
    return degree * pi / 180.0;
  }

  /// Checks if user location triggers a proximity alert for any POI within radiusMeters.
  static PlaceOfInterest? checkNearbyPOI(
    double userLat,
    double userLng,
    List<PlaceOfInterest> pois, {
    double radiusMeters = 500.0,
  }) {
    for (var poi in pois) {
      final dist = calculateDistanceMeters(userLat, userLng, poi.latitude, poi.longitude);
      if (dist <= radiusMeters) {
        return poi;
      }
    }
    return null;
  }
}
