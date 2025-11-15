import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/velocidad_data.dart';
import '../services/location_service.dart';
import '../widgets/mapa_widget.dart';
import '../widgets/velocimetro_display.dart';
import '../widgets/info_card.dart';
import '../widgets/control_buttons.dart';
import '../widgets/fisica_explicacion.dart';

class VelocimetroScreen extends StatefulWidget {
  const VelocimetroScreen({super.key});

  @override
  State<VelocimetroScreen> createState() => _VelocimetroScreenState();
}

class _VelocimetroScreenState extends State<VelocimetroScreen> {
  // Services
  final LocationService _locationService = LocationService();

  // Data
  VelocidadData _velocidadData = VelocidadData();
  Position? _posicionAnterior;
  Position? _posicionActual;
  DateTime? _tiempoAnterior;
  StreamSubscription<Position>? _positionStream;

  // Mapa
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _routeCoordinates = [];

  @override
  void initState() {
    super.initState();
    _locationService.checkPermisos();
    _cargarUbicacionInicial();
  }

  // Carga la ubicación inicial al abrir la app
  Future<void> _cargarUbicacionInicial() async {
    try {
      // Verifica permisos
      LocationPermission permission = await _locationService.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _locationService.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }

      // Obtener posición inicial
      Position initialPosition = await _locationService.getCurrentPosition();
      setState(() {
        _posicionActual = initialPosition;
        _velocidadData = _velocidadData.copyWith(
          statusMessage: 'Ubicación obtenida. Presiona iniciar para rastrear.',
        );
      });
      _actualizarMapa(initialPosition);
    } catch (e) {
      debugPrint('Error obteniendo ubicación inicial: $e');
      setState(() {
        _velocidadData = _velocidadData.copyWith(
          statusMessage: 'Error obteniendo ubicación. Verifica los permisos.',
        );
      });
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _locationService.dispose();
    super.dispose();
  }

