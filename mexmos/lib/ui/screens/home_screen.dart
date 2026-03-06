import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/accessibility_control.dart';
import '../../logic/accesibilidad_logic.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accesibilidadLogic = context.watch<AccesibilidadLogic>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mexmos'),
        actions: [
          AccessibilityControl(
            modoActual: accesibilidadLogic.modoDaltonismo,
            onModoCambiado: accesibilidadLogic.cambiarModo,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Acerca de',
            onPressed: () => _mostrarAcercaDe(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido a Mexmos',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Diseña mosaicos de terrazo y marmolina con cálculo automático de MRP.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MenuCard(
                      icon: Icons.add_circle_outline,
                      title: 'Nuevo Diseño',
                      description:
                          'Comenzar un mosaico a partir de una receta base.',
                      onTap: () => Navigator.pushNamed(context, '/catalogo'),
                    ),
                    const SizedBox(width: 24),
                    _MenuCard(
                      icon: Icons.grid_view,
                      title: 'Mis Diseños',
                      description:
                          'Ver catálogos de diseños previos guardados.',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'La función de guardar diseños usando SQLite estará disponible próximamente.')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarAcercaDe(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Acerca de Mexmos'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mexicana de Mosaicos (Mexmos)'),
              SizedBox(height: 8),
              Text(
                  'Más de 55 años de experiencia en mosaicos de terrazo y mármol.'),
              SizedBox(height: 16),
              Text(
                  'Esta versión incluye el calculador de fórmulas (MRP) para minimizar errores y mermas en la fabricación.'),
              SizedBox(height: 16),
              Text('Versión: 0.1.0 (Prototipo)',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 64, color: Colors.blue.shade800),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
