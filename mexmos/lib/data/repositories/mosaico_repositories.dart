import '../../domain/models/enums.dart';
import '../../domain/models/insumo.dart';
import '../../domain/models/pigmento.dart';
import '../../domain/models/grano_marmol.dart';
import '../../domain/models/pasta_base.dart';
import '../../domain/models/pigmento_en_receta.dart';
import '../../domain/models/grano_en_receta.dart';
import '../../domain/models/receta.dart';
import '../../domain/models/configuracion_pedido.dart';

/// Repositorio que simula la conexión a una base de datos para obtener 
/// los insumos, pigmentos, granos y recetas disponibles en la fábrica.
class MosaicoRepository {
  // --- Base de Datos en Memoria ---

  final List<Insumo> _insumosDB = [
    const Insumo(
      id: 'ins-cem-01',
      nombre: 'Cemento Gris CPC 40',
      tipo: TipoInsumo.cemento,
      costoPorKg: 5.0,
      unidadMedida: 'kg',
    ),
    const Insumo(
      id: 'ins-mar-01',
      nombre: 'Marmolina Blanca',
      tipo: TipoInsumo.marmolina,
      costoPorKg: 2.5,
      unidadMedida: 'kg',
    ),
    const Insumo(
      id: 'ins-pig-01',
      nombre: 'Óxido Rojo',
      tipo: TipoInsumo.pigmento,
      costoPorKg: 50.0,
      unidadMedida: 'kg',
    ),
    const Insumo(
      id: 'ins-pig-02',
      nombre: 'Negro Humo',
      tipo: TipoInsumo.pigmento,
      costoPorKg: 60.0,
      unidadMedida: 'kg',
    ),
    const Insumo(
      id: 'ins-gra-01',
      nombre: 'Mármol Blanco en Grano',
      tipo: TipoInsumo.grano,
      costoPorKg: 8.0,
      unidadMedida: 'kg',
    ),
  ];

  final List<Pigmento> _pigmentosDB = [
    Pigmento(
      id: 'pig-01',
      nombreComercial: 'Rojo Óxido',
      codigoHex: '#B22222',
      codigoFisico: 'PIG-ROJO-01',
      insumoRelacionadoId: 'ins-pig-01',
    ),
    Pigmento(
      id: 'pig-02',
      nombreComercial: 'Negro Intenso',
      codigoHex: '#000000',
      codigoFisico: 'PIG-NEG-01',
      insumoRelacionadoId: 'ins-pig-02',
    ),
  ];

  final List<GranoMarmol> _granosDB = [
    const GranoMarmol(
      id: 'gra-01',
      nombre: 'Mármol Blanco Macael',
      equipo: EquipoMolienda.molinoBoludo,
      codigoTamano: '0-2',
      abertura: '1/8"',
      colorNatural: 0xFFF5F5F5,
      esTenible: true,
      insumoRelacionadoId: 'ins-gra-01',
    ),
  ];

  final List<Receta> _recetasDB = [];

 MosaicoRepository() {
    // Cambio: de 'final' a 'const'
    const pastaBasePrueba = PastaBase(
      id: 'pb-01',
      nombre: 'Pasta Gris Estándar',
      cementoInsumoId: 'ins-cem-01',
      marmolinaInsumoId: 'ins-mar-01',
      proporcionCemento: 1.0,
      proporcionMarmolina: 3.0,
      aguaLitrosPorKgSeco: 0.15,
    );

    _recetasDB.add(
      Receta(
        id: 'rec-01',
        nombre: 'Clásico Rojo',
        descripcion: 'Mosaico tradicional base gris con pigmento rojo y grano blanco.',
        pastaBase: pastaBasePrueba,
        pigmentos: [
          PigmentoEnReceta(pigmento: _pigmentosDB.first, cantidadKgPorM2: 0.5),
        ],
        granos: [
          GranoEnReceta(grano: _granosDB.first, cantidadKgPorM2: 2.0),
        ],
        rendimientoKgPorM2: 25.0,
        aguaLitrosPorM2: 3.75,
        fechaCreacion: DateTime.now(),
        activa: true,
      ),
    );
  }

  Future<List<Receta>> obtenerRecetasDisponibles() async {
    await Future.delayed(const Duration(milliseconds: 600)); 
    return _recetasDB.where((r) => r.activa).toList();
  }

  Future<List<Pigmento>> obtenerPigmentos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _pigmentosDB;
  }

  Future<List<GranoMarmol>> obtenerGranos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _granosDB;
  }

  Future<Insumo?> obtenerInsumoPorId(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _insumosDB.firstWhere((insumo) => insumo.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<ConfiguracionPedido> guardarConfiguracion(ConfiguracionPedido config) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return config;
  }
}