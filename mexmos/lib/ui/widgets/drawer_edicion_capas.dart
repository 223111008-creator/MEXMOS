// lib/ui/widgets/drawer_edicion_capas.dart
import 'package:flutter/material.dart';
import '../../logic/trabajo_logic.dart';

class DrawerEdicionCapas extends StatelessWidget {
  final TrabajoLogic logic;

  const DrawerEdicionCapas({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final capas = logic.capasGrano;

    if (capas.isEmpty) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text('No hay granos en la mezcla.\nVe a "Grano" para añadir aditivos.', textAlign: TextAlign.center),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: capas.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final capa = capas[index];
          final colorTexto = capa.pigmento != null 
              ? 'Teñido: ${capa.pigmento!.nombre}' 
              : 'Color natural';

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.grain, color: Colors.grey),
            ),
            title: Text(capa.grano.nombre),
            subtitle: Text('Densidad: ${(capa.densidad * 100).round()}% | $colorTexto'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => logic.eliminarCapaGrano(capa.id),
              tooltip: 'Eliminar grano de la mezcla',
            ),
          );
        },
      ),
    );
  }
}