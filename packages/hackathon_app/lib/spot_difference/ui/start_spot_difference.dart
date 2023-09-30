import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_ui_feedback_controller.dart';
import '../../app_user/app_user.dart';
import '../spot_difference.dart';
import 'create_room_dialog.dart';
import 'waiting_room.dart';

// TODO
// - roomsを購読(status:pending or playing)
// - roomを選択できるようにする
// -「参加する」ボタンを押すとそのルームに遷移
// - roomのサムネ表示
// - roomごとに募集中とか入れる

class StartSpotDifferenceUI extends StatefulHookConsumerWidget {
  const StartSpotDifferenceUI({required this.userId, super.key});

  final String userId;

  @override
  ConsumerState<StartSpotDifferenceUI> createState() =>
      StartSpotDifferenceUIState();
}

class StartSpotDifferenceUIState extends ConsumerState<StartSpotDifferenceUI> {
  late final TextEditingController _displayNameTextEditingController;

  @override
  void initState() {
    _displayNameTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _displayNameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedRoomId = useState<String?>(null);
    final roomsAsyncValue = ref.watch(roomAndSpotDifferencesFutureProvider);
    return roomsAsyncValue.when(
      data: (roomAndSpotDifferencesData) {
        final roomAndSpotDifferences = roomAndSpotDifferencesData;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: [
                const Gap(32),
                UnconstrainedBox(
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _displayNameTextEditingController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '表示名を入力',
                      ),
                    ),
                  ),
                ),
                const Gap(32),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) =>
                            CreateRoomUI(userId: widget.userId),
                        fullscreenDialog: true,
                      ),
                    ),
                    child: const Text('ルームを作成する'),
                  ),
                ),
                const Gap(32),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      // ルーム選択なし or 表示名未入力の場合は何もしない
                      final roomId = selectedRoomId.value;
                      final displayName =
                          _displayNameTextEditingController.text;
                      if (roomId == null) {
                        ref
                            .read(appUIFeedbackControllerProvider)
                            .showSnackBar('間違い探しルームを選択してください');
                        return;
                      }
                      if (displayName.isEmpty) {
                        ref
                            .read(appUIFeedbackControllerProvider)
                            .showSnackBar('表示名を入力してください');
                        return;
                      }
                      await ref.read(appUserService).createOrUpdateUser(
                            userId: widget.userId,
                            displayName: displayName,
                          );
                      await Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<void>(
                          builder: (context) => RoomStatusSwitchingUI(
                            userId: widget.userId,
                            roomId: roomId,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text('参加する'),
                  ),
                ),
                const Gap(32),
                Column(
                  children: roomAndSpotDifferences.map((roomAndSpotDifference) {
                    final room = roomAndSpotDifference.$1;
                    final spotDifference = roomAndSpotDifference.$2;

                    return _RoomCard(
                      room: room,
                      spotDifference: spotDifference,
                      selectedRoomId: selectedRoomId,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox(),
    );
  }
}

class _RoomCard extends HookWidget {
  const _RoomCard({
    required this.room,
    required this.spotDifference,
    required this.selectedRoomId,
  });

  final ReadRoom room;
  final ReadSpotDifference spotDifference;
  final ValueNotifier<String?> selectedRoomId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => selectedRoomId.value = room.roomId,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            child: Stack(
              children: [
                GenericImage.rectangle(
                  imageUrl: spotDifference.thumbnailImageUrl,
                  maxWidth: 500,
                ),
                Positioned.fill(
                  child: ColoredBox(
                    color: selectedRoomId.value == room.roomId
                        ? const Color.fromARGB(
                            158,
                            226,
                            218,
                            61,
                          )
                        : const Color.fromARGB(
                            106,
                            157,
                            157,
                            157,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spotDifference.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      _RoomStatusText(roomStatus: room.roomStatus),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(16),
      ],
    );
  }
}

class _RoomStatusText extends StatelessWidget {
  const _RoomStatusText({
    required this.roomStatus,
  });

  final RoomStatus roomStatus;
  final _textStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    switch (roomStatus) {
      case RoomStatus.pending:
        return Text(
          '待機中',
          style: _textStyle,
        );
      case RoomStatus.playing:
        return Text(
          '開催中',
          style: _textStyle,
        );
      case RoomStatus.completed:
        return Text(
          '終了',
          style: _textStyle,
        );
    }
  }
}
