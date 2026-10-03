import 'dart:async';
import 'package:flutter/material.dart';
import '../../features/status_pack/status_skin_store.dart';
import '../../services/purchase_service.dart';

/// Live UI inside an original generated raster frame. The artwork has no text.
class HunterSystemFrame extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const HunterSystemFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(28, 26, 28, 30),
  });

  static ThemeData themeFor(
    BuildContext context, {
    StatusWindowLook look = StatusWindowLook.core,
  }) {
    final base = Theme.of(context);
    const ink = Color(0xFF06131E);
    const light = Color(0xFFEAF9FF);
    final cyan = look.accent;
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        surface: ink,
        onSurface: light,
        onSurfaceVariant: const Color(0xFFB2CCDA),
        primary: cyan,
        onPrimary: ink,
        secondary: cyan,
        onSecondary: ink,
        secondaryContainer: const Color(0xFF183B4C),
        onSecondaryContainer: light,
        outline: const Color(0xFF32546A),
        outlineVariant: const Color(0xFF32546A),
      ),
      textTheme: base.textTheme.apply(bodyColor: light, displayColor: light),
      dividerTheme: const DividerThemeData(color: Color(0xFF32546A)),
      progressIndicatorTheme: base.progressIndicatorTheme.copyWith(color: cyan),
      iconTheme: IconThemeData(color: cyan),
      chipTheme: base.chipTheme.copyWith(
        selectedColor: const Color(0xFF183B4C),
        checkmarkColor: cyan,
        secondaryLabelStyle: TextStyle(color: cyan),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: ink,
          backgroundColor: cyan,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }

  @override
  State<HunterSystemFrame> createState() => _HunterSystemFrameState();
}

class _HunterSystemFrameState extends State<HunterSystemFrame> {
  @override
  void initState() {
    super.initState();
    unawaited(StatusSkinStore.instance.load());
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([StatusSkinStore.instance, PurchaseService()]),
    builder: (context, _) {
      final look = StatusSkinStore.instance.effective(
        PurchaseService().ownsStatusWindowPlus,
      );
      return Theme(
        data: HunterSystemFrame.themeFor(context, look: look),
        child: Material(
          color: const Color(0xFF06131E),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final requested = widget.padding.resolve(
                Directionality.of(context),
              );
              // Reserve the raster rails' proportional width, then leave a
              // visible gap between their glow and the live content.
              final safeSide = constraints.maxWidth * .085 + 12;
              final safePadding = requested.copyWith(
                left: requested.left < safeSide ? safeSide : requested.left,
                right: requested.right < safeSide ? safeSide : requested.right,
              );
              return Stack(
                children: [
                  Padding(padding: safePadding, child: widget.child),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ExcludeSemantics(
                        child: Image.asset(look.assetPath, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
