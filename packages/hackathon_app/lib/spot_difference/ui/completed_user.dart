import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../spot_difference.dart';

class CompletedUserScreen extends ConsumerWidget {
  const CompletedUserScreen({
    required this.roomId,
    super.key,
  });

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedAppUsersAsyncValue =
        ref.watch(completedAppUsersFutureProvider(roomId));

    return completedAppUsersAsyncValue.when(
      data: (appUsers) {
        return Scaffold(
          body: Center(
            child: ListView.builder(
              itemCount: appUsers.length,
              itemBuilder: (context, index) {
                final appUser = appUsers[index];
                return Row(
                  children: [
                    Text(appUser?.displayName ?? ''),
                  ],
                );
              },
            ),
          ),
        );
      },
      error: (e, st) => Text(e.toString()),
      loading: () => const Text('loading'),
    );
  }
}
