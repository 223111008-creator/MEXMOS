import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../logic/configurador_logic.dart';

/// Pantalla de Configurador - Donde usuarios eligen colores para sus mosaicos
class ConfiguradorScreen extends StatefulWidget {
  const ConfiguradorScreen({super.key});

  @override
  State<ConfiguradorScreen> createState() => _ConfiguradorScreenState();
}

class _ConfiguradorScreenState extends State<ConfiguradorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.configuradorTitle),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.configuradorTitle,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.configuradorSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              // Stack de SVG del mosaico (Fondo + Figura + Borde)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                padding: const EdgeInsets.all(AppConstants.paddingDefault),
                height: 300,
                child: const Center(
                  child: Text('Visor de Mosaico (Stack SVG)'),
                ),
              ),
              const SizedBox(height: 24),
              // Selector de colores accesible
              Text(
                'Selecciona tu Color',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                padding: const EdgeInsets.all(AppConstants.paddingDefault),
                child: const Center(
                  child: Text('Selector de Colores'),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/resumen');
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(AppConstants.botonVerResumen),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
