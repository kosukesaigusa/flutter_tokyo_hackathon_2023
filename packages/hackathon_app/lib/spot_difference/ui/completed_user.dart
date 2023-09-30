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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text((index + 1).toString()),
                      const SizedBox(
                        width: 10,
                      ),
                      if (appUser?.imageUrl != null)
                        CircleAvatar(
                          backgroundImage: NetworkImage(appUser!.imageUrl),
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
                      Expanded(
                        child: Text(
                          appUser?.displayName ?? '',
                        ),
                      ),
                    ],
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
