import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/trabajo_logic.dart';
import '../../domain/services/traductor_diseno_service.dart';
import '../../domain/services/pdf_generator_service.dart';
import '../../domain/models/ficha_tecnica.dart';
import 'package:printing/printing.dart';

class ResumenMRPScreen extends StatefulWidget {
  const ResumenMRPScreen({super.key});

  @override
  State<ResumenMRPScreen> createState() => _ResumenMRPScreenState();
}

class _ResumenMRPScreenState extends State<ResumenMRPScreen> {
  final _traductor = TraductorDisenoService();
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

  void _recalcular() {
    final logic = context.read<TrabajoLogic>();
    final receta = logic.crearRecetaActual("borrador");

    // Si no hubiera un servicio completo, creamos un set de insumos vacío,
    // el traductor proveerá valores genéricos estandarizados
    final ficha = _traductor.calcularProduccion(
      receta: receta,
      metrosCuadrados: _metrosCuadrados,
      margenMerma: _mermaPorcentaje / 100.0,
      pedidoId: 'tmp_PEDIDO',
      baseDatosInsumos: {}, // Aquí se inyectaría un provder real de inventario
    );

    setState(() {
      _fichaActual = ficha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha Técnica (MRP)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Exportar PDF',
            onPressed: () async {
              if (_fichaActual == null) return;
              final pdfService = PdfGeneratorService();
              final bytes =
                  await pdfService.generarFichaTecnicaPDF(_fichaActual!);
              await Printing.sharePdf(
                  bytes: bytes, filename: 'mrp_${_fichaActual!.id}.pdf');
            },
          )
        ],
      ),
      body: Row(
        children: [
          // Panel Izquierdo: Parámetros de Producción
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Parámetros de Producción',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  // Slider de Metros Cuadrados
                  Text(
                      'Área a cubrir: ${_metrosCuadrados.toStringAsFixed(1)} m²'),
                  Slider(
                    value: _metrosCuadrados,
                    min: 1.0,
                    max: 100.0,
                    divisions: 99,
                    label: '${_metrosCuadrados.round()} m²',
                    onChanged: (val) {
                      setState(() => _metrosCuadrados = val);
                      _recalcular();
                    },
                  ),

                  const SizedBox(height: 16),

                  // Slider de Merma
                  Text(
                      'Margen de Merma/Desperdicio: ${_mermaPorcentaje.round()}%'),
                  Slider(
                    value: _mermaPorcentaje,
                    min: 0.0,
                    max: 20.0,
                    divisions: 20,
                    label: '${_mermaPorcentaje.round()}%',
                    onChanged: (val) {
                      setState(() => _mermaPorcentaje = val);
                      _recalcular();
                    },
                  ),

                  const Spacer(),
                  if (_fichaActual != null) ...[
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Masa Bruta Requerida:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(
                          '${_fichaActual!.totalKg.toStringAsFixed(2)} kg',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.blueAccent)),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Costo Est. Materiales:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(
                          '\$${_fichaActual!.insumosRequeridos.fold(0.0, (sum, L) => sum + (L.cantidadTotalKg * L.insumo.costoPorKg)).toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ),
                  ]
                ],
              ),
            ),
          ),

          // Panel Derecho: Lista de Materiales (BOM)
          Expanded(
            flex: 2,
            child: _fichaActual == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Lista de Materiales (BOM)',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const Text(
                            'Desglose técnico calculado para mezclas en planta.'),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.separated(
                            itemCount: _fichaActual!.insumosRequeridos.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final linea =
                                  _fichaActual!.insumosRequeridos[index];
                              return ListTile(
                                leading: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Icon(
                                      linea.insumo.unidadMedida == 'l'
                                          ? Icons.water_drop
                                          : Icons.kitchen,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                                title: Text(linea.insumo.nombre,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                    'ID: ${linea.insumo.id} • ${linea.insumo.tipo.name}'),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${linea.cantidadTotalKg.toStringAsFixed(2)} ${linea.insumo.unidadMedida}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '\$${(linea.cantidadTotalKg * linea.insumo.costoPorKg).toStringAsFixed(2)}',
                                      style:
                                          const TextStyle(color: Colors.green),
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
        ],
      ),
    );
  }
}
