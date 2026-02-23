import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../logic/configurador_logic.dart';
import '../../data/repositories/mosaico_repositories.dart'; // CORREGIDO
import '../../domain/models/pigmento.dart';
import '../../domain/models/grano_marmol.dart';
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
      return Scaffold(
        appBar: AppBar(title: const Text(AppConstants.configuradorTitle)),
        body: const Center(child: Text('Error: No se ha seleccionado receta.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.configuradorTitle),
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
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar catálogo: ${snapshot.error}'));
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Divider(height: 30),
                
                const Text('Escala de producción (m²):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: configLogic.metrosCuadrados,
                        min: 1.0,
                        max: 100.0,
                        divisions: 99,
                        onChanged: (val) => configLogic.actualizarMetros(val),
                      ),
                    ),
                    Text('${configLogic.metrosCuadrados.round()} m²', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 20),

                ...receta.pigmentos.map((pigReceta) {
                  final pigmentoOriginal = pigReceta.pigmento;
                  final pigmentoActual = configLogic.pigmentosSeleccionados[pigmentoOriginal.id] ?? pigmentoOriginal;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ColorPickerAccesible(
                      etiqueta: 'Reemplazar color: ${pigmentoOriginal.nombreComercial}',
                      pigmentosDisponibles: pigmentosDisponibles,
                      pigmentoSeleccionado: pigmentoActual,
                      modoDaltonismo: _modoDaltonismo,
                      onPigmentoSeleccionado: (nuevoPigmento) {
                        configLogic.personalizarPigmento(pigmentoOriginal.id, nuevoPigmento);
                      },
                    ),
                  );
                }),

                ...receta.granos.map((granoReceta) {
                  final granoOriginal = granoReceta.grano;
                  final granoActual = configLogic.granosSeleccionados[granoOriginal.id] ?? granoOriginal;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GranoPickerAccesible(
                      etiqueta: 'Reemplazar grano: ${granoOriginal.nombre}',
                      granosDisponibles: granosDisponibles,
                      granoSeleccionado: granoActual,
                      modoDaltonismo: _modoDaltonismo,
                      onGranoSeleccionado: (nuevoGrano) {
                        configLogic.personalizarGrano(granoOriginal.id, nuevoGrano);
                      },
                    ),
                  );
                }),

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/resumen'),
                    child: const Text('Calcular Ficha Técnica', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}