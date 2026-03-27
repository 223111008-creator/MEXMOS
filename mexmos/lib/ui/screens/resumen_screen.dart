import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/constants.dart';
import '../../data/repositories/mosaico_repositories.dart';
import '../../domain/services/calculador_produccion.dart';
import '../../domain/models/ficha_tecnica.dart';
import '../../logic/configurador_logic.dart';
import '../app_theme.dart';

class ResumenScreen extends StatefulWidget {
  const ResumenScreen({super.key});

  @override
  State<ResumenScreen> createState() => _ResumenScreenState();
}

class _ResumenScreenState extends State<ResumenScreen> {
  Future<FichaTecnica>? _calculoFuture;

  @override
  void initState() {
    super.initState();
    _ejecutarCalculoMRP();
  }

  void _ejecutarCalculoMRP() {
    final config = context.read<ConfiguradorLogic>().generarConfiguracion();

    if (config != null) {
      final repository = MosaicoRepository();
      final calculador = CalculadorProduccion(repository);
      _calculoFuture = calculador.generarFicha(config);
    } else {
      _calculoFuture =
          Future.error('No hay una configuración válida para calcular.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        backgroundColor: AppTheme.surfaceDark,
        appBar: AppBar(
          backgroundColor: AppTheme.surfacePanel,
          elevation: 0,
          title: Text(
            AppConstants.resumenTitle,
            style: GoogleFonts.syne(
              color: AppTheme.brandTerra,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        ),
        body: FutureBuilder<FichaTecnica>(
          future: _calculoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppTheme.brandTerra,
                  semanticsLabel: 'Calculando MRP...',
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(color: AppTheme.textSecondary),
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'No se pudo generar la Ficha Técnica.',
                  style: GoogleFonts.dmSans(color: AppTheme.textSecondary),
                ),
              );
            }

            final ficha = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ficha Técnica Generada',
                    style: GoogleFonts.syne(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'ID: ${ficha.id}',
                    style:
                        GoogleFonts.dmSans(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  Divider(height: 30, color: AppTheme.borderPanel),

                  // Content card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderPanel),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total de mezcla sólida: ${ficha.totalKg.toStringAsFixed(2)} kg',
                          style: GoogleFonts.syne(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppTheme.brandTerra,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'INSUMOS REQUERIDOS',
                          style: GoogleFonts.syne(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMuted,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...ficha.insumosRequeridos.asMap().entries.map((entry) {
                          final isLast =
                              entry.key == ficha.insumosRequeridos.length - 1;
                          final linea = entry.value;
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                leading: Icon(
                                  Icons.check_box_outline_blank,
                                  color: AppTheme.brandTerra,
                                ),
                                title: Text(
                                  linea.insumo.nombre,
                                  style: GoogleFonts.dmSans(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Text(
                                  '${linea.cantidadTotalKg.toStringAsFixed(2)} kg',
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                              if (!isLast)
                                Divider(
                                  height: 1,
                                  color: AppTheme.borderPanel,
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),

                  Divider(height: 30, color: AppTheme.borderPanel),

                  Text(
                    'INSTRUCCIONES OPERATIVAS',
                    style: GoogleFonts.syne(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfacePanel,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderPanel),
                    ),
                    child: Text(
                      ficha.instruccionesMezcla,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: AppTheme.textPrimary,
                      ).copyWith(fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
