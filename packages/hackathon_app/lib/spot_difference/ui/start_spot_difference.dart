import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_ui_feedback_controller.dart';
import '../../app_user/app_user.dart';
import '../spot_difference.dart';
import 'create_room_dialog.dart';
import 'spot_difference.dart';

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
            padding: const EdgeInsets.all(100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _displayNameTextEditingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '表示名を入力',
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
                          builder: (context) => SpotDifferenceRoom(
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
                // ルーム一覧を表示する
                Expanded(
                  child: ListView.builder(
                    itemCount: roomAndSpotDifferences.length,
                    itemBuilder: (context, index) {
                      final room = roomAndSpotDifferences[index].$1;
                      final spotDifference = roomAndSpotDifferences[index].$2;
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
                                  Image.network(
                                    spotDifference.thumbnailImageUrl,
                                    width: 500,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                  const Positioned.fill(
                                    child: ColoredBox(
                                      color: Color.fromARGB(106, 157, 157, 157),
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
