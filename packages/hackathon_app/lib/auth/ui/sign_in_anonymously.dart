import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/ui/auth_controller.dart';

@RoutePage()
class SignInAnonymouslyPage extends ConsumerStatefulWidget {
  const SignInAnonymouslyPage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/signInAnonymously';

  /// [SignInAnonymouslyPage] に遷移する際に `context.router.pushNamed` で
  /// 指定する文字列。
  static const location = path;

  @override
  ConsumerState<SignInAnonymouslyPage> createState() =>
      SignInAnonymouslyPageState();
}

class SignInAnonymouslyPageState extends ConsumerState<SignInAnonymouslyPage> {
  late final TextEditingController _displayNameTextEditingController;

  @override
  void initState() {
    _displayNameTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _displayNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _displayNameTextEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '表示名を入力',
              ),
            ),
            const Gap(32),
            Center(
              child: ElevatedButton(
                onPressed: () =>
                    ref.read(authControllerProvider).signInAnonymously(
                          displayName: _displayNameTextEditingController.text,
                          // TODO: 適当な画像を選ばせると良さそう
                          // imageUrl: '',
                        ),
                child: const Text('サインイン'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
