import 'package:shared_preferences/shared_preferences.dart';

enum AccountDeletionPhase { requesting, accepted }

/// A per-account crash guard, written before a request can reach the server.
/// It contains no credentials or profile data and never resumes cloud writes.
class AccountDeletionJournal {
  static String key(String uid) => 'lifequest.accountDeletion.v1.$uid';

  static Future<AccountDeletionPhase?> read(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (!prefs.containsKey(key(uid))) return null;
    return prefs.get(key(uid)) == AccountDeletionPhase.accepted.name
        ? AccountDeletionPhase.accepted
        : AccountDeletionPhase.requesting;
  }

  static Future<void> write(String uid, AccountDeletionPhase phase) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(key(uid), phase.name)) {
      throw StateError('Account deletion guard could not be saved.');
    }
  }

  static Future<void> clear(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.remove(key(uid))) {
      throw StateError('Account deletion guard could not be cleared.');
    }
  }

  static Future<void> finishLocalCleanup(
    String uid, {
    required Future<void> Function() signOut,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    for (final cache in [
      'lifequest.director.v1.$uid',
      'lifequest.purchases.v1.$uid',
    ]) {
      if (!await prefs.remove(cache)) {
        throw StateError('Account cache could not be cleared.');
      }
    }
    // Keep the guard across a failed sign-out or process exit. In particular,
    // never clear it in a finally block before authentication has been revoked.
    await signOut();
    await clear(uid);
  }
}
