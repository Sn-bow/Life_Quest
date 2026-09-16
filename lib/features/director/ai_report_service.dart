import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/qa_preview_config.dart';
import '../../config/cloud_config.dart';

enum AiReportResult { sent, preview, failed }

class AiReportContent {
  final String title, instruction, reason, locale;
  const AiReportContent({
    required this.title,
    required this.instruction,
    required this.reason,
    required this.locale,
  });
  Map<String, dynamic> toJson() => {
    'schema': 1,
    'model': 'gemma-4-e2b',
    'title': title,
    'instruction': instruction,
    'reason': reason,
    'locale': locale,
  };
  bool get valid =>
      title.trim().isNotEmpty &&
      title.runes.length <= 25 &&
      instruction.trim().isNotEmpty &&
      instruction.runes.length <= 80 &&
      reason.trim().isNotEmpty &&
      reason.runes.length <= 60 &&
      ['ko', 'en', 'ja', 'zh'].contains(locale);
}

class AiReportReceipt {
  final String id, ownerUid;
  String get reference => '$ownerUid/$id';
  final int createdAt;
  const AiReportReceipt({
    required this.id,
    required this.ownerUid,
    required this.createdAt,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'ownerUid': ownerUid,
    'createdAt': createdAt,
  };
  static bool validId(Object? id) =>
      id is String && RegExp(r'^[a-f0-9]{64}$').hasMatch(id);
  factory AiReportReceipt.fromJson(Map<String, dynamic> value) {
    if (!validId(value['id']) ||
        value['ownerUid'] is! String ||
        (value['ownerUid'] as String).isEmpty ||
        (value['ownerUid'] as String).contains('/') ||
        value['createdAt'] is! int) {
      throw const FormatException('Invalid report receipt');
    }
    return AiReportReceipt(
      id: value['id'],
      ownerUid: value['ownerUid'],
      createdAt: value['createdAt'],
    );
  }
}

class AiReportResponse {
  final AiReportResult result;
  final AiReportReceipt? receipt;
  const AiReportResponse(this.result, [this.receipt]);
}

class AiReportService {
  static const receiptsKey = 'lifequest.aiReportReceipts.v1';
  final Future<Map<String, dynamic>> Function(Map<String, dynamic>)?
  submitRemote;
  final Future<void> Function(AiReportReceipt)? deleteRemote;
  final String? Function()? currentUidOverride;
  const AiReportService({
    this.submitRemote,
    this.deleteRemote,
    this.currentUidOverride,
  });
  String? get currentUid => currentUidOverride != null
      ? currentUidOverride!()
      : kLifeQuestCloudEnabled
      ? FirebaseAuth.instance.currentUser?.uid
      : null;
  bool get canDeleteAnonymousIdentity =>
      kLifeQuestCloudEnabled &&
      FirebaseAuth.instance.currentUser?.isAnonymous == true;

  Future<bool> deleteAnonymousIdentity() async {
    if (!canDeleteAnonymousIdentity) return false;
    final uid = currentUid;
    try {
      final response = await FirebaseFunctions.instance
          .httpsCallable(
            'requestReportIdentityDeletion',
            options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
          )
          .call();
      if (response.data is! Map || response.data['accepted'] != true) {
        return false;
      }
      try {
        await _save(
          (await receipts()).where((r) => r.ownerUid != uid).toList(),
        );
      } catch (_) {}
      try {
        if (FirebaseAuth.instance.currentUser?.uid == uid) {
          await FirebaseAuth.instance.signOut();
        }
      } catch (_) {}
      return true; // The durable server job is the acceptance boundary.
    } catch (_) {
      return false;
    }
  }

  Future<List<AiReportReceipt>> receipts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(receiptsKey);
    if (raw == null) return [];
    final data = jsonDecode(raw);
    if (data is! List || data.length > 100) {
      throw const FormatException('Invalid report receipts');
    }
    return data
        .map(
          (row) =>
              AiReportReceipt.fromJson(Map<String, dynamic>.from(row as Map)),
        )
        .toList();
  }

  Future<void> _save(List<AiReportReceipt> entries) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(
      receiptsKey,
      jsonEncode(entries.map((r) => r.toJson()).toList()),
    )) {
      throw StateError('Report receipts could not be saved.');
    }
  }

  Future<Map<String, dynamic>> _send(Map<String, dynamic> payload) async {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously().timeout(
        const Duration(seconds: 10),
      );
    }
    final response = await FirebaseFunctions.instance
        .httpsCallable(
          'submitAiReport',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
        )
        .call<Map<String, dynamic>>(payload);
    return response.data;
  }

  /// Only reviewed text is sent. Callable acknowledgement is required; a timeout
  /// is uncertain, never a promise that Firestore will upload later. Retrying the
  /// same output is idempotent on the server.
  Future<AiReportResponse> submit(AiReportContent content) async {
    if (!content.valid) return const AiReportResponse(AiReportResult.failed);
    final payload = content.toJson();
    if (kLifeQuestQaPreview) {
      return const AiReportResponse(AiReportResult.preview);
    }
    if (!kLifeQuestCloudEnabled && submitRemote == null) {
      return const AiReportResponse(AiReportResult.failed);
    }
    try {
      final result = await (submitRemote ?? _send)(payload);
      if (result['accepted'] != true) {
        return const AiReportResponse(AiReportResult.failed);
      }
      final receipt = AiReportReceipt.fromJson({
        'id': result['reportId'],
        'ownerUid': result['ownerUid'],
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });
      try {
        final previous = await receipts();
        await _save(
          [
            receipt,
            ...previous.where((r) => r.id != receipt.id),
          ].take(100).toList(),
        );
      } catch (_) {
        // A local disk failure cannot undo server acceptance. The receipt is
        // still returned so the user can copy it from the success message.
      }
      return AiReportResponse(AiReportResult.sent, receipt);
    } catch (_) {
      return const AiReportResponse(AiReportResult.failed);
    }
  }

  Future<bool> delete(AiReportReceipt receipt) async {
    if (receipt.ownerUid != currentUid) return false;
    try {
      if (deleteRemote != null) {
        await deleteRemote!(receipt);
      } else {
        if (!kLifeQuestCloudEnabled) return false;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(receipt.ownerUid)
            .collection('aiReports')
            .doc(receipt.id)
            .delete()
            .timeout(const Duration(seconds: 10));
      }
      // Server deletion is idempotent. A failed local write keeps the receipt
      // available for another attempt instead of silently losing the handle.
      await _save((await receipts()).where((r) => r.id != receipt.id).toList());
      return true;
    } catch (_) {
      return false;
    }
  }
}
