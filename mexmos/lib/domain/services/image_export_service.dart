import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../logic/trabajo_logic.dart';
import '../../ui/widgets/mosaico_viewer.dart';
import '../../core/rendering/voronoi_engine.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'web_download_stub.dart' if (dart.library.html) 'web_download_impl.dart';

class ImageExportService {
  /// Generates a high-resolution PNG image of the mosaic
  static Future<void> exportarImagenAltaResolucion(
    TrabajoLogic logic,
    String modoDaltonismo, {
    double sizePx = 2000.0,
  }) async {
    // 1. Configurar el Canvas y el Grabador
    final recorder = ui.PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromPoints(Offset.zero, Offset(sizePx, sizePx)));

    final engine = VoronoiEngine(
      width: sizePx,
      height: sizePx,
      offsetPasta: 1.0,
    );
    final piedras = engine.generarSistema(logic.capasGrano, sizePx / 300.0);

    // 2. Instanciar el painter que comparten la UI y el exporter
    final painter = MosaicoPainter(
      logic: logic,
      modoDaltonismo: modoDaltonismo,
      piedrasCacheadas: piedras,
    );

    // 3. Dibujar en el canvas forzado
    painter.paint(canvas, Size(sizePx, sizePx));

    // 4. Finalizar el grabado e instanciar la Imagen
    final picture = recorder.endRecording();
    final img = await picture.toImage(sizePx.toInt(), sizePx.toInt());

    // 5. Convertir a Bytes PNG (es asincrónico y algo costoso)
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;
    final bytes = byteData.buffer.asUint8List();

    // 6. Descargar / Compartir
    if (kIsWeb) {
      _downloadWeb(
          bytes, "mosaico_${DateTime.now().millisecondsSinceEpoch}.png");
    } else {
      // Para Windows, Desktop o Móvil, imprimir solo mensaje por el momento
      // Aquí se usaría path_provider o share_plus en el futuro.
      print("Imagen renderizada lista en bytes: ${bytes.length} bytes");
    }
  }

  static void _downloadWeb(List<int> bytes, String filename) {
    if (kIsWeb) {
      downloadWebFile(bytes, filename);
    }
  }
}
