import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/firebase_options.dart';
import 'package:life_quest_final_v2/screens/login_screen.dart';
import 'package:life_quest_final_v2/screens/loading_screen.dart';
import 'package:life_quest_final_v2/services/notification_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/combat_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/services/ad_service.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

const _homeWidgetAppGroupId = String.fromEnvironment(
  'HOME_WIDGET_APP_GROUP_ID',
  defaultValue: 'group.com.example.lifeQuestWidget',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firestore 오프라인 persistence 활성화 (네트워크 없이도 캐시 데이터 사용 가능)
  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    debugPrint('Firestore persistence 설정 실패: $e');
  }

  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider:
          kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    );
  } catch (e) {
    debugPrint('FirebaseAppCheck activation failed: $e');
  }
  await NotificationService().init();
  await SoundService().init();
  await AdService().init(); // Init AdMob

  // Setup HomeWidget (iOS / Android) App Group
  await HomeWidget.setAppGroupId(_homeWidgetAppGroupId);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CharacterState()),
        ChangeNotifierProvider(create: (context) => CombatState()),
        Provider<SoundService>.value(value: SoundService()),
      ],
      child: const LifeQuestApp(),
    ),
  );
}

class LifeQuestApp extends StatelessWidget {
  const LifeQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterState>(
      builder: (context, state, child) {
        // --- Cosmetic Theme Logic ---
        final equippedTheme =
            state.isDataLoaded ? state.character.equippedTheme : null;
        Color primaryColorLight = Colors.indigo.shade600;
        Color primaryColorDark = Colors.indigo.shade300;
        Color? customDarkBg;

        if (equippedTheme == 'theme_neon_cyberpunk') {
          primaryColorDark = Colors.pinkAccent;
          primaryColorLight = Colors.pink;
          customDarkBg = const Color(0xFF0D0221); // Deep dark purple/black
        } else if (equippedTheme == 'theme_royal_gold') {
          primaryColorDark = Colors.amber;
          primaryColorLight = Colors.amber.shade700;
          customDarkBg = const Color(0xFF1E1E1E); // Rich dark gray
        }
        // -----------------------------

        return MaterialApp(
          scaffoldMessengerKey: state.scaffoldMessengerKey,
          title: 'Life Quest',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko'),
            Locale('en'),
            Locale('ja'),
            Locale('zh'),
          ],
          themeMode: state.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            primaryColor: primaryColorLight,
            colorScheme: ColorScheme.light(
              primary: primaryColorLight,
              secondary: Colors.teal.shade500,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                  color: Colors.indigo.shade900,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5),
              iconTheme: IconThemeData(color: Colors.indigo.shade800),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
              bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
              headlineSmall: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24,
                  letterSpacing: -0.5),
              titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
              titleMedium: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.05),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.indigo.shade600,
              unselectedItemColor: Colors.grey.shade400,
              elevation: 10,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              selectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.indigo.shade500, width: 2),
              ),
              labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            primaryColor: primaryColorDark,
            scaffoldBackgroundColor: customDarkBg ?? const Color(0xFF0F172A),
            colorScheme: ColorScheme.dark(
              primary: primaryColorDark, // Custom Cyan/Pink/Amber
              secondary: const Color(0xFFA78BFA), // Pastel Purple
              surface: customDarkBg ?? const Color(0xFF1E293B),
              onSurface: const Color(0xFFF1F5F9), // Slate 100
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                  color: Color(0xFFF1F5F9),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5),
              iconTheme: IconThemeData(color: Color(0xFFF1F5F9)),
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E293B),
              elevation: 8,
              shadowColor: Colors.black.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color(0xFFF1F5F9), fontSize: 16),
              bodyMedium: TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
              headlineSmall: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: -0.5),
              titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20),
              titleMedium: TextStyle(
                  color: Color(0xFFF1F5F9),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF0F172A),
              selectedItemColor: Color(0xFF38BDF8),
              unselectedItemColor: Color(0xFF64748B),
              elevation: 10,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              selectedLabelStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF0F172A),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF334155), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF38BDF8), width: 2),
              ),
              labelStyle:
                  const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
          ),
          home: const AuthWrapper(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showIntro = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _showIntro = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (_showIntro || snapshot.connectionState != ConnectionState.active) {
          return const LoadingScreen();
        }
        if (snapshot.hasData) {
          return LoadingScreen(user: snapshot.data);
        }
        return const LoginScreen();
      },
    );
  }
}





