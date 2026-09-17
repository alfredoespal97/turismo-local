import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/models/poi_model.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/location_service.dart';
import '../../core/services/navigation_service.dart';

// ─── Map Base Layers ─────────────────────────────────────────────────────────

enum BaseMapLayer {
  dark,
  standard,
  topo,
  satellite,
}

extension BaseMapLayerExt on BaseMapLayer {
  String get label {
    switch (this) {
      case BaseMapLayer.dark:      return 'Oscuro';
      case BaseMapLayer.standard:  return 'Estándar';
      case BaseMapLayer.topo:      return 'Relieve';
      case BaseMapLayer.satellite: return 'Satélite';
    }
  }

  IconData get icon {
    switch (this) {
      case BaseMapLayer.dark:      return Icons.dark_mode_rounded;
      case BaseMapLayer.standard:  return Icons.map_rounded;
      case BaseMapLayer.topo:      return Icons.terrain_rounded;
      case BaseMapLayer.satellite: return Icons.satellite_alt_rounded;
    }
  }

  String get urlTemplate {
    switch (this) {
      case BaseMapLayer.dark:
        return 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
      case BaseMapLayer.standard:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case BaseMapLayer.topo:
        return 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png';
      case BaseMapLayer.satellite:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
    }
  }

  List<String> get subdomains {
    switch (this) {
      case BaseMapLayer.dark:
      case BaseMapLayer.topo:
        return ['a', 'b', 'c'];
      default:
        return const [];
    }
  }
}

// ─── Overlays (Multi-selectable) ──────────────────────────────────────────────

enum MapOverlay {
  cycling,
  hiking,
  pois,
  navigationRoute,
}

extension MapOverlayExt on MapOverlay {
  String get label {
    switch (this) {
      case MapOverlay.cycling:         return 'Rutas Ciclistas';
      case MapOverlay.hiking:          return 'Rutas Senderismo';
      case MapOverlay.pois:            return 'Puntos de Interés';
      case MapOverlay.navigationRoute: return 'Ruta de Navegación';
    }
  }

  IconData get icon {
    switch (this) {
      case MapOverlay.cycling:         return Icons.directions_bike_rounded;
      case MapOverlay.hiking:          return Icons.hiking_rounded;
      case MapOverlay.pois:            return Icons.place_rounded;
      case MapOverlay.navigationRoute: return Icons.alt_route_rounded;
    }
  }
}

// ─── HereMapWidget ────────────────────────────────────────────────────────────

class HereMapWidget extends StatefulWidget {
  final List<PlaceOfInterest> pois;
  final PlaceOfInterest? selectedPoi;
  final Function(PlaceOfInterest) onSelectPoi;
  final VoidCallback? onDeselectPoi;
  final VoidCallback? onOpenPoiDetail;
  final VoidCallback? onRequestLocation;
  final bool isOfflineMode;
  final double userLat;
  final double userLng;
  final bool hasRealLocation;

  const HereMapWidget({
    super.key,
    required this.pois,
    required this.selectedPoi,
    required this.onSelectPoi,
    this.onDeselectPoi,
    this.onOpenPoiDetail,
    this.onRequestLocation,
    required this.isOfflineMode,
    required this.userLat,
    required this.userLng,
    this.hasRealLocation = false,
  });

  @override
  State<HereMapWidget> createState() => _HereMapWidgetState();
}

class _HereMapWidgetState extends State<HereMapWidget> {
  late final MapController _mapController;

  // Layer State: 1 Base Layer + Set of active overlays (Multiple layers supported!)
  BaseMapLayer _baseLayer = BaseMapLayer.dark;
  final Set<MapOverlay> _activeOverlays = {
    MapOverlay.pois,
    MapOverlay.navigationRoute,
  };

