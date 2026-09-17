import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/offline_region_model.dart';
import '../../domain/repositories/offline_repository.dart';

class OfflineRepositoryImpl implements IOfflineRepository {
  final Map<String, OfflineRegion> _regions = {
    'region_madrid': const OfflineRegion(
      id: 'region_madrid',
      name: 'Madrid Histórico & Centro',
      country: 'España',
      sizeMb: 145.5,
      poiCount: 4,
    ),
    'region_barcelona': const OfflineRegion(
      id: 'region_barcelona',
      name: 'Barcelona Modernismo & Costa',
      country: 'España',
      sizeMb: 210.0,
      poiCount: 1,
    ),
    'region_andalucia': const OfflineRegion(
      id: 'region_andalucia',
      name: 'Granada & Alhambra Cultural',
      country: 'España',
      sizeMb: 180.2,
      poiCount: 1,
    ),
    'region_zaragoza': const OfflineRegion(
      id: 'region_zaragoza',
      name: 'Zaragoza Basílica del Pilar & Ebro',
      country: 'España',
      sizeMb: 165.4,
      poiCount: 2,
    ),
    'region_sevilla': const OfflineRegion(
      id: 'region_sevilla',
      name: 'Sevilla Giralda & Santa Cruz',
      country: 'España',
      sizeMb: 195.8,
      poiCount: 2,
    ),
    'region_valencia': const OfflineRegion(
      id: 'region_valencia',
      name: 'Valencia Ciudad de las Artes & Turia',
      country: 'España',
      sizeMb: 178.0,
      poiCount: 2,
    ),
  };

  @override
  Future<List<OfflineRegion>> getAvailableRegions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<OfflineRegion> result = [];

    for (var entry in _regions.entries) {
      final isDownloaded = prefs.getBool('offline_region_${entry.key}') ?? false;
      result.add(entry.value.copyWith(
        status: isDownloaded ? OfflineDownloadStatus.downloaded : entry.value.status,
        downloadProgress: isDownloaded ? 1.0 : entry.value.downloadProgress,
      ));
    }
    return result;
  }

  @override
  Future<void> downloadRegion(String regionId, Function(double progress) onProgress) async {
    final prefs = await SharedPreferences.getInstance();
    double current = 0.0;
    
    // Simulate real HERE SDK region download package progress
    while (current < 1.0) {
      await Future.delayed(const Duration(milliseconds: 200));
      current += 0.15;
      if (current > 1.0) current = 1.0;
      onProgress(current);
    }

    await prefs.setBool('offline_region_$regionId', true);
  }

  @override
  Future<void> deleteRegion(String regionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('offline_region_$regionId', false);
  }

  @override
  Future<bool> isRegionDownloaded(String regionId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('offline_region_$regionId') ?? false;
  }
}
