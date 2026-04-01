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
      builder: (ctx) => AlertDialog(
        title: const Text('닉네임 변경'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: '새 닉네임', counterText: ''),
          autofocus: true,
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                characterState.changeCharacterName(newName);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('변경'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(
      BuildContext context, CharacterState characterState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content:
            const Text('정말로 탈퇴하시겠습니까?\n모든 데이터가 영구적으로 삭제되며, 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
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
            child: const Text('탈퇴 확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterState = context.watch<CharacterState>();
    final isDarkMode = characterState.themeMode == ThemeMode.dark;
    final isNotificationEnabled = characterState.isNotificationEnabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('계정',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          TranslucentCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(PhosphorIcons.userCircle),
                  title: const Text('닉네임'),
                  subtitle: Text(characterState.character.name),
                  trailing: const Icon(PhosphorIcons.caretRight),
                  onTap: () => _showChangeNameDialog(context, characterState),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('앱 설정',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          TranslucentCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('다크 모드'),
                  subtitle: const Text('앱의 전체 테마를 변경합니다.'),
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
                  title: const Text('사운드 효과음 (SFX)'),
                  subtitle: const Text('각종 게임 효과음을 켜거나 끕니다.'),
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
                  title: const Text('알림 설정'),
                  subtitle: const Text('매일 아침 9시에 퀘스트 알림을 받습니다.'),
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
                      if (value) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: const Text(
                              '매일 아침 9시, 저녁 8시에 알림이 예약되었습니다.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green.shade600,
                          ),
                        );
                      } else {
                        messenger.showSnackBar(
                          SnackBar(
                            content: const Text(
                              '모든 알림이 취소되었습니다.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.grey.shade700,
                          ),
                        );
                      }
                    });
                  },
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
          const TranslucentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('광고 후원 안내',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ),
                ListTile(
                  leading:
                      Icon(PhosphorIcons.videoCamera, color: Colors.amber),
                  title: Text('선택형 광고로 앱을 운영합니다'),
                  subtitle: Text(
                    '광고는 퀘스트 보상 2배, AP 회복, 전투 부활처럼 추가 보상이 필요할 때만 표시됩니다.',
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(PhosphorIcons.coins, color: Colors.teal),
                  title: Text('광고 후원형 운영'),
                  subtitle: Text(
                    '현재 버전은 인앱결제보다 광고 수익 중심으로 운영됩니다. 유료 상품은 추후 검토됩니다.',
                  ),
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
                  title: Text('로그아웃',
                      style: TextStyle(color: Colors.red.shade400)),
                  onTap: _handleLogout,
                ),
                const Divider(),
                ListTile(
                  leading: Icon(PhosphorIcons.userCircleMinus,
                      color: Colors.red.shade400),
                  title: Text('회원 탈퇴',
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

