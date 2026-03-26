import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:life_quest_final_v2/models/character.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/player_avatar_view.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  File? _selectedImage;
  String _selectedAvatarPreset = playerAvatarPresets.first.id;
  String _selectedAvatarGender = playerAvatarPresets.first.gender;
  String _selectedAvatarSkinTone = playerAvatarPresets.first.skinTone;
  String _selectedAvatarHairStyle = playerAvatarPresets.first.hairStyle;
  String _selectedAvatarEyeStyle = playerAvatarPresets.first.eyeStyle;
  String _selectedAvatarEarStyle = playerAvatarPresets.first.earStyle;
  String _selectedAvatarNoseStyle = playerAvatarPresets.first.noseStyle;
  String _selectedAvatarMouthStyle = playerAvatarPresets.first.mouthStyle;
  String _selectedAvatarOutfitStyle = playerAvatarPresets.first.outfitStyle;

  Widget _buildAvatarPlaceholder(ThemeData theme, {double size = 118}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: size * 0.34,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            '캐릭터 재작업 중',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. 파이어베이스 계정 생성
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('사용자 생성에 실패했습니다.');
      }

      String? photoUrl;
      // 2. 이미지 선택 시 Storage에 업로드
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('users/${user.uid}/profile.jpg');

        await storageRef.putFile(_selectedImage!);
        photoUrl = await storageRef.getDownloadURL();
      }

      final newName = _nameController.text.trim();
      // 3. 생성된 계정의 프로필에 닉네임과 사진 URL 업데이트
      await user.updateDisplayName(newName);
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // 4. Firestore에 초기 데이터 직접 생성
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final initialCharacter = Character(
        name: newName,
        photoUrl: photoUrl,
        level: 1,
        title: '새싹 모험가',
        xp: 0,
        maxXp: CharacterState.xpRequiredForLevel(1),
        strength: 0,
        wisdom: 0,
        health: 0,
        charisma: 0,
        statPoints: 0,
        skillPoints: 0,
        lastLoginDate: DateTime.now(),
        avatarPreset: _selectedAvatarPreset,
        avatarGender: _selectedAvatarGender,
        avatarSkinTone: _selectedAvatarSkinTone,
        avatarHairStyle: _selectedAvatarHairStyle,
        avatarEyeStyle: _selectedAvatarEyeStyle,
        avatarEarStyle: _selectedAvatarEarStyle,
        avatarNoseStyle: _selectedAvatarNoseStyle,
        avatarMouthStyle: _selectedAvatarMouthStyle,
        avatarOutfitStyle: _selectedAvatarOutfitStyle,
      );

      final initialData = {
        'character': initialCharacter.toJson(),
        'dailyQuests': [
          Quest(
                  id: 'd1',
                  name: '아침 7시 기상',
                  xp: 10,
                  type: QuestType.daily,
                  category: StatType.health)
              .toJson(),
          Quest(
                  id: 'd2',
                  name: '운동 30분',
                  xp: 20,
                  type: QuestType.daily,
                  category: StatType.strength)
              .toJson(),
          Quest(
                  id: 'd3',
                  name: '책 10페이지 읽기',
                  xp: 15,
                  type: QuestType.daily,
                  category: StatType.wisdom)
              .toJson(),
        ],
        'weeklyQuests': [
          Quest(
                  id: 'w1',
                  name: '주 3회 이상 운동하기',
                  xp: 100,
                  type: QuestType.weekly,
                  category: StatType.strength)
              .toJson(),
          Quest(
                  id: 'w2',
                  name: '새로운 기술/지식 학습하기',
                  xp: 120,
                  type: QuestType.weekly,
                  category: StatType.wisdom)
              .toJson(),
        ],
        'monthlyQuests': [
          Quest(
                  id: 'm1',
                  name: '이번 달 운동 12회 달성',
                  xp: 140,
                  type: QuestType.monthly,
                  category: StatType.health,
                  difficulty: QuestDifficulty.hard)
              .toJson(),
          Quest(
                  id: 'm2',
                  name: '사이드 프로젝트 핵심 기능 완성',
                  xp: 200,
                  type: QuestType.monthly,
                  category: StatType.wisdom,
                  difficulty: QuestDifficulty.veryHard)
              .toJson(),
        ],
        'yearlyQuests': [
          Quest(
                  id: 'y1',
                  name: '올해 대표 목표 하나 완수하기',
                  xp: 280,
                  type: QuestType.yearly,
                  category: StatType.charisma,
                  difficulty: QuestDifficulty.veryHard)
              .toJson(),
        ],
        'unlockedTitleIds': ['t0'],
        'learnedSkillIds': [],
        'achievementProgress': {}, // 초기에는 비어있음
        'themeMode': ThemeMode.dark.index,
        'isNotificationEnabled': true,
        'lastLoginDate': DateTime.now().toIso8601String(),
      };

      await docRef.set(initialData);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 회원가입 성공! 환영합니다!',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(e.message ?? '회원가입에 실패했습니다.');
    } catch (e) {
      _showErrorSnackBar('알 수 없는 오류가 발생했습니다: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
                child:
                    Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    Widget buildOptionSection(
      String title,
      List<AvatarOption> options,
      String selected,
      ValueChanged<String> onSelected,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              return ChoiceChip(
                label: Text(option.label),
                selected: selected == option.id,
                onSelected: (_) => setState(() => onSelected(option.id)),
              );
            }).toList(),
          ),
        ],
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('새 모험가 등록',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24.0, 100.0, 24.0, 24.0),
            child: TranslucentCard(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: isDarkMode
                              ? Colors.white12
                              : Colors.grey.shade300,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : null,
                          child: _selectedImage == null
                              ? Icon(Icons.camera_alt_outlined,
                                  size: 40,
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.grey.shade600)
                              : null,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon:
                            const Icon(Icons.photo_library_outlined, size: 18),
                        label: const Text('프로필 사진 선택'),
                        style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '내 캐릭터 만들기',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: _buildAvatarPlaceholder(theme, size: 118),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 124,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: playerAvatarPresets.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final preset = playerAvatarPresets[index];
                            final selected = _selectedAvatarPreset == preset.id;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedAvatarPreset = preset.id;
                                  _selectedAvatarGender = preset.gender;
                                  _selectedAvatarSkinTone = preset.skinTone;
                                  _selectedAvatarHairStyle = preset.hairStyle;
                                  _selectedAvatarEyeStyle = preset.eyeStyle;
                                  _selectedAvatarEarStyle = preset.earStyle;
                                  _selectedAvatarNoseStyle = preset.noseStyle;
                                  _selectedAvatarMouthStyle = preset.mouthStyle;
                                  _selectedAvatarOutfitStyle =
                                      preset.outfitStyle;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 110,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white.withValues(alpha: 0.04),
                                  border: Border.all(
                                    color: selected
                                        ? theme.colorScheme.primary
                                        : Colors.white.withValues(alpha: 0.08),
                                    width: selected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 66,
                                      height: 66,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white.withValues(alpha: 0.04),
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.person_outline,
                                        color: theme.colorScheme.primary,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      preset.name,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '성별 스타일',
                        avatarGenderOptions,
                        _selectedAvatarGender,
                        (value) => _selectedAvatarGender = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '피부 톤',
                        avatarSkinToneOptions,
                        _selectedAvatarSkinTone,
                        (value) => _selectedAvatarSkinTone = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '머리',
                        avatarHairOptions,
                        _selectedAvatarHairStyle,
                        (value) => _selectedAvatarHairStyle = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '눈',
                        avatarEyeOptions,
                        _selectedAvatarEyeStyle,
                        (value) => _selectedAvatarEyeStyle = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '귀',
                        avatarEarOptions,
                        _selectedAvatarEarStyle,
                        (value) => _selectedAvatarEarStyle = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '코',
                        avatarNoseOptions,
                        _selectedAvatarNoseStyle,
                        (value) => _selectedAvatarNoseStyle = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '입',
                        avatarMouthOptions,
                        _selectedAvatarMouthStyle,
                        (value) => _selectedAvatarMouthStyle = value,
                      ),
                      const SizedBox(height: 16),
                      buildOptionSection(
                        '의상',
                        avatarOutfitOptions,
                        _selectedAvatarOutfitStyle,
                        (value) => _selectedAvatarOutfitStyle = value,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: '이메일',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return '유효한 이메일을 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: '닉네임',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '닉네임을 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: '비밀번호',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return '비밀번호는 6자 이상이어야 합니다.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: '비밀번호 확인',
                          prefixIcon: Icon(Icons.lock_reset_outlined),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return '비밀번호가 일치하지 않습니다.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: theme.colorScheme.primary
                                .withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('가입 완료',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


