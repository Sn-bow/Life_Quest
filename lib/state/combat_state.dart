import 'dart:math';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/models/monster.dart';
import 'package:life_quest_final_v2/models/item.dart';
import 'package:life_quest_final_v2/models/character.dart';
import 'package:life_quest_final_v2/models/skill.dart';
import 'package:life_quest_final_v2/data/monster_database.dart';
import 'package:life_quest_final_v2/data/loot_table.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';

enum CombatStatus {
  idle, // No combat, choosing monsters
  fighting, // In combat
  victory, // Monster defeated
  defeat, // Player HP reached 0
}

class CombatResult {
  final int xpGained;
  final EquipmentItem? loot;
  final int goldGained;

  CombatResult({
    required this.xpGained,
    this.loot,
    required this.goldGained,
  });
}

class CombatState extends ChangeNotifier {
  final Random _random = Random();

  CombatStatus _status = CombatStatus.idle;
  Monster? _currentMonster;
  CombatResult? _lastResult;
  String _combatLog = '';
  int _comboCount = 0;
  int _turnCount = 0;
  bool _isDefending = false;
  int? _activeDungeonChapter;
  int? _activeDungeonFloor;
  final Map<String, int> _skillCooldowns = {}; // skillId -> turn when usable

  // Getters
  CombatStatus get status => _status;
  Monster? get currentMonster => _currentMonster;
  CombatResult? get lastResult => _lastResult;
  String get combatLog => _combatLog;
  int get comboCount => _comboCount;

  /// Check if a combat skill is ready to use
  bool isSkillReady(String skillId) {
    return (_skillCooldowns[skillId] ?? 0) <= _turnCount;
  }

  /// Get remaining cooldown turns for a skill
  int getSkillCooldown(String skillId) {
    final readyAt = _skillCooldowns[skillId] ?? 0;
    return (readyAt - _turnCount).clamp(0, 999);
  }

  /// Get available monsters for the player's level
  List<Monster> getAvailableMonsters(int playerLevel) {
    return MonsterDatabase.getMonstersForLevel(playerLevel);
  }

  /// Shared combat formulas so UI and battle logic stay in sync.
  static double effectiveAttack(Character character) {
    double base = character.strength + 5; // Base attack = STR + 5
    if (character.equippedWeapon != null) {
      base += character.equippedWeapon!.attackPower;
      base += character.equippedWeapon!.bonusStrength;
    }
    if (character.equippedAccessory != null) {
      base += character.equippedAccessory!.bonusStrength;
    }
    return base;
  }

  static double effectiveDefense(Character character) {
    double base = character.health * 0.5; // Base defense = HP * 0.5
    if (character.equippedArmor != null) {
      base += character.equippedArmor!.defensePower;
      base += character.equippedArmor!.bonusHealth * 0.3;
    }
    if (character.equippedAccessory != null) {
      base += character.equippedAccessory!.bonusHealth * 0.3;
    }
    return base;
  }

  static double critChance(Character character) {
    return (0.05 + (character.wisdom * 0.005)).clamp(0.05, 0.30).toDouble();
  }

  static double dodgeChance(Character character) {
    return (0.05 + (character.charisma * 0.005)).clamp(0.05, 0.35).toDouble();
  }

  /// Start a fight against a selected monster
  void startCombat(Monster monster, Character character,
      {int? chapter, int? floor}) {
    _currentMonster = monster.copyWith();
    _status = CombatStatus.fighting;
    _lastResult = null;
    _combatLog = '⚔️ ${monster.name}(이)가 무시무시한 기세로 나타났다!';
    _comboCount = 0;
    _turnCount = 0;
    _isDefending = false;
    _activeDungeonChapter = chapter;
    _activeDungeonFloor = floor;
    _skillCooldowns.clear();
    notifyListeners();
  }

  /// Player attacks the monster (consumes 1 Action from UI)
  /// Returns the AP cost (1) or 0 if combat is not active
  int playerAttack(Character character) {
    if (_status != CombatStatus.fighting || _currentMonster == null) return 0;

    _isDefending = false;

    double attack = effectiveAttack(character);
    double baseDamage = (attack - _currentMonster!.defense).clamp(0, double.infinity);
    double variance = attack * 0.2;
    double damage = baseDamage + (_random.nextDouble() * variance * 2 - variance);

    if (damage < 1) damage = 1;

    _comboCount++;
    _turnCount++;

    bool isCrit =
        _random.nextDouble() < critChance(character) || _comboCount % 5 == 0;
    if (isCrit) {
      damage *= 1.5;
      _combatLog =
          '💥 크리티컬 히트! [${character.name}]의 공격이 급소를 찔렀다! (${damage.toInt()} 데미지)';
    } else {
      _combatLog = '⚔️ [${character.name}]의 공격! (${damage.toInt()} 데미지)';
    }

    SoundService().playAttack();

    _currentMonster!.currentHp -= damage;

    if (_currentMonster!.currentHp <= 0) {
      _currentMonster!.currentHp = 0;
      _onMonsterDefeated(character);
    } else {
      _monsterAttack(character);
    }

    notifyListeners();
    return 1;
  }

