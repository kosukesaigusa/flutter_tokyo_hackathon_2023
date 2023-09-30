import 'package:auto_route/auto_route.dart';

import '../auth/ui/sign_in.dart';
import '../root/ui/root.dart';
import '../spot_difference/ui/start_spot_difference.dart';
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
      path: StartSpotDifferencePage.path,
      page: SignInAnonymouslyRoute.page,
    ),
    AutoRoute(
      path: SocialSignInPage.path,
      page: SocialSignInRoute.page,
    ),
  ];
}
