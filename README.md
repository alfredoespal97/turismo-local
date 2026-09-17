# 🗺️ Turismo Local HERE - Flutter & HERE SDK App

[![Flutter Version](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter)](https://flutter.dev)
[![HERE SDK](https://img.shields.io/badge/HERE_SDK-Explore%2FNavigate-00C897?logo=here)](https://developer.here.com)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-FF6F00)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Una aplicación móvil moderna de **Turismo Local y Guía Cultural** desarrollada en **Flutter**, integrada con **HERE SDK (Explore & Navigate Edition)**. Diseñada para demostrar patrones de ingeniería de software avanzados como **Clean Architecture**, **Mapas Vectoriales Interactivos**, **Navegación Offline**, **Geolocalización en Segundo Plano** e **Internacionalización (i18n)**.

---

## 🌟 Características Destacadas

* 🗺️ **Renderizado Vectorial con HERE SDK**: Mapas interactivos de alto rendimiento con `MapMarker` personalizados, cálculo de polígonos y rutas.
* 📦 **Modo Offline & Descarga de Regiones**: Gestor de descarga de mapas regionales pesados para exploración turística en zonas rurales o de montaña sin cobertura móvil.
* 🔔 **Geolocalización & Alertas de Proximidad**: Cálculo de distancias mediante la fórmula de Haversine y geocercas para notificar al usuario cuando está cerca de un monumento o punto de interés histórico.
* 🎧 **Audioguías e Información Cultural**: Fichas detalladas de cada POI con duración de narración, valoraciones y coordenadas.
* 🎨 **Diseño UX/UI de Nivel Premium**: Interfaz en modo oscuro con estética *Glassmorphic*, paleta de colores pulida (Teal & Cyan) y soporte de tipografías nativas con Google Fonts (`Outfit`).
* 🌐 **Internacionalización (i18n)**: Soporte completo para Español (`es`) e Inglés (`en`) utilizando `flutter_localizations` e `intl`.

---

## 🏗️ Arquitectura del Proyecto (Clean Architecture)

El código sigue estrictamente la separación de responsabilidades en 4 capas desacopladas:

```
lib/
├── core/                   # Clases base, servicios de infraestructura y tema
│   ├── config/             # Configuración de HERE SDK y constantes de entorno
│   ├── services/           # HereSdkService, LocationService (Haversine)
│   └── theme/              # Tokens de diseño, gradientes y tipografías (AppTheme)
├── domain/                 # Reglas de negocio puras e interfaces
│   ├── models/             # PlaceOfInterest, OfflineRegion, HereCredentials
│   └── repositories/       # Interfaces (IPOIRepository, IOfflineRepository)
├── data/                   # Datos, datasources e implementaciones
│   ├── datasources/        # Archivos JSON locales de monumentos y regiones
│   └── repositories_impl/  # Implementaciones concretas con gestión de cache y storage
├── presentation/           # Capa visual (UI, Providers, Screens y Widgets)
│   ├── providers/          # AppProvider y OfflineMapsProvider
│   ├── screens/            # MapScreen, POIDetailScreen, OfflineMapsScreen, SettingsScreen
│   └── widgets/            # HereMapWidget, POICard, CategoryChips, ProximityBanner
└── l10n/                   # Archivos ARB para internacionalización (app_es.arb, app_en.arb)
```

---

## 🚀 Guía de Inicio Rápido

### Prerrequisitos
- **Flutter SDK**: `>=3.13.3` (Canal estable)
- **Dart SDK**: `>=3.0.0`
- **HERE Developer Account**: Cuenta gratuita en [developer.here.com](https://developer.here.com/)

### 1. Clonar el Repositorio
```bash
git clone https://github.com/tu-usuario/turismo_local_here.git
cd turismo_local_here
```

### 2. Instalar Dependencias
```bash
flutter pub get
```

### 3. Ejecutar la Aplicación
```bash
flutter run
```

---

## 🔑 Configuración del HERE SDK en la Aplicación

1. Regístrate en el [HERE Developer Portal](https://developer.here.com/).
2. Crea un nuevo proyecto y genera tus **SDK Credentials** (`App ID`, `Access Key ID` y `Access Key Secret`).
3. Inicia la aplicación, navega al menú de **Configuración & SDK Options** (ícono ⚙️ en la esquina superior derecha).
4. Ingresa tus credenciales y presiona **Guardar e Inicializar Engine**.

> **Nota para Desarrolladores**: La app incluye un motor de abstracción y simulación interactiva (`HereSdkService`), lo que permite compilar y previsualizar la interfaz en cualquier plataforma (Web, iOS, Android) sin requerir binarios nativos adicionales de inmediato.

---

## 💼 Puntos Clave para Destacar en un CV / Entrevista Técnica

Cuando presentes este proyecto a reclutadores o equipos de ingeniería, puedes resaltar los siguientes logros técnicos:

- **Dominio de SDKs Industriales de Cartografía**: *“Integración de HERE SDK (Explore/Navigate edition) en Flutter para renderizado de mapas vectoriales y navegación giro a giro en aplicaciones móviles de alto tráfico.”*
- **Arquitectura Escalable y Mantenible**: *“Diseño estructurado bajo Clean Architecture e inyección de dependencias, garantizando una alta cobertura de pruebas unitarias y facilidades de mantenimiento.”*
- **Persistencia de Datos & Estrategia Offline-First**: *“Desarrollo de un gestor de descargas regionales de cartografía pesada para asegurar operatividad fluida sin conexión a internet.”*
- **Optimización Energética & Background GPS**: *“Implementación de geocercas eficientes y fórmulas trigonométricas (Haversine) para alertas de proximidad sin drenar la batería del dispositivo.”*

---

## 🧪 Pruebas Unitarias

Ejecuta el conjunto de tests automatizados para validar los repositorios y servicios de geolocalización:

```bash
flutter test
```

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.
