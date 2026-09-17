// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Turismo Local HERE';

  @override
  String get searchPlaceholder => 'Buscar monumentos, rutas, zonas...';

  @override
  String get categoryAll => 'Todos';

  @override
  String get categoryMonuments => 'Monumentos';

  @override
  String get categoryGastronomy => 'Gastronomía';

  @override
  String get categoryNature => 'Naturaleza';

  @override
  String get categoryCulture => 'Cultura';

  @override
  String get offlineMaps => 'Mapas Offline';

  @override
  String get offlineMapsSubtitle =>
      'Gestiona paquetes de datos regionales para usar sin conexión';

  @override
  String get offlineReady => 'Modo Offline Activo';

  @override
  String get onlineMode => 'Modo Online (HERE Live SDK)';

  @override
  String get downloadRegion => 'Descargar Región';

  @override
  String get downloaded => 'Descargado';

  @override
  String get downloading => 'Descargando...';

  @override
  String get deleteRegion => 'Eliminar Región';

  @override
  String get audioGuideAvailable => 'Audioguía disponible';

  @override
  String get startNavigation => 'Navegar con HERE SDK';

  @override
  String get proximityAlertTitle => '¡Punto de Interés Cercano!';

  @override
  String proximityAlertDesc(Object poiName) {
    return 'Estás cerca de $poiName. Toca para abrir la guía.';
  }

  @override
  String get settingsTitle => 'Ajustes del Proyecto';

  @override
  String get languageLabel => 'Idioma de la App';

  @override
  String get hereCredentialsLabel => 'Credenciales HERE Developer';

  @override
  String get appIdLabel => 'HERE App ID';

  @override
  String get accessKeyLabel => 'HERE Access Key ID';

  @override
  String get accessSecretLabel => 'HERE Access Key Secret';

  @override
  String get saveCredentials => 'Guardar Credenciales';

  @override
  String get hereSdkNotice =>
      'Esta app está lista para HERE SDK (Explore/Navigate edition).';

  @override
  String get exploreNotice =>
      'Usa mapas vectoriales en tiempo real y paquetes de zonas sin conexión.';
}