  bool _layerPanelOpen = false;
  bool _hasInitialCentered = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.hasRealLocation) {
      _hasInitialCentered = true;
    }
  }

  @override
  void didUpdateWidget(HereMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Auto-center as soon as real GPS position is received
    if (widget.hasRealLocation && !_hasInitialCentered) {
      _hasInitialCentered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(widget.userLat, widget.userLng),
          15.0,
        );
      });
    }

    // Center on POI when user selects one
    if (widget.selectedPoi != null &&
        widget.selectedPoi?.id != oldWidget.selectedPoi?.id) {
      _mapController.move(
        LatLng(widget.selectedPoi!.latitude, widget.selectedPoi!.longitude),
        15.5,
      );
    }
  }

  void _centerOnUser() {
    if (widget.hasRealLocation) {
      _mapController.move(
        LatLng(widget.userLat, widget.userLng),
        15.5,
      );
    } else {
      widget.onRequestLocation?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Obteniendo tu ubicación GPS actual...'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleOverlay(MapOverlay overlay) {
    setState(() {
      if (_activeOverlays.contains(overlay)) {
        _activeOverlays.remove(overlay);
      } else {
        _activeOverlays.add(overlay);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = LatLng(widget.userLat, widget.userLng);
    final selectedPoi = widget.selectedPoi;

    // Calculate distance and route points if POI is selected
    double? distanceMeters;
    List<LatLng> routePoints = [];
    if (selectedPoi != null) {
      distanceMeters = LocationService.calculateDistanceMeters(
        widget.userLat,
        widget.userLng,
        selectedPoi.latitude,
        selectedPoi.longitude,
      );
      routePoints = [
        userLocation,
        LatLng(selectedPoi.latitude, selectedPoi.longitude),
      ];
    }

    return Stack(
      children: [
        // ── Main Map Canvas ───────────────────────────────────────────────
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: userLocation,
            initialZoom: widget.hasRealLocation ? 15.0 : 13.0,
            minZoom: 3,
            maxZoom: 18,
            backgroundColor: const Color(0xFF0F172A),
            onTap: (tapPosition, point) {
              if (_layerPanelOpen) {
                setState(() => _layerPanelOpen = false);
              }
            },
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            // 1. Base Tile Layer
            TileLayer(
              key: ValueKey(_baseLayer),
              urlTemplate: _baseLayer.urlTemplate,
              subdomains: _baseLayer.subdomains,
              userAgentPackageName: 'com.turismo.local',
              maxNativeZoom: 19,
            ),

            // 2. Multi-layer Overlay 1: Cycling Routes (Transparent overlay)
            if (_activeOverlays.contains(MapOverlay.cycling))
              TileLayer(
                key: const ValueKey('layer_cycling'),
                urlTemplate:
                    'https://tile.waymarkedtrails.org/cycling/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.turismo.local',
                maxNativeZoom: 18,
              ),

            // 3. Multi-layer Overlay 2: Hiking Trails (Transparent overlay)
            if (_activeOverlays.contains(MapOverlay.hiking))
              TileLayer(
                key: const ValueKey('layer_hiking'),
                urlTemplate:
                    'https://tile.waymarkedtrails.org/hiking/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.turismo.local',
                maxNativeZoom: 18,
              ),

            // 4. Navigation Route Polyline Layer (from user to selected POI)
            if (_activeOverlays.contains(MapOverlay.navigationRoute) &&
                selectedPoi != null &&
                routePoints.length >= 2)
              PolylineLayer(
                polylines: [
                  // Outer halo
                  Polyline(
                    points: routePoints,
                    strokeWidth: 7.0,
                    color: AppTheme.accentCyan.withValues(alpha: 0.4),
                  ),
                  // Inner solid line
                  Polyline(
                    points: routePoints,
                    strokeWidth: 4.0,
                    color: AppTheme.primaryTeal,
                  ),
                ],
              ),

            // 5. User Real-Time Location Marker
            MarkerLayer(
              markers: [
                Marker(
                  point: userLocation,
                  width: 34,
                  height: 34,
                  child: _UserLocationDot(
                    hasRealLocation: widget.hasRealLocation,
                  ),
                ),
              ],
            ),

            // 6. POIs Markers Layer (can be toggled in multi-layer selector)
            if (_activeOverlays.contains(MapOverlay.pois))
              MarkerLayer(
                markers: widget.pois.map((poi) {
                  final isSelected = widget.selectedPoi?.id == poi.id;
                  return Marker(
                    point: LatLng(poi.latitude, poi.longitude),
                    width: isSelected ? 170 : 138,
                    height: 42,
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () => widget.onSelectPoi(poi),
                      child: _PoiMarkerBubble(
                        poi: poi,
                        isSelected: isSelected,
                      ),
                    ),
                  );
                }).toList(),
              ),

            // 7. OSM & CartoDB attribution
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  '© OpenStreetMap, CARTO, Esri',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),

        // ── Floating Navigation Banner when a POI is selected ─────────────
        if (selectedPoi != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 156,
            child: _NavigationBanner(
              poi: selectedPoi,
              distanceMeters: distanceMeters,
              hasRealLocation: widget.hasRealLocation,
              onStartNavigation: () {
                NavigationService.openNavigation(
                  latitude: selectedPoi.latitude,
                  longitude: selectedPoi.longitude,
                  label: selectedPoi.name,
                );
              },
              onOpenDetails: widget.onOpenPoiDetail,
              onClose: widget.onDeselectPoi,
            ),
          ),

        // ── Multi-Layer Selection Panel ───────────────────────────────────
        if (_layerPanelOpen)
          Positioned(
            right: 16,
            bottom: selectedPoi != null ? 260 : 160,
            child: _MultiLayerPanel(
              selectedBase: _baseLayer,
              activeOverlays: _activeOverlays,
              onSelectBase: (base) => setState(() => _baseLayer = base),
              onToggleOverlay: _toggleOverlay,
              onClose: () => setState(() => _layerPanelOpen = false),
            ),
          ),

        // ── Map Control Buttons (FAB column) ──────────────────────────────
        Positioned(
          right: 16,
          bottom: selectedPoi != null ? 206 : 148,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Capas del Mapa FAB (muestra indicador si hay varias capas activas)
              _MapFab(
                icon: Icons.layers_rounded,
                tooltip: 'Capas del mapa (Selección múltiple)',
                active: _layerPanelOpen,
                badgeCount: _activeOverlays.length + 1,
                onTap: () => setState(() => _layerPanelOpen = !_layerPanelOpen),
              ),
              const SizedBox(height: 10),

              // 2. Centrar en mi ubicación GPS
              _MapFab(
                icon: widget.hasRealLocation
                    ? Icons.my_location_rounded
                    : Icons.location_searching_rounded,
                tooltip: 'Centrar en mi ubicación actual',
                active: widget.hasRealLocation,
                onTap: _centerOnUser,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Multi-Layer Panel (Supports selecting base + multiple overlays) ─────────

class _MultiLayerPanel extends StatelessWidget {
  final BaseMapLayer selectedBase;
  final Set<MapOverlay> activeOverlays;
  final ValueChanged<BaseMapLayer> onSelectBase;
  final ValueChanged<MapOverlay> onToggleOverlay;
  final VoidCallback onClose;

  const _MultiLayerPanel({
    required this.selectedBase,
    required this.activeOverlays,
    required this.onSelectBase,
    required this.onToggleOverlay,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardGlassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.layers_rounded, color: AppTheme.primaryTeal, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Capas del Mapa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close_rounded, color: Colors.white60, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Base map selector
          const Text(
            'ESTILO BASE',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: BaseMapLayer.values.map((base) {
              final isSelected = base == selectedBase;
              return ChoiceChip(
                showCheckmark: false,
                avatar: Icon(
                  base.icon,
                  size: 14,
                  color: isSelected ? Colors.black : Colors.white70,
                ),
                label: Text(base.label),
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.white,
                ),
                selected: isSelected,
                selectedColor: AppTheme.primaryTeal,
                backgroundColor: const Color(0xFF1E293B),
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryTeal : Colors.white24,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                onSelected: (_) => onSelectBase(base),
              );
            }).toList(),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: Colors.white12, height: 1),
          ),

          // Overlays (Multi-select)
          const Text(
            'SUPERPONER CAPAS (ACTIVAR VARIAS)',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          ...MapOverlay.values.map((overlay) {
            final isActive = activeOverlays.contains(overlay);
            return GestureDetector(
              onTap: () => onToggleOverlay(overlay),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.primaryTeal.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      overlay.icon,
                      size: 15,
                      color: isActive ? AppTheme.accentCyan : Colors.white60,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        overlay.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive ? Colors.white : Colors.white70,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                    Switch(
                      value: isActive,
                      activeThumbColor: AppTheme.primaryTeal,
                      activeTrackColor: AppTheme.primaryTeal.withValues(alpha: 0.35),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (_) => onToggleOverlay(overlay),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Floating Navigation Banner ───────────────────────────────────────────────

class _NavigationBanner extends StatelessWidget {
  final PlaceOfInterest poi;
  final double? distanceMeters;
  final bool hasRealLocation;
  final VoidCallback onStartNavigation;
  final VoidCallback? onOpenDetails;
  final VoidCallback? onClose;

  const _NavigationBanner({
    required this.poi,
    required this.distanceMeters,
    required this.hasRealLocation,
    required this.onStartNavigation,
    this.onOpenDetails,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    String distanceText = 'Calculando...';
    String etaText = '';

    if (distanceMeters != null) {
      if (distanceMeters! < 1000) {
        distanceText = '${distanceMeters!.round()} m';
      } else {
        distanceText = '${(distanceMeters! / 1000).toStringAsFixed(1)} km';
      }

      // Walking estimate (~5 km/h) & Car estimate (~30 km/h)
      final walkingMinutes = (distanceMeters! / 83.3).round();
      if (walkingMinutes < 60) {
        etaText = '🚶 $walkingMinutes min a pie';
      } else {
        final hours = walkingMinutes ~/ 60;
        final mins = walkingMinutes % 60;
        etaText = '🚶 ${hours}h ${mins}m a pie';
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primaryTeal.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Destination Avatar / Icon
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              poi.imageUrl,
              width: 46,
              height: 46,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 46,
                height: 46,
                color: const Color(0xFF1E293B),
                child: const Icon(
                  Icons.place_rounded,
                  color: AppTheme.primaryTeal,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Name and distance/time info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  poi.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      distanceText,
                      style: const TextStyle(
                        color: AppTheme.accentCyan,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (etaText.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        etaText,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Action: Start Navigation Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryTeal,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.navigation_rounded, size: 16),
            label: const Text(
              'Navegar',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onStartNavigation,
          ),
          const SizedBox(width: 4),

          // Action: Info button
          if (onOpenDetails != null)
            IconButton(
              icon: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white70,
                size: 20,
              ),
              tooltip: 'Ver detalles',
              onPressed: onOpenDetails,
            ),

          // Close button
          if (onClose != null)
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white54,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}

// ─── FAB Helper ──────────────────────────────────────────────────────────────

class _MapFab extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool active;
  final int? badgeCount;
  final VoidCallback onTap;

  const _MapFab({
    required this.icon,
    required this.tooltip,
    required this.active,
    this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: active
                    ? AppTheme.primaryTeal
                    : const Color(0xFF1E293B).withValues(alpha: 0.95),
                shape: BoxShape.circle,
                border: Border.all(
                  color: active ? AppTheme.primaryTeal : AppTheme.cardGlassBorder,
                  width: active ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 20,
                color: active ? Colors.black : AppTheme.accentCyan,
              ),
            ),
            if (badgeCount != null && badgeCount! > 1)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.accentCyan,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$badgeCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _UserLocationDot extends StatelessWidget {
  final bool hasRealLocation;
  const _UserLocationDot({this.hasRealLocation = false});

  @override
  Widget build(BuildContext context) {
    final color = hasRealLocation ? AppTheme.accentCyan : Colors.amber;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.5),
      ),
      child: Center(
        child: Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.6),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PoiMarkerBubble extends StatelessWidget {
  final PlaceOfInterest poi;
  final bool isSelected;

  const _PoiMarkerBubble({required this.poi, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryTeal
            : AppTheme.cardDark.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.white : AppTheme.primaryTeal,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isSelected ? AppTheme.primaryTeal : Colors.black)
                .withValues(alpha: 0.5),
            blurRadius: isSelected ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _categoryIcon(poi.category),
            size: 14,
            color: isSelected ? Colors.black : AppTheme.primaryTeal,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              poi.name.split(' ').take(2).join(' '),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
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
