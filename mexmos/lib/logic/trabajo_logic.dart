// lib/logic/trabajo_logic.dart
import 'package:flutter/foundation.dart';
import '../core/constants/mosaic_physics.dart';
import '../domain/models/pigmento.dart';
import '../domain/models/capa_grano.dart';
import '../domain/models/receta.dart';
import '../domain/models/grano_en_receta.dart';
import '../domain/models/pigmento_en_receta.dart';
import '../domain/models/pasta_base.dart';
import '../domain/models/grano_marmol.dart';
import '../domain/models/enums.dart';
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
  double _dosisPigmento = MosaicPhysics.defaultDosisPigmento;

  Pigmento? get colorBaseSeleccionado => _colorBaseSeleccionado;
  double get opacidadBase => _opacidadBase;
  double get dosisPigmento => _dosisPigmento;

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

  void actualizarDosisPigmento(double dosis) {
    _dosisPigmento =
        dosis.clamp(MosaicPhysics.minDosisPigmento, MosaicPhysics.maxDosisPigmento);
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

  Receta crearRecetaActual(String nombre) {
    const rendimiento = MosaicPhysics.rendimientoBase;

    // ── Grains: distribute kg proportionally by layer density ──
    final densidades = _capasGrano.map((c) => c.densidad).toList();
    final kgsGrano = MosaicPhysics.distribuirGranos(densidades, rendimiento);
    final granos = List.generate(_capasGrano.length, (i) {
      return GranoEnReceta(
        grano: _capasGrano[i].grano,
        cantidadKgPorM2: kgsGrano[i],
      );
    });

    // ── Pigment: dosage as % of cement weight ──────────────────
    final kgPigmento =
        MosaicPhysics.kgPigmentoPorM2(rendimiento, _dosisPigmento);

    final pigmentoBase = _colorBaseSeleccionado ??
        Pigmento(
          id: 'default_gris',
          nombreComercial: 'Gris Natural',
          codigoHex: '#808080',
          codigoFisico: 'GN-00',
          insumoRelacionadoId: 'pigmento_gris',
        );

    // ── Pasta base ────────────────────────────────────────────
    final pasta = PastaBase(
      id: 'pasta_custom',
      nombre: 'Pasta Personalizada',
      cementoInsumoId: 'cemento_gpc_40',
      marmolinaInsumoId: 'marmolina_blanca',
      proporcionCemento: MosaicPhysics.proporcionCemento,
      proporcionMarmolina: MosaicPhysics.proporcionMarmolina,
      aguaLitrosPorKgSeco: MosaicPhysics.ratioAguaSeco,
    );

    return Receta(
      id: 'receta_${DateTime.now().millisecondsSinceEpoch}',
      nombre: nombre,
      descripcion: 'Diseño personalizado',
      pastaBase: pasta,
      pigmentos: [
        PigmentoEnReceta(
          pigmento: pigmentoBase,
          cantidadKgPorM2: kgPigmento,
        ),
      ],
      granos: granos.isEmpty
          ? [
              GranoEnReceta(
                grano: GranoMarmol(
                  id: 'grano_default',
                  nombre: 'Mármol Blanco',
                  equipo: EquipoMolienda.quebradora,
                  codigoTamano: '3-4',
                  abertura: '3/16"',
                  colorNatural: 0xFFF5F5F5,
                  esTenible: false,
                  insumoRelacionadoId: 'marmol_blanco_grano',
                ),
                cantidadKgPorM2: rendimiento * MosaicPhysics.fraccionGranos,
              )
            ]
          : granos,
      rendimientoKgPorM2: rendimiento,
      aguaLitrosPorM2: rendimiento * MosaicPhysics.ratioAguaSeco,
      fechaCreacion: DateTime.now(),
      activa: true,
    );
  }

  Future<void> guardarDisenoActual(String nombre, String? descripcion) async {
    final repo = MosaicoRepository();
    final receta = crearRecetaActual(nombre);
    await repo.guardarReceta(receta);
  }
}
