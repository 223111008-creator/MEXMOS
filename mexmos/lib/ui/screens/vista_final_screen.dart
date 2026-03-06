import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/trabajo_logic.dart';
import '../../logic/accesibilidad_logic.dart';
import '../widgets/mosaico_viewer.dart';
import '../../domain/services/image_export_service.dart';

class VistaFinalScreen extends StatelessWidget {
  const VistaFinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<TrabajoLogic>();
    final accesibilidad = context.watch<AccesibilidadLogic>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acabado Final'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Descargar HD',
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Generando Imagen 2000x2000 px...')),
              );
              await ImageExportService.exportarImagenAltaResolucion(
                logic,
                accesibilidad.modoDaltonismo,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Descarga iniciada!')),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade900,
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: 1.0, // Mosaico siempre cuadrado
          child: Hero(
            tag: 'mosaico_viewer_hero',
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: MosaicoViewer(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
