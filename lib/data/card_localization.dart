import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:life_quest_final_v2/models/card_data.dart';

/// Provides localized card names and descriptions.
///
/// Falls back to the raw Korean strings stored on [CardData] for any card
/// whose ID is not yet mapped here.  Add new cases as translations become
/// available for more cards.
class CardLocalization {
  CardLocalization._();

  static String localizedName(CardData card, AppLocalizations l10n) {
    switch (card.id) {
      case 'base_strike':
        return l10n.cardNameBaseStrike;
      case 'base_defend':
        return l10n.cardNameBaseDefend;
      case 'base_focus':
        return l10n.cardNameBaseFocus;
      case 'curse_pain':
        return l10n.cardNameCursePain;
      case 'curse_doubt':
        return l10n.cardNameCurseDoubt;
      case 'curse_burden':
        return l10n.cardNameCurseBurden;
      case 'curse_decay':
        return l10n.cardNameCurseDecay;
      default:
        return card.name;
    }
  }

  static String localizedDescription(CardData card, AppLocalizations l10n) {
    switch (card.id) {
      case 'base_strike':
        return l10n.cardDescBaseStrike;
      case 'base_defend':
        return l10n.cardDescBaseDefend;
      case 'base_focus':
        return l10n.cardDescBaseFocus;
      case 'curse_pain':
        return l10n.cardDescCursePain;
      case 'curse_doubt':
        return l10n.cardDescCurseDoubt;
      case 'curse_burden':
        return l10n.cardDescCurseBurden;
      case 'curse_decay':
        return l10n.cardDescCurseDecay;
      default:
        return card.description;
    }
  }
}
