# Configuración de Variables de Entorno

## 🔐 Seguridad de API Keys

Este proyecto usa variables de entorno para proteger las API Keys y evitar exponerlas en el repositorio.

## 📋 Configuración Inicial

### 1. Archivo `.env`

Crear un archivo `.env` en la raíz del proyecto (ya está en `.gitignore`):

```env
# Google Maps API Key
GOOGLE_MAPS_API_KEY=tu_api_key_real_aqui
```

### 2. Android - `local.properties`

Agregar la API Key en `android/local.properties` (ya está en `.gitignore`):

```properties
GOOGLE_MAPS_API_KEY=tu_api_key_real_aqui
```

### 3. iOS - Secrets.xcconfig

Crear archivo `ios/Flutter/Secrets.xcconfig` (ya está en `.gitignore`):

```
GOOGLE_MAPS_API_KEY=tu_api_key_real_aqui
```

El archivo `AppDelegate.swift` ya está configurado para leer la key automáticamente desde `Info.plist`, que a su vez la obtiene de `Secrets.xcconfig`.

## 🚀 Obtener Google Maps API Key

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea o selecciona un proyecto
3. Habilita las APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
4. Ve a "Credenciales" → "Crear credenciales" → "Clave de API"
5. Copia la API Key generada
6. (Opcional pero recomendado) Restringe la key:
   - Android: Restringir por nombre de paquete `com.example.velocimetro`
   - iOS: Restringir por Bundle ID

## ⚠️ IMPORTANTE - Archivos NO versionados

Estos archivos contienen información sensible y NO deben subirse a GitHub:

- ✅ `.env` (ya en `.gitignore`)
- ✅ `android/local.properties` (ya en `.gitignore` de Android)
- ✅ `ios/Flutter/Secrets.xcconfig` (ya en `.gitignore` de iOS)

## 🔄 Para otros desarrolladores

1. Clonar el repositorio
2. Copiar `.env.example` como `.env`
3. Copiar `ios/Flutter/Secrets.xcconfig.example` como `ios/Flutter/Secrets.xcconfig`
4. Solicitar las API Keys al líder del equipo
5. Agregar las keys en:
   - `.env`
   - `android/local.properties`
   - `ios/Flutter/Secrets.xcconfig`
6. Ejecutar `flutter pub get`
7. Para iOS: `cd ios && pod install`
8. Ejecutar `flutter run`

## 📝 Checklist antes de hacer commit

- [ ] Verificar que `.env` NO esté en el commit
- [ ] Verificar que `android/local.properties` NO tenga cambios
- [ ] Verificar que `ios/Flutter/Secrets.xcconfig` NO esté en el commit
- [ ] Verificar que los `.gitignore` están actualizados

## 🛠️ Troubleshooting

### Error: "API Key not found"
- Verificar que `.env` existe y tiene la key correcta
- Ejecutar `flutter pub get`
- Limpiar y reconstruir: `flutter clean && flutter pub get`

### Error en Android: "Map no carga"
- Verificar que `local.properties` tiene la key
- Verificar que `build.gradle.kts` tiene la configuración de manifestPlaceholders
- Limpiar: `cd android && ./gradlew clean`

### Error en iOS: "Map muestra marca de agua"
- Verificar que `ios/Flutter/Secrets.xcconfig` existe y tiene la key
- Verificar que `Info.plist` tiene la entrada `GOOGLE_MAPS_API_KEY`
- Limpiar y reconstruir: `cd ios && rm -rf Pods Podfile.lock && pod install`
- Ejecutar: `flutter clean && flutter run`
