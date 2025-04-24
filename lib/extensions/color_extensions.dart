import 'package:flutter/material.dart' show Color, Colors;

extension ColorToHex on Color {
  String toHex({bool leadingHashSign = true, bool includeAlpha = false}) {
    final String aHex = includeAlpha ? a.round().toRadixString(16).padLeft(2, '0') : '';
    final String rHex = r.round().toRadixString(16).padLeft(2, '0');
    final String gHex = g.round().toRadixString(16).padLeft(2, '0');
    final String bHex = b.round().toRadixString(16).padLeft(2, '0');

    return '${leadingHashSign ? '#' : ''}$aHex$rHex$gHex$bHex';
  }
}

extension HexToColor on String {
  Color toColor({double opacity = 1.0}) {
    try {
      String hex = this;
      if (hex.startsWith('#')) {
        hex = hex.substring(1);
      }

      if (hex.length == 3) {
        hex = hex.split('').map((char) => char + char).join('');
      }

      if (hex.isEmpty || hex.length != 6) {
        throw FormatException('Invalid hex length: $this');
      }

      return Color(int.parse('FF$hex', radix: 16));

    } catch (e) {
      return Colors.purple;
    }
  }
}