  /// Player Defends: Reduces next damage by 50% and heals a bit
  int playerDefend(Character character) {
    if (_status != CombatStatus.fighting || _currentMonster == null) return 0;

    _isDefending = true;
    _turnCount++;

    int healAmount = (character.characterMaxHp * 0.05).toInt();
    if (healAmount < 1) healAmount = 1;

    character.characterHp += healAmount;
    if (character.characterHp > character.characterMaxHp) {
      character.characterHp = character.characterMaxHp;
    }

    _combatLog = '🛡️ [${character.name}]은(는) 방어 태세를 취했다! (체력 $healAmount 회복)';

    _monsterAttack(character);
    notifyListeners();
    return 1;
  }

  /// Player Flees: 70% chance to run away
  int playerFlee(Character character) {
    if (_status != CombatStatus.fighting || _currentMonster == null) return 0;

    _isDefending = false;
    _turnCount++;

    if (_random.nextDouble() < 0.70) {
      _combatLog = '🏃 무사히 도망쳤다...!';
      _status = CombatStatus.idle;
      _currentMonster = null;
      _lastResult = null;
    } else {
      _combatLog = '🏃 도망치려 했으나 몬스터가 길을 막았다!';
      _monsterAttack(character);
    }

    notifyListeners();
    return 1;
  }

  void _monsterAttack(Character character) {
    if (_currentMonster == null) return;

    if (_random.nextDouble() < dodgeChance(character)) {
      _combatLog += '\n💨 [${character.name}]은(는) 가볍게 공격을 피했다!';
      return;
    }

    double defense = effectiveDefense(character);
    double baseMonsterDamage = (_currentMonster!.attack - defense * 0.3).clamp(0, double.infinity);
    double variance = _currentMonster!.attack * 0.15;
    double monsterDamage = baseMonsterDamage + (_random.nextDouble() * variance * 2 - variance);

    if (monsterDamage < 1) monsterDamage = 1;

    // Special Monster Attack (20% chance)
    bool isSpecial = _random.nextDouble() < 0.20;
    String attackText = '공격!';
    if (isSpecial) {
      monsterDamage *= 1.5;
      attackText = '치명적인 강타!!';
    }

    // Apply Defend modifier
    if (_isDefending) {
      monsterDamage *= 0.5;
    }

    character.characterHp -= monsterDamage.toInt();

    _combatLog +=
        '\n🔥 ${_currentMonster!.name}의 $attackText (${monsterDamage.toInt()} 데미지)';

    if (character.characterHp <= 0) {
      character.characterHp = 0;
      _status = CombatStatus.defeat;
      _combatLog += '\n💀 눈앞이 깜깜해졌다... 전투 불능...';
      _lastResult = CombatResult(xpGained: 0, goldGained: 0);
    }
  }

  void _onMonsterDefeated(Character character) {
    _status = CombatStatus.victory;
    int xp = _currentMonster!.xpReward;
    int goldReward = (_currentMonster!.level * 5) + _random.nextInt(20);

    // Roll for loot
    EquipmentItem? loot = LootTable.rollLoot(_currentMonster!);

    character.gold += goldReward;
    _lastResult = CombatResult(
      xpGained: xp,
      loot: loot,
      goldGained: goldReward,
    );

    String lootText =
        loot != null ? '\n🎁 드롭: ${loot.name} (${loot.rarity.name})' : '';
    _combatLog = '🎉 ${_currentMonster!.name}을(를) 처치!\n'
        '✨ XP +$xp | 💰 골드 +$goldReward$lootText';

    // Dungeon Progression logic
    if (_activeDungeonChapter != null && _activeDungeonFloor != null) {
      if (_activeDungeonChapter == character.currentDungeonChapter &&
          _activeDungeonFloor == character.highestDungeonFloor) {
        bool isBoss = _activeDungeonFloor! % 5 == 0;
        if (isBoss) {
          character.currentDungeonChapter += 1;
          character.highestDungeonFloor = 1;
          _combatLog += '\n👑 보스 처치! 다음 던전 구역이 열렸습니다!';
        } else {
          character.highestDungeonFloor += 1;
          _combatLog += '\n🗝️ 다음 층으로 가는 길이 열렸습니다!';
        }
      }
    }
  }

