import '../models/ficha_tecnica.dart';
import '../models/configuracion_pedido.dart';
import '../models/linea_insumo.dart';
import '../../data/repositories/mosaico_repositories.dart'; // CORREGIDO

/// Servicio de dominio responsable del cálculo MRP (Material Requirement Planning).
/// Transforma una configuración de cliente en una Ficha Técnica de producción exacta.
class CalculadorProduccion {
  final MosaicoRepository _repository;

  const CalculadorProduccion(this._repository);

  /// Genera una [FichaTecnica] consolidando las proporciones de la receta base, 
  /// los metros cuadrados solicitados y las personalizaciones del cliente.
  Future<FichaTecnica> generarFicha(ConfiguracionPedido config) async {
    final receta = config.recetaBase;
    final metros = config.metrosCuadrados;
    final lineasInsumo = <LineaInsumo>[];

    // 1. Cálculo del peso total de la pasta base
    final pesoTotalSeco = receta.rendimientoKgPorM2 * metros;
    
    // 2. Distribución proporcional de Cemento y Marmolina
    final sumaFactores = receta.pastaBase.proporcionCemento + receta.pastaBase.proporcionMarmolina;
    final pesoCemento = (receta.pastaBase.proporcionCemento / sumaFactores) * pesoTotalSeco;
    final pesoMarmolina = (receta.pastaBase.proporcionMarmolina / sumaFactores) * pesoTotalSeco;

    // Obtener y validar insumo de Cemento
    final insumoCemento = await _repository.obtenerInsumoPorId(receta.pastaBase.cementoInsumoId);
    if (insumoCemento == null) {
      throw Exception('Error Crítico: Insumo no encontrado (Cemento ID: ${receta.pastaBase.cementoInsumoId})');
    }
    lineasInsumo.add(LineaInsumo(insumo: insumoCemento, cantidadTotalKg: pesoCemento));

    // Obtener y validar insumo de Marmolina
    final insumoMarmolina = await _repository.obtenerInsumoPorId(receta.pastaBase.marmolinaInsumoId);
    if (insumoMarmolina == null) {
      throw Exception('Error Crítico: Insumo no encontrado (Marmolina ID: ${receta.pastaBase.marmolinaInsumoId})');
    }
    lineasInsumo.add(LineaInsumo(insumo: insumoMarmolina, cantidadTotalKg: pesoMarmolina));

    // Listas auxiliares para armar las instrucciones de texto
    final textosPigmentos = <String>[];
    final textosGranos = <String>[];

    // 3. Cálculo de Pigmentos (aplicando personalización si existe)
    for (final pigReceta in receta.pigmentos) {
      final pigmentoOriginal = pigReceta.pigmento;
      final pigmentoUsado = config.pigmentosSeleccionados[pigmentoOriginal.id] ?? pigmentoOriginal;
      
      final pesoPigmento = pigReceta.cantidadKgPorM2 * metros;
      
      final insumoPigmento = await _repository.obtenerInsumoPorId(pigmentoUsado.insumoRelacionadoId);
      if (insumoPigmento == null) {
        throw Exception('Error Crítico: Insumo no encontrado (Pigmento ID: ${pigmentoUsado.insumoRelacionadoId})');
      }
      
      lineasInsumo.add(LineaInsumo(insumo: insumoPigmento, cantidadTotalKg: pesoPigmento));
      textosPigmentos.add('- ${pigmentoUsado.nombreComercial}: ${pesoPigmento.toStringAsFixed(2)} kg');
    }

    // 4. Cálculo de Granos (aplicando personalización si existe)
    for (final granoReceta in receta.granos) {
      final granoOriginal = granoReceta.grano;
      final granoUsado = config.granosSeleccionados[granoOriginal.id] ?? granoOriginal;
      
      final pesoGrano = granoReceta.cantidadKgPorM2 * metros;
      
      final insumoGrano = await _repository.obtenerInsumoPorId(granoUsado.insumoRelacionadoId);
      if (insumoGrano == null) {
        throw Exception('Error Crítico: Insumo no encontrado (Grano ID: ${granoUsado.insumoRelacionadoId})');
      }
      
      lineasInsumo.add(LineaInsumo(insumo: insumoGrano, cantidadTotalKg: pesoGrano));
      textosGranos.add('- ${granoUsado.nombre}: ${pesoGrano.toStringAsFixed(2)} kg');
    }

    // 5. Cálculo de Agua (No es un insumo almacenado, pero es vital para la mezcla)
    final aguaTotal = receta.aguaLitrosPorM2 * metros;

    // 6. Generación de Instrucciones Legibles
    final listaPigmentosStr = textosPigmentos.isEmpty ? '- Ninguno' : textosPigmentos.join('\n');
    final listaGranosStr = textosGranos.isEmpty ? '- Ninguno' : textosGranos.join('\n');

    final instruccionesMezcla = '''
--- INSTRUCCIONES DE PRODUCCIÓN ---
Volumen a producir: ${metros.toStringAsFixed(2)} m²

MATERIALES REQUERIDOS:
- Cemento: ${pesoCemento.toStringAsFixed(2)} kg
- Marmolina: ${pesoMarmolina.toStringAsFixed(2)} kg
PIGMENTOS:
$listaPigmentosStr
GRANOS:
$listaGranosStr
AGUA: 
- ${aguaTotal.toStringAsFixed(2)} litros

PROCEDIMIENTO:
1. Mezclar en seco el cemento, la marmolina y los pigmentos hasta obtener un color homogéneo.
2. Agregar el agua gradualmente mientras se continúa batiendo la mezcla.
3. Incorporar los granos de mármol al final para evitar que se asienten.
4. Vaciar la mezcla resultante en los moldes y aplicar presión.
''';

    // 7. Cálculo del Peso Total de Sólidos
    final double totalKg = lineasInsumo.fold(0.0, (suma, linea) => suma + linea.cantidadTotalKg);

    // 8. Construcción de la Ficha Técnica Final
    final idGenerado = 'FT-${DateTime.now().millisecondsSinceEpoch}-${config.id.substring(0, config.id.length > 4 ? 4 : config.id.length)}';

    return FichaTecnica(
      id: idGenerado,
      pedidoId: config.id, 
      configuracion: config,
      insumosRequeridos: lineasInsumo,
      instruccionesMezcla: instruccionesMezcla,
      fechaGeneracion: DateTime.now(),
      totalKg: totalKg,
    );
  }
}