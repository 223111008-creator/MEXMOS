import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../data/repositories/mosaico_repositories.dart'; // CORREGIDO
import '../../domain/models/receta.dart';
import '../../logic/trabajo_logic.dart';

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MosaicoRepository();

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.catalogoTitle)),
      body: FutureBuilder<List<Receta>>(
        future: repository.obtenerRecetasDisponibles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay recetas disponibles.'));
          }

          final recetas = snapshot.data!;
          return ListView.builder(
            itemCount: recetas.length,
            itemBuilder: (context, index) {
              final receta = recetas[index];
              return ListTile(
                leading: const Icon(Icons.grid_on, size: 36),
                title: Text(receta.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle:
                    Text('Rendimiento: ${receta.rendimientoKgPorM2} kg/m²'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.read<TrabajoLogic>().inicializarConReceta(receta);
                  Navigator.pushNamed(context, '/trabajo');
                },
              );
            },
          );
        },
      ),
    );
  }
}
