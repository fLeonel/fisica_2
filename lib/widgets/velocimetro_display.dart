import 'package:flutter/material.dart';

class VelocimetroDisplay extends StatelessWidget {
  final double velocidadActual;

  const VelocimetroDisplay({super.key, required this.velocidadActual});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.blue.shade900, Colors.blue.shade700],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            velocidadActual.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'km/h',
            style: TextStyle(fontSize: 24, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
