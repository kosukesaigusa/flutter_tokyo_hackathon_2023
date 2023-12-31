import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_ui_feedback_controller.dart';
import 'firebase_options.dart';
import 'loading/ui/loading.dart';
import 'root/ui/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Widget Wizards',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        sliderTheme: SliderThemeData(
          overlayShape: SliderComponentShape.noOverlay,
        ),
        textTheme: GoogleFonts.notoSansJpTextTheme(
          Theme.of(context).textTheme,
        ),
        fontFamily: 'Noto Sans JP',
        fontFamilyFallback: const ['Noto Sans JP'],
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', 'JP'),
      ],
      debugShowCheckedModeBanner: false,
      home: const RootPage(),
      builder: (context, child) {
        return Navigator(
          key: ref.watch(navigatorKeyProvider),
          onPopPage: (route, dynamic _) => false,
          pages: [
            MaterialPage<Widget>(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: ScaffoldMessenger(
                      key: ref.watch(scaffoldMessengerKeyProvider),
                      child: child!,
                    ),
                  ),
                  if (ref.watch(overlayLoadingStateProvider))
                    const OverlayLoading(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
