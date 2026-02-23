import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../data/repositories/mosaico_repositories.dart'; // CORREGIDO
import '../../domain/services/calculador_produccion.dart';
import '../../domain/models/ficha_tecnica.dart';
import '../../logic/configurador_logic.dart';

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
      _calculoFuture = Future.error('No hay una configuración válida para calcular.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.resumenTitle)),
      body: FutureBuilder<FichaTecnica>(
        future: _calculoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(semanticsLabel: 'Calculando MRP...'), // CORREGIDO
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No se pudo generar la Ficha Técnica.'));
          }

          final ficha = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ficha Técnica Generada', style: Theme.of(context).textTheme.headlineSmall),
                Text('ID: ${ficha.id}', style: const TextStyle(color: Colors.grey)),
                const Divider(height: 30),
                Text(
                  'Total de mezcla sólida: ${ficha.totalKg.toStringAsFixed(2)} kg',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text('Insumos Requeridos:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                ...ficha.insumosRequeridos.map((linea) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: const Icon(Icons.check_box_outline_blank),
                      title: Text(linea.insumo.nombre),
                      trailing: Text(
                        '${linea.cantidadTotalKg.toStringAsFixed(2)} kg',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )),
                const Divider(height: 30),
                const Text('Instrucciones Operativas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ficha.instruccionesMezcla,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}