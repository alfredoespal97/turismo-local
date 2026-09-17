import 'dart:math';
import '../../domain/models/poi_model.dart';

class LocationService {
  /// Calculates distance in meters between two geographical points using Haversine formula
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

  /// Checks if user location triggers a proximity alert for any POI within radiusMeters (e.g. 500m)
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
