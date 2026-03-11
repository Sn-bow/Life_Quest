import 'package:flutter/material.dart';
import 'dart:ui';

class TranslucentCard extends StatelessWidget {
  final Widget child;

  const TranslucentCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (isDarkMode) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      );
    } else {
      return Card(
        elevation: 4,
        shadowColor: Colors.grey.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      );
    }
  }
}
