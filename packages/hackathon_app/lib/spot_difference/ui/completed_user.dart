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
    final completedUsersAsyncValue =
        ref.watch(completedUsersStreamProvider(roomId));

    return completedUsersAsyncValue.when(
      data: (completedUsers) {
        final users = completedUsers ?? [];
        return Scaffold(
          body: Center(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Text(users[index].completedUserId),
                  ],
                );
              },
            ),
          ),
        );
      },
      error: (e, st) => Text(e.toString()),
      loading: () => const Text('data'),
    );
  }
}
