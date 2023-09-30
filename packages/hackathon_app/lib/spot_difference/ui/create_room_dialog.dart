import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_ui_feedback_controller.dart';
import '../../loading/ui/loading.dart';
import '../spot_difference.dart';

/// 間違い探しルームを作成する UI.
class CreateRoomUI extends ConsumerWidget {
  const CreateRoomUI({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(allSpotDifferencesStreamProvider).when(
            data: (spotDifferences) {
              return ListView.builder(
                itemCount: spotDifferences.length,
                itemBuilder: (context, index) {
                  final spotDifference = spotDifferences[index];
                  final spotDifferenceId = spotDifference.spotDifferenceId;
                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('難易度'),
                        for (var i = 0; i < spotDifference.level; i++)
                          const Icon(Icons.star),
                      ],
                    ),
                    title: Text(spotDifference.name),
                    trailing: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(overlayLoadingStateProvider.notifier)
                            .update((_) => true);
                        try {
                          ref.read(spotDifferenceServiceProvider).createRoom(
                                spotDifferenceId: spotDifferenceId,
                                userId: userId,
                              );
                        } on FirebaseException catch (e) {
                          ref
                              .read(appUIFeedbackControllerProvider)
                              .showSnackBarByFirebaseException(e);
                        } finally {
                          ref
                              .read(overlayLoadingStateProvider.notifier)
                              .update((_) => false);
                        }
                      },
                      child: const Text('間違い探しルームを作成する'),
                    ),
                  );
                },
              );
            },
            error: (_, __) => const Center(child: Text('間違い探しの取得に失敗しました。')),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
