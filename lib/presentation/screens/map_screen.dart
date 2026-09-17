import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/here_map_widget.dart';
import '../widgets/poi_card.dart';
import '../widgets/category_chips.dart';
import '../widgets/proximity_banner.dart';
import 'poi_detail_screen.dart';
import 'offline_maps_screen.dart';
import 'settings_screen.dart';
import '../../core/theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Todos',
    'Monuments',
    'Gastronomy',
    'Nature',
    'Culture',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final provider = context.read<AppProvider>();
      provider.loadPOIs();
      provider.initLocationTracking(); // Request GPS permission + start stream
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // 1. Vector HERE Map Widget
          HereMapWidget(
            pois: appProvider.pois,
            selectedPoi: appProvider.selectedPoi,
            onSelectPoi: (poi) {
              appProvider.selectPOI(poi);
            },
            onDeselectPoi: () {
              appProvider.selectPOI(null);
            },
            onOpenPoiDetail: () {
              if (appProvider.selectedPoi != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        POIDetailScreen(poi: appProvider.selectedPoi!),
                  ),
                );
              }
            },
            onRequestLocation: () {
              appProvider.initLocationTracking();
            },
            isOfflineMode: appProvider.isOfflineMode,
            userLat: appProvider.userLat,
            userLng: appProvider.userLng,
            hasRealLocation: appProvider.hasRealLocation,
          ),

          // 2. Top Header Overlay (Search Bar & Offline Toggle & Navigation Actions)
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // Search Bar Card
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.cardDark.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppTheme.cardGlassBorder),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => appProvider.setSearchQuery(val),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Buscar monumentos, parques...',
                              hintStyle: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: AppTheme.primaryTeal,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Offline Maps Button
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: appProvider.isOfflineMode
                              ? AppTheme.primaryTeal
                              : AppTheme.cardDark,
                          foregroundColor: appProvider.isOfflineMode
                              ? Colors.black
                              : AppTheme.accentCyan,
                        ),
                        icon: const Icon(Icons.download_for_offline_rounded),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OfflineMapsScreen(),
                            ),
                          );
                        },
                      ),

                      // Settings Button
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.cardDark,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.settings_rounded),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Category Chips Selector
                CategoryChips(
                  categories: _categories,
                  selectedCategory: appProvider.selectedCategory,
                  onSelectCategory: (cat) => appProvider.setCategory(cat),
                ),

                // Proximity Alert Banner
                if (appProvider.nearbyAlertPoi != null)
                  ProximityBanner(
                    poi: appProvider.nearbyAlertPoi!,
                    onTap: () {
                      final poi = appProvider.nearbyAlertPoi!;
                      appProvider.dismissProximityAlert();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => POIDetailScreen(poi: poi),
                        ),
                      );
                    },
                    onDismiss: () => appProvider.dismissProximityAlert(),
                  ),
              ],
            ),
          ),

          // 3. Location Permission Denied Banner
          if (appProvider.locationPermissionDenied)
            Positioned(
              left: 16,
              right: 16,
              bottom: 160,
              child: GestureDetector(
                onTap: () => Geolocator.openAppSettings(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.location_off_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Ubicación desactivada. Toca aquí para activarla en Ajustes.',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 18),
                    ],
                  ),
                ),
              ),
            ),

          // 4. Bottom Carousel of Points of Interest
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: SizedBox(
              height: 120,
              child: appProvider.pois.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'No se encontraron lugares con esos criterios.',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: appProvider.pois.length,
                      itemBuilder: (context, index) {
                        final poi = appProvider.pois[index];
                        final isSelected =
                            appProvider.selectedPoi?.id == poi.id;

                        return POICard(
                          poi: poi,
                          isSelected: isSelected,
                          onTap: () {
                            appProvider.selectPOI(poi);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => POIDetailScreen(poi: poi),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