  /// Reset combat to idle state
  void endCombat() {
    _status = CombatStatus.idle;
    _currentMonster = null;
    _lastResult = null;
    _combatLog = '';
    _comboCount = 0;
    _turnCount = 0;
    _isDefending = false;
    _skillCooldowns.clear();
    notifyListeners();
  }

  /// Revives the player with 50% HP and resumes combat
  void revive(Character character) {
    if (_status == CombatStatus.defeat) {
      character.characterHp = character.characterMaxHp ~/ 2;
      _status = CombatStatus.fighting;
      _combatLog = '🔥 신비로운 힘으로 부활했습니다! HP가 50% 회복되었습니다.\n\n$_combatLog';
      notifyListeners();
    }
  }

  /// Use a combat skill (damage or heal) with 5-turn cooldown
  /// Returns true if skill was used successfully
  bool useSkill(Skill skill, Character character) {
    if (_status != CombatStatus.fighting || _currentMonster == null) {
      return false;
    }
    if (!isSkillReady(skill.id)) return false;

    _isDefending = false;
    _turnCount++;
    _skillCooldowns[skill.id] = _turnCount + 5; // 5-turn cooldown

    if (skill.effectType == SkillEffectType.combatDamage) {
      double damage = skill.effectValue;
      _currentMonster!.currentHp -= damage;
      _combatLog = '✨ [${skill.name}] 마법 발동! (${damage.toInt()} 데미지)';

      if (_currentMonster!.currentHp <= 0) {
        _currentMonster!.currentHp = 0;
        _onMonsterDefeated(character);
      } else {
        _monsterAttack(character);
      }
    } else if (skill.effectType == SkillEffectType.combatHeal) {
      int heal = skill.effectValue.toInt();
      character.characterHp += heal;
      if (character.characterHp > character.characterMaxHp) {
        character.characterHp = character.characterMaxHp;
      }
      _combatLog = '💚 [${skill.name}] 마법 발동! (체력 $heal 회복)';
      // Monster attacks after heal
      _monsterAttack(character);
    }

    notifyListeners();
    return true;
  }

  /// Equip an item to the character
  void equipItem(Character character, EquipmentItem item) {
    switch (item.type) {
      case ItemType.weapon:
        // Unequip current weapon if any
        if (character.equippedWeapon != null) {
          character.inventory.add(character.equippedWeapon!);
        }
        character.equippedWeapon = item;
        character.inventory.removeWhere((i) => i.id == item.id);
        break;
      case ItemType.armor:
        if (character.equippedArmor != null) {
          character.inventory.add(character.equippedArmor!);
        }
        character.equippedArmor = item;
        character.inventory.removeWhere((i) => i.id == item.id);
        break;
      case ItemType.accessory:
        if (character.equippedAccessory != null) {
          character.inventory.add(character.equippedAccessory!);
        }
        character.equippedAccessory = item;
        character.inventory.removeWhere((i) => i.id == item.id);
        break;
      case ItemType.consumable:
        // Consumables are used immediately, not equipped
        break;
    }
    notifyListeners();
  }

  /// Unequip an item back to inventory
  void unequipItem(Character character, ItemType slot) {
    switch (slot) {
      case ItemType.weapon:
        if (character.equippedWeapon != null) {
          character.inventory.add(character.equippedWeapon!);
          character.equippedWeapon = null;
        }
        break;
      case ItemType.armor:
        if (character.equippedArmor != null) {
          character.inventory.add(character.equippedArmor!);
          character.equippedArmor = null;
        }
        break;
      case ItemType.accessory:
        if (character.equippedAccessory != null) {
          character.inventory.add(character.equippedAccessory!);
          character.equippedAccessory = null;
        }
        break;
      default:
        break;
    }
    notifyListeners();
  }

  /// Open a loot box and add random equipment to character's inventory.
  /// tier 1 = normal (common/uncommon/rare), tier 2 = premium (rare/epic/legendary)
  void openLootBox(Character character, int tier) {
    final item = LootTable.rollLootBoxReward(tier);
    character.inventory.add(item);
    notifyListeners();
  }
}

