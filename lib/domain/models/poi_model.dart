class PlaceOfInterest {
  final String id;
  final String name;
  final String category;
  final String description;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final int audioGuideMinutes;
  final String regionId;
  final String address;
  final List<String> tags;

  const PlaceOfInterest({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.audioGuideMinutes,
    required this.regionId,
    required this.address,
    required this.tags,
  });

  factory PlaceOfInterest.fromJson(Map<String, dynamic> json) {
    return PlaceOfInterest(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      imageUrl: json['imageUrl'] as String,
      audioGuideMinutes: json['audioGuideMinutes'] as int,
      regionId: json['regionId'] as String,
      address: json['address'] as String,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'audioGuideMinutes': audioGuideMinutes,
      'regionId': regionId,
      'address': address,
      'tags': tags,
    };
  }
}
