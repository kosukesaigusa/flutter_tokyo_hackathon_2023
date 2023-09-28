import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class FooPage extends ConsumerWidget {
  const FooPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = 'foo';

  /// [FooPage] に遷移する際に `context.router.pushNamed` で指定する文字列。
  static const location = path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(child: Text('Foo')),
    );
  }
}
