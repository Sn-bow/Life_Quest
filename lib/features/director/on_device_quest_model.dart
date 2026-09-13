import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'quest_director_engine.dart';
import 'quest_generation.dart';

enum OnDeviceModelStatus {
  checking,
  available,
  downloadable,
  downloading,
  unavailable,
}

class ModelSnapshot {
  final OnDeviceModelStatus status;
  final double progress;
  final String? reason;
  const ModelSnapshot(this.status, {this.progress = 0, this.reason});
}

class OnDeviceQuestModel {
  static const channel = MethodChannel('com.lifequest.app/quest_director');
  Future<ModelSnapshot> status() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return const ModelSnapshot(
        OnDeviceModelStatus.unavailable,
        reason: 'platform',
      );
    }
    try {
      final json = await channel
          .invokeMapMethod<String, dynamic>('status')
          .timeout(const Duration(seconds: 8));
      final value = OnDeviceModelStatus.values
          .where((e) => e.name == json?['state'])
          .firstOrNull;
      final total = json?['total'];
      final downloaded = json?['downloaded'];
      return ModelSnapshot(
        value ?? OnDeviceModelStatus.unavailable,
        progress: total is num && total > 0 && downloaded is num
            ? (downloaded / total).clamp(0, 1)
            : 0,
        reason: json?['reason'] is String ? json!['reason'] : null,
      );
    } on Exception {
      return const ModelSnapshot(OnDeviceModelStatus.unavailable);
    }
  }

  Future<void> download() => channel.invokeMethod<void>('download');
  Future<void> deleteModel() => channel.invokeMethod<void>('deleteModel');
  Future<void> cancel() async {
    try {
      await channel.invokeMethod<void>('cancel');
    } on Exception {
      /* Already stopped. */
    }
  }

  Future<List<DirectedQuest>?> generate(
    List<DirectedQuest> plan,
    HunterProfile profile,
    List<QuestSignal> history,
    String locale,
    DateTime now,
  ) async {
    try {
      final raw = await channel
          .invokeMethod<String>('generate', {
            'system': QuestGeneration.system(locale, plan.length),
            'prompt': QuestGeneration.prompt(plan, profile, history, now),
          })
          .timeout(const Duration(seconds: 90));
      return raw == null
          ? null
          : QuestGeneration.parse(
              raw,
              plan,
              locale,
              silenceRequired: QuestGeneration.quietHours(now),
            );
    } on TimeoutException {
      await cancel();
      return null;
    } on Exception {
      return null;
    }
  }
}
