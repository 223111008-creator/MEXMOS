import 'package:flutter/material.dart';

/// Tarjeta Accesible - Componente reutilizable para mostrar información
class AccesibleCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final Widget? contenido;
  final List<Widget>? acciones;
  final VoidCallback? onTap;
  final bool habilitado;

  const AccesibleCard({
    super.key,
    required this.titulo,
    required this.descripcion,
    this.contenido,
    this.acciones,
    this.onTap,
    this.habilitado = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: titulo,
      enabled: habilitado,
      onTap: onTap,
      child: Card(
        elevation: habilitado ? 2 : 0,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          onTap: habilitado ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  semanticsLabel: 'Título: $titulo',
                ),
                const SizedBox(height: 8),
                Text(
                  descripcion,
                  style: Theme.of(context).textTheme.bodyMedium,
                  semanticsLabel: 'Descripción: $descripcion',
                ),
                if (contenido != null) ...[
                  const SizedBox(height: 12),
                  contenido!,
                ],
                if (acciones != null && acciones!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: acciones!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
