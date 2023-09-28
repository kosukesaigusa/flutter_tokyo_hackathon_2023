import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'auth_controller.dart';

/// サインアウト時に表示する UI.
class SignedOut extends StatelessWidget {
  const SignedOut({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('機能を使用するには、サインインが必要です。'),
          Text('下記のいずれかの方法でサインインしてください。'),
          Gap(24),
          SignInButtons(),
        ],
      ),
    );
  }
}

/// サインイン方法のボタン一覧を表示する UI.
class SignInButtons extends ConsumerWidget {
  const SignInButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 48,
          child: SignInButton(
            Buttons.google,
            text: 'Google でサインイン',
            onPressed: () async =>
                ref.read(authControllerProvider).signInWithGoogle(),
          ),
        ),
      ],
    );
  }
}
