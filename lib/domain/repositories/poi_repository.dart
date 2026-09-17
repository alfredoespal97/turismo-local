import '../models/poi_model.dart';

abstract class IPOIRepository {
  Future<List<PlaceOfInterest>> getPointsOfInterest();
  Future<List<PlaceOfInterest>> searchPOIs(String query, {String? category});
  Future<PlaceOfInterest?> getPOIById(String id);
  Future<List<PlaceOfInterest>> getPOIsByRegion(String regionId);
}
