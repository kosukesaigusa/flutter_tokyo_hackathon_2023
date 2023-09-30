// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter_tokyo_hackathon_2023/auth/ui/sign_in.dart' as _i3;
import 'package:flutter_tokyo_hackathon_2023/auth/ui/sign_in_anonymously.dart'
    as _i2;
import 'package:flutter_tokyo_hackathon_2023/root/ui/root.dart' as _i1;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    RootRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.RootPage(),
      );
    },
    SignInAnonymouslyRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.SignInAnonymouslyPage(),
      );
    },
    SocialSignInRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.SocialSignInPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.RootPage]
class RootRoute extends _i4.PageRouteInfo<void> {
  const RootRoute({List<_i4.PageRouteInfo>? children})
      : super(
          RootRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i2.SignInAnonymouslyPage]
class SignInAnonymouslyRoute extends _i4.PageRouteInfo<void> {
  const SignInAnonymouslyRoute({List<_i4.PageRouteInfo>? children})
      : super(
          SignInAnonymouslyRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInAnonymouslyRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.SocialSignInPage]
class SocialSignInRoute extends _i4.PageRouteInfo<void> {
  const SocialSignInRoute({List<_i4.PageRouteInfo>? children})
      : super(
          SocialSignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SocialSignInRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}
