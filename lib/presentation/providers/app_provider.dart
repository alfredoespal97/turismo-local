import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/models/here_credentials_model.dart';
import '../../domain/models/poi_model.dart';
import '../../domain/repositories/poi_repository.dart';
import '../../core/services/here_sdk_service.dart';
import '../../core/services/location_service.dart';

class AppProvider extends ChangeNotifier {
  final IPOIRepository _poiRepository;

  AppProvider(this._poiRepository);

  List<PlaceOfInterest> _allPois = [];
  List<PlaceOfInterest> _filteredPois = [];
  PlaceOfInterest? _selectedPoi;
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  Locale _currentLocale = const Locale('es');
  bool _isOfflineMode = false;

  // Real user GPS location (defaults to Puerta del Sol until GPS fix)
  double _userLat = 40.4168;
  double _userLng = -3.7038;
  bool _locationPermissionDenied = false;
  bool _hasRealLocation = false;

  PlaceOfInterest? _nearbyAlertPoi;
  HereCredentials _credentials = const HereCredentials();
  StreamSubscription<Position>? _locationSubscription;

  // Getters
  List<PlaceOfInterest> get pois => _filteredPois;
  List<PlaceOfInterest> get allPois => _allPois;
  PlaceOfInterest? get selectedPoi => _selectedPoi;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  Locale get currentLocale => _currentLocale;
  bool get isOfflineMode => _isOfflineMode;
  double get userLat => _userLat;
  double get userLng => _userLng;
  bool get locationPermissionDenied => _locationPermissionDenied;
  bool get hasRealLocation => _hasRealLocation;
  PlaceOfInterest? get nearbyAlertPoi => _nearbyAlertPoi;
  HereCredentials get credentials => _credentials;

  Future<void> loadPOIs() async {
    _allPois = await _poiRepository.getPointsOfInterest();
    _applyFilters();
    _checkProximity();
    notifyListeners();
  }

  /// Requests location permission and starts real GPS tracking.
  Future<void> initLocationTracking() async {
    // Check last known position first for immediate UI jump to real location
    try {
      final lastPos = await Geolocator.getLastKnownPosition();
      if (lastPos != null) {
        _userLat = lastPos.latitude;
        _userLng = lastPos.longitude;
        _hasRealLocation = true;
        _locationPermissionDenied = false;
        _checkProximity();
        notifyListeners();
      }
    } catch (_) {}

    final Position? position = await LocationService.requestAndGetCurrentLocation();

    if (position == null) {
      if (!_hasRealLocation) {
        _locationPermissionDenied = true;
      }
      notifyListeners();
      return;
    }

    // Apply first real GPS fix
    _userLat = position.latitude;
    _userLng = position.longitude;
    _hasRealLocation = true;
    _locationPermissionDenied = false;
    _checkProximity();
    notifyListeners();

    // Start continuous stream
    _locationSubscription?.cancel();
    _locationSubscription = LocationService.getLocationStream().listen(
      (Position pos) {
        _userLat = pos.latitude;
        _userLng = pos.longitude;
        _hasRealLocation = true;
        _checkProximity();
        notifyListeners();
      },
      onError: (_) {
        // Silently ignore stream errors; keep last known position
      },
    );
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void selectPOI(PlaceOfInterest? poi) {
    _selectedPoi = poi;
    notifyListeners();
  }

  void toggleOfflineMode(bool val) {
    _isOfflineMode = val;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  void updateUserLocation(double lat, double lng) {
    _userLat = lat;
    _userLng = lng;
    _checkProximity();
    notifyListeners();
  }

  void updateCredentials(HereCredentials creds) {
    _credentials = creds;
    HereSdkService().initialize(creds);
    notifyListeners();
  }

  void dismissProximityAlert() {
    _nearbyAlertPoi = null;
    notifyListeners();
  }

  void _applyFilters() {
    _filteredPois = _allPois.where((poi) {
      final matchesSearch = _searchQuery.isEmpty ||
          poi.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          poi.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'Todos' ||
          _selectedCategory == 'All' ||
          poi.category.toLowerCase() == _selectedCategory.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();

    if (_selectedPoi != null && !_filteredPois.contains(_selectedPoi)) {
      _selectedPoi = _filteredPois.isNotEmpty ? _filteredPois.first : null;
    }
  }

  void _checkProximity() {
    _nearbyAlertPoi = LocationService.checkNearbyPOI(
      _userLat,
      _userLng,
      _allPois,
      radiusMeters: 800.0,
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
