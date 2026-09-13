import 'dart:async';
import 'package:life_quest_final_v2/theme/quest_theme.dart';
import 'package:life_quest_final_v2/features/director/quest_director_state.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_quest_final_v2/config/monetization_config.dart';
import 'package:life_quest_final_v2/config/qa_preview_config.dart';
import 'package:life_quest_final_v2/firebase_options.dart';
import 'features/session/session_gate.dart';
import 'features/session/session_state.dart';
import 'config/cloud_config.dart';
import 'package:life_quest_final_v2/screens/qa_preview_gate_screen.dart';
import 'package:life_quest_final_v2/services/notification_service.dart';
import 'package:life_quest_final_v2/state/character_state.dart';
import 'package:life_quest_final_v2/state/combat_state.dart';
import 'package:life_quest_final_v2/state/card_combat_state.dart';
import 'package:life_quest_final_v2/state/dungeon_state.dart';
import 'package:life_quest_final_v2/services/sound_service.dart';
import 'package:life_quest_final_v2/services/ad_service.dart';
import 'package:life_quest_final_v2/services/purchase_service.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:life_quest_final_v2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

const _homeWidgetAppGroupId = String.fromEnvironment(
  'HOME_WIDGET_APP_GROUP_ID',
  defaultValue: 'group.com.lifequest.app.widget',
);

void main() {
  // runZonedGuarded을 가장 먼저 시작해야 Flutter 바인딩 Zone 충돌을 방지함
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      LicenseRegistry.addLicense(() async* {
        yield LicenseEntryWithLineBreaks(
          ['Gemma 4 E2B'],
          'Google Gemma 4 E2B. Unmodified model weights.\n'
          'Source: https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm\n\n'
          '${await rootBundle.loadString('assets/licenses/Apache-2.0.txt')}',
        );
        yield LicenseEntryWithLineBreaks(
          ['LiteRT-LM Android 0.17.0'],
          await rootBundle.loadString('assets/licenses/LiteRT-LM-LICENSE.txt'),
        );
      });
      if (!kLifeQuestQaPreview && kLifeQuestCloudEnabled) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        // Crashlytics: Flutter 프레임워크 에러 캡처
        FlutterError.onError = (errorDetails) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };

        // Firestore 오프라인 persistence 활성화
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
            androidProvider: kDebugMode
                ? AndroidProvider.debug
                : AndroidProvider.playIntegrity,
          );
        } catch (e) {
          debugPrint('FirebaseAppCheck activation failed: $e');
        }
      } else {
        FlutterError.onError = (errorDetails) {
          FlutterError.presentError(errorDetails);
        };
      }

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => CharacterState()),
            ChangeNotifierProvider(
              create: (context) => SessionState()..initialize(),
            ),
            ChangeNotifierProvider(create: (context) => QuestDirectorState()),
            ChangeNotifierProvider(create: (context) => CombatState()),
            ChangeNotifierProvider(create: (context) => CardCombatState()),
            ChangeNotifierProvider(create: (context) => DungeonState()),
            Provider<SoundService>.value(value: SoundService()),
          ],
          child: const LifeQuestApp(),
        ),
      );

      if (!kLifeQuestQaPreview) {
        unawaited(_initializeOptionalServices());
      }
    },
    (error, stack) {
      if (kLifeQuestQaPreview ||
          !kLifeQuestCloudEnabled ||
          Firebase.apps.isEmpty) {
        debugPrint('Uncaught QA preview error: $error');
        debugPrintStack(stackTrace: stack);
        return;
      }
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

Future<void> _initializeOptionalServices() async {
  await _runStartupTask(
    'NotificationService.init',
    () => NotificationService().init(),
  );
  await _runStartupTask('SoundService.init', () => SoundService().init());
  if (kLifeQuestAdsEnabled) {
    await _runStartupTask(
      'AdService.init',
      () => AdService().init(),
      timeout: const Duration(seconds: 12),
    );
  }
  if (kLifeQuestMonetizationEnabled) {
    await _runStartupTask(
      'PurchaseService.init',
      () => PurchaseService().init(),
      timeout: const Duration(seconds: 12),
    );
  }
  await _runStartupTask(
    'HomeWidget.setAppGroupId',
    () => HomeWidget.setAppGroupId(_homeWidgetAppGroupId),
  );
}

Future<void> _runStartupTask(
  String name,
  Future<void> Function() task, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  try {
    await task().timeout(timeout);
  } catch (error, stack) {
    debugPrint('$name failed: $error');
    if (!kLifeQuestCloudEnabled) return;
    await FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: name,
      fatal: false,
    );
  }
}

class LifeQuestApp extends StatelessWidget {
  const LifeQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterState>(
      builder: (context, state, child) {
        final cosmetic = state.isDataLoaded
            ? state.character.equippedTheme
            : null;

        return MaterialApp(
          scaffoldMessengerKey: state.scaffoldMessengerKey,
          title: 'Life Quest',
          scrollBehavior: const LifeQuestScrollBehavior(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: state.locale,
          supportedLocales: const [
            Locale('ko'),
            Locale('en'),
            Locale('ja'),
            Locale('zh'),
          ],
          themeMode: state.themeMode,
          theme: QuestTheme.build(Brightness.light, cosmetic: cosmetic),
          darkTheme: QuestTheme.build(Brightness.dark, cosmetic: cosmetic),
          home: kLifeQuestQaPreview
              ? const QaPreviewGateScreen()
              : const SessionGate(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class LifeQuestScrollBehavior extends MaterialScrollBehavior {
  const LifeQuestScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}
