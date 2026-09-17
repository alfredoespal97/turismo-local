import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/offline_region_model.dart';
import '../providers/offline_maps_provider.dart';
import '../../core/theme/app_theme.dart';

class OfflineMapsScreen extends StatefulWidget {
  const OfflineMapsScreen({super.key});

  @override
  State<OfflineMapsScreen> createState() => _OfflineMapsScreenState();
}

class _OfflineMapsScreenState extends State<OfflineMapsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OfflineMapsProvider>().loadRegions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final offlineProvider = context.watch<OfflineMapsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mapas y Datos Offline',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.darkBackground,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.cardDark,
                    AppTheme.cardDark.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardGlassBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.wifi_off_rounded, color: AppTheme.primaryTeal, size: 32),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descarga de Paquetes HERE SDK',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Guarda mapas vectoriales y rutas completas para navegar sin cobertura móvil.',
                          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Regiones Disponibles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: offlineProvider.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal))
                  : ListView.builder(
                      itemCount: offlineProvider.regions.length,
                      itemBuilder: (context, index) {
                        final region = offlineProvider.regions[index];
                        final isDownloaded = region.status == OfflineDownloadStatus.downloaded;
                        final isDownloading = region.status == OfflineDownloadStatus.downloading;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.cardDark,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDownloaded ? AppTheme.primaryTeal : AppTheme.cardGlassBorder,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          region.name,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${region.country} • ${region.sizeMb} MB • ${region.poiCount} POIs',
                                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isDownloaded)
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                      onPressed: () => offlineProvider.deleteRegion(region.id),
                                    )
                                  else if (isDownloading)
                                    const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppTheme.accentCyan,
                                      ),
                                    )
                                  else
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryTeal,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      icon: const Icon(Icons.download_rounded, size: 16),
                                      label: const Text('Descargar', style: TextStyle(fontWeight: FontWeight.bold)),
                                      onPressed: () => offlineProvider.downloadRegion(region.id),
                                    ),
                                ],
                              ),
                              if (isDownloading) ...[
                                const SizedBox(height: 12),
                                LinearProgressIndicator(
                                  value: region.downloadProgress,
                                  backgroundColor: Colors.white12,
                                  color: AppTheme.accentCyan,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Descargando datos vectoriales de HERE: ${(region.downloadProgress * 100).toInt()}%',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.accentCyan),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
