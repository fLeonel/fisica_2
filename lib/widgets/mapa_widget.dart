import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapaWidget extends StatelessWidget {
  final Position? posicionActual;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Function(GoogleMapController) onMapCreated;

  const MapaWidget({
    super.key,
    required this.posicionActual,
    required this.markers,
    required this.polylines,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: posicionActual != null
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  posicionActual!.latitude,
                  posicionActual!.longitude,
                ),
                zoom: 16,
              ),
              onMapCreated: onMapCreated,
              markers: markers,
              polylines: polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
            )
          : Container(
              color: Colors.grey.shade300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off,
                      size: 60,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Esperando ubicación GPS...',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
