import 'package:flutter/material.dart';
import '../../logic/trabajo_logic.dart';
import '../../domain/services/transformador_color.dart';

class DrawerEdicionCapas extends StatelessWidget {
  final TrabajoLogic logic;

  const DrawerEdicionCapas({
    super.key,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    final capas = logic.capasGrano;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Capas de Grano',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          if (capas.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Aún no hay capas de grano añadidas.'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: capas.length,
                itemBuilder: (context, index) {
                  final capa = capas[index];
                  final colorOriginal =
                      Color(capa.grano.colorNatural | 0xFF000000);

                  // Color del pigmento o color natural si no está pigmentado
                  final colorMostrar = capa.pigmento != null
                      ? TransformadorColor.hexToColor(capa.pigmento!.codigoHex)
                      : colorOriginal;

                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: TransformadorColor.aplicarFiltro(colorMostrar,
                              'Normal'), // O el modo actual si es global
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                      title: Text(capa.grano.nombre),
                      subtitle: Text('Tamaño: ${capa.grano.codigoTamano} | '
                          'Pigmento: ${capa.pigmento?.nombreComercial ?? "Ninguno"} | '
                          'Densidad: ${(capa.densidad * 100).round()}%'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Eliminar capa',
                        onPressed: () => logic.eliminarCapaGrano(capa.id),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
