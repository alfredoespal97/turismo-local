import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'data/repositories_impl/poi_repository_impl.dart';
import 'data/repositories_impl/offline_repository_impl.dart';
import 'presentation/providers/app_provider.dart';
import 'presentation/providers/offline_maps_provider.dart';
import 'presentation/screens/map_screen.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TurismoLocalApp());
}

class TurismoLocalApp extends StatelessWidget {
  const TurismoLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider(POIRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => OfflineMapsProvider(OfflineRepositoryImpl()),
        ),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'Turismo Local HERE',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: appProvider.currentLocale,
            supportedLocales: const [
              Locale('es', ''),
              Locale('en', ''),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const MapScreen(),
          );
        },
      ),
    );
  }
}
