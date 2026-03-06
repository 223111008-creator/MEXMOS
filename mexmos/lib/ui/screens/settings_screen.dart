import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/accesibilidad_logic.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accesibilidadLogic = context.watch<AccesibilidadLogic>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes Globales'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Accesibilidad Visual',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Filtro de Daltonismo'),
            subtitle: const Text(
                'Simula o corrige deficiencias de visión de color en toda la app.'),
            trailing: DropdownButton<String>(
              value: accesibilidadLogic.modoDaltonismo,
              items: const [
                DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                DropdownMenuItem(
                    value: 'Protanopia', child: Text('Protanopia (Rojo)')),
                DropdownMenuItem(
                    value: 'Deuteranopia', child: Text('Deuteranopia (Verde)')),
                DropdownMenuItem(
                    value: 'Tritanopia', child: Text('Tritanopia (Azul)')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  accesibilidadLogic.cambiarModo(newValue);
                }
              },
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Modo Alto Contraste'),
            subtitle: const Text(
                'Aplica un tema oscuro para resaltar colores brillantes.'),
            value: accesibilidadLogic.altoContraste,
            onChanged: accesibilidadLogic.toggleAltoContraste,
          ),
          const Divider(),
          ListTile(
            title: const Text('Tamaño de Interfaz y Texto'),
            subtitle: const Text(
                'Ajusta la escala global de los elementos visuales.'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('A', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Slider(
                    value: accesibilidadLogic.escalaTexto,
                    min: 1.0,
                    max: 1.5,
                    divisions: 5,
                    label: '${(accesibilidadLogic.escalaTexto * 100).round()}%',
                    onChanged: accesibilidadLogic.cambiarEscalaTexto,
                  ),
                ),
                const Text('A',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Nota: Estos ajustes se aplican a toda la aplicación instantáneamente para cumplir con los estándares de accesibilidad industrial.',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          )
        ],
      ),
    );
  }
}
