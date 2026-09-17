import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationService {
  /// Opens turn-by-turn navigation to target coordinates in Google Maps or Apple Maps.
  static Future<bool> openNavigation({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final encodedLabel = Uri.encodeComponent(label ?? 'Destino');

    // 1. Google Maps URL (works on Android, iOS, web, macOS)
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&destination_place_id=$encodedLabel&travelmode=walking',
    );

    // 2. Apple Maps URL (optimal for iOS / macOS)
    final appleMapsUrl = Uri.parse(
      'https://maps.apple.com/?daddr=$latitude,$longitude&q=$encodedLabel&dirflg=w',
    );

    // 3. Native geo URI scheme (for Android intent)
    final geoUrl = Uri.parse(
      'geo:$latitude,$longitude?q=$latitude,$longitude($encodedLabel)',
    );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        return await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else if (await canLaunchUrl(appleMapsUrl)) {
        return await launchUrl(
          appleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else if (await canLaunchUrl(geoUrl)) {
        return await launchUrl(
          geoUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to platform default browser
        return await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.platformDefault,
        );
      }
    } catch (e) {
      debugPrint('Error launching navigation: $e');
      return false;
    }
  }
}
