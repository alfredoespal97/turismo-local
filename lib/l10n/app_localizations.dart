import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Turismo Local HERE'**
  String get appTitle;

  /// No description provided for @searchPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Buscar monumentos, rutas, zonas...'**
  String get searchPlaceholder;

  /// No description provided for @categoryAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get categoryAll;

  /// No description provided for @categoryMonuments.
  ///
  /// In es, this message translates to:
  /// **'Monumentos'**
  String get categoryMonuments;

  /// No description provided for @categoryGastronomy.
  ///
  /// In es, this message translates to:
  /// **'Gastronomía'**
  String get categoryGastronomy;

  /// No description provided for @categoryNature.
  ///
  /// In es, this message translates to:
  /// **'Naturaleza'**
  String get categoryNature;

  /// No description provided for @categoryCulture.
  ///
  /// In es, this message translates to:
  /// **'Cultura'**
  String get categoryCulture;

  /// No description provided for @offlineMaps.
  ///
  /// In es, this message translates to:
  /// **'Mapas Offline'**
  String get offlineMaps;

  /// No description provided for @offlineMapsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Gestiona paquetes de datos regionales para usar sin conexión'**
  String get offlineMapsSubtitle;

  /// No description provided for @offlineReady.
  ///
  /// In es, this message translates to:
  /// **'Modo Offline Activo'**
  String get offlineReady;

  /// No description provided for @onlineMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Online (HERE Live SDK)'**
  String get onlineMode;

  /// No description provided for @downloadRegion.
  ///
  /// In es, this message translates to:
  /// **'Descargar Región'**
  String get downloadRegion;

  /// No description provided for @downloaded.
  ///
  /// In es, this message translates to:
  /// **'Descargado'**
  String get downloaded;

  /// No description provided for @downloading.
  ///
  /// In es, this message translates to:
  /// **'Descargando...'**
  String get downloading;

  /// No description provided for @deleteRegion.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Región'**
  String get deleteRegion;

  /// No description provided for @audioGuideAvailable.
  ///
  /// In es, this message translates to:
  /// **'Audioguía disponible'**
  String get audioGuideAvailable;

  /// No description provided for @startNavigation.
  ///
  /// In es, this message translates to:
  /// **'Navegar con HERE SDK'**
  String get startNavigation;

  /// No description provided for @proximityAlertTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Punto de Interés Cercano!'**
  String get proximityAlertTitle;

  /// No description provided for @proximityAlertDesc.
  ///
  /// In es, this message translates to:
  /// **'Estás cerca de {poiName}. Toca para abrir la guía.'**
  String proximityAlertDesc(Object poiName);

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes del Proyecto'**
  String get settingsTitle;

  /// No description provided for @languageLabel.
  ///
  /// In es, this message translates to:
  /// **'Idioma de la App'**
  String get languageLabel;

  /// No description provided for @hereCredentialsLabel.
  ///
  /// In es, this message translates to:
  /// **'Credenciales HERE Developer'**
  String get hereCredentialsLabel;

  /// No description provided for @appIdLabel.
  ///
  /// In es, this message translates to:
  /// **'HERE App ID'**
  String get appIdLabel;

  /// No description provided for @accessKeyLabel.
  ///
  /// In es, this message translates to:
  /// **'HERE Access Key ID'**
  String get accessKeyLabel;

  /// No description provided for @accessSecretLabel.
  ///
  /// In es, this message translates to:
  /// **'HERE Access Key Secret'**
  String get accessSecretLabel;

  /// No description provided for @saveCredentials.
  ///
  /// In es, this message translates to:
  /// **'Guardar Credenciales'**
  String get saveCredentials;

  /// No description provided for @hereSdkNotice.
  ///
  /// In es, this message translates to:
  /// **'Esta app está lista para HERE SDK (Explore/Navigate edition).'**
  String get hereSdkNotice;

  /// No description provided for @exploreNotice.
  ///
  /// In es, this message translates to:
  /// **'Usa mapas vectoriales en tiempo real y paquetes de zonas sin conexión.'**
  String get exploreNotice;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
