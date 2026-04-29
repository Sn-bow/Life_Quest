import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/relic_data.dart';

/// 렐릭 아이콘 위젯 — spritePath가 있으면 이미지, 없으면 컬러 아이콘 폴백
class RelicIcon extends StatelessWidget {
  final RelicData relic;
  final double size;
  final bool showBorder;

  const RelicIcon({
    super.key,
    required this.relic,
    this.size = 40,
    this.showBorder = true,
  });

  Color get _rarityColor {
    switch (relic.rarity) {
      case RelicRarity.starter:
        return const Color(0xFF78909C);
      case RelicRarity.common:
        return const Color(0xFF8D8D8D);
      case RelicRarity.uncommon:
        return const Color(0xFF4CAF50);
      case RelicRarity.rare:
        return const Color(0xFF2196F3);
      case RelicRarity.boss:
        return const Color(0xFFFF5722);
      case RelicRarity.event:
        return const Color(0xFF9C27B0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _rarityColor;

    return Container(
      width: size,
      height: size,
      decoration: showBorder
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black54,
              border: Border.all(color: borderColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: borderColor.withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            )
          : null,
      child: ClipOval(
        child: relic.spritePath.isNotEmpty
            ? Image.asset(
                relic.spritePath,
                width: size,
                height: size,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _fallbackIcon(borderColor),
              )
            : _fallbackIcon(borderColor),
      ),
    );
  }

  Widget _fallbackIcon(Color color) {
    return Icon(
      Icons.diamond_outlined,
      color: color,
      size: size * 0.55,
    );
  }
}

/// 툴팁이 있는 렐릭 아이콘 (전투 화면 상단 렐릭 슬롯용)
class RelicIconWithTooltip extends StatelessWidget {
  final RelicData relic;
  final double size;

  const RelicIconWithTooltip({
    super.key,
    required this.relic,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${relic.name}\n${relic.description}',
      preferBelow: false,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      child: RelicIcon(relic: relic, size: size),
    );
  }
}
