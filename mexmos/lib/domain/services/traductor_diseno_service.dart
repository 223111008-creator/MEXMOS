import '../models/receta.dart';
import '../models/insumo.dart';
import '../models/linea_insumo.dart';
import '../models/ficha_tecnica.dart';
import '../models/configuracion_pedido.dart';
import '../models/enums.dart';

class TraductorDisenoService {
  // Constantes físicas aproximadas (a calibrar con producción real)
  // Peso promedio de 1 m2 de terrazo de grosor estándar.
  static const double pesoM2ReferenciaKg = 40.0;

  /// Calcula la lista de insumos físicos (kg y costo) necesarios para fabricar
  /// la [receta] dada, cubriendo un área de [metrosCuadrados] y previendo
  /// un factor de desperdicio [margenMerma] (ej. 1.05 para 5%).
  FichaTecnica calcularProduccion({
    required Receta receta,
    required double metrosCuadrados,
    required double margenMerma,
    required String pedidoId,
    // Se requiere la base de datos de insumos reales para extraer los precios
    required Map<String, Insumo> baseDatosInsumos,
  }) {
    final double areaReal = metrosCuadrados * (1.0 + margenMerma);
    List<LineaInsumo> lineas = [];

    // 1. Calcular Pesta Base (Cemento, Marmolina, Agua)
    final double pesoPastaTotalSeco = areaReal * receta.rendimientoKgPorM2;
    final pasta = receta.pastaBase;
    final totalProporcionSolidos =
        pasta.proporcionCemento + pasta.proporcionMarmolina;

    final kgCemento =
        pesoPastaTotalSeco * (pasta.proporcionCemento / totalProporcionSolidos);
    final kgMarmolina = pesoPastaTotalSeco *
        (pasta.proporcionMarmolina / totalProporcionSolidos);
    final litrosAgua = areaReal * receta.aguaLitrosPorM2;

    // Búsqueda de Insumos Genéricos de Base (usando IDs Hardcodeados de la librería de prueba)
    final insumoCemento = baseDatosInsumos[pasta.cementoInsumoId] ??
        Insumo(
            id: pasta.cementoInsumoId,
            nombre: 'Cemento Blanco',
            tipo: TipoInsumo.cemento,
            costoPorKg: 3.5);
    final insumoMarmolina = baseDatosInsumos[pasta.marmolinaInsumoId] ??
        Insumo(
            id: pasta.marmolinaInsumoId,
            nombre: 'Marmolina Cero Fina',
            tipo: TipoInsumo.marmolina,
            costoPorKg: 1.2);
    final insumoAgua = const Insumo(
        id: 'agua',
        nombre: 'Agua de Red',
        tipo: TipoInsumo.marmolina,
        costoPorKg: 0.05,
        unidadMedida: 'l');

    lineas.add(LineaInsumo(insumo: insumoCemento, cantidadTotalKg: kgCemento));
    lineas.add(
        LineaInsumo(insumo: insumoMarmolina, cantidadTotalKg: kgMarmolina));
    lineas.add(LineaInsumo(insumo: insumoAgua, cantidadTotalKg: litrosAgua));

    // 2. Pigmentos de la Base
    for (var pigmentoHijo in receta.pigmentos) {
      final kgColorante = pigmentoHijo.cantidadKgPorM2 * areaReal;
      final insumoP = baseDatosInsumos[pigmentoHijo.pigmento.id] ??
          Insumo(
              id: pigmentoHijo.pigmento.id,
              nombre: 'Pigmento Especial',
              tipo: TipoInsumo.pigmento,
              costoPorKg: 85.0);

      lineas.add(LineaInsumo(insumo: insumoP, cantidadTotalKg: kgColorante));
    }

    // 3. Capas de Granos (Áridos)
    for (var granoHijo in receta.granos) {
      final kgGrano = granoHijo.cantidadKgPorM2 * areaReal;

      final insumoG = baseDatosInsumos[granoHijo.grano.id] ??
          Insumo(
              id: granoHijo.grano.id,
              nombre: 'Grano Marmol ${granoHijo.grano.nombre}',
              tipo: TipoInsumo.grano,
              costoPorKg: 4.5);

      lineas.add(LineaInsumo(insumo: insumoG, cantidadTotalKg: kgGrano));
    }

    // Sumatoria Total
    double totalKgCalculado = lineas.fold(
        0.0,
        (sum, linea) =>
            sum +
            (linea.insumo.unidadMedida == 'kg' ? linea.cantidadTotalKg : 0));

    // Generar la Ficha
    return FichaTecnica(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pedidoId: pedidoId,
      configuracion: ConfiguracionPedido(
        id: 'cfg_$pedidoId',
        recetaBase: receta,
        metrosCuadrados: metrosCuadrados,
        fechaCreacion: DateTime.now(),
      ),
      insumosRequeridos: lineas,
      instruccionesMezcla:
          "Mezclar pigmento base con agua; agregar cemento y marmolina. Finalmente agregar los áridos por granulometría ascendente.",
      fechaGeneracion: DateTime.now(),
      totalKg: totalKgCalculado,
    );
  }
}
