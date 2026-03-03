import 'package:flutter/material.dart';

class PlaceholderVisor extends StatelessWidget {
  final double tamano;

  const PlaceholderVisor({super.key, this.tamano = 300});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 80, color: Colors.grey),
            SizedBox(height: 8),
            Text('Vista previa del mosaico'),
          ],
        ),
      ),
    );
  }
}