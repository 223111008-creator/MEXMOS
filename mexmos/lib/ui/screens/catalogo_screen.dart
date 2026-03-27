import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/constants.dart';
import '../../data/repositories/mosaico_repositories.dart';
import '../../domain/models/receta.dart';
import '../../logic/trabajo_logic.dart';
import '../app_theme.dart';

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MosaicoRepository();

    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppTheme.surfacePanel,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textSecondary, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppConstants.catalogoTitle.toUpperCase(),
          style: GoogleFonts.syne(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.brandTerra,
            letterSpacing: 1.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppTheme.borderPanel,
          ),
        ),
      ),
      body: FutureBuilder<List<Receta>>(
        future: repository.obtenerRecetasDisponibles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: AppTheme.brandTerra,
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cargando recetas…',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfacePanel,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderPanel),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppTheme.brandTerra, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'Error al cargar el catálogo',
                      style: GoogleFonts.syne(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${snapshot.error}',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.library_books_outlined,
                      color: AppTheme.textMuted, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    'No hay recetas disponibles',
                    style: GoogleFonts.syne(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final recetas = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: recetas.length,
            itemBuilder: (context, index) {
              final receta = recetas[index];
              return _RecetaCard(
                receta: receta,
                onTap: () {
                  context.read<TrabajoLogic>().inicializarConReceta(receta);
                  Navigator.pushNamed(context, '/trabajo');
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _RecetaCard extends StatelessWidget {
  const _RecetaCard({required this.receta, required this.onTap});

  final Receta receta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfacePanel,
              borderRadius: BorderRadius.circular(6),
              border: Border(
                left: const BorderSide(color: AppTheme.brandTerra, width: 3),
                top: BorderSide(color: AppTheme.borderPanel, width: 1),
                right: BorderSide(color: AppTheme.borderPanel, width: 1),
                bottom: BorderSide(color: AppTheme.borderPanel, width: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.brandTerra.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.grid_on,
                        color: AppTheme.brandTerra, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receta.nombre,
                          style: GoogleFonts.syne(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Rendimiento: ${receta.rendimientoKgPorM2} kg/m²',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppTheme.textMuted, size: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
