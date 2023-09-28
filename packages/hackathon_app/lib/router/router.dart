import 'package:auto_route/auto_route.dart';

import '../auth/ui/email_and_password_sign_in.dart';
import '../auth/ui/sign_in.dart';
import '../foo/ui/foo.dart';
import '../root/ui/root.dart';
import '../todo/ui/todos.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      path: RootPage.path,
      page: RootRoute.page,
      children: [
        AutoRoute(
          path: TodosPage.path,
          page: TodosRoute.page,
        ),
        AutoRoute(
          path: FooPage.path,
          page: FooRoute.page,
        ),
      ],
    ),
    AutoRoute(
      path: SignInWithEmailAndPasswordPage.path,
      page: SignInWithEmailAndPasswordRoute.page,
    ),
    AutoRoute(
      path: SocialSignInPage.path,
      page: SocialSignInRoute.page,
    ),
  ];
}
