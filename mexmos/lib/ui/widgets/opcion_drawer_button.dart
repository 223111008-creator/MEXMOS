import 'package:flutter/material.dart';

class OpcionDrawerButton extends StatefulWidget {
  final IconData icon;
  final String? label;
  final bool isSelected;
  final VoidCallback onTap;

  const OpcionDrawerButton({
    super.key,
    required this.icon,
    this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<OpcionDrawerButton> createState() => _OpcionDrawerButtonState();
}

class _OpcionDrawerButtonState extends State<OpcionDrawerButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Determinar el color de fondo basado en selección y hover
    Color bgColor = Colors.transparent;
    if (widget.isSelected) {
      bgColor = Colors.blue.shade100;
    } else if (_isHovered) {
      bgColor = Colors.grey.shade100;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.label == null ? 60 : 105,
          height: widget.label == null ? 60 : 90,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isSelected ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: widget.label == null ? 24 : 32,
                color: widget.isSelected ? Colors.blue : Colors.grey.shade600,
              ),
              if (widget.label != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.label!,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.isSelected ? Colors.blue : Colors.grey.shade600,
                    fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}