// lib/logic/trabajo_logic.dart
import 'package:flutter/foundation.dart';
import '../domain/models/pigmento.dart';
import '../domain/models/capa_grano.dart';
import '../domain/models/receta.dart';
import '../domain/models/grano_en_receta.dart';
import '../domain/models/pigmento_en_receta.dart';
import '../domain/models/pasta_base.dart';
import '../data/repositories/mosaico_repositories.dart';

enum OpcionDrawer { base, grano, capas, acabado }

class TrabajoLogic extends ChangeNotifier {
  OpcionDrawer _opcionSeleccionada = OpcionDrawer.base;
  OpcionDrawer get opcionSeleccionada => _opcionSeleccionada;

  // --- Propiedades de Base ---
  final List<Pigmento> _pigmentosPersonalizados = [];
  List<Pigmento> get pigmentosPersonalizados =>
      List.unmodifiable(_pigmentosPersonalizados);

  Pigmento? _colorBaseSeleccionado;
  double _opacidadBase = 1.0;

  Pigmento? get colorBaseSeleccionado => _colorBaseSeleccionado;
  double get opacidadBase => _opacidadBase;

  // --- Propiedades de Granos (Capas) ---
  final List<CapaGrano> _capasGrano = [];
  List<CapaGrano> get capasGrano => List.unmodifiable(_capasGrano);

  CapaGrano? _capaEnEdicion;
  CapaGrano? get capaEnEdicion => _capaEnEdicion;

  // --- Propiedades de Acabado ---
  String _acabadoSeleccionado = 'Mate';
  String get acabadoSeleccionado => _acabadoSeleccionado;

  // --- Métodos ---
  void seleccionarOpcion(OpcionDrawer opcion) {
    if (_opcionSeleccionada != opcion) {
      _opcionSeleccionada = opcion;
      _capaEnEdicion = null; // Limpiar preview al cambiar de pestaña
      notifyListeners();
    }
  }

  void seleccionarColorBase(Pigmento pigmento) {
    _colorBaseSeleccionado = pigmento;
    notifyListeners();
  }

  void actualizarOpacidadBase(double opacidad) {
    _opacidadBase = opacidad.clamp(0.0, 1.0);
    notifyListeners();
  }

  void agregarPigmentoPersonalizado(Pigmento pigmento) {
    _pigmentosPersonalizados.add(pigmento);
    // Auto-seleccionar si se añade para la base (opcional, o dejar que el UI lo haga)
    notifyListeners();
  }

  void agregarCapaGrano(CapaGrano capa) {
    _capasGrano.add(capa);
    _capaEnEdicion = null; // Limpiar preview al añadir
    notifyListeners();
  }

  void actualizarCapaEnEdicion(CapaGrano? capa) {
    _capaEnEdicion = capa;
    notifyListeners();
  }

  void eliminarCapaGrano(String idCapa) {
    _capasGrano.removeWhere((c) => c.id == idCapa);
    notifyListeners();
  }

  void actualizarAcabado(String acabado) {
    _acabadoSeleccionado = acabado;
    notifyListeners();
  }

  void inicializarConReceta(Receta receta) {
    // Tomamos el primer pigmento de la receta como color base inicial si existe
    _colorBaseSeleccionado =
        receta.pigmentos.isNotEmpty ? receta.pigmentos.first.pigmento : null;
    _capasGrano.clear();

    // Convertir los granos de la receta a capas iniciales sin pigmento asignado por defecto
    for (var granoReceta in receta.granos) {
      _capasGrano.add(CapaGrano.crear(
        grano: granoReceta.grano,
        pigmento: null,
        densidad: 0.5, // Valor por defecto o podrías calcularlo basado en kg/m2
      ));
    }

    _opcionSeleccionada = OpcionDrawer.base;
    _opacidadBase = 1.0;
    _acabadoSeleccionado = 'Mate';

    notifyListeners();
  }

  void iniciarDisenoVacio() {
    _colorBaseSeleccionado =
        null; // Empieza sin color (fondo gris/blanco por defecto)
    _capasGrano.clear();
    _opcionSeleccionada = OpcionDrawer.base;
    _opacidadBase = 1.0;
    _acabadoSeleccionado = 'Mate';
    notifyListeners();
  }

  Receta crearRecetaActual(String nombre, [String? descripcion]) {
    final double pesoGranos = _capasGrano.fold(0.0, (sum, capa) => sum + (5.0 * capa.densidad));
    final double rendimientoTotal = 25.0 + pesoGranos; // Pasta base (25kg) + granos
    final double aguaNecesaria = rendimientoTotal * 0.15; // 15% de agua

    return Receta(
      id: 'diseno-${DateTime.now().millisecondsSinceEpoch}', // ID único simple
      nombre: nombre,
      descripcion: descripcion,
      // Usamos una pasta base genérica por ahora ya que el configurador se saltó esa parte física
      pastaBase: const PastaBase(
        id: 'pb-custom',
        nombre: 'Pasta Base Personalizada',
        cementoInsumoId: 'ins-cem-01',
        marmolinaInsumoId: 'ins-mar-01',
        proporcionCemento: 1.0,
        proporcionMarmolina: 3.0,
        aguaLitrosPorKgSeco: 0.15,
      ),
      pigmentos: [
        if (_colorBaseSeleccionado != null)
          PigmentoEnReceta(pigmento: _colorBaseSeleccionado!, cantidadKgPorM2: 0.5)
        else
          PigmentoEnReceta(
            pigmento: Pigmento(id: 'pig-default', nombreComercial: 'Gris Natural', codigoHex: '#9E9E9E', codigoFisico: 'N/A', insumoRelacionadoId: 'ins-default'), 
            cantidadKgPorM2: 0.5
          )
      ],
      granos: _capasGrano
          .map((capa) => GranoEnReceta(
                grano: capa.grano,
                cantidadKgPorM2: 5.0 * capa.densidad, 
              ))
          .toList(),
      rendimientoKgPorM2: rendimientoTotal,
      aguaLitrosPorM2: aguaNecesaria,
      fechaCreacion: DateTime.now(),
      activa: true,
    );
  }

  Future<void> guardarDisenoActual(String nombre, String? descripcion) async {
    final repo = MosaicoRepository();
    final receta = crearRecetaActual(nombre, descripcion);
    await repo.guardarReceta(receta);
  }
}
