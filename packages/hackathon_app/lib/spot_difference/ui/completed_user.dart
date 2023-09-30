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
    final completedUsers = ref.watch(completedUsersStreamProvider(roomId));
    return completedUsers.when(
      data: (data) => const SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      ),
      error: (e, st) => const Text('error'),
      loading: () => const Text('data'),
    );
  }
}
