import '../l10n/app_localizations.dart';
import '../models/character.dart';

/// The original guest name is a placeholder, unlike a user-chosen nickname.
/// Translate it only for profiles explicitly marked as using that placeholder.
class GuestNameLocalization {
  static const legacyDefaults = {'기록자', 'Chronicler', '記録者', '記錄者'};

  static String displayName(Character character, AppLocalizations l10n) =>
      character.usesDefaultGuestName ? l10n.lqGuestName : character.name;
}
