import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/trabajo_logic.dart';
import '../widgets/drawer_vertical.dart';
import '../widgets/placeholder_visor.dart';
import '../widgets/drawer_edicion_placeholder.dart';

class TrabajoScreen extends StatelessWidget {
  const TrabajoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrabajoLogic(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Diseñador de Mosaicos'),
        ),
        body: Consumer<TrabajoLogic>(
          builder: (context, logic, child) {
            return Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drawer vertical izquierdo
                      DrawerVertical(
                        opcionSeleccionada: logic.opcionSeleccionada,
                        onOpcionSeleccionada: logic.seleccionarOpcion,
                      ),
                      // Área central del visor
                      Expanded(
                        child: Center(
                          child: PlaceholderVisor(tamano: MediaQuery.of(context).size.width * 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                // Drawer de edición inferior
                DrawerEdicionPlaceholder(opcionSeleccionada: logic.opcionSeleccionada),
              ],
            );
          },
        ),
      ),
    );
  }
}