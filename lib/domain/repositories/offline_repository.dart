import '../models/offline_region_model.dart';

abstract class IOfflineRepository {
  Future<List<OfflineRegion>> getAvailableRegions();
  Future<void> downloadRegion(String regionId, Function(double progress) onProgress);
  Future<void> deleteRegion(String regionId);
  Future<bool> isRegionDownloaded(String regionId);
}
