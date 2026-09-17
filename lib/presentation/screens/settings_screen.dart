import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.darkBackground,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // i18n Language Selector Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.cardGlassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.language_rounded, color: AppTheme.primaryTeal),
                    SizedBox(width: 10),
                    Text(
                      'Idioma de la Aplicación (i18n)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ChoiceChip(
                      selected: appProvider.currentLocale.languageCode == 'es',
                      label: const Text('Español (ES)'),
                      selectedColor: AppTheme.primaryTeal,
                      onSelected: (_) => appProvider.setLocale(const Locale('es')),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      selected: appProvider.currentLocale.languageCode == 'en',
                      label: const Text('English (EN)'),
                      selectedColor: AppTheme.primaryTeal,
                      onSelected: (_) => appProvider.setLocale(const Locale('en')),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // OpenStreetMap Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryTeal.withValues(alpha: 0.4)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.map_rounded, color: AppTheme.primaryTeal, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mapas: OpenStreetMap',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Esta app usa OpenStreetMap (flutter_map) — cartografía libre, gratuita y sin API key. Los tiles se descargan en tiempo real cuando hay conexión.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '© OpenStreetMap contributors · Licencia ODbL',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.accentCyan,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

