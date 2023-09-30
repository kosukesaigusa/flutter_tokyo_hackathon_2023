import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../spot_difference.dart';
import 'completed_user.dart';
import 'spot_difference.dart';

/// ルームのステータスによって表示すべき内容をスイッチする UI.
class RoomStatusSwitchingUI extends ConsumerWidget {
  const RoomStatusSwitchingUI({
    required this.roomId,
    required this.userId,
    super.key,
  });

  final String roomId;

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(roomStreamProvider(roomId)).when(
          data: (room) {
            if (room == null) {
              return const Center(child: Text('間違い探しルームの取得に失敗しました。'));
            }
            final status = room.roomStatus;
            return switch (status) {
              RoomStatus.pending => WaitingRoomUI(room: room, userId: userId),
              RoomStatus.playing =>
                SpotDifferenceRoom(roomId: roomId, userId: userId),
              RoomStatus.completed => CompletedUserScreen(roomId: roomId),
            };
          },
          error: (_, __) => const Center(child: Text('間違い探しルームの取得に失敗しました。')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}

class WaitingRoomUI extends ConsumerWidget {
  const WaitingRoomUI({
    required this.room,
    required this.userId,
    super.key,
  });

  final ReadRoom room;

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(answersStreamProvider(room.roomId)).when(
            data: (answers) {
              return Center(
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '現在の参加人数 ${answers.length.withComma} 人',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Lottie.asset(
                          'assets/lottie/loading.json',
                          width: 550,
                          height: 550,
                          repeat: true,
                          reverse: false,
                          animate: true,
                        ),
                      ),
                    ),
                    if (userId == room.createdByAppUserId)
                      Center(
                        child: FilledButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 25,
                            ),
                          ),
                          onPressed: () => ref
                              .read(spotDifferenceServiceProvider)
                              .playSpotDifference(roomId: room.roomId),
                          child: const Text('間違い探しを開始する'),
                        ),
                      ),
                  ],
                ),
              );
            },
            error: (_, __) => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
