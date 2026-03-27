import 'package:flutter/material.dart';
import '../app_theme.dart';

import 'package:provider/provider.dart';
import '../../logic/configurador_2d_logic.dart';
import '../../data/repositories/mosaico_repositories.dart';
import '../../domain/models/pigmento.dart';
import '../../domain/models/grano_marmol.dart';
import '../../logic/trabajo_logic.dart';
import '../../domain/services/image_export_service.dart';
import '../widgets/mosaico_viewer.dart';
import '../widgets/drawer_edicion_base.dart';
import '../widgets/drawer_edicion_grano.dart';


class Configurador2DScreen extends StatefulWidget {
  const Configurador2DScreen({super.key});

  @override
  State<Configurador2DScreen> createState() => _Configurador2DScreenState();
}

class _Configurador2DScreenState extends State<Configurador2DScreen> {
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





  @override
  Widget build(BuildContext context) {
    final logic = context.watch<Configurador2DLogic>();
    final trabajoLogic = context.watch<TrabajoLogic>();
    return Theme(
      data: logic.highContrast ? AppTheme.highContrastDarkTheme : AppTheme.darkTheme,
      child: Scaffold(
        body: FutureBuilder<List<dynamic>>(
        future: _catalogosFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final pigmentos = snapshot.data![0] as List<Pigmento>;
          final granos = snapshot.data![1] as List<GranoMarmol>;
          
          return Column(
            children: [
              _buildAppBar(logic),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLeftPanel(logic, trabajoLogic, pigmentos, granos),
                    const VerticalDivider(width: 1, thickness: 1, color: AppTheme.borderPanel),
                    _buildCenterCanvas(logic, trabajoLogic),
                    const VerticalDivider(width: 1, thickness: 1, color: AppTheme.borderPanel),
                    _buildRightPanel(logic, trabajoLogic),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomStatusBar(),
      ),
    );
  }

  Widget _buildBottomStatusBar() {
    return Container(
      height: 36,
      decoration: const BoxDecoration(
        color: AppTheme.surfacePanel,
        border: Border(top: BorderSide(color: AppTheme.borderPanel)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildKbdHint('Tab', 'Navegar'),
          const SizedBox(width: 16),
          _buildKbdHint('↑↓←→', 'Ajustar'),
          const SizedBox(width: 16),
          _buildKbdHint('Enter', 'Seleccionar'),
          const SizedBox(width: 16),
          _buildKbdHint('Esc', 'Salir'),
          const SizedBox(width: 16),
          _buildKbdHint('Ctrl+Z', 'Deshacer'),
          const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 6, color: Colors.green),
                SizedBox(width: 6),
                Text('WCAG 2.1 AA · Conforme', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Text('NVDA · JAWS compatible  ·  DM Sans + Syne', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _buildKbdHint(String keys, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            border: Border.all(color: AppTheme.borderPanel),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(keys, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppTheme.textSecondary)),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
      ],
    );
  }

  Widget _buildAppBar(Configurador2DLogic logic) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppTheme.surfacePanel,
        border: Border(bottom: BorderSide(color: AppTheme.borderPanel)),
      ),
      child: Row(
        children: [
          // Back btn
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          // Logo & Name
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.brandTerra,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: const Text(
              'M',
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mexicana de Mosaicos',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'CONFIGURADOR 2D',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 24, color: AppTheme.borderPanel),
          const SizedBox(width: 16),
          // Breadcrumb
          // Breadcrumb
          const Text('Catálogo / Línea Tradicional / ', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const Text('Configurador Visual', style: TextStyle(fontSize: 12, color: AppTheme.brandTerra, fontWeight: FontWeight.w500)),
          const Spacer(),
          // A11y Group
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildA11yBtn(Icons.contrast, 'Contraste', 'contrast', logic),
              const SizedBox(width: 4),
              _buildA11yBtn(Icons.format_size, 'Texto', 'text', logic),
            ],
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 24, color: AppTheme.borderPanel),
          const SizedBox(width: 16),
          // User Avatar Placeholder
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppTheme.brandCobalt,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'VM',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildA11yBtn(IconData icon, String label, String id, Configurador2DLogic logic) {
    bool isActive = false;
    // ignore: prefer_typing_uninitialized_variables
    var onTap;
    if (id == 'contrast') { isActive = logic.highContrast; onTap = logic.toggleHighContrast; }
    if (id == 'text') { isActive = logic.largeText; onTap = logic.toggleLargeText; }
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.surfaceHover : Colors.transparent,
          border: Border.all(
            color: isActive ? AppTheme.borderAccent : AppTheme.borderPanel,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 13,
              color: isActive ? AppTheme.brandTerra : AppTheme.textSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? AppTheme.brandTerra : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftPanel(Configurador2DLogic logic, TrabajoLogic trabajoLogic, List<Pigmento> pigmentos, List<GranoMarmol> granos) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppTheme.surfacePanel,
        border: Border(right: BorderSide(color: AppTheme.borderPanel)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildPanelSection(
            title: 'LÍNEA DE PRODUCTO',
            hint: 'STEP 1',
            child: Row(
              children: [
                _buildLineTab('TRAD', 'Tradicional', 'trad', logic),
                const SizedBox(width: 4),
                _buildLineTab('L-64', 'Línea 64', 'l64', logic),
                const SizedBox(width: 4),
                _buildLineTab('COL', 'Colonial', 'col', logic),
              ],
            ),
          ),
          _buildPanelSection(
            title: 'TAMAÑO DE PIEZA',
            hint: 'STEP 2',
            child: Wrap(
              spacing: 4, runSpacing: 4,
              children: [
                SizedBox(width: 70, child: _buildSizeChip('20x20', '20x20', logic)),
                SizedBox(width: 70, child: _buildSizeChip('30x30', '30x30', logic)),
                SizedBox(width: 70, child: _buildSizeChip('40x40', '40x40', logic)),
                SizedBox(width: 70, child: _buildSizeChip('50x50', '50x50', logic)),
                SizedBox(width: 70, child: _buildSizeChip('60x60', '60x60', logic)),
                SizedBox(width: 70, child: _buildSizeChip('Custom', 'custom', logic)),
              ],
            ),
          ),
          _buildPanelSection(
            title: 'COLOR DE PASTA',
            hint: 'STEP 3',
            child: DrawerEdicionBase(logic: trabajoLogic, pigmentosDisponibles: pigmentos),
          ),
          _buildPanelSection(
            title: 'GRANULOMETRÍA MÁRMOL',
            hint: 'STEP 4',
            child: SizedBox(
              height: 400,
              child: DrawerEdicionGrano(logic: trabajoLogic, pigmentosDisponibles: pigmentos, granosDisponibles: granos),
            ),
          ),
          _buildPanelSection(
            title: 'SIMULADOR DALTONISMO',
            hint: 'ACC',
            child: _buildCvdPills(logic),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelSection({required String title, required String hint, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.borderPanel)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppTheme.textMuted,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  hint,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildLineTab(String code, String name, String id, Configurador2DLogic logic) {
    final isActive = logic.activeLine == id;
    return Expanded(
      child: Semantics(
        label: 'Línea $name',
        selected: isActive,
        button: true,
        child: GestureDetector(
          onTap: () => logic.setActiveLine(id),
          child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.brandTerra.withOpacity(0.12) : AppTheme.surfaceCard,
            border: Border.all(
              color: isActive ? AppTheme.brandTerra : AppTheme.borderSubtle,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                code,
                style: const TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppTheme.textMuted,
                ),
              ),
              if (isActive)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 20,
                  height: 2,
                  decoration: const BoxDecoration(
                    color: AppTheme.brandTerra,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                  ),
                ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildSizeChip(String label, String id, Configurador2DLogic logic) {
    final isActive = logic.activeSize == id;
    return Semantics(
      label: 'Tamaño $label',
      selected: isActive,
      button: true,
      child: GestureDetector(
        onTap: () => logic.setActiveSize(id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.brandCobalt.withOpacity(0.25) : AppTheme.surfaceCard,
            border: Border.all(
              color: isActive ? AppTheme.brandCobalt : AppTheme.borderSubtle,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isActive ? const Color(0xFF7EB3E8) : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }






  // End of right panel utilities

  Widget _buildCenterCanvas(Configurador2DLogic logic, TrabajoLogic trabajoLogic) {
    return Expanded(
      child: Center(
        child: Container(
          width: 480,
          height: 480,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 64, offset: const Offset(0, 24)),
              BoxShadow(color: const Color(0xFFC8741A).withOpacity(0.06), blurRadius: 80),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: MosaicoViewer(
                  modoDaltonismoOverride: logic.activeCvd == 'normal' ? 'Ninguno' : (logic.activeCvd == 'protan' ? 'Protanopía' : (logic.activeCvd == 'deuter' ? 'Deuteranopía' : 'Tritanopía')),
                ),
              ),
              if (logic.activeCvd != 'normal')
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF333344)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.visibility_off, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          'Simulando ${logic.activeCvd.toUpperCase()}',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel(Configurador2DLogic logic, TrabajoLogic trabajoLogic) {
    // Calculo dinámico usando crearRecetaActual (dummy de nombre)
    final receta = trabajoLogic.crearRecetaActual('Provisional');
    final rendimientoM2 = receta.rendimientoKgPorM2;
    final pesoPieza = rendimientoM2 / 6.25;

    return Container(
      width: 320,
      color: const Color(0xFF1E1E2C),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ACCESIBILIDAD VISUAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                  const SizedBox(height: 12),
                  const Text('Simulación Daltonismo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white)),
                  const SizedBox(height: 8),
                  _buildCvdPills(logic),
                  
                  const SizedBox(height: 32),
                  const Text('ESPECIFICACIONES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  
                  _buildSpecRow('Formato', '40x40 cm'),
                  _buildSpecRow('Espesor Nominal', '33 mm'),
                  _buildSpecRow('Peso aprox.', '${pesoPieza.toStringAsFixed(1)} kg/pz'),
                  _buildSpecRow('Rendimiento', '${rendimientoM2.toStringAsFixed(1)} kg/m²'),
                  
                  const SizedBox(height: 32),
                  _buildValidationCard(logic),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF333344)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navegación al Carrito no implementada aún.')));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC8741A), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text('GENERAR PEDIDO', style: TextStyle(fontFamily: 'Syne', fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await _mostrarDialogoGuardar(context, trabajoLogic);
                        },
                        icon: const Icon(Icons.save, size: 14),
                        label: const Text('Guardar'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Renderizando matriz 4K Voronoi...')));
                          try {
                            final cvdStr = logic.activeCvd == 'normal' ? 'Ninguno' : (logic.activeCvd == 'protan' ? 'Protanopía' : (logic.activeCvd == 'deuter' ? 'Deuteranopía' : 'Tritanopía'));
                            await ImageExportService.exportarImagenAltaResolucion(
                              trabajoLogic, 
                              cvdStr
                            );
                            if (context.mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imagen guardada con éxito', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green));
                            }
                          } catch (e) {
                             if (context.mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                             }
                          }
                        },
                        icon: const Icon(Icons.image, size: 14),
                        label: const Text('Render 4K'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoGuardar(BuildContext context, TrabajoLogic trabajoLogic) async {
    final controller = TextEditingController(text: 'Mi Diseño Personalizado');
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3C),
        title: const Text('Guardar Diseño', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
             labelText: 'Nombre del lote/receta',
             labelStyle: TextStyle(color: Colors.grey),
             enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF3D3D52))),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC8741A)), child: const Text('Guardar', style: TextStyle(color: Colors.white))),
        ],
      )
    );
    
    if (result == true && controller.text.isNotEmpty && context.mounted) {
      await trabajoLogic.guardarDisenoActual(controller.text, 'Diseño guardado desde el Configurador Visual 2D');
      if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lote configurado: ${controller.text} guardado con éxito', style: const TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green));
      }
    }
  }

  Widget _buildCvdPills(Configurador2DLogic logic) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _buildCvdPill('Normal', 'normal', const Color(0xFF4CAF50), logic),
        _buildCvdPill('Protanopia', 'protan', const Color(0xFFFF5252), logic),
        _buildCvdPill('Deuteranopia', 'deuter', const Color(0xFFFF9800), logic),
        _buildCvdPill('Tritanopia', 'tritan', const Color(0xFF2196F3), logic),
      ],
    );
  }

  Widget _buildCvdPill(String label, String id, Color dotColor, Configurador2DLogic logic) {
    final isActive = logic.activeCvd == id;
    return Semantics(
      label: 'Filtro de daltonismo $label',
      selected: isActive,
      button: true,
      child: GestureDetector(
        onTap: () => logic.setActiveCvd(id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? dotColor.withOpacity(0.1) : const Color(0xFF2A2A3C),
            border: Border.all(color: isActive ? dotColor : const Color(0xFF3D3D52)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor)),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 11, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, color: isActive ? dotColor : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSpecCard({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3D3D52)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildValidationCard(Configurador2DLogic logic) {
    return _buildSpecCard(
      icon: Icons.check_circle_outline,
      title: 'Validación WCAG 2.1 AA',
      children: [
        _buildValRow('Contraste texto', '7.2:1', true),
        _buildValRow('Navegación teclado', '2.1.1', true),
        _buildValRow('Etiquetas ARIA', '4.1.2', true),
        _buildValRow('Color no es único', '1.4.1', true),
      ],
    );
  }

  Widget _buildValRow(String title, String badge, bool pass) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(pass ? Icons.check : Icons.warning, size: 12, color: pass ? Colors.green.shade400 : Colors.amber),
          const SizedBox(width: 6),
          Expanded(child: Text(title, style: TextStyle(fontSize: 11, color: pass ? Colors.green.shade300 : Colors.amber))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: pass ? Colors.green.withOpacity(0.1) : Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(badge, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: pass ? Colors.green.shade400 : Colors.amber)),
          ),
        ],
      ),
    );
  }
}
