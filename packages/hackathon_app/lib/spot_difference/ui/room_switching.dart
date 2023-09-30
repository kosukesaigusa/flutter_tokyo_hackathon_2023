import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
              return ListView(
                children: [
                  Text('現在の参加人数 ${answers.length.withComma} 人'),
                  if (userId == room.createdByAppUserId)
                    ElevatedButton(
                      onPressed: () => ref
                          .read(spotDifferenceServiceProvider)
                          .playSpotDifference(roomId: room.roomId),
                      child: const Text('間違い探しを開始する'),
                    ),
                ],
              );
            },
            error: (_, __) => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
