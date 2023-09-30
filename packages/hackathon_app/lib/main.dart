import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_ui_feedback_controller.dart';
import 'firebase_options.dart';
import 'loading/ui/loading.dart';
import 'router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

final _appRouterProvider = Provider.autoDispose<AppRouter>((_) => AppRouter());

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Widget Wizards',
      theme: ThemeData(
        useMaterial3: true,
        sliderTheme: SliderThemeData(
          overlayShape: SliderComponentShape.noOverlay,
        ),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              centerTitle: true,
              elevation: 4,
              shadowColor: Theme.of(context).shadowColor,
            ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(_appRouterProvider).config(),
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
