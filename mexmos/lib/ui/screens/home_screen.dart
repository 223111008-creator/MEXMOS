import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/trabajo_logic.dart';
import 'configurador_2d_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mexmos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Ajustes Globales y Accesibilidad',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
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
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    SizedBox(
                      width: 250,
                      child: _MenuCard(
                        icon: Icons.add_circle,
                        title: 'Diseño 2D (Nuevo)',
                        description: 'Prototipo del nuevo configurador visual 2D.',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const Configurador2DScreen()));
                        },
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: _MenuCard(
                        icon: Icons.build_circle,
                        title: 'Diseño Básico',
                        description: 'Configurador clásico de recetas.',
                        onTap: () {
                          context.read<TrabajoLogic>().iniciarDisenoVacio();
                          Navigator.pushNamed(context, '/trabajo');
                        },
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: _MenuCard(
                        icon: Icons.auto_awesome_mosaic,
                        title: 'Plantillas',
                        description: 'Iniciar basado en una receta clásica.',
                        onTap: () => Navigator.pushNamed(context, '/catalogo'),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: _MenuCard(
                        icon: Icons.grid_view,
                        title: 'Mis Diseños',
                        description: 'Ver catálogos de diseños guardados.',
                        onTap: () =>
                            Navigator.pushNamed(context, '/mis_disenos'),
                      ),
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
    return Card(
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
