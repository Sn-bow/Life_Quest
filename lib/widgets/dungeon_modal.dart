import 'package:flutter/material.dart';

/// A scrollable game overlay with a separate focus scope and semantics barrier.
class DungeonModal extends StatelessWidget {
  final Widget child;
  const DungeonModal({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: BlockSemantics(
      child: FocusScope(
        autofocus: true,
        child: Material(
          color: Colors.black.withValues(alpha: 0.72),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
