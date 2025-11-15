import 'package:flutter/material.dart';

class FisicaExplicacion extends StatelessWidget {
  const FisicaExplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📐 Física del Velocímetro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Fórmula: v = Δd / Δt\n'
              '• Δd: Distancia entre posiciones GPS (Haversine)\n'
              '• Δt: Tiempo transcurrido entre mediciones\n'
              '• Bearing: Ángulo de dirección de movimiento',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
