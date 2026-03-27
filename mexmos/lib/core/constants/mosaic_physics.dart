/// Physical constants for terrazo/mosaico production (industry standard values).
/// All quantities are per m² of finished mosaic.
class MosaicPhysics {
  MosaicPhysics._();

  // ── Total yield ────────────────────────────────────────────────
  /// Standard total dry weight of terrazo (kg/m²)
  static const double rendimientoBase = 27.0;

  // ── Material fractions (of rendimientoBase) ────────────────────
  /// Fraction of total weight corresponding to pasta base (cement + marmolina)
  static const double fraccionPasta = 0.62; // ≈ 16.7 kg/m²

  /// Fraction of total weight corresponding to marble grains
  static const double fraccionGranos = 0.33; // ≈ 8.9 kg/m²

  /// Fraction of total weight corresponding to pigments (baseline, configurable)
  static const double fraccionPigmentoBase = 0.05; // ≈ 1.35 kg/m²

  // ── Paste base proportions (cement : marmolina by weight) ──────
  static const double proporcionCemento = 1.0;
  static const double proporcionMarmolina = 3.0;

  // ── Pigment dosage limits (as % of cement weight) ─────────────
  /// Minimum pigment dosage (2% of cement weight)
  static const double minDosisPigmento = 0.02;

  /// Maximum pigment dosage (8% of cement weight) — above this saturation occurs
  static const double maxDosisPigmento = 0.08;

  /// Default pigment dosage
  static const double defaultDosisPigmento = 0.05;

  // ── Water ──────────────────────────────────────────────────────
  /// Water-to-dry-solids ratio (liters per kg of dry mix)
  static const double ratioAguaSeco = 0.18; // ≈ 4.9 L/m²

  // ── Grain particle density (for Voronoi rendering, not MRP) ────
  /// Visual scaling multiplier for particle count (empirical, rendering only)
  static const double voronoiDensityScale = 1.8;

  /// Maximum particles per Voronoi layer (performance cap)
  static const int maxParticulasVoronoi = 15000;

  // ── Helpers ────────────────────────────────────────────────────

  /// Returns kg of cement per m² for the given rendimiento.
  static double kgCementoPorM2(double rendimiento) {
    final totalPasta = rendimiento * fraccionPasta;
    return totalPasta *
        (proporcionCemento / (proporcionCemento + proporcionMarmolina));
  }

  /// Returns kg of marmolina per m² for the given rendimiento.
  static double kgMarmolinaPorM2(double rendimiento) {
    final totalPasta = rendimiento * fraccionPasta;
    return totalPasta *
        (proporcionMarmolina / (proporcionCemento + proporcionMarmolina));
  }

  /// Returns kg of pigment per m² given a dosage fraction (of cement weight).
  static double kgPigmentoPorM2(double rendimiento, double dosis) {
    return kgCementoPorM2(rendimiento) *
        dosis.clamp(minDosisPigmento, maxDosisPigmento);
  }

  /// Given a list of per-layer densities, returns kg/m² for each layer
  /// such that the total equals [rendimiento * fraccionGranos].
  static List<double> distribuirGranos(
      List<double> densidades, double rendimiento) {
    final totalKg = rendimiento * fraccionGranos;
    final suma = densidades.fold(0.0, (s, d) => s + d);
    if (suma == 0) return List.filled(densidades.length, 0.0);
    return densidades.map((d) => totalKg * (d / suma)).toList();
  }
}
