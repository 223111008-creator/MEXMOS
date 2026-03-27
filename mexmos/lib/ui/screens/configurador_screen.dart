import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/constants.dart';
import '../../logic/configurador_logic.dart';
import '../../data/repositories/mosaico_repositories.dart';
import '../../domain/models/pigmento.dart';
import '../../domain/models/grano_marmol.dart';
import '../app_theme.dart';
import '../widgets/accessibility_control.dart';
import '../widgets/color_picker_accesible.dart';
import '../widgets/grano_picker_accesible.dart';

class ConfiguradorScreen extends StatefulWidget {
  const ConfiguradorScreen({super.key});

  @override
  State<ConfiguradorScreen> createState() => _ConfiguradorScreenState();
}

class _ConfiguradorScreenState extends State<ConfiguradorScreen> {
  final MosaicoRepository _repository = MosaicoRepository();
  late Future<List<dynamic>> _catalogosFuture;
  String _modoDaltonismo = 'Normal';

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
    final configLogic = context.watch<ConfiguradorLogic>();
    final receta = configLogic.recetaSeleccionada;

    if (receta == null) {
      return Theme(
        data: AppTheme.darkTheme,
        child: Scaffold(
          backgroundColor: AppTheme.surfaceDark,
          appBar: AppBar(
            backgroundColor: AppTheme.surfacePanel,
            elevation: 0,
            title: Text(
              AppConstants.configuradorTitle,
              style: GoogleFonts.syne(
                color: AppTheme.brandTerra,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            iconTheme: const IconThemeData(color: AppTheme.textPrimary),
          ),
          body: Center(
            child: Text(
              'Error: No se ha seleccionado receta.',
              style: GoogleFonts.dmSans(color: AppTheme.textSecondary),
            ),
          ),
        ),
      );
    }

    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        backgroundColor: AppTheme.surfaceDark,
        appBar: AppBar(
          backgroundColor: AppTheme.surfacePanel,
          elevation: 0,
          title: Text(
            AppConstants.configuradorTitle,
            style: GoogleFonts.syne(
              color: AppTheme.brandTerra,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          iconTheme: const IconThemeData(color: AppTheme.textPrimary),
          actions: [
            AccessibilityControl(
              modoActual: _modoDaltonismo,
              onModoCambiado: (nuevoModo) {
                setState(() => _modoDaltonismo = nuevoModo);
              },
            ),
          ],
        ),
        body: FutureBuilder<List<dynamic>>(
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
                  'Error al cargar catálogo: ${snapshot.error}',
                  style: GoogleFonts.dmSans(color: AppTheme.textSecondary),
                ),
              );
            }

            final List<Pigmento> pigmentosDisponibles = snapshot.data![0];
            final List<GranoMarmol> granosDisponibles = snapshot.data![1];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receta: ${receta.nombre}',
                    style: GoogleFonts.syne(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Divider(height: 30, color: AppTheme.borderPanel),

                  // Section: Escala de producción
                  Text(
                    'ESCALA DE PRODUCCIÓN',
                    style: GoogleFonts.syne(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderPanel),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: configLogic.metrosCuadrados,
                            min: 1.0,
                            max: 100.0,
                            divisions: 99,
                            activeColor: AppTheme.brandTerra,
                            onChanged: (val) =>
                                configLogic.actualizarMetros(val),
                          ),
                        ),
                        Text(
                          '${configLogic.metrosCuadrados.round()} m²',
                          style: GoogleFonts.syne(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Pigment pickers
                  ...receta.pigmentos.map((pigReceta) {
                    final pigmentoOriginal = pigReceta.pigmento;
                    final pigmentoActual =
                        configLogic.pigmentosSeleccionados[pigmentoOriginal.id] ??
                            pigmentoOriginal;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ColorPickerAccesible(
                        etiqueta:
                            'Reemplazar color: ${pigmentoOriginal.nombreComercial}',
                        pigmentosDisponibles: pigmentosDisponibles,
                        pigmentoSeleccionado: pigmentoActual,
                        modoDaltonismo: _modoDaltonismo,
                        onPigmentoSeleccionado: (nuevoPigmento) {
                          configLogic.personalizarPigmento(
                              pigmentoOriginal.id, nuevoPigmento);
                        },
                      ),
                    );
                  }),

                  // Grain pickers
                  ...receta.granos.map((granoReceta) {
                    final granoOriginal = granoReceta.grano;
                    final granoActual =
                        configLogic.granosSeleccionados[granoOriginal.id] ??
                            granoOriginal;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: GranoPickerAccesible(
                        etiqueta: 'Reemplazar grano: ${granoOriginal.nombre}',
                        granosDisponibles: granosDisponibles,
                        granoSeleccionado: granoActual,
                        modoDaltonismo: _modoDaltonismo,
                        onGranoSeleccionado: (nuevoGrano) {
                          configLogic.personalizarGrano(
                              granoOriginal.id, nuevoGrano);
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandTerra,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/resumen'),
                      child: Text(
                        'Calcular Ficha Técnica',
                        style: GoogleFonts.syne(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
