// lib/ui/widgets/drawer_edicion_base.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/mosaic_physics.dart';
import '../../domain/models/pigmento.dart';
import '../../logic/trabajo_logic.dart';
import '../app_theme.dart';
import 'color_picker_accesible.dart';
import 'panel_section.dart';

class DrawerEdicionBase extends StatelessWidget {
  final TrabajoLogic logic;
  final List<Pigmento> pigmentosDisponibles;

  const DrawerEdicionBase({
    super.key,
    required this.logic,
    required this.pigmentosDisponibles,
  });

  Future<void> _mostrarDialogoColorPersonalizado(BuildContext context) async {
    Color tempColor = Colors.blue;
    final result = await showDialog<Color>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: AppTheme.surfaceCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppTheme.borderPanel),
            ),
            title: Text(
              'Configurar Nuevo Pigmento',
              style: GoogleFonts.syne(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: tempColor,
                onColorChanged: (color) {
                  tempColor = color;
                },
                enableAlpha: false,
                displayThumbColor: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancelar',
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
                onPressed: () => Navigator.pop(ctx, tempColor),
                child: Text(
                  'Añadir',
                  style: GoogleFonts.syne(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          );
        });

    if (result != null) {
      try {
        // Formatear Color a HEX ej. #FFFFFF
        final hexString =
            '#${result.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
        final nuevoPigmento = Pigmento.personalizado(hexString);
        logic.agregarPigmentoPersonalizado(nuevoPigmento);
        logic.seleccionarColorBase(nuevoPigmento);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al crear color.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfacePanel,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 280,
              child: PanelSection(
                title: 'Color de Base',
                padding: EdgeInsets.zero,
                child: ColorPickerAccesible(
                  pigmentosDisponibles: [
                    ...pigmentosDisponibles,
                    ...logic.pigmentosPersonalizados
                  ],
                  pigmentoSeleccionado: logic.colorBaseSeleccionado,
                  onPigmentoSeleccionado: logic.seleccionarColorBase,
                  onAddCustomColor: () =>
                      _mostrarDialogoColorPersonalizado(context),
                  etiqueta: 'Color de Base',
                ),
              ),
            ),
            const SizedBox(width: 24),
            SizedBox(
              width: 260,
              child: PanelSection(
                title: 'Opacidad',
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      slider: true,
                      label: 'Ajustar opacidad de la base',
                      child: Slider(
                        value: logic.opacidadBase,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        activeColor: AppTheme.brandTerra,
                        label: '${(logic.opacidadBase * 100).round()}%',
                        onChanged: logic.actualizarOpacidadBase,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0%',
                          style: GoogleFonts.dmSans(
                              fontSize: 10, color: AppTheme.textMuted),
                        ),
                        Text(
                          '${(logic.opacidadBase * 100).round()}%',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '100%',
                          style: GoogleFonts.dmSans(
                              fontSize: 10, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            SizedBox(
              width: 320,
              child: PanelSection(
                title: 'Intensidad del pigmento',
                hint: 'kg/m²',
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Slider(
                      value: logic.dosisPigmento,
                      min: MosaicPhysics.minDosisPigmento,
                      max: MosaicPhysics.maxDosisPigmento,
                      divisions: 12,
                      activeColor: AppTheme.brandTerra,
                      label:
                          '${(logic.dosisPigmento * 100).toStringAsFixed(1)}% de cemento'
                          ' · ${MosaicPhysics.kgPigmentoPorM2(MosaicPhysics.rendimientoBase, logic.dosisPigmento).toStringAsFixed(2)} kg/m²',
                      onChanged: (v) => logic.actualizarDosisPigmento(v),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(MosaicPhysics.minDosisPigmento * 100).toStringAsFixed(0)}%',
                          style: GoogleFonts.dmSans(
                              fontSize: 10, color: AppTheme.textMuted),
                        ),
                        Text(
                          '${(logic.dosisPigmento * 100).toStringAsFixed(1)}% · '
                          '${MosaicPhysics.kgPigmentoPorM2(MosaicPhysics.rendimientoBase, logic.dosisPigmento).toStringAsFixed(2)} kg/m²',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(MosaicPhysics.maxDosisPigmento * 100).toStringAsFixed(0)}%',
                          style: GoogleFonts.dmSans(
                              fontSize: 10, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
