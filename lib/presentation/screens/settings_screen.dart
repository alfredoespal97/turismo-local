import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/here_credentials_model.dart';
import '../providers/app_provider.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _appIdController;
  late TextEditingController _accessKeyIdController;
  late TextEditingController _accessKeySecretController;

  @override
  void initState() {
    super.initState();
    final creds = context.read<AppProvider>().credentials;
    _appIdController = TextEditingController(text: creds.appId);
    _accessKeyIdController = TextEditingController(text: creds.accessKeyId);
    _accessKeySecretController = TextEditingController(text: creds.accessKeySecret);
  }

  @override
  void dispose() {
    _appIdController.dispose();
    _accessKeyIdController.dispose();
    _accessKeySecretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuración & SDK Options',
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

          // HERE SDK Credentials Card
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
                    Icon(Icons.key_rounded, color: AppTheme.accentCyan),
                    SizedBox(width: 10),
                    Text(
                      'Credenciales HERE Developer Portal',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa las claves obtenidas en developer.here.com (Plan Freemium / Base)',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 16),
                _buildTextField(_appIdController, 'App ID (e.g. wX9Yk...)', Icons.developer_mode),
                const SizedBox(height: 12),
                _buildTextField(_accessKeyIdController, 'Access Key ID', Icons.fingerprint),
                const SizedBox(height: 12),
                _buildTextField(_accessKeySecretController, 'Access Key Secret', Icons.lock_outline, isSecret: true),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentCyan,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.check_circle_rounded),
                    label: const Text('Guardar e Inicializar Engine', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      final newCreds = HereCredentials(
                        appId: _appIdController.text.trim(),
                        accessKeyId: _accessKeyIdController.text.trim(),
                        accessKeySecret: _accessKeySecretController.text.trim(),
                      );
                      appProvider.updateCredentials(newCreds);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Credenciales de HERE SDK actualizadas correctamente.'),
                          backgroundColor: AppTheme.primaryTeal,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isSecret = false}) {
    return TextField(
      controller: controller,
      obscureText: isSecret,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        prefixIcon: Icon(icon, color: AppTheme.primaryTeal, size: 18),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.cardGlassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.cardGlassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryTeal),
        ),
      ),
    );
  }
}
