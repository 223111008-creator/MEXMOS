// lib/ui/screens/trabajo_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/trabajo_logic.dart';
import '../../domain/models/pigmento.dart';
import '../../domain/models/grano_marmol.dart';
import '../../data/repositories/mosaico_repositories.dart';
import '../app_theme.dart';
import '../widgets/opcion_drawer_button.dart';
import '../widgets/drawer_edicion_base.dart';
import '../widgets/drawer_edicion_grano.dart';
import '../widgets/drawer_edicion_capas.dart';
import '../widgets/drawer_edicion_acabado.dart';
import '../widgets/mosaico_viewer.dart';
import 'resumen_mrp_screen.dart';
import 'vista_final_screen.dart';

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

  Widget _buildDrawerEdicion(
      OpcionDrawer opcion, List<Pigmento> pigmentos, List<GranoMarmol> granos) {
    final logic = context.read<TrabajoLogic>();
    switch (opcion) {
      case OpcionDrawer.base:
        return DrawerEdicionBase(logic: logic, pigmentosDisponibles: pigmentos);
      case OpcionDrawer.grano:
        return DrawerEdicionGrano(
            logic: logic,
            pigmentosDisponibles: pigmentos,
            granosDisponibles: granos);
      case OpcionDrawer.capas:
        return DrawerEdicionCapas(logic: logic);
      case OpcionDrawer.acabado:
        return DrawerEdicionAcabado(logic: logic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<TrabajoLogic>();

    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        backgroundColor: AppTheme.surfaceDark,
        appBar: AppBar(
          backgroundColor: AppTheme.surfacePanel,
          elevation: 0,
          title: Text(
            'Workspace de Diseño',
            style: GoogleFonts.syne(
              color: AppTheme.brandTerra,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          iconTheme: const IconThemeData(color: AppTheme.textPrimary),
          actions: [
            IconButton(
              icon: const Icon(Icons.fullscreen, color: AppTheme.textPrimary),
              tooltip: 'Ver Acabado Final',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VistaFinalScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.save, color: AppTheme.textPrimary),
              tooltip: 'Guardar Diseño / Ficha MRP',
              onPressed: () => _mostrarDialogoGuardar(context, logic),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;
            final double drawerWidth = isSmallScreen ? 80.0 : 120.0;

            return Row(
              children: [
                // 1. Drawer Vertical Izquierdo
                Container(
                  width: drawerWidth,
                  decoration: const BoxDecoration(
                    color: AppTheme.surfacePanel,
                    border: Border(
                      right: BorderSide(color: AppTheme.borderPanel, width: 1),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    children: [
                      _buildNavButton(context, logic, OpcionDrawer.base,
                          Icons.format_color_fill,
                          isSmallScreen ? null : 'Base'),
                      const SizedBox(height: 12),
                      _buildNavButton(context, logic, OpcionDrawer.grano,
                          Icons.grain, isSmallScreen ? null : 'Grano'),
                      const SizedBox(height: 12),
                      _buildNavButton(context, logic, OpcionDrawer.capas,
                          Icons.layers, isSmallScreen ? null : 'Capas'),
                      const SizedBox(height: 12),
                      _buildNavButton(context, logic, OpcionDrawer.acabado,
                          Icons.auto_awesome,
                          isSmallScreen ? null : 'Acabado'),
                    ],
                  ),
                ),

                // 2 y 3. Visor Central y Drawer de Edición (Cargando datos)
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _catalogosFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.brandTerra,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error de conexión: ${snapshot.error}',
                            style: GoogleFonts.dmSans(
                                color: AppTheme.textSecondary),
                          ),
                        );
                      }

                      final pigmentos = snapshot.data![0] as List<Pigmento>;
                      final granos = snapshot.data![1] as List<GranoMarmol>;

                      return Column(
                        children: [
                          // Visor Central
                          Expanded(
                            child: Container(
                              color: AppTheme.surfaceDark,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(32),
                              child: const MosaicoViewer(),
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: AppTheme.borderPanel,
                          ),
                          // Drawer Inferior
                          Container(
                            height: 220,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: AppTheme.surfacePanel,
                              border: Border(
                                top: BorderSide(
                                    color: AppTheme.borderPanel, width: 1),
                              ),
                            ),
                            child: _buildDrawerEdicion(
                                logic.opcionSeleccionada, pigmentos, granos),
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
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, TrabajoLogic logic,
      OpcionDrawer opcion, IconData icon, String? label) {
    return Center(
      child: OpcionDrawerButton(
        icon: icon,
        label: label,
        isSelected: logic.opcionSeleccionada == opcion,
        onTap: () => logic.seleccionarOpcion(opcion),
      ),
    );
  }

  Future<void> _mostrarDialogoGuardar(
      BuildContext context, TrabajoLogic logic) async {
    String nombreDiseno = '';
    String descripcionDiseno = '';

    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppTheme.borderPanel),
          ),
          title: Text(
            'Guardar Diseño',
            style: GoogleFonts.syne(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: GoogleFonts.dmSans(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Nombre del Mosaico (Ej. Clásico Rojo)',
                  labelStyle:
                      GoogleFonts.dmSans(color: AppTheme.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.borderPanel),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.brandTerra),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfacePanel,
                ),
                onChanged: (val) => nombreDiseno = val,
              ),
              const SizedBox(height: 10),
              TextField(
                style: GoogleFonts.dmSans(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Descripción (Opcional)',
                  labelStyle:
                      GoogleFonts.dmSans(color: AppTheme.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.borderPanel),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.brandTerra),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfacePanel,
                ),
                onChanged: (val) => descripcionDiseno = val,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancelar',
                style: GoogleFonts.dmSans(color: AppTheme.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ResumenMRPScreen()));
              },
              child: Text(
                'Ficha MRP',
                style: GoogleFonts.dmSans(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandTerra,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (nombreDiseno.trim().isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                      content: Text('El nombre es obligatorio')));
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: Text(
                'Guardar',
                style: GoogleFonts.syne(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );

    if (confirmacion == true && context.mounted) {
      try {
        await logic.guardarDisenoActual(nombreDiseno, descripcionDiseno);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Diseño guardado exitosamente en la nube ☁️')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
        }
      }
    }
  }
}
