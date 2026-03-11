import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StatBar extends StatelessWidget {
  final String label;
  final double value;
  final Icon icon;
  final Color color;
  final bool canUpgrade;
  final VoidCallback onUpgrade;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.canUpgrade,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(value.toStringAsFixed(0), style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            SizedBox(
              width: 24,
              height: 24,
              child: canUpgrade
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      icon: Icon(PhosphorIcons.plusCircle, color: Theme.of(context).colorScheme.primary),
                      onPressed: onUpgrade,
                    )
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value / 100.0,
            minHeight: 10,
            backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
