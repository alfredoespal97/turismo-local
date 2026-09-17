import 'package:flutter_test/flutter_test.dart';
import 'package:turismo_local_here/data/repositories_impl/poi_repository_impl.dart';

void main() {
  group('POIRepositoryImpl Tests', () {
    late POIRepositoryImpl repository;

    setUp(() {
      repository = POIRepositoryImpl();
    });

    test('getPointsOfInterest returns list of tourist spots', () async {
      final pois = await repository.getPointsOfInterest();
      expect(pois, isNotEmpty);
      expect(pois.first.name, isNotEmpty);
    });

    test('searchPOIs filters correctly by query string', () async {
      final results = await repository.searchPOIs('Palacio');
      expect(results, isNotEmpty);
      expect(results.every((poi) => poi.name.contains('Palacio') || poi.description.contains('Palacio') || poi.tags.contains('Palacio')), isTrue);
    });

    test('searchPOIs filters correctly by category', () async {
      final results = await repository.searchPOIs('', category: 'Nature');
      expect(results, isNotEmpty);
      expect(results.every((poi) => poi.category == 'Nature'), isTrue);
    });
  });
}
