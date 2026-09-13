import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/qa_preview_config.dart';
import '../../config/cloud_config.dart';

enum AiReportResult { sent, queued, preview, failed }

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
      title.isNotEmpty &&
      title.runes.length <= 25 &&
      instruction.isNotEmpty &&
      instruction.runes.length <= 80 &&
      reason.isNotEmpty &&
      reason.runes.length <= 60 &&
      ['ko', 'en', 'ja', 'zh'].contains(locale);
}

class AiReportService {
  final FirebaseFirestore? firestore;
  final String? userId;
  const AiReportService({this.firestore, this.userId});

  /// Only the exact text reviewed by the user is attached. Generated text may
  /// reflect their goal; the raw profile/history is never included automatically.
  Future<AiReportResult> submit(AiReportContent content) async {
    if (!content.valid) return AiReportResult.failed;
    final payload = content.toJson();
    if (kLifeQuestQaPreview) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'lifequest.qaPreview.lastAiReport',
        jsonEncode(payload),
      );
      return AiReportResult.preview;
    }
    if (!kLifeQuestCloudEnabled && firestore == null) {
      return AiReportResult.failed;
    }
    var writeStarted = false;
    try {
      var uid = userId ?? FirebaseAuth.instance.currentUser?.uid;
      // A user-approved report can use an anonymous identity; the device profile
      // and its raw goal/history are never migrated or uploaded by this action.
      if (uid == null) {
        final credential = await FirebaseAuth.instance
            .signInAnonymously()
            .timeout(const Duration(seconds: 10));
        uid = credential.user?.uid;
      }
      if (uid == null) return AiReportResult.failed;
      writeStarted = true;
      await (firestore ?? FirebaseFirestore.instance)
          .collection('users')
          .doc(uid)
          .collection('aiReports')
          .add({...payload, 'reportedAt': FieldValue.serverTimestamp()})
          .timeout(const Duration(seconds: 10));
      return AiReportResult.sent;
    } on TimeoutException {
      return writeStarted
          ? AiReportResult.queued
          : AiReportResult.failed; // Firestore retries the queued write online.
    } on Exception {
      return AiReportResult.failed;
    }
  }
}