  // Inicia el seguimiento GPS
  Future<void> _iniciarTracking() async {
    // Verifica si el servicio de ubicación está habilitado
    bool serviceEnabled = await _locationService.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _velocidadData = _velocidadData.copyWith(
          statusMessage: 'El servicio de ubicación está deshabilitado',
        );
      });
      return;
    }

    // Verifica permisos
    LocationPermission permission = await _locationService.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _locationService.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _velocidadData = _velocidadData.copyWith(
            statusMessage: 'Permisos de ubicación denegados',
          );
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _velocidadData = _velocidadData.copyWith(
          statusMessage: 'Permisos de ubicación denegados permanentemente',
        );
      });
      return;
    }

    setState(() {
      _velocidadData = VelocidadData(
        isTracking: true,
        statusMessage: 'Rastreando...',
      );
      _posicionAnterior = null;
      _tiempoAnterior = null;
    });

    // Si no hay posición actual, obtenerla primero
    if (_posicionActual == null) {
      try {
        Position initialPosition = await _locationService.getCurrentPosition();
        setState(() {
          _posicionActual = initialPosition;
        });
        _actualizarMapa(initialPosition);
      } catch (e) {
        debugPrint('Error obteniendo posición inicial: $e');
      }
    }

    // Iniciar stream de posiciones
    _positionStream = _locationService.getPositionStream().listen((
      Position position,
    ) {
      _calcularVelocidad(position);
    });
  }

  // Calcula la velocidad basándose en física: v = d/t
  void _calcularVelocidad(Position nuevaPosicion) {
    DateTime tiempoActual = DateTime.now();

    if (_posicionAnterior != null && _tiempoAnterior != null) {
      // Calcula distancia entre dos puntos (fórmula de Haversine)
      double distanciaMetros = _locationService.calculateDistance(
        _posicionAnterior!.latitude,
        _posicionAnterior!.longitude,
        nuevaPosicion.latitude,
        nuevaPosicion.longitude,
      );

      // Calcula tiempo transcurrido
      double tiempoSegundos =
          tiempoActual.difference(_tiempoAnterior!).inMilliseconds / 1000.0;

      if (tiempoSegundos > 0) {
        // Velocidad = distancia / tiempo
        double velocidadKmh = _locationService.calculateVelocity(
          distanciaMetros: distanciaMetros,
          tiempoSegundos: tiempoSegundos,
        );

        // Filtrar lecturas anómalas
        if (velocidadKmh < 300) {
          // Máximo razonable
          // Calcular dirección (bearing)
          double bearing = _locationService.calculateBearing(
            _posicionAnterior!.latitude,
            _posicionAnterior!.longitude,
            nuevaPosicion.latitude,
            nuevaPosicion.longitude,
          );
          String direccion = _locationService.bearingToCardinal(bearing);

          setState(() {
            _velocidadData = _velocidadData.copyWith(
              velocidadActual: velocidadKmh,
              velocidadMaxima: velocidadKmh > _velocidadData.velocidadMaxima
                  ? velocidadKmh
                  : _velocidadData.velocidadMaxima,
              distanciaTotal:
                  _velocidadData.distanciaTotal + (distanciaMetros / 1000.0),
              direccion: direccion,
            );
          });
        }
      }
    }

    _posicionAnterior = nuevaPosicion;
    _posicionActual = nuevaPosicion;
    _tiempoAnterior = tiempoActual;

    // Actualizar mapa
    _actualizarMapa(nuevaPosicion);
  }

  // Actualiza el mapa con la nueva posición
  void _actualizarMapa(Position position) {
    final LatLng newPosition = LatLng(position.latitude, position.longitude);

    setState(() {
      // Agregar la nueva posición a la ruta
      _routeCoordinates.add(newPosition);

      // Actualizar marcador de posición actual
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('current_position'),
          position: newPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'Tu posición',
            snippet:
                '${_velocidadData.velocidadActual.toStringAsFixed(1)} km/h',
          ),
        ),
      );

      // Actualizar polyline con la ruta recorrida
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: _routeCoordinates,
          color: Colors.blue,
          width: 5,
        ),
      );
    });

    // Mover la cámara para seguir la posición actual
    _mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
  }

  // Detiene el seguimiento
  void _detenerTracking() {
    _positionStream?.cancel();
    setState(() {
      _velocidadData = _velocidadData.copyWith(
        isTracking: false,
        statusMessage: 'Detenido',
        velocidadActual: 0.0,
      );
    });
  }

  // Reinicia todos los valores
  void _resetear() {
    _detenerTracking();
    setState(() {
      _velocidadData = VelocidadData();
      _routeCoordinates.clear();
      _polylines.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Velocímetro GPS'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mapa
            MapaWidget(
              posicionActual: _posicionActual,
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),

            // Contenido del velocímetro
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Velocímetro principal
                  VelocimetroDisplay(
                    velocidadActual: _velocidadData.velocidadActual,
                  ),
                  const SizedBox(height: 40),

                  // Información adicional
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoCard(
                        label: 'Velocidad Máx.',
                        value:
                            '${_velocidadData.velocidadMaxima.toStringAsFixed(1)} km/h',
                      ),
                      InfoCard(
                        label: 'Dirección',
                        value: _velocidadData.direccion,
                      ),
                      InfoCard(
                        label: 'Distancia',
                        value:
                            '${_velocidadData.distanciaTotal.toStringAsFixed(2)} km',
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Estado
                  Text(
                    _velocidadData.statusMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: _velocidadData.isTracking
                          ? Colors.green
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botones de control
                  ControlButtons(
                    isTracking: _velocidadData.isTracking,
                    onIniciar: _iniciarTracking,
                    onDetener: _detenerTracking,
                    onReset: _resetear,
                  ),

                  const SizedBox(height: 30),

                  // Explicación física
                  const FisicaExplicacion(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
