# Velocímetro GPS - Documentación

## 📱 Descripción del Proyecto

Aplicación móvil de velocímetro GPS desarrollada en Flutter que calcula la velocidad en tiempo real utilizando principios de física y geolocalización.

## 🎯 Características

- **Velocímetro en tiempo real**: Calcula la velocidad usando GPS (fórmula v = Δd/Δt)
- **Mapa interactivo**: Visualiza tu ubicación y ruta recorrida con Google Maps
- **Métricas completas**:
  - Velocidad actual (km/h)
  - Velocidad máxima alcanzada
  - Distancia total recorrida
  - Dirección de movimiento (puntos cardinales)
- **Visualización de ruta**: Polyline azul que dibuja el recorrido
- **Interfaz intuitiva**: Botones de Iniciar, Detener y Reset

## 🏗️ Arquitectura

El proyecto sigue principios de **arquitectura limpia** con separación de responsabilidades:

```
lib/
├── main.dart                          # Punto de entrada de la aplicación
├── models/
│   └── velocidad_data.dart           # Modelo de datos inmutable
├── services/
│   └── location_service.dart         # Servicio de geolocalización GPS
├── screens/
│   └── velocimetro_screen.dart       # Pantalla principal
└── widgets/
    ├── velocimetro_display.dart      # Velocímetro circular
    ├── info_card.dart                # Tarjetas de información
    ├── control_buttons.dart          # Botones de control
    ├── fisica_explicacion.dart       # Explicación física
    └── mapa_widget.dart              # Widget del mapa Google Maps
```

## 📐 Física Aplicada

### Cálculo de Velocidad
```
v = Δd / Δt

Donde:
- v = velocidad (km/h)
- Δd = distancia entre dos puntos GPS (metros)
- Δt = tiempo transcurrido entre mediciones (segundos)
```

### Fórmula de Haversine
Utilizada para calcular la distancia entre dos coordenadas GPS en la superficie de la Tierra.

### Bearing (Ángulo de Dirección)
Calcula el ángulo de movimiento y lo convierte a puntos cardinales (N, NE, E, SE, S, SO, O, NO).

## 🛠️ Tecnologías Utilizadas

- **Framework**: Flutter 3.x
- **Lenguaje**: Dart
- **Paquetes principales**:
  - `geolocator`: Geolocalización GPS
  - `google_maps_flutter`: Integración de Google Maps
  - `permission_handler`: Manejo de permisos

## 📦 Instalación

### Prerrequisitos
- Flutter SDK (3.9.2 o superior)
- Android Studio / Xcode
- Cuenta de Google Cloud (para API Key de Maps)

### Pasos

1. Clonar el repositorio:
```bash
git clone <url-del-repositorio>
cd velocimetro
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. **Configurar Variables de Entorno** (IMPORTANTE):

Crear archivo `.env` en la raíz del proyecto:
```env
GOOGLE_MAPS_API_KEY=tu_api_key_aqui
```

**Android**: Agregar en `android/local.properties`:
```properties
GOOGLE_MAPS_API_KEY=tu_api_key_aqui
```

**iOS**: Por ahora mantener hardcodeada en `AppDelegate.swift` (no hacer commit con la key real)

Ver documentación completa en [CONFIGURACION_ENV.md](CONFIGURACION_ENV.md)

4. Ejecutar en dispositivo:
```bash
flutter run
```

## 🔐 Seguridad

- El archivo `.env` está en `.gitignore` y NO debe versionarse
- `android/local.properties` tampoco se versiona
- Las API Keys están protegidas y no se exponen en el repositorio
- Ver [CONFIGURACION_ENV.md](CONFIGURACION_ENV.md) para más detalles

## 🚀 Uso

1. **Inicio**: Al abrir la app, automáticamente obtiene tu ubicación GPS
2. **Rastrear**: Presiona "Iniciar" para comenzar a medir velocidad
3. **Movimiento**: Camina, corre o maneja para ver datos en tiempo real
4. **Detener**: Presiona "Detener" para pausar el rastreo
5. **Reset**: Presiona "Reset" para reiniciar todas las métricas

## 📱 Permisos Requeridos

### Android
- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`
- `ACCESS_BACKGROUND_LOCATION`
- `INTERNET`

### iOS
- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`

## 🎨 Componentes Principales

### VelocimetroScreen
Pantalla principal que coordina todos los componentes y maneja el estado de la aplicación.

### LocationService
Servicio centralizado para todas las operaciones de GPS:
- Verificación de permisos
- Obtención de ubicación
- Cálculo de distancias y velocidades
- Conversión de bearing a puntos cardinales

### VelocidadData
Modelo inmutable de datos con método `copyWith()` para actualizaciones seguras del estado.

### Widgets Personalizados
- **VelocimetroDisplay**: Círculo animado que muestra la velocidad actual
- **InfoCard**: Tarjetas para mostrar métricas (velocidad máxima, dirección, distancia)
- **ControlButtons**: Botones de Iniciar, Detener y Reset
- **MapaWidget**: Mapa de Google Maps con marcadores y polylines
- **FisicaExplicacion**: Card educativo con las fórmulas físicas

## 🔬 Proyecto Académico

Este proyecto fue desarrollado como parte de un curso de física, aplicando conceptos de:
- Cinemática (velocidad, distancia, tiempo)
- Sistemas de coordenadas geográficas
- Cálculos trigonométricos (bearing)

## 📄 Licencia

MIT License

## 👥 Autor

Proyecto desarrollado para la universidad

---

**Nota**: Para generar documentación HTML automática del código, ejecutá:
```bash
dart doc .
```
La documentación se generará en la carpeta `doc/api/`
