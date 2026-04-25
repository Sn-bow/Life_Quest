import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:life_quest_final_v2/models/character.dart';
import 'package:life_quest_final_v2/models/quest.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

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
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  File? _selectedImage;

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

    final l10n = AppLocalizations.of(context)!;
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
        title: l10n.initialTitleRookie,
        xp: 0,
        maxXp: CharacterState.xpRequiredForLevel(1),
        strength: 0,
        wisdom: 0,
        health: 0,
        charisma: 0,
        statPoints: 0,
        skillPoints: 0,
        lastLoginDate: DateTime.now(),
      );

      final initialData = {
        'character': initialCharacter.toJson(),
        'dailyQuests': [
          Quest(
                  id: 'd1',
                  name: l10n.initialQuestMorning,
                  xp: 10,
                  type: QuestType.daily,
                  category: StatType.health)
              .toJson(),
          Quest(
                  id: 'd2',
                  name: l10n.initialQuestExercise,
                  xp: 20,
                  type: QuestType.daily,
                  category: StatType.strength)
              .toJson(),
          Quest(
                  id: 'd3',
                  name: l10n.initialQuestRead,
                  xp: 15,
                  type: QuestType.daily,
                  category: StatType.wisdom)
              .toJson(),
        ],
        'weeklyQuests': [
          Quest(
                  id: 'w1',
                  name: l10n.initialQuestWeeklyExercise,
                  xp: 100,
                  type: QuestType.weekly,
                  category: StatType.strength)
              .toJson(),
          Quest(
                  id: 'w2',
                  name: l10n.initialQuestWeeklyLearn,
                  xp: 120,
                  type: QuestType.weekly,
                  category: StatType.wisdom)
              .toJson(),
        ],
        'monthlyQuests': [
          Quest(
                  id: 'm1',
                  name: l10n.initialQuestMonthlyExercise,
                  xp: 140,
                  type: QuestType.monthly,
                  category: StatType.health,
                  difficulty: QuestDifficulty.hard)
              .toJson(),
          Quest(
                  id: 'm2',
                  name: l10n.initialQuestMonthlyProject,
                  xp: 200,
                  type: QuestType.monthly,
                  category: StatType.wisdom,
                  difficulty: QuestDifficulty.veryHard)
              .toJson(),
        ],
        'yearlyQuests': [
          Quest(
                  id: 'y1',
                  name: l10n.initialQuestYearly,
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
          SnackBar(
            content: Text(l10n.signupSuccess,
                style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(e.message ?? l10n.signupErrorFailed);
    } catch (e) {
      _showErrorSnackBar(l10n.signupErrorUnknown(e.toString()));
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.signupTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
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
                        label: Text(l10n.signupPickPhoto),
                        style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: l10n.signupEmailLabel,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.signupEmailRequired;
                          }
                          final email = value.trim();
                          final parts = email.split('@');
                          if (parts.length != 2 ||
                              parts[0].isEmpty ||
                              parts[1].isEmpty ||
                              !parts[1].contains('.')) {
                            return l10n.signupEmailInvalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.signupNicknameLabel,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.signupNicknameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: l10n.signupPasswordLabel,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return l10n.signupPasswordTooShort;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: l10n.signupPasswordConfirmLabel,
                          prefixIcon: const Icon(Icons.lock_reset_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                            onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        obscureText: _obscureConfirm,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return l10n.signupPasswordMismatch;
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
                          child: Text(l10n.signupButton,
                              style: const TextStyle(
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


