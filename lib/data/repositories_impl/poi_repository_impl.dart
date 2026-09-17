import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/poi_model.dart';
import '../../domain/repositories/poi_repository.dart';

class POIRepositoryImpl implements IPOIRepository {
  List<PlaceOfInterest>? _cachedPois;

  @override
  Future<List<PlaceOfInterest>> getPointsOfInterest() async {
    if (_cachedPois != null) return _cachedPois!;
    try {
      final String jsonString = await rootBundle.loadString('assets/data/pois.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _cachedPois = jsonList.map((e) => PlaceOfInterest.fromJson(e)).toList();
      return _cachedPois!;
    } catch (e) {
      // Fallback mock data if asset loading fails in isolated testing environments
      _cachedPois = _getFallbackPois();
      return _cachedPois!;
    }
  }

  @override
  Future<List<PlaceOfInterest>> searchPOIs(String query, {String? category}) async {
    final all = await getPointsOfInterest();
    return all.where((poi) {
      final matchesQuery = query.isEmpty ||
          poi.name.toLowerCase().contains(query.toLowerCase()) ||
          poi.description.toLowerCase().contains(query.toLowerCase()) ||
          poi.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));

      final matchesCategory = category == null ||
          category.isEmpty ||
          category.toLowerCase() == 'todos' ||
          category.toLowerCase() == 'all' ||
          poi.category.toLowerCase() == category.toLowerCase();

      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Future<PlaceOfInterest?> getPOIById(String id) async {
    final all = await getPointsOfInterest();
    try {
      return all.firstWhere((poi) => poi.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<PlaceOfInterest>> getPOIsByRegion(String regionId) async {
    final all = await getPointsOfInterest();
    return all.where((poi) => poi.regionId == regionId).toList();
  }

  List<PlaceOfInterest> _getFallbackPois() {
    return const [
      PlaceOfInterest(
        id: 'poi_01',
        name: 'Palacio Real y Jardines del Sabatini',
        category: 'Monuments',
        description: 'Residencia oficial de la monarquía española construida en el siglo XVIII con jardines neoclásicos.',
        latitude: 40.4180,
        longitude: -3.7142,
        rating: 4.8,
        reviewCount: 1250,
        imageUrl: 'https://images.unsplash.com/photo-1543783207-ec64e4d95325?auto=format&fit=crop&w=800&q=80',
        audioGuideMinutes: 45,
        regionId: 'region_madrid',
        address: 'Calle de Bailén, Madrid',
        tags: ['Historia', 'Palacio'],
      ),
      PlaceOfInterest(
        id: 'poi_02',
        name: 'Parque del Retiro',
        category: 'Nature',
        description: 'Pulmón verde histórico y Patrimonio de la Humanidad UNESCO.',
        latitude: 40.4153,
        longitude: -3.6844,
        rating: 4.9,
        reviewCount: 3420,
        imageUrl: 'https://images.unsplash.com/photo-1578637387939-43c525550085?auto=format&fit=crop&w=800&q=80',
        audioGuideMinutes: 30,
        regionId: 'region_madrid',
        address: 'Plaza de la Independencia, Madrid',
        tags: ['Naturaleza', 'UNESCO'],
      ),
    ];
  }
}
