import 'package:flutter/material.dart';
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
  
  // Simulated User Location (Defaulting near Puerta del Sol, Madrid)
  double _userLat = 40.4168;
  double _userLng = -3.7038;
  PlaceOfInterest? _nearbyAlertPoi;

  HereCredentials _credentials = const HereCredentials();

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
  PlaceOfInterest? get nearbyAlertPoi => _nearbyAlertPoi;
  HereCredentials get credentials => _credentials;

  Future<void> loadPOIs() async {
    _allPois = await _poiRepository.getPointsOfInterest();
    _applyFilters();
    _checkProximity();
    notifyListeners();
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
      radiusMeters: 800.0, // Alert radius for showcase demo
    );
  }
}
