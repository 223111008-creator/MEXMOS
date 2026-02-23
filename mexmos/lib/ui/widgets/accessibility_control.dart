import 'package:flutter/material.dart';

/// Widget que provee un menú desplegable para seleccionar el modo de 
/// simulación de daltonismo, facilitando la accesibilidad visual.
class AccessibilityControl extends StatelessWidget {
  /// El modo de visión actualmente seleccionado.
  final String modoActual;
  
  /// Callback que se ejecuta cuando el usuario selecciona un nuevo modo.
  final ValueChanged<String> onModoCambiado;

  const AccessibilityControl({
    super.key,
    required this.modoActual,
    required this.onModoCambiado,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Opciones de accesibilidad visual',
      icon: const Icon(Icons.visibility),
      onSelected: onModoCambiado,
      itemBuilder: (BuildContext context) {
        return const [
          PopupMenuItem(value: 'Normal', child: Text('Visión Normal')),
          PopupMenuItem(value: 'Protanopía', child: Text('Protanopía (Sin rojo)')),
          PopupMenuItem(value: 'Deuteranopía', child: Text('Deuteranopía (Sin verde)')),
          PopupMenuItem(value: 'Tritanopía', child: Text('Tritanopía (Sin azul)')),
        ];
      },
    );
  }
}