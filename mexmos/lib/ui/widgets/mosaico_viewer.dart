import 'package:flutter/material.dart';

/// Visor de Mosaico - Stack de SVGs (Fondo + Figura + Borde)
/// Permite visualizar el mosaico con el color seleccionado
class MosaicoViewer extends StatelessWidget {
  final String mosaicoId;
  final String nombre;
  final Color colorSeleccionado;
  final double size;

  const MosaicoViewer({
    super.key,
    required this.mosaicoId,
    required this.nombre,
    required this.colorSeleccionado,
    this.size = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Visor de mosaico: $nombre',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Capa de fondo del mosaico
            Container(
              width: size * 0.8,
              height: size * 0.8,
              decoration: BoxDecoration(
                color: colorSeleccionado.withOpacity(0.2),
                border: Border.all(
                  color: colorSeleccionado.withOpacity(0.5),
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
            ),
            // Capa de figura (SVG irá aquí)
            Container(
              width: size * 0.6,
              height: size * 0.6,
              decoration: BoxDecoration(
                color: colorSeleccionado,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  nombre,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Capa de borde (SVG irá aquí)
            Container(
              width: size * 0.65,
              height: size * 0.65,
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorSeleccionado,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}