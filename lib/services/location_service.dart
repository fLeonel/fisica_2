import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  StreamSubscription<Position>? _positionStream;

  // Verifica y solicita permisos de ubicación
  Future<void> checkPermisos() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  // Verifica si el servicio de ubicación está habilitado
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Verifica permisos de ubicación
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Solicita permisos de ubicación
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Obtiene la posición actual
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  // Inicia el stream de posiciones
  Stream<Position> getPositionStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  // Calcula la distancia entre dos puntos
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // Calcula el bearing (ángulo de dirección)
  double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.bearingBetween(lat1, lon1, lat2, lon2);
  }

  // Convierte bearing a dirección cardinal
  String bearingToCardinal(double bearing) {
    bearing = (bearing + 360) % 360;
    const List<String> direcciones = [
      'N',
      'NE',
      'E',
      'SE',
      'S',
      'SO',
      'O',
      'NO',
    ];
    int index = ((bearing + 22.5) / 45).floor() % 8;
    return direcciones[index];
  }

  // Calcula la velocidad entre dos posiciones
  double calculateVelocity({
    required double distanciaMetros,
    required double tiempoSegundos,
  }) {
    if (tiempoSegundos <= 0) return 0.0;
    // Convertir m/s a km/h multiplicando por 3.6
    return (distanciaMetros / tiempoSegundos) * 3.6;
  }

  // Cancela el stream de posiciones
  void cancelPositionStream() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  // Dispose
  void dispose() {
    cancelPositionStream();
  }
}
