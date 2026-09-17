import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_local_here/core/services/location_service.dart';
import 'package:turismo_local_here/domain/models/poi_model.dart';

void main() {
  group('LocationService Tests', () {
    test('calculateDistanceMeters calculates accurate distance using Haversine formula', () {
      // Distance between Puerta del Sol (40.4168, -3.7038) and Palacio Real (40.4180, -3.7142) ~ 890 meters
      final distance = LocationService.calculateDistanceMeters(
        40.4168, -3.7038,
        40.4180, -3.7142,
      );

      expect(distance, greaterThan(800));
      expect(distance, lessThan(1000));
    });

    test('checkNearbyPOI detects POIs within radius', () {
      const samplePoi = PlaceOfInterest(
        id: 'test_poi',
        name: 'Palacio Real',
        category: 'Monuments',
        description: 'Test description',
        latitude: 40.4180,
        longitude: -3.7142,
        rating: 4.8,
        reviewCount: 100,
        imageUrl: 'https://example.com/img.jpg',
        audioGuideMinutes: 30,
        regionId: 'region_madrid',
        address: 'Madrid',
        tags: ['History'],
      );

      // User location 100 meters away
      final nearby = LocationService.checkNearbyPOI(
        40.4181, -3.7140,
        [samplePoi],
        radiusMeters: 500,
      );

      expect(nearby, isNotNull);
      expect(nearby?.id, equals('test_poi'));
    });
  });
}
