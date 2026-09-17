// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Local Tourism HERE';

  @override
  String get searchPlaceholder => 'Search monuments, routes, spots...';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryMonuments => 'Monuments';

  @override
  String get categoryGastronomy => 'Gastronomy';

  @override
  String get categoryNature => 'Nature';

  @override
  String get categoryCulture => 'Culture';

  @override
  String get offlineMaps => 'Offline Maps';

  @override
  String get offlineMapsSubtitle =>
      'Manage regional data packages for offline usage';

  @override
  String get offlineReady => 'Offline Mode Ready';

  @override
  String get onlineMode => 'Online Mode (HERE Live SDK)';

  @override
  String get downloadRegion => 'Download Region';

  @override
  String get downloaded => 'Downloaded';

  @override
  String get downloading => 'Downloading...';

  @override
  String get deleteRegion => 'Delete Region';

  @override
  String get audioGuideAvailable => 'Audio guide available';

  @override
  String get startNavigation => 'Navigate with HERE SDK';

  @override
  String get proximityAlertTitle => 'Nearby Point of Interest!';

  @override
  String proximityAlertDesc(Object poiName) {
    return 'You are near $poiName. Tap to view guide.';
  }

  @override
  String get settingsTitle => 'Project Settings';

  @override
  String get languageLabel => 'App Language';

  @override
  String get hereCredentialsLabel => 'HERE Developer Credentials';

  @override
  String get appIdLabel => 'HERE App ID';

  @override
  String get accessKeyLabel => 'HERE Access Key ID';

  @override
  String get accessSecretLabel => 'HERE Access Key Secret';

  @override
  String get saveCredentials => 'Save Credentials';

  @override
  String get hereSdkNotice =>
      'This app is pre-configured for HERE SDK (Explore/Navigate edition).';

  @override
  String get exploreNotice =>
      'Utilizes vector maps in real-time and downloadable offline regions.';
}
