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
      case 'atk_c01':
        return l10n.cardNameAtkC01;
      case 'atk_c01_up':
        return l10n.cardNameAtkC01Up;
      case 'atk_c02':
        return l10n.cardNameAtkC02;
      case 'atk_c02_up':
        return l10n.cardNameAtkC02Up;
      case 'atk_c03':
        return l10n.cardNameAtkC03;
      case 'atk_c03_up':
        return l10n.cardNameAtkC03Up;
      case 'atk_c04':
        return l10n.cardNameAtkC04;
      case 'atk_c04_up':
        return l10n.cardNameAtkC04Up;
      case 'atk_c05':
        return l10n.cardNameAtkC05;
      case 'atk_c05_up':
        return l10n.cardNameAtkC05Up;
      case 'atk_c06':
        return l10n.cardNameAtkC06;
      case 'atk_c06_up':
        return l10n.cardNameAtkC06Up;
      case 'atk_c07':
        return l10n.cardNameAtkC07;
      case 'atk_c07_up':
        return l10n.cardNameAtkC07Up;
      case 'atk_c08':
        return l10n.cardNameAtkC08;
      case 'atk_c08_up':
        return l10n.cardNameAtkC08Up;
      case 'atk_c09':
        return l10n.cardNameAtkC09;
      case 'atk_c09_up':
        return l10n.cardNameAtkC09Up;
      case 'atk_c10':
        return l10n.cardNameAtkC10;
      case 'atk_c10_up':
        return l10n.cardNameAtkC10Up;
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
      case 'atk_c01':
        return l10n.cardDescAtkC01;
      case 'atk_c01_up':
        return l10n.cardDescAtkC01Up;
      case 'atk_c02':
        return l10n.cardDescAtkC02;
      case 'atk_c02_up':
        return l10n.cardDescAtkC02Up;
      case 'atk_c03':
        return l10n.cardDescAtkC03;
      case 'atk_c03_up':
        return l10n.cardDescAtkC03Up;
      case 'atk_c04':
        return l10n.cardDescAtkC04;
      case 'atk_c04_up':
        return l10n.cardDescAtkC04Up;
      case 'atk_c05':
        return l10n.cardDescAtkC05;
      case 'atk_c05_up':
        return l10n.cardDescAtkC05Up;
      case 'atk_c06':
        return l10n.cardDescAtkC06;
      case 'atk_c06_up':
        return l10n.cardDescAtkC06Up;
      case 'atk_c07':
        return l10n.cardDescAtkC07;
      case 'atk_c07_up':
        return l10n.cardDescAtkC07Up;
      case 'atk_c08':
        return l10n.cardDescAtkC08;
      case 'atk_c08_up':
        return l10n.cardDescAtkC08Up;
      case 'atk_c09':
        return l10n.cardDescAtkC09;
      case 'atk_c09_up':
        return l10n.cardDescAtkC09Up;
      case 'atk_c10':
        return l10n.cardDescAtkC10;
      case 'atk_c10_up':
        return l10n.cardDescAtkC10Up;
      default:
        return card.description;
    }
  }
}
