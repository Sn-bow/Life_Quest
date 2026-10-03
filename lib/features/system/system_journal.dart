/// Persisted facts, shared by status, reward scenes and the activity journal.
/// Missing legacy receipts are never reconstructed as if they were observed.
class GrowthReceipt {
  final String id, questId, title, day, source;
  final DateTime at;
  final int category, baseXp, gold, levelBefore, levelAfter;
  final double xp, xpBefore, xpAfter, maxXpAfter, bonusXp;
  double get questXp => xp - bonusXp;
  final List<double> statChanges;
  const GrowthReceipt({
    required this.id,
    required this.questId,
    required this.title,
    required this.day,
    required this.source,
    required this.at,
    required this.category,
    required this.baseXp,
    required this.gold,
    required this.levelBefore,
    required this.levelAfter,
    required this.xp,
    this.bonusXp = 0,
    required this.xpBefore,
    required this.xpAfter,
    required this.maxXpAfter,
    required this.statChanges,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'questId': questId,
    'title': title,
    'day': day,
    'source': source,
    'at': at.toIso8601String(),
    'category': category,
    'baseXp': baseXp,
    'gold': gold,
    'levelBefore': levelBefore,
    'levelAfter': levelAfter,
    'xp': xp,
    'bonusXp': bonusXp,
    'xpBefore': xpBefore,
    'xpAfter': xpAfter,
    'maxXpAfter': maxXpAfter,
    'statChanges': statChanges,
  };
  factory GrowthReceipt.fromJson(Map<String, dynamic> j) {
    final result = GrowthReceipt(
      id: j['id'] as String,
      questId: j['questId'] as String,
      title: j['title'] as String,
      day: j['day'] as String,
      source: j['source'] as String,
      at: DateTime.parse(j['at'] as String),
      category: j['category'] as int,
      baseXp: j['baseXp'] as int,
      gold: j['gold'] as int,
      levelBefore: j['levelBefore'] as int,
      levelAfter: j['levelAfter'] as int,
      xp: (j['xp'] as num).toDouble(),
      bonusXp: (j['bonusXp'] as num? ?? 0).toDouble(),
      xpBefore: (j['xpBefore'] as num).toDouble(),
      xpAfter: (j['xpAfter'] as num).toDouble(),
      maxXpAfter: (j['maxXpAfter'] as num).toDouble(),
      statChanges: (j['statChanges'] as List)
          .map((v) => (v as num).toDouble())
          .toList(),
    );
    if (result.category < 0 ||
        result.category > 3 ||
        result.statChanges.length != 4 ||
        ![
          result.xp,
          result.bonusXp,
          result.xpBefore,
          result.xpAfter,
          result.maxXpAfter,
          ...result.statChanges,
        ].every((v) => v.isFinite && v >= 0) ||
        result.bonusXp > result.xp ||
        result.levelBefore < 1 ||
        result.levelAfter < result.levelBefore ||
        result.maxXpAfter <= 0 ||
        result.baseXp < 0 ||
        result.gold < 0 ||
        !['quest', 'system'].contains(result.source)) {
      throw const FormatException('Invalid growth receipt');
    }
    return result;
  }
}

String systemDay(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

enum SystemOfferStatus {
  offered,
  accepted,
  completed,
  declined,
  expired,
  abandoned,
}

class SystemOffer {
  final String id, day, template;
  final DateTime offeredAt, offerDeadline;
  final int category, minutes, reward;
  SystemOfferStatus status;
  DateTime? acceptedAt, deadline;
  SystemOffer({
    required this.id,
    required this.day,
    required this.template,
    required this.offeredAt,
    required this.offerDeadline,
    required this.category,
    this.minutes = 3,
    this.reward = 15,
    this.status = SystemOfferStatus.offered,
    this.acceptedAt,
    this.deadline,
  });
  bool get open =>
      status == SystemOfferStatus.offered ||
      status == SystemOfferStatus.accepted;
  bool expire(DateTime now) {
    if ((status == SystemOfferStatus.offered && !now.isBefore(offerDeadline)) ||
        (status == SystemOfferStatus.accepted && !now.isBefore(deadline!))) {
      status = SystemOfferStatus.expired;
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'day': day,
    'template': template,
    'offeredAt': offeredAt.toIso8601String(),
    'offerDeadline': offerDeadline.toIso8601String(),
    'category': category,
    'minutes': minutes,
    'reward': reward,
    'status': status.name,
    'acceptedAt': acceptedAt?.toIso8601String(),
    'deadline': deadline?.toIso8601String(),
  };
  factory SystemOffer.fromJson(Map<String, dynamic> j) {
    final o = SystemOffer(
      id: j['id'] as String,
      day: j['day'] as String,
      template: j['template'] as String,
      offeredAt: DateTime.parse(j['offeredAt'] as String),
      offerDeadline: DateTime.parse(j['offerDeadline'] as String),
      category: j['category'] as int,
      minutes: j['minutes'] as int,
      reward: j['reward'] as int,
      status: SystemOfferStatus.values.byName(j['status'] as String),
      acceptedAt: j['acceptedAt'] == null
          ? null
          : DateTime.parse(j['acceptedAt'] as String),
      deadline: j['deadline'] == null
          ? null
          : DateTime.parse(j['deadline'] as String),
    );
    if (!['reflection', 'space', 'pause', 'kindness'].contains(o.template) ||
        o.category < 0 ||
        o.category > 3 ||
        o.minutes != 3 ||
        o.reward != 15 ||
        !o.offerDeadline.isAfter(o.offeredAt) ||
        ([
              SystemOfferStatus.accepted,
              SystemOfferStatus.completed,
              SystemOfferStatus.abandoned,
            ].contains(o.status) &&
            (o.acceptedAt == null ||
                o.deadline == null ||
                !o.deadline!.isAfter(o.acceptedAt!)))) {
      throw const FormatException('Invalid system offer');
    }
    return o;
  }
}

class SystemJournal {
  final List<GrowthReceipt> receipts;
  final List<SystemOffer> offers;
  bool enabled;
  SystemJournal({
    List<GrowthReceipt>? receipts,
    List<SystemOffer>? offers,
    this.enabled = true,
  }) : receipts = receipts ?? [],
       offers = offers ?? [];
  SystemOffer? get current => offers.where((o) => o.open).firstOrNull;
  bool expire(DateTime now) {
    var changed = false;
    for (final o in offers) {
      changed = o.expire(now) || changed;
    }
    return changed;
  }

  SystemOffer? propose({
    required DateTime now,
    required int completions,
    required int availableMinutes,
    required int category,
  }) {
    expire(now);
    if (!enabled ||
        completions < 1 ||
        availableMinutes < 3 ||
        current != null ||
        offers.any(
          (o) => o.day == systemDay(now) || !o.offeredAt.isBefore(now),
        ) ||
        offers
                .where(
                  (o) => o.offeredAt.isAfter(
                    now.subtract(const Duration(days: 7)),
                  ),
                )
                .length >=
            3) {
      return null;
    }
    final choices = ['space', 'reflection', 'pause', 'kindness'];
    for (var n = 0; n < 4; n++) {
      final index = (category + n) % 4;
      final template = choices[index];
      if (offers.any(
        (o) =>
            o.template == template &&
            o.offeredAt.isAfter(now.subtract(const Duration(days: 7))),
      )) {
        continue;
      }
      final offer = SystemOffer(
        id: 'system-${now.microsecondsSinceEpoch}',
        day: systemDay(now),
        template: template,
        offeredAt: now,
        offerDeadline: now.add(const Duration(hours: 2)),
        category: index,
      );
      offers.add(offer);
      return offer;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'version': 1,
    'enabled': enabled,
    'receipts': receipts.map((r) => r.toJson()).toList(),
    'offers': offers.map((o) => o.toJson()).toList(),
  };
  factory SystemJournal.fromJson(Object? raw) {
    if (raw == null) return SystemJournal();
    final j = Map<String, dynamic>.from(raw as Map);
    if (j['version'] != 1) {
      throw const FormatException('Unknown journal version');
    }
    final result = SystemJournal(
      enabled: j['enabled'] == true,
      receipts: (j['receipts'] as List)
          .map((r) => GrowthReceipt.fromJson(Map<String, dynamic>.from(r)))
          .toList(),
      offers: (j['offers'] as List)
          .map((r) => SystemOffer.fromJson(Map<String, dynamic>.from(r)))
          .toList(),
    );
    if (result.offers.where((o) => o.open).length > 1 ||
        result.offers.map((o) => o.id).toSet().length != result.offers.length ||
        result.receipts.map((r) => r.id).toSet().length !=
            result.receipts.length) {
      throw const FormatException('Duplicate system activity');
    }
    return result;
  }
}
