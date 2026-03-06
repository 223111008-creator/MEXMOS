import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/trabajo_logic.dart';
import '../../logic/accesibilidad_logic.dart';
import '../../domain/services/transformador_color.dart';
import '../../core/rendering/voronoi_engine.dart';

class MosaicoViewer extends StatelessWidget {
  const MosaicoViewer({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios tanto de los diseños como de accesibilidad
    final trabajoLogic = context.watch<TrabajoLogic>();
    final accesibilidadLogic = context.watch<AccesibilidadLogic>();

    return AspectRatio(
      aspectRatio: 1, // Mantén la previsualización cuadrada para simplificar
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: CustomPaint(
          painter: MosaicoPainter(
            logic: trabajoLogic,
            modoDaltonismo: accesibilidadLogic.modoDaltonismo,
          ),
          child: Container(),
        ),
      ),
    );
  }
}

class MosaicoPainter extends CustomPainter {
  final TrabajoLogic logic;
  final String modoDaltonismo;

  MosaicoPainter({
    required this.logic,
    required this.modoDaltonismo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dibujar el fondo
    Color baseColor = Colors.grey.shade300; // Por defecto
    if (logic.colorBaseSeleccionado != null) {
      baseColor =
          TransformadorColor.hexToColor(logic.colorBaseSeleccionado!.codigoHex);
    }

    // Aplicar opacidad y filtro
    baseColor = baseColor.withOpacity(logic.opacidadBase);
    baseColor = TransformadorColor.aplicarFiltro(baseColor, modoDaltonismo);

    final bgPaint = Paint()..color = baseColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // CLIP RECT para que los limites del Voronoi (astillas) no desborden la zona de pintado.
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 2. Motor Geométrico: Calcular Diagramas de Voronoi (Power Diagram + Poisson Disk)
    final double escalaPixelesPorMm = size.width / 300.0;

    final engine = VoronoiEngine(
      width: size.width,
      height: size.height,
      offsetPasta: 1.0, // mm to pixel buffering (Pasta de cemento base)
    );

    final piedras = engine.generarSistema(logic.capasGrano, escalaPixelesPorMm);

    // 3. Renderizar Piedras de Mármol Procesadas
    for (var piedra in piedras) {
      Color colorGrano;
      if (piedra.capa.pigmento != null) {
        colorGrano =
            TransformadorColor.hexToColor(piedra.capa.pigmento!.codigoHex);
      } else {
        colorGrano = Color(piedra.capa.grano.colorNatural);
      }

      colorGrano = TransformadorColor.aplicarFiltro(colorGrano, modoDaltonismo);
      final capaPaint = Paint()..color = colorGrano;

      canvas.drawPath(piedra.path, capaPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MosaicoPainter oldDelegate) {
    // Si la lógica o estado profundo cambió
    // Lo más simple para el prototipo es retornar true para redibujar siempre
    return true;
  }
}
