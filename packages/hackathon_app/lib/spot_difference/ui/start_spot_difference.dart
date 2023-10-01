import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_ui_feedback_controller.dart';
import '../../app_user/app_user.dart';
import '../spot_difference.dart';
import 'create_room_dialog.dart';
import 'room_switching.dart';

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
    final selectedIconId =
        useState<String>('3wRejmI9NPn5MoPCYLrI'); // うさぎのIconId

    final selectedRoomId = useState<String?>(null);

    final roomsAsyncValue = ref.watch(roomsStreamProvider);

    final iconsAsyncValue = ref.watch(iconsSteamProvider);

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
                    icon: Icon(Icons.person),
                    labelText: 'なまえを入力',
                  ),
                ),
              ),
            ),
            const Gap(32),
            iconsAsyncValue.when(
              data: (data) {
                final icons = data ?? [];
                final iconUIs = icons.map((icon) {
                  final isSelectedIcon = selectedIconId.value == icon.iconId;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Stack(
                      children: [
                        GenericImage.circle(
                          imageUrl: icon.imageUrl,
                          onTap: () => selectedIconId.value = icon.iconId,
                          showDetailOnTap: false,
                        ),
                        if (isSelectedIcon)
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(113, 255, 204, 128),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [...iconUIs],
                );
              },
              error: (_, __) => const SizedBox(),
              loading: () => const SizedBox(),
            ),
            const Gap(32),
            Center(
              child: FilledButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  // ルーム選択なし or 表示名未入力の場合は何もしない
                  final roomId = selectedRoomId.value;
                  final displayName = _displayNameTextEditingController.text;
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
                  final icons = ref.read(iconsSteamProvider).valueOrNull ?? [];
                  final imageUrl = icons
                      .firstWhere(
                        (icon) => icon.iconId == selectedIconId.value,
                      )
                      .imageUrl;
                  await ref.read(appUserService).createOrUpdateUser(
                        userId: widget.userId,
                        displayName: displayName,
                        imageUrl: imageUrl,
                      );

                  // 参加時に空のAnswerを作成する
                  await ref
                      .read(spotDifferenceServiceProvider)
                      .createInitialAnswer(
                        roomId: roomId,
                        userId: widget.userId,
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
            roomsAsyncValue.when(
              data: (data) {
                final rooms = data ?? [];
                final roomCards = rooms.map((room) {
                  return _RoomCard(
                    room: room,
                    selectedRoomId: selectedRoomId,
                  );
                }).toList();
                return Column(
                  children: [
                    if (rooms.isEmpty || kDebugMode)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Center(
                          child: FilledButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
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
                      ),
                    ...roomCards,
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomCard extends ConsumerWidget {
  const _RoomCard({required this.room, required this.selectedRoomId});

  final ReadRoom room;
  final ValueNotifier<String?> selectedRoomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spotDifferenceAsyncValue =
        ref.watch(spotDifferenceFutureProvider(room.roomId));
    return spotDifferenceAsyncValue.when(
      data: (spotDifference) {
        if (spotDifference == null) {
          return const SizedBox();
        }
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
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
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
