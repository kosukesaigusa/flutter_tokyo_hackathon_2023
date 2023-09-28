// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter_tokyo_hackathon_2023/auth/ui/email_and_password_sign_in.dart'
    as _i3;
import 'package:flutter_tokyo_hackathon_2023/auth/ui/sign_in.dart' as _i4;
import 'package:flutter_tokyo_hackathon_2023/foo/ui/foo.dart' as _i1;
import 'package:flutter_tokyo_hackathon_2023/root/ui/root.dart' as _i2;
import 'package:flutter_tokyo_hackathon_2023/todo/ui/todos.dart' as _i5;

abstract class $AppRouter extends _i6.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    FooRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.FooPage(),
      );
    },
    RootRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.RootPage(),
      );
    },
    SignInWithEmailAndPasswordRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.SignInWithEmailAndPasswordPage(),
      );
    },
    SocialSignInRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.SocialSignInPage(),
      );
    },
    TodosRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.TodosPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.FooPage]
class FooRoute extends _i6.PageRouteInfo<void> {
  const FooRoute({List<_i6.PageRouteInfo>? children})
      : super(
          FooRoute.name,
          initialChildren: children,
        );

  static const String name = 'FooRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i2.RootPage]
class RootRoute extends _i6.PageRouteInfo<void> {
  const RootRoute({List<_i6.PageRouteInfo>? children})
      : super(
          RootRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i3.SignInWithEmailAndPasswordPage]
class SignInWithEmailAndPasswordRoute extends _i6.PageRouteInfo<void> {
  const SignInWithEmailAndPasswordRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SignInWithEmailAndPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInWithEmailAndPasswordRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i4.SocialSignInPage]
class SocialSignInRoute extends _i6.PageRouteInfo<void> {
  const SocialSignInRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SocialSignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SocialSignInRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i5.TodosPage]
class TodosRoute extends _i6.PageRouteInfo<void> {
  const TodosRoute({List<_i6.PageRouteInfo>? children})
      : super(
          TodosRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodosRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}
