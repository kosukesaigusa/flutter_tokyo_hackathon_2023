import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
      body: Column(
        children: [
          const Gap(32),
          const Text('作成する間違い探しルームを選択してください'),
          const Gap(32),
          ref.watch(allSpotDifferencesStreamProvider).when(
                data: (spotDifferences) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: spotDifferences.length,
                      itemBuilder: (context, index) {
                        final spotDifference = spotDifferences[index];
                        final spotDifferenceId =
                            spotDifference.spotDifferenceId;
                        return Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                ref
                                    .read(overlayLoadingStateProvider.notifier)
                                    .update((_) => true);
                                try {
                                  await ref
                                      .read(spotDifferenceServiceProvider)
                                      .createRoom(
                                        spotDifferenceId: spotDifferenceId,
                                        userId: userId,
                                      );
                                  Navigator.of(context).pop();
                                } on FirebaseException catch (e) {
                                  ref
                                      .read(appUIFeedbackControllerProvider)
                                      .showSnackBarByFirebaseException(e);
                                } finally {
                                  ref
                                      .read(
                                        overlayLoadingStateProvider.notifier,
                                      )
                                      .update((_) => false);
                                }
                              },
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      spotDifference.thumbnailImageUrl,
                                      width: 500,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                    const Positioned.fill(
                                      child: ColoredBox(
                                        color:
                                            Color.fromARGB(106, 157, 157, 157),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 10,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            '難易度',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          for (var i = 0;
                                              i < spotDifference.level;
                                              i++)
                                            const Icon(
                                              Icons.star,
                                              color: Colors.white,
                                            ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 250,
                                        left: 20,
                                      ),
                                      child: Text(
                                        spotDifference.name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(16),
                          ],
                        );
                      },
                    ),
                  );
                },
                error: (_, __) => const Center(child: Text('間違い探しの取得に失敗しました。')),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        ],
      ),
    );
  }
}
