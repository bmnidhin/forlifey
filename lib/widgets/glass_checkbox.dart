import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';

class GlassCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  const GlassCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  State<GlassCheckbox> createState() => _GlassCheckboxState();
}

class _GlassCheckboxState extends State<GlassCheckbox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.85), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 0.85, end: 1.05), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.05, end: 1.0), weight: 20),
    ]).animate(_controller);

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant GlassCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? GlassTheme.secondaryAccent;
    
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.value 
                ? activeColor 
                : Colors.black.withOpacity(0.04),
            border: Border.all(
              color: widget.value 
                  ? activeColor 
                  : Colors.black.withOpacity(0.18),
              width: 1.5,
            ),
            boxShadow: widget.value
                ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: widget.value ? 1.0 : 0.0,
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
