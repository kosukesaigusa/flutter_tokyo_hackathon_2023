import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app_ui_feedback_controller.dart';
import 'device_info.dart';
import 'firebase_options.dart';
import 'loading/ui/loading.dart';
import 'package_info.dart';
import 'push_notification/firebase_messaging.dart';
import 'router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      overrides: [
        packageInfoProvider.overrideWithValue(await PackageInfo.fromPlatform()),
        deviceInfoProvider.overrideWithValue(await getDeviceInfo()),
        firebaseMessagingProvider
            .overrideWithValue(await getFirebaseMessagingInstance()),
      ],
      child: const MainApp(),
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
