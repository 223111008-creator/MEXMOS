/// Configuration for accessibility features like colorblind modes and text scaling.
class AccessibilityConfig {
  /// Colorblind mode: normal, deuteranopia, protanopia, tritanopia
  final String colorblindMode;
  
  /// Text scale factor (1.0 = normal)
  final double textScaleFactor;

  AccessibilityConfig({
    this.colorblindMode = 'normal',
    this.textScaleFactor = 1.0,
  });

  /// Get the adjusted color for the current colorblind mode
  String adjustColorForBlindness(String hexColor) {
    // Implementation for color adjustment
    return hexColor;
  }
}
