// lib/ui/screens/trabajo_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/trabajo_logic.dart';
import '../../domain/models/pigmento.dart';
import '../../domain/models/grano_marmol.dart';
import '../../data/repositories/mosaico_repositories.dart';
import '../widgets/opcion_drawer_button.dart';
import '../widgets/drawer_edicion_base.dart';
import '../widgets/drawer_edicion_grano.dart';
import '../widgets/drawer_edicion_capas.dart';
import '../widgets/drawer_edicion_acabado.dart';

class TrabajoScreen extends StatefulWidget {
  const TrabajoScreen({super.key});

  @override
  State<TrabajoScreen> createState() => _TrabajoScreenState();
}

class _TrabajoScreenState extends State<TrabajoScreen> {
  final MosaicoRepository _repository = MosaicoRepository();
  late Future<List<dynamic>> _catalogosFuture;

  @override
  void initState() {
    super.initState();
    _catalogosFuture = Future.wait([
      _repository.obtenerPigmentos(),
      _repository.obtenerGranos(),
    ]);
  }

  Widget _buildDrawerEdicion(OpcionDrawer opcion, List<Pigmento> pigmentos, List<GranoMarmol> granos) {
    final logic = context.read<TrabajoLogic>();
    switch (opcion) {
      case OpcionDrawer.base:
        return DrawerEdicionBase(logic: logic, pigmentosDisponibles: pigmentos);
      case OpcionDrawer.grano:
        return DrawerEdicionGrano(logic: logic, pigmentosDisponibles: pigmentos, granosDisponibles: granos);
      case OpcionDrawer.capas:
        return DrawerEdicionCapas(logic: logic);
      case OpcionDrawer.acabado:
        return DrawerEdicionAcabado(logic: logic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<TrabajoLogic>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final double drawerWidth = isSmallScreen ? 80.0 : 120.0;

          return Row(
            children: [
              // 1. Drawer Vertical Izquierdo
              Container(
                width: drawerWidth,
                color: Colors.white,
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    _buildNavButton(context, logic, OpcionDrawer.base, Icons.format_color_fill, isSmallScreen ? null : 'Base'),
                    const SizedBox(height: 12),
                    _buildNavButton(context, logic, OpcionDrawer.grano, Icons.grain, isSmallScreen ? null : 'Grano'),
                    const SizedBox(height: 12),
                    _buildNavButton(context, logic, OpcionDrawer.capas, Icons.layers, isSmallScreen ? null : 'Capas'),
                    const SizedBox(height: 12),
                    _buildNavButton(context, logic, OpcionDrawer.acabado, Icons.auto_awesome, isSmallScreen ? null : 'Acabado'),
                  ],
                ),
              ),
              const VerticalDivider(width: 1, thickness: 1),

              // 2 y 3. Visor Central y Drawer de Edición (Cargando datos)
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _catalogosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error de conexión: ${snapshot.error}'));
                    }

                    final pigmentos = snapshot.data![0] as List<Pigmento>;
                    final granos = snapshot.data![1] as List<GranoMarmol>;

                    return Column(
                      children: [
                        // Visor
                        Expanded(
                          child: Container(
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: Text('Vista previa del mosaico', style: TextStyle(fontSize: 20, color: Colors.grey)),
                            ),
                          ),
                        ),
                        const Divider(height: 1, thickness: 1),
                        // Drawer Inferior
                        SizedBox(
                          height: 220, // Altura ajustada para acomodar los nuevos controles
                          width: double.infinity,
                          child: _buildDrawerEdicion(logic.opcionSeleccionada, pigmentos, granos),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, TrabajoLogic logic, OpcionDrawer opcion, IconData icon, String? label) {
    return Center(
      child: OpcionDrawerButton(
        icon: icon,
        label: label,
        isSelected: logic.opcionSeleccionada == opcion,
        onTap: () => logic.seleccionarOpcion(opcion),
      ),
    );
  }
}