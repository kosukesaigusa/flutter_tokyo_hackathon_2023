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
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: _RankingCard(
                      imageUrl: appUser?.imageUrl,
                      displayName: appUser?.displayName,
                      index: index,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      error: (e, st) => Text(e.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class _RankingCard extends StatelessWidget {
  const _RankingCard({
    required this.imageUrl,
    required this.displayName,
    required this.index,
  });

  final int index;
  final String? imageUrl;
  final String? displayName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 300,
      child: Row(
        children: [
          Text((index + 1).toString()),
          const SizedBox(
            width: 10,
          ),
          if (imageUrl != null)
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl!),
              radius: 30,
            )
          else
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 30,
              child: const Icon(
                Icons.person,
              ),
            ),
          const SizedBox(
            width: 10,
          ),
          Text(
            displayName ?? '',
          ),
        ],
      ),
    );
  }
}
