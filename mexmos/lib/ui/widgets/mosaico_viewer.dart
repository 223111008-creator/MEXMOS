import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/trabajo_logic.dart';
import '../../logic/accesibilidad_logic.dart';
import '../../domain/services/transformador_color.dart';
import '../../core/rendering/voronoi_engine.dart';
import '../../domain/models/capa_grano.dart';

class MosaicoViewer extends StatefulWidget {
  final String? modoDaltonismoOverride;

  const MosaicoViewer({
    super.key,
    this.modoDaltonismoOverride,
  });

  @override
  State<MosaicoViewer> createState() => _MosaicoViewerState();
}

class _MosaicoViewerState extends State<MosaicoViewer> {
  List<PiedraRenderizable>? _piedrasCacheadas;
  List<CapaGrano>? _ultimasCapas;
  double? _ultimoAncho;

  bool _capasSonIguales(List<CapaGrano> a, List<CapaGrano> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].grano.id != b[i].grano.id) return false;
      if (a[i].densidad != b[i].densidad) return false;
      if (a[i].pigmento?.codigoHex != b[i].pigmento?.codigoHex) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final trabajoLogic = context.watch<TrabajoLogic>();
    final accesibilidadLogic = context.watch<AccesibilidadLogic>();
    final modoDaltonismoApp =
        widget.modoDaltonismoOverride ?? accesibilidadLogic.modoDaltonismo;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;

          // Unir capas confirmadas con la capa que actualmente está en preview/edición
          final capasTotales = [...trabajoLogic.capasGrano];
          if (trabajoLogic.capaEnEdicion != null) {
            capasTotales.add(trabajoLogic.capaEnEdicion!);
          }

          // Recalcular SI y SÓLO SI las capas cambiaron O el tamaño físico cambió
          bool needsRecalc = _piedrasCacheadas == null ||
              _ultimasCapas == null ||
              !_capasSonIguales(_ultimasCapas!, capasTotales);
          if (!needsRecalc && _ultimoAncho != null) {
            if ((_ultimoAncho! - width).abs() > 2.0) needsRecalc = true;
          }
          if (needsRecalc) {
            final engine = VoronoiEngine(
              width: width,
              height: height,
              offsetPasta: 1.0,
            );
            final escalaPixelesPorMm = width / 300.0;
            _piedrasCacheadas =
                engine.generarSistema(capasTotales, escalaPixelesPorMm);
            _ultimasCapas = List.from(capasTotales);
            _ultimoAncho = width;
          }

          return CustomPaint(
            painter: MosaicoPainter(
              logic: trabajoLogic,
              modoDaltonismo: modoDaltonismoApp,
              piedrasCacheadas: _piedrasCacheadas!,
            ),
            child: Container(),
          );
        }),
      ),
    );
  }
}

class MosaicoPainter extends CustomPainter {
  final TrabajoLogic logic;
  final String modoDaltonismo;
  final List<PiedraRenderizable> piedrasCacheadas;

  MosaicoPainter({
    required this.logic,
    required this.modoDaltonismo,
    required this.piedrasCacheadas,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Color baseColor = Colors.grey.shade300;
    if (logic.colorBaseSeleccionado != null) {
      baseColor =
          TransformadorColor.hexToColor(logic.colorBaseSeleccionado!.codigoHex);
    }

    baseColor = baseColor.withValues(alpha: logic.opacidadBase * 255);
    baseColor = TransformadorColor.aplicarFiltro(baseColor, modoDaltonismo);

    final bgPaint = Paint()..color = baseColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (var piedra in piedrasCacheadas) {
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
    return true;
  }
}
