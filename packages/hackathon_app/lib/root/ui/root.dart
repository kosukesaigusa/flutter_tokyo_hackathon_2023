import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_controller.dart';
import '../../auth/ui/auth_dependent_builder.dart';
import '../../spot_difference/ui/start_spot_difference.dart';

final rootPageKey = Provider((ref) => GlobalKey<NavigatorState>());

/// メインの [BottomNavigationBar] を含む画面。
@RoutePage()
class RootPage extends HookConsumerWidget {
  const RootPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/';

  /// [RootPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await ref.read(authControllerProvider).signInAnonymously();
        });
        return;
      },
      [],
    );
    return Scaffold(
      key: ref.watch(rootPageKey),
      body: AuthDependentBuilder(
        onAuthenticated: (userId) {
          return StartSpotDifferenceUI(userId: userId);
        },
        onUnAuthenticated: () =>
            const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// TODO: 仮の roomId で決め打ちしているので修正する。
const _roomId = 'a6aylO1igdisuWJZUpcv';
