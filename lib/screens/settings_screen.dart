import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/services/ad_service.dart';
import 'package:life_quest_final_v2/services/notification_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _runRewardedAdCheck(String rewardType, String label) async {
    final messenger = ScaffoldMessenger.of(context);
    final success = await AdService().showRewardedAd(rewardType);
    if (!mounted) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? '$label 광고 보상 검증 성공'
              : '$label 광고를 불러오지 못했습니다. 실패 처리 검증 완료',
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final characterState = context.read<CharacterState>();
    await NotificationService().cancelAllNotifications();
    await FirebaseAuth.instance.signOut();
    characterState.resetState();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _showChangeNameDialog(
      BuildContext context, CharacterState characterState) {
    final nameController =
        TextEditingController(text: characterState.character.name);
    showDialog(
      context: context,
      builder: (ctx) {
        final dialogL10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(dialogL10n.settingsNicknameChangeTitle),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: dialogL10n.settingsNicknameNewLabel, counterText: ''),
            autofocus: true,
            maxLength: 20,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(dialogL10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  characterState.changeCharacterName(newName);
                  Navigator.of(ctx).pop();
                }
              },
              child: Text(dialogL10n.change),
            ),
          ],
        );
      },
    );
  }

  void _showLanguagePicker(
      BuildContext context, CharacterState characterState) {
    final l10n = AppLocalizations.of(context)!;
    final current = characterState.locale?.languageCode;
    final entries = <MapEntry<String?, String>>[
      MapEntry(null, l10n.settingsLanguageSystem),
      MapEntry('ko', l10n.settingsLanguageKorean),
      MapEntry('en', l10n.settingsLanguageEnglish),
      MapEntry('ja', l10n.settingsLanguageJapanese),
      MapEntry('zh', l10n.settingsLanguageChinese),
    ];
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.settingsLanguage),
        children: entries
            .map((e) => SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    characterState
                        .changeLocale(e.key == null ? null : Locale(e.key!));
                  },
                  child: Row(
                    children: [
                      Icon(
                        e.key == current
                            ? PhosphorIcons.checkCircleFill
                            : PhosphorIcons.circle,
                        size: 20,
                        color: e.key == current
                            ? Theme.of(ctx).colorScheme.primary
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(e.value)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  String _languageLabel(AppLocalizations l10n, String? code) {
    switch (code) {
      case 'ko':
        return l10n.settingsLanguageKorean;
      case 'en':
        return l10n.settingsLanguageEnglish;
      case 'ja':
        return l10n.settingsLanguageJapanese;
      case 'zh':
        return l10n.settingsLanguageChinese;
      default:
        return l10n.settingsLanguageSystem;
    }
  }

  void _showDeleteAccountDialog(
      BuildContext context, CharacterState characterState) {
    showDialog(
      context: context,
      builder: (ctx) {
        final dialogL10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(dialogL10n.settingsWithdrawTitle),
          content: Text(dialogL10n.settingsWithdrawBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(dialogL10n.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade800,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.of(ctx).pop();
                await characterState.deleteAccount();
                if (!context.mounted) return;
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(dialogL10n.settingsWithdrawConfirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final characterState = context.watch<CharacterState>();
    final isDarkMode = characterState.themeMode == ThemeMode.dark;
    final isNotificationEnabled = characterState.isNotificationEnabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsScreenTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(l10n.settingsAccountSection,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          TranslucentCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(PhosphorIcons.userCircle),
                  title: Text(l10n.settingsNicknameLabel),
                  subtitle: Text(characterState.character.name),
                  trailing: const Icon(PhosphorIcons.caretRight),
                  onTap: () => _showChangeNameDialog(context, characterState),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.settingsAppSection,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          TranslucentCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.settingsDarkMode),
                  subtitle: Text(l10n.settingsDarkModeSubtitle),
                  secondary: Icon(
                    isDarkMode ? PhosphorIcons.moon : PhosphorIcons.sun,
                  ),
                  value: isDarkMode,
                  onChanged: (bool value) {
                    final newMode = value ? ThemeMode.dark : ThemeMode.light;
                    context.read<CharacterState>().changeThemeMode(newMode);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: Text(l10n.settingsSfx),
                  subtitle: Text(l10n.settingsSfxSubtitle),
                  secondary: Icon(
                    SoundService().isMuted ? Icons.volume_off : Icons.volume_up,
                  ),
                  value: !SoundService().isMuted,
                  onChanged: (bool value) async {
                    await SoundService().toggleMute();
                    setState(() {}); // trigger rebuild to show updated icon
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: Text(l10n.settingsNotification),
                  subtitle: Text(l10n.settingsNotificationSubtitle),
                  secondary: Icon(
                    isNotificationEnabled
                        ? PhosphorIcons.bellRinging
                        : PhosphorIcons.bellSlash,
                  ),
                  value: isNotificationEnabled,
                  onChanged: (bool value) {
                    final characterState = context.read<CharacterState>();
                    characterState.changeNotificationSetting(value).then((_) {
                      if (!context.mounted) return;
                      final messenger = ScaffoldMessenger.of(context);
                      final snackL10n = AppLocalizations.of(context)!;
                      if (value) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              snackL10n.settingsNotificationEnabled,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green.shade600,
                          ),
                        );
                      } else {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              snackL10n.settingsNotificationDisabled,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.grey.shade700,
                          ),
                        );
                      }
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(PhosphorIcons.globe),
                  title: Text(l10n.settingsLanguage),
                  subtitle: Text(
                      _languageLabel(l10n, characterState.locale?.languageCode)),
                  trailing: const Icon(PhosphorIcons.caretRight),
                  onTap: () => _showLanguagePicker(context, characterState),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (kDebugMode) ...[
            const Text('디버그 QA',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            TranslucentCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.ondemand_video),
                    title: const Text('퀘스트 2배 광고 검증'),
                    subtitle: const Text('quest_double 런타임 결과를 직접 확인합니다.'),
                    onTap: () => _runRewardedAdCheck('quest_double', '퀘스트 2배'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.bolt),
                    title: const Text('AP 회복 광고 검증'),
                    subtitle: const Text('ap_recovery 실패/성공 메시지를 확인합니다.'),
                    onTap: () => _runRewardedAdCheck('ap_recovery', 'AP 회복'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text('전투 부활 광고 검증'),
                    subtitle: const Text('combat_revive 실패/성공 메시지를 확인합니다.'),
                    onTap: () => _runRewardedAdCheck('combat_revive', '전투 부활'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          TranslucentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(l10n.settingsAdSupportSection,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ),
                ListTile(
                  leading: const Icon(PhosphorIcons.videoCamera, color: Colors.amber),
                  title: Text(l10n.settingsAdSupportTitle),
                  subtitle: Text(l10n.settingsAdSupportDesc),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(PhosphorIcons.coins, color: Colors.teal),
                  title: Text(l10n.settingsAdModelTitle),
                  subtitle: Text(l10n.settingsAdModelDesc),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TranslucentCard(
            child: Column(
              children: [
                ListTile(
                  leading:
                      Icon(PhosphorIcons.signOut, color: Colors.red.shade400),
                  title: Text(l10n.settingsLogout,
                      style: TextStyle(color: Colors.red.shade400)),
                  onTap: _handleLogout,
                ),
                const Divider(),
                ListTile(
                  leading: Icon(PhosphorIcons.userCircleMinus,
                      color: Colors.red.shade400),
                  title: Text(l10n.settingsWithdraw,
                      style: TextStyle(color: Colors.red.shade400)),
                  onTap: () =>
                      _showDeleteAccountDialog(context, characterState),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
