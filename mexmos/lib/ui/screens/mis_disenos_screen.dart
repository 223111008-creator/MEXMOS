import 'package:flutter/material.dart';
import '../../data/repositories/mosaico_repositories.dart';
import '../../domain/models/receta.dart';
import 'package:provider/provider.dart';
import '../../logic/trabajo_logic.dart';

class MisDisenosScreen extends StatefulWidget {
  const MisDisenosScreen({super.key});

  @override
  State<MisDisenosScreen> createState() => _MisDisenosScreenState();
}

class _MisDisenosScreenState extends State<MisDisenosScreen> {
  final MosaicoRepository _repository = MosaicoRepository();
  late Future<List<Receta>> _disenosFuture;

  @override
  void initState() {
    super.initState();
    _disenosFuture = _repository.obtenerMisDisenos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Diseños Guardados'),
      ),
      body: FutureBuilder<List<Receta>>(
        future: _disenosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar diseños: ${snapshot.error}'));
          }

          final recetas = snapshot.data ?? [];

          if (recetas.isEmpty) {
            return const Center(
              child: Text(
                'Aún no has guardado ningún diseño en la nube.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recetas.length,
            itemBuilder: (context, index) {
              final receta = recetas[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.grid_on, color: Colors.white),
                  ),
                  title: Text(receta.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(receta.descripcion ?? 'Sin descripción'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Cargar la receta en el Workspace y navegar
                    context.read<TrabajoLogic>().inicializarConReceta(receta);
                    Navigator.pushReplacementNamed(context, '/trabajo');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
