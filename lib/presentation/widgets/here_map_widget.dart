import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/models/poi_model.dart';
import '../../core/theme/app_theme.dart';

class HereMapWidget extends StatelessWidget {
  final List<PlaceOfInterest> pois;
  final PlaceOfInterest? selectedPoi;
  final Function(PlaceOfInterest) onSelectPoi;
  final bool isOfflineMode;
  final double userLat;
  final double userLng;

  const HereMapWidget({
    super.key,
    required this.pois,
    required this.selectedPoi,
    required this.onSelectPoi,
    required this.isOfflineMode,
    required this.userLat,
    required this.userLng,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxHorizontalRange = max(1.0, screenWidth - 120.0);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF0F172A),
      child: Stack(
        children: [
          // Styled Map Background Grid with vector aesthetic
          CustomPaint(
            size: Size.infinite,
            painter: MapGridPainter(isOffline: isOfflineMode),
          ),

          // User GPS Location Marker
          Center(
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppTheme.accentCyan.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.accentCyan, width: 2),
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppTheme.accentCyan,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          // Render POI Map Markers (HERE MapMarker simulation)
          ...pois.asMap().entries.map((entry) {
            final idx = entry.key;
            final poi = entry.value;
            final isSelected = selectedPoi?.id == poi.id;

            // Offset positioning for map visualization simulation
            final double leftOffset = 40.0 + (idx * 65.0) % maxHorizontalRange;
            final double topOffset = 180.0 + ((idx * 85.0) % 280.0);

            return Positioned(
              left: leftOffset,
              top: topOffset,
              child: GestureDetector(
                onTap: () => onSelectPoi(poi),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryTeal : AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.white : AppTheme.primaryTeal,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isSelected ? AppTheme.primaryTeal : Colors.black).withValues(alpha: 0.4),
                        blurRadius: isSelected ? 12 : 6,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(poi.category),
                        size: 16,
                        color: isSelected ? Colors.black : AppTheme.primaryTeal,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        poi.name.split(' ').first,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // HERE Watermark Badge (Official SDK integration requirement)
          Positioned(
            left: 16,
            bottom: 210,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, color: AppTheme.accentCyan, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'HERE SDK Vector Engine',
                    style: TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'monuments':
      case 'monumentos':
        return Icons.account_balance_rounded;
      case 'nature':
      case 'naturaleza':
        return Icons.park_rounded;
      case 'gastronomy':
      case 'gastronomía':
        return Icons.restaurant_rounded;
      case 'culture':
      case 'cultura':
        return Icons.museum_rounded;
      default:
        return Icons.place_rounded;
    }
  }
}

class MapGridPainter extends CustomPainter {
  final bool isOffline;

  MapGridPainter({required this.isOffline});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isOffline ? const Color(0xFF1E293B).withValues(alpha: 0.5) : const Color(0xFF334155).withValues(alpha: 0.3)
      ..strokeWidth = 1.0;

    const double step = 45.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant MapGridPainter oldDelegate) => oldDelegate.isOffline != isOffline;
}
