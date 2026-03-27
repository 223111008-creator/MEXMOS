import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../logic/trabajo_logic.dart';
import '../app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(child: _buildBody(context)),
            _buildStatusBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.surfacePanel,
        border: Border(
          bottom: BorderSide(color: AppTheme.borderPanel, width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            'MEXMOS',
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppTheme.brandTerra,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '·  Mosaicos Personalizados',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.settings_outlined,
                color: AppTheme.textSecondary, size: 18),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Configuración',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Diseña tu mosaico',
                style: GoogleFonts.syne(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Selecciona cómo quieres comenzar',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              _buildMenuGrid(context),
              const SizedBox(height: 40),
              _buildVersionBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final items = [
      _MenuItem(
        icon: Icons.grid_view_rounded,
        label: 'Configurador 2D',
        description: 'Diseño visual con renderizado Voronoi en tiempo real',
        route: '/configurador_2d',
        accent: AppTheme.brandTerra,
        isHighlighted: true,
      ),
      _MenuItem(
        icon: Icons.tune_rounded,
        label: 'Diseñador Básico',
        description: 'Configura materiales, colores y capas de grano',
        route: '/trabajo',
        accent: AppTheme.brandCobalt,
      ),
      _MenuItem(
        icon: Icons.library_books_outlined,
        label: 'Catálogo de Recetas',
        description: 'Explora y carga plantillas predefinidas',
        route: '/catalogo',
        accent: const Color(0xFF4A7C6B),
      ),
      _MenuItem(
        icon: Icons.folder_open_rounded,
        label: 'Mis Diseños',
        description: 'Carga y edita diseños guardados en la nube',
        route: '/mis_disenos',
        accent: const Color(0xFF6B4A7C),
      ),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: items.map((item) => _buildMenuCard(context, item)).toList(),
    );
  }

  Widget _buildMenuCard(BuildContext context, _MenuItem item) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, item.route),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: item.isHighlighted ? AppTheme.surfaceCard : AppTheme.surfacePanel,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: item.isHighlighted
                  ? item.accent.withOpacity(0.4)
                  : AppTheme.borderPanel,
              width: 1,
            ),
            boxShadow: item.isHighlighted
                ? [
                    BoxShadow(
                      color: item.accent.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: item.accent, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: GoogleFonts.syne(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.description,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textMuted, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surfacePanel,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppTheme.borderPanel),
          ),
          child: Text(
            'v0.1.0 · Prototipo',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: AppTheme.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.surfacePanel,
        border: Border(
          top: BorderSide(color: AppTheme.borderPanel, width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Mexana de Mosaicos S.A. de C.V.',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: AppTheme.textMuted,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1A4B2E),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              'WCAG 2.1 AA',
              style: GoogleFonts.dmSans(
                fontSize: 9,
                color: const Color(0xFF4ADE80),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.description,
    required this.route,
    required this.accent,
    this.isHighlighted = false,
  });
  final IconData icon;
  final String label;
  final String description;
  final String route;
  final Color accent;
  final bool isHighlighted;
}
