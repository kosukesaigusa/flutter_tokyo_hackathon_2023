import 'package:auto_route/auto_route.dart';

import '../auth/ui/sign_in.dart';
import '../auth/ui/sign_in_anonymously.dart';
import '../root/ui/root.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      path: RootPage.path,
      page: RootRoute.page,
    ),
    AutoRoute(
      path: SignInAnonymouslyPage.path,
      page: SignInAnonymouslyRoute.page,
    ),
    AutoRoute(
      path: SocialSignInPage.path,
      page: SocialSignInRoute.page,
    ),
  ];
}
