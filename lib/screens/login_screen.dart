import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:life_quest_final_v2/screens/signup_screen.dart'; // --- 추가된 부분 ---
import 'package:life_quest_final_v2/widgets/translucent_card.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showErrorSnackBar(l10n.loginErrorEmpty);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(e.message ?? l10n.loginErrorFailed);
    } catch (e) {
      _showErrorSnackBar(l10n.loginErrorUnknown(e.toString()));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- 수정된 부분: 회원가입 화면으로 이동 ---
  void _handleSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }
  // --- 여기까지 ---

  Future<void> _handleForgotPassword(AppLocalizations l10n) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showErrorSnackBar(l10n.loginForgotPasswordEmailRequired);
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.loginForgotPasswordSent(email)),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 4),
      ));
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(e.message ?? l10n.loginErrorFailed);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.idToken == null) {
        _showErrorSnackBar(l10n.loginErrorGoogleToken);
        return;
      }
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(e.message ?? l10n.loginErrorGoogle);
    } catch (e) {
      _showErrorSnackBar(l10n.loginErrorUnknown(e.toString()));
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
            padding: const EdgeInsets.all(24.0),
            child: TranslucentCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      isDarkMode
                          ? 'assets/images/splash_logo_dark.png'
                          : 'assets/images/splash_logo.png',
                      height: 132,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'LIFE QUEST',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.0,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.loginTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 48),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: l10n.loginEmailLabel,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: l10n.loginPasswordLabel,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      obscureText: _obscurePassword,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _handleForgotPassword(l10n),
                        child: Text(l10n.loginForgotPassword,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: _handleLogin,
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
                            child: Text(l10n.loginButton,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: _handleSignUp,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              side: BorderSide(
                                  color: theme.colorScheme.primary, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(l10n.loginRegisterButton,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary)),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                      color: isDarkMode
                                          ? Colors.white24
                                          : Colors.black12)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(l10n.loginDivider,
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white54
                                            : Colors.black54,
                                        fontSize: 12)),
                              ),
                              Expanded(
                                  child: Divider(
                                      color: isDarkMode
                                          ? Colors.white24
                                          : Colors.black12)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _handleGoogleSignIn,
                            icon: Image.asset('assets/images/google_logo.png',
                                height: 24.0),
                            label: Text(l10n.loginGoogleButton,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              backgroundColor: isDarkMode
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              foregroundColor:
                                  isDarkMode ? Colors.white : Colors.black87,
                              side: BorderSide(
                                  color: isDarkMode
                                      ? Colors.white12
                                      : Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
