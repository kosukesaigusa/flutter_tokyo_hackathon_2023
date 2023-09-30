import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_controller.dart';
import '../../loading/ui/loading.dart';
import '../spot_difference.dart';

// TODO
// - roomsを購読(status:pending or playing)
// - roomを選択できるようにする
// -「参加する」ボタンを押すとそのルームに遷移
// - roomのサムネ表示
// - roomごとに募集中とか入れる

@RoutePage()
class StartSpotDifferencePage extends ConsumerStatefulWidget {
  const StartSpotDifferencePage({super.key});

  /// [AutoRoute] で指定するパス文字列。
  static const path = '/signInAnonymously';

  /// [StartSpotDifferencePage] に遷移する際に `context.router.pushNamed` で
  /// 指定する文字列。
  static const location = path;

  @override
  ConsumerState<StartSpotDifferencePage> createState() =>
      StartSpotDifferencePageState();
}

class StartSpotDifferencePageState
    extends ConsumerState<StartSpotDifferencePage> {
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
    final roomsAsyncValue = ref.watch(roomsStreamProvider);
    return roomsAsyncValue.when(
      data: (roomsData) {
        final rooms = roomsData ?? [];
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
                    onPressed: () => ref
                        .read(authControllerProvider)
                        .signInAnonymously(
                          displayName: _displayNameTextEditingController.text,
                          // TODO: 適当な画像を選ばせると良さそう
                          // imageUrl: '',
                        ),
                    child: const Text('参加する'),
                  ),
                ),
                // ルーム一覧を表示する
                Container(
                  color: Colors.amber,
                  height: 500,
                  child: ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      return Row(
                        children: [
                          // TODO
                          // 画像表示 SpotDifferenceの right or left imageURLでよさそう

                          // 名前表示
                          Text(room.roomStatus.toString()),
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
      loading: () => const OverlayLoading(),
      error: (error, stackTrace) => const Text('エラーが発生しました'),
    );
  }
}
