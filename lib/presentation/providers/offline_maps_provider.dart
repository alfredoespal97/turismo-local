import 'package:flutter/material.dart';
import '../../domain/models/offline_region_model.dart';
import '../../domain/repositories/offline_repository.dart';

class OfflineMapsProvider extends ChangeNotifier {
  final IOfflineRepository _offlineRepository;

  OfflineMapsProvider(this._offlineRepository);

  List<OfflineRegion> _regions = [];
  bool _isLoading = false;

  List<OfflineRegion> get regions => _regions;
  bool get isLoading => _isLoading;

  Future<void> loadRegions() async {
    _isLoading = true;
    notifyListeners();
    _regions = await _offlineRepository.getAvailableRegions();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> downloadRegion(String regionId) async {
    final index = _regions.indexWhere((r) => r.id == regionId);
    if (index == -1) return;

    _regions[index] = _regions[index].copyWith(
      status: OfflineDownloadStatus.downloading,
      downloadProgress: 0.0,
    );
    notifyListeners();

    await _offlineRepository.downloadRegion(regionId, (progress) {
      _regions[index] = _regions[index].copyWith(
        downloadProgress: progress,
      );
      notifyListeners();
    });

    _regions[index] = _regions[index].copyWith(
      status: OfflineDownloadStatus.downloaded,
      downloadProgress: 1.0,
    );
    notifyListeners();
  }

  Future<void> deleteRegion(String regionId) async {
    final index = _regions.indexWhere((r) => r.id == regionId);
    if (index == -1) return;

    await _offlineRepository.deleteRegion(regionId);
    _regions[index] = _regions[index].copyWith(
      status: OfflineDownloadStatus.notDownloaded,
      downloadProgress: 0.0,
    );
    notifyListeners();
  }
}
