import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';

class LiquidBackground extends StatelessWidget {
  final Widget child;
  const LiquidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlassTheme.backgroundColor,
      body: child,
    );
  }
}
