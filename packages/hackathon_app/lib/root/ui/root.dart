import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_dependent_builder.dart';
import '../../auth/ui/sign_in_anonymously.dart';
import '../../spot_difference/ui/spot_difference.dart';

final rootPageKey = Provider((ref) => GlobalKey<NavigatorState>());

/// メインの [BottomNavigationBar] を含む画面。
@RoutePage()
class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/';

  /// [RootPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: ref.watch(rootPageKey),
      body: AuthDependentBuilder(
        // onAuthenticated 以下ではログイン済みの userId が取得できるので子に直接渡して使用する。
        onAuthenticated: (userId) {
          return SpotDifferenceRoom(
            roomId: _roomId,
            userId: userId,
          );
        },
        onUnAuthenticated: SignInAnonymouslyPage.new,
      ),
      // body: const SignInAnonymouslyPage(),
    );
  }
}

// TODO: 仮の roomId で決め打ちしているので修正する。
const _roomId = 'a6aylO1igdisuWJZUpcv';
