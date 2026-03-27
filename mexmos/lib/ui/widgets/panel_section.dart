import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';

/// Reusable section container matching the Configurador2DScreen design language.
class PanelSection extends StatelessWidget {
  const PanelSection({
    super.key,
    required this.title,
    required this.child,
    this.hint,
    this.showDivider = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final String title;
  final Widget child;
  final String? hint;
  final bool showDivider;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.syne(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                  letterSpacing: 1.2,
                ),
              ),
              if (hint != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceHover,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    hint!,
                    style: GoogleFonts.dmSans(
                      fontSize: 9,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          child,
          if (showDivider) ...[
            const SizedBox(height: 16),
            Divider(
              height: 1,
              thickness: 1,
              color: AppTheme.borderPanel,
            ),
          ],
        ],
      ),
    );
  }
}
