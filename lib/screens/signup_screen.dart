import 'dart:io';
import 'package:provider/provider.dart';
import '../features/session/cloud_profile_registration.dart';
import '../features/session/session_state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  final CloudProfileRegistration? registration;
  const SignUpScreen({super.key, this.registration});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  late final CloudProfileRegistration _registration;

  @override
  void initState() {
    super.initState();
    _registration = widget.registration ?? CloudProfileRegistration();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  File? _selectedImage;

  Future<void> _pickImage() async {
    if (_isLoading) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150,
      );
      if (!mounted || pickedImage == null) return;
      setState(() => _selectedImage = File(pickedImage.path));
    } catch (_) {
      if (mounted) _showErrorSnackBar(l10n.signupErrorFailed);
    }
  }

  Future<void> _handleSignUp() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    final session = context.read<SessionState>();
    final languageCode = Localizations.localeOf(context).languageCode;
    session.setCloudRegistrationPending(true);
    setState(() => _isLoading = true);
    try {
      await _registration.finish(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        languageCode: languageCode,
        photo: _selectedImage,
      );
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      session.setCloudRegistrationPending(false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.signupSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        _showErrorSnackBar(
          _registration.hasCreatedAccount
              ? l10n.signupSetupRetryNotice
              : e.message ?? l10n.signupErrorFailed,
        );
      }
      if (!_registration.hasCreatedAccount) {
        session.setCloudRegistrationPending(false);
      }
    } catch (_) {
      if (mounted) {
        _showErrorSnackBar(
          _registration.hasCreatedAccount
              ? l10n.signupSetupRetryNotice
              : l10n.signupErrorFailed,
        );
      }
      if (!_registration.hasCreatedAccount) {
        session.setCloudRegistrationPending(false);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _leaveSetup() async {
    if (_isLoading) return;
    final session = context.read<SessionState>();
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      await _registration.leaveSetup();
      if (!mounted) return;
      session.setCloudRegistrationPending(false);
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) _showErrorSnackBar(l10n.signupSetupRetryNotice);
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth > 608
        ? (screenWidth - 560) / 2
        : 24.0;

    return PopScope(
      canPop: !_isLoading && !_registration.hasCreatedAccount,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_isLoading) _leaveSetup();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            l10n.signupTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                100,
                horizontalPadding,
                24,
              ),
              child: TranslucentCard(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _isLoading ? null : _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: isDarkMode
                                ? Colors.white12
                                : Colors.grey.shade300,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : null,
                            child: _selectedImage == null
                                ? Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                    color: isDarkMode
                                        ? Colors.white54
                                        : Colors.grey.shade600,
                                  )
                                : null,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _isLoading ? null : _pickImage,
                          icon: const Icon(
                            Icons.photo_library_outlined,
                            size: 18,
                          ),
                          label: Text(l10n.signupPickPhoto),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_registration.hasCreatedAccount) ...[
                          Text(l10n.signupSetupPending),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          controller: _emailController,
                          readOnly:
                              _isLoading || _registration.hasCreatedAccount,
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
                          readOnly: _isLoading,
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
                          readOnly:
                              _isLoading || _registration.hasCreatedAccount,
                          decoration: InputDecoration(
                            labelText: l10n.signupPasswordLabel,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.length < 6) {
                              return l10n.signupPasswordTooShort;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          readOnly:
                              _isLoading || _registration.hasCreatedAccount,
                          decoration: InputDecoration(
                            labelText: l10n.signupPasswordConfirmLabel,
                            prefixIcon: const Icon(Icons.lock_reset_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
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
                              shadowColor: theme.colorScheme.primary.withValues(
                                alpha: 0.4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              _registration.hasCreatedAccount
                                  ? l10n.signupFinishSetup
                                  : l10n.signupButton,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
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
