import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth.dart';
import '../../auth/ui/auth_controller.dart';
import '../../auth/ui/email_and_password_sign_in.dart';
import '../../auth/ui/sign_in.dart';
import '../../package_info.dart';
import '../../push_notification/firebase_messaging.dart';
import '../../router/router.gr.dart';
import '../../todo/ui/todos.dart';

final rootPageKey = Provider((ref) => GlobalKey<NavigatorState>());

/// メインの [BottomNavigationBar] を含む画面。
@RoutePage()
class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/';

  /// [RootPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  @override
  void initState() {
    super.initState();
    Future.wait<void>([
      ref.read(initializeFirebaseMessagingProvider)(),
      _setFcmTokenIfSignedIn(),
    ]);
  }

  /// FCM トークンを取得し、サインイン済みなら FCM トークンを保存する。
  Future<void> _setFcmTokenIfSignedIn() async {
    final fcmToken = await ref.read(getFcmTokenProvider)();
    if (fcmToken == null) {
      return;
    }
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    // await ref.read(fcmTokenServiceProvider).setUserFcmToken(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      key: ref.watch(rootPageKey),
      appBarBuilder: (_, tabsRouter) => AppBar(
        actions: tabsRouter.activeIndex == 0
            ? [const TodoOrderByDropdownButton()]
            : null,
      ),
      drawer: const Drawer(child: _DrawerChild()),
      routes: const [
        TodosRoute(),
        FooRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Todo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'サンプル',
            ),
          ],
        );
      },
    );
  }
}

class _DrawerChild extends ConsumerWidget {
  const _DrawerChild();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);
    return ListView(
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${packageInfo.packageName} '
                '(${packageInfo.version}+${packageInfo.buildNumber})',
              ),
            ],
          ),
        ),
        if (ref.watch(isSignedInProvider)) ...[
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(ref.watch(userIdProvider)!),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('サインアウト'),
            onTap: () => ref.read(authControllerProvider).signOut(),
          ),
        ] else ...[
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('サインイン（メールアドレスとパスワード）'),
            onTap: () => context.router
                .pushNamed(SignInWithEmailAndPasswordPage.location),
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('サインイン（ソーシャル）'),
            onTap: () => context.router.pushNamed(SocialSignInPage.location),
          ),
        ],
      ],
    );
  }
}
