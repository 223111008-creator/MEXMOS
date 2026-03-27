import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../logic/accesibilidad_logic.dart';
import '../app_theme.dart';
import '../widgets/panel_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accesibilidadLogic = context.watch<AccesibilidadLogic>();

    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppTheme.surfacePanel,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: AppTheme.textSecondary, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'AJUSTES GLOBALES',
          style: GoogleFonts.syne(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.brandTerra,
            letterSpacing: 1.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.borderPanel),
        ),
      ),
      body: ListView(
        children: [
          // ── Accesibilidad Visual ──────────────────────────────────────
          PanelSection(
            title: 'Accesibilidad Visual',
            child: Column(
              children: [
                // Filtro de Daltonismo
                _SettingRow(
                  label: 'Filtro de Daltonismo',
                  description:
                      'Simula o corrige deficiencias de visión de color en toda la app.',
                  control: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.borderPanel),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: accesibilidadLogic.modoDaltonismo,
                        dropdownColor: AppTheme.surfaceCard,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: AppTheme.textPrimary,
                        ),
                        iconEnabledColor: AppTheme.textMuted,
                        items: const [
                          DropdownMenuItem(
                              value: 'Normal', child: Text('Normal')),
                          DropdownMenuItem(
                              value: 'Protanopia',
                              child: Text('Protanopia (Rojo)')),
                          DropdownMenuItem(
                              value: 'Deuteranopia',
                              child: Text('Deuteranopia (Verde)')),
                          DropdownMenuItem(
                              value: 'Tritanopia',
                              child: Text('Tritanopia (Azul)')),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            accesibilidadLogic.cambiarModo(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Modo Alto Contraste
                _SettingRow(
                  label: 'Modo Alto Contraste',
                  description:
                      'Aplica un tema oscuro para resaltar colores brillantes.',
                  control: Switch(
                    value: accesibilidadLogic.altoContraste,
                    onChanged: accesibilidadLogic.toggleAltoContraste,
                    activeColor: AppTheme.brandTerra,
                    activeTrackColor: AppTheme.brandTerra.withOpacity(0.3),
                    inactiveThumbColor: AppTheme.textMuted,
                    inactiveTrackColor: AppTheme.surfaceHover,
                  ),
                ),
              ],
            ),
          ),

          // ── Tamaño de Interfaz ────────────────────────────────────────
          PanelSection(
            title: 'Tamaño de Interfaz y Texto',
            hint: '${(accesibilidadLogic.escalaTexto * 100).round()}%',
            showDivider: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ajusta la escala global de los elementos visuales.',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'A',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: AppTheme.brandTerra,
                          inactiveTrackColor: AppTheme.surfaceHover,
                          thumbColor: AppTheme.brandTerra,
                          overlayColor: AppTheme.brandTerra.withOpacity(0.12),
                          trackHeight: 2,
                        ),
                        child: Slider(
                          value: accesibilidadLogic.escalaTexto,
                          min: 1.0,
                          max: 1.5,
                          divisions: 5,
                          label:
                              '${(accesibilidadLogic.escalaTexto * 100).round()}%',
                          onChanged: accesibilidadLogic.cambiarEscalaTexto,
                        ),
                      ),
                    ),
                    Text(
                      'A',
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Nota informativa ─────────────────────────────────────────
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfacePanel,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.borderPanel),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline,
                      color: AppTheme.textMuted, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Estos ajustes se aplican a toda la aplicación '
                      'instantáneamente para cumplir con los estándares '
                      'de accesibilidad industrial.',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A two-column row for a setting label + its control widget.
class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.description,
    required this.control,
  });

  final String label;
  final String description;
  final Widget control;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderPanel),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          control,
        ],
      ),
    );
  }
}
