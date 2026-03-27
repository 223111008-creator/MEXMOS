import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import '../../logic/trabajo_logic.dart';
import '../../data/repositories/mosaico_repositories.dart';
import '../../domain/services/traductor_diseno_service.dart';
import '../../domain/services/pdf_generator_service.dart';
import '../../domain/models/ficha_tecnica.dart';
import '../../domain/models/insumo.dart';
import '../app_theme.dart';

class ResumenMRPScreen extends StatefulWidget {
  const ResumenMRPScreen({super.key});

  @override
  State<ResumenMRPScreen> createState() => _ResumenMRPScreenState();
}

class _ResumenMRPScreenState extends State<ResumenMRPScreen> {
  final _traductor = TraductorDisenoService();
  final _repository = MosaicoRepository();
  double _metrosCuadrados = 10.0;
  double _mermaPorcentaje = 5.0; // 5%

  FichaTecnica? _fichaActual;

  @override
  void initState() {
    super.initState();
    // Calcular inicialmente con valores por defecto en el siguiente frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recalcular();
    });
  }

  Future<void> _recalcular() async {
    final logic = context.read<TrabajoLogic>();
    final receta = logic.crearRecetaActual("borrador");

    // Build baseDatosInsumos from the repository's local _insumosDB data
    // by fetching each insumo referenced in the recipe
    final Map<String, Insumo> baseDatosInsumos = {};
    final insumoIds = <String>{};

    // Collect all insumo IDs referenced in the recipe
    for (final pigReceta in receta.pigmentos) {
      insumoIds.add(pigReceta.pigmento.insumoRelacionadoId);
    }
    for (final granoReceta in receta.granos) {
      insumoIds.add(granoReceta.grano.insumoRelacionadoId);
    }
    // Also collect from pasta base
    insumoIds.add(receta.pastaBase.cementoInsumoId);
    insumoIds.add(receta.pastaBase.marmolinaInsumoId);

    for (final id in insumoIds) {
      final insumo = await _repository.obtenerInsumoPorId(id);
      if (insumo != null) {
        baseDatosInsumos[id] = insumo;
      }
    }

    final ficha = _traductor.calcularProduccion(
      receta: receta,
      metrosCuadrados: _metrosCuadrados,
      margenMerma: _mermaPorcentaje / 100.0,
      pedidoId: 'tmp_PEDIDO',
      baseDatosInsumos: baseDatosInsumos,
    );

    if (mounted) {
      setState(() {
        _fichaActual = ficha;
      });
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
            'Ficha Técnica (MRP)',
            style: GoogleFonts.syne(
              color: AppTheme.brandTerra,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          iconTheme: const IconThemeData(color: AppTheme.textPrimary),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: Text(
                'PDF',
                style: GoogleFonts.syne(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.brandTerra,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              onPressed: () async {
                if (_fichaActual == null) return;
                final pdfService = PdfGeneratorService();
                final bytes =
                    await pdfService.generarFichaTecnicaPDF(_fichaActual!);
                await Printing.sharePdf(
                    bytes: bytes, filename: 'mrp_${_fichaActual!.id}.pdf');
              },
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Row(
          children: [
            // Panel Izquierdo: Parámetros de Producción
            Expanded(
              flex: 1,
              child: Container(
                color: AppTheme.surfacePanel,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PARÁMETROS DE PRODUCCIÓN',
                      style: GoogleFonts.syne(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textMuted,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Slider de Metros Cuadrados
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderPanel),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Área a cubrir',
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            '${_metrosCuadrados.toStringAsFixed(1)} m²',
                            style: GoogleFonts.syne(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Slider(
                            value: _metrosCuadrados,
                            min: 1.0,
                            max: 100.0,
                            divisions: 99,
                            activeColor: AppTheme.brandTerra,
                            label: '${_metrosCuadrados.round()} m²',
                            onChanged: (val) {
                              setState(() => _metrosCuadrados = val);
                              _recalcular();
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Slider de Merma
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderPanel),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Margen de Merma/Desperdicio',
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            '${_mermaPorcentaje.round()}%',
                            style: GoogleFonts.syne(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Slider(
                            value: _mermaPorcentaje,
                            min: 0.0,
                            max: 20.0,
                            divisions: 20,
                            activeColor: AppTheme.brandTerra,
                            label: '${_mermaPorcentaje.round()}%',
                            onChanged: (val) {
                              setState(() => _mermaPorcentaje = val);
                              _recalcular();
                            },
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                    if (_fichaActual != null) ...[
                      Divider(color: AppTheme.borderPanel),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Masa Bruta Requerida:',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        trailing: Text(
                          '${_fichaActual!.totalKg.toStringAsFixed(2)} kg',
                          style: GoogleFonts.syne(
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Costo Est. Materiales:',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        trailing: Text(
                          '\$${_fichaActual!.insumosRequeridos.fold(0.0, (sum, L) => sum + (L.cantidadTotalKg * L.insumo.costoPorKg)).toStringAsFixed(2)}',
                          style: GoogleFonts.syne(
                            fontSize: 20,
                            color: AppTheme.brandTerra,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),

            // Panel Derecho: Lista de Materiales (BOM)
            Expanded(
              flex: 2,
              child: Container(
                color: AppTheme.surfaceDark,
                child: _fichaActual == null
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.brandTerra,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LISTA DE MATERIALES (BOM)',
                              style: GoogleFonts.syne(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textMuted,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Desglose técnico calculado para mezclas en planta.',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.separated(
                                itemCount:
                                    _fichaActual!.insumosRequeridos.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final linea =
                                      _fichaActual!.insumosRequeridos[index];
                                  return Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceCard,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: AppTheme.borderPanel),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: AppTheme.surfaceHover,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            linea.insumo.unidadMedida == 'l'
                                                ? Icons.water_drop
                                                : Icons.kitchen,
                                            color: AppTheme.brandTerra,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                linea.insumo.nombre,
                                                style: GoogleFonts.dmSans(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.textPrimary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                'ID: ${linea.insumo.id} · ${linea.insumo.tipo.name}',
                                                style: GoogleFonts.dmSans(
                                                  fontSize: 11,
                                                  color: AppTheme.textMuted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${linea.cantidadTotalKg.toStringAsFixed(2)} ${linea.insumo.unidadMedida}',
                                              style: GoogleFonts.syne(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.textPrimary,
                                              ),
                                            ),
                                            Text(
                                              '\$${(linea.cantidadTotalKg * linea.insumo.costoPorKg).toStringAsFixed(2)}',
                                              style: GoogleFonts.dmSans(
                                                color: AppTheme.brandTerra,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
