class VelocidadData {
  final double velocidadActual; // km/h
  final double velocidadMaxima; // km/h
  final double distanciaTotal; // km
  final String direccion;
  final bool isTracking;
  final String statusMessage;

  VelocidadData({
    this.velocidadActual = 0.0,
    this.velocidadMaxima = 0.0,
    this.distanciaTotal = 0.0,
    this.direccion = '--',
    this.isTracking = false,
    this.statusMessage = 'Cargando ubicación...',
  });

  VelocidadData copyWith({
    double? velocidadActual,
    double? velocidadMaxima,
    double? distanciaTotal,
    String? direccion,
    bool? isTracking,
    String? statusMessage,
  }) {
    return VelocidadData(
      velocidadActual: velocidadActual ?? this.velocidadActual,
      velocidadMaxima: velocidadMaxima ?? this.velocidadMaxima,
      distanciaTotal: distanciaTotal ?? this.distanciaTotal,
      direccion: direccion ?? this.direccion,
      isTracking: isTracking ?? this.isTracking,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}
