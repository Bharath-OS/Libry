import 'dart:ui';

import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const GlassMorphism({
    required this.child,
    this.height,
    this.width,
    this.borderRadius = 50,
    this.padding = const EdgeInsets.all(30),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: this.padding,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.2 * 255).toInt()),
            borderRadius: BorderRadius.circular(this.borderRadius),
            border: Border.all(
              color: Colors.white.withAlpha((0.3 * 255).toInt()),
              width: 1.5,
            ),
          ),
          child: this.child,
        ),
      ),
    );
  }
}
