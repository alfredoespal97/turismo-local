enum OfflineDownloadStatus {
  notDownloaded,
  downloading,
  downloaded,
  failed,
}

class OfflineRegion {
  final String id;
  final String name;
  final String country;
  final double sizeMb;
  final int poiCount;
  final OfflineDownloadStatus status;
  final double downloadProgress; // 0.0 to 1.0

  const OfflineRegion({
    required this.id,
    required this.name,
    required this.country,
    required this.sizeMb,
    required this.poiCount,
    this.status = OfflineDownloadStatus.notDownloaded,
    this.downloadProgress = 0.0,
  });

  OfflineRegion copyWith({
    String? id,
    String? name,
    String? country,
    double? sizeMb,
    int? poiCount,
    OfflineDownloadStatus? status,
    double? downloadProgress,
  }) {
    return OfflineRegion(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      sizeMb: sizeMb ?? this.sizeMb,
      poiCount: poiCount ?? this.poiCount,
      status: status ?? this.status,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }
}
