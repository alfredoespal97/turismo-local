import 'package:flutter/material.dart';
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
      context.read<AppProvider>().loadPOIs();
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
            isOfflineMode: appProvider.isOfflineMode,
            userLat: appProvider.userLat,
            userLng: appProvider.userLng,
          ),

          // 2. Top Header Overlay (Search Bar & Offline Toggle & Navigation Actions)
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Search Bar Card
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.cardDark.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppTheme.cardGlassBorder),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => appProvider.setSearchQuery(val),
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Buscar monumentos, parques...',
                              hintStyle: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                              prefixIcon: Icon(Icons.search_rounded, color: AppTheme.primaryTeal),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Offline Maps Button
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: appProvider.isOfflineMode ? AppTheme.primaryTeal : AppTheme.cardDark,
                          foregroundColor: appProvider.isOfflineMode ? Colors.black : AppTheme.accentCyan,
                        ),
                        icon: const Icon(Icons.download_for_offline_rounded),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const OfflineMapsScreen()),
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
                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
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
                        MaterialPageRoute(builder: (_) => POIDetailScreen(poi: poi)),
                      );
                    },
                    onDismiss: () => appProvider.dismissProximityAlert(),
                  ),
              ],
            ),
          ),

          // 3. Bottom Carousel of Points of Interest
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: SizedBox(
              height: 120,
              child: appProvider.pois.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'No se encontraron lugares con esos criterios.',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: appProvider.pois.length,
                      itemBuilder: (context, index) {
                        final poi = appProvider.pois[index];
                        final isSelected = appProvider.selectedPoi?.id == poi.id;

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
