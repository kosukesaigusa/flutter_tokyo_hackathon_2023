import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_controller.dart';

/// 間違い探しを行うルームの UI.
/// そのルームに対応する [roomId] とサインイン済みのユーザーの [userId] を引数として渡す。
class SpotDifferenceRoom extends ConsumerWidget {
  const SpotDifferenceRoom({
    required this.roomId,
    required this.userId,
    super.key,
  });

  final String roomId;

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO 座標リストを取得
    const answerOffsets = [Offset(21.7, 146.2)];
    const completedOffsets = [Offset(21.7, 146.2)];

    return SafeArea(
      child: Scaffold(
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  _SpotDifference(
                    answerOffsets: answerOffsets,
                    completedOffsets: completedOffsets,
                    path:
                        'https://firebasestorage.googleapis.com/v0/b/flutter-tokyo-hackathon-2023.appspot.com/o/left1.png?alt=media&token=33a33476-d6d8-496b-8397-4057380de429',
                  ),
                  Gap(20),
                  _SpotDifference(
                    answerOffsets: answerOffsets,
                    completedOffsets: completedOffsets,
                    path:
                        'https://firebasestorage.googleapis.com/v0/b/flutter-tokyo-hackathon-2023.appspot.com/o/right2.png?alt=media&token=460c5614-9947-4581-8537-f672a9f8c55d',
                  ),
                ],
              ),
            ],
          ),
        ),
        // TODO: 開発中にサインアウトできる手段を与えるために一時的に表示している。
        floatingActionButton: FloatingActionButton(
          onPressed: () => ref.read(authControllerProvider).signOut(),
          child: const Icon(Icons.logout),
        ),
      ),
    );
  }
}

class _SpotDifference extends StatelessWidget {
  const _SpotDifference({
    required this.path,
    required this.answerOffsets,
    required this.completedOffsets,
  });

  final String path;
  final List<Offset> answerOffsets;
  final List<Offset> completedOffsets;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        // TODO(masaki): 最新タップ日時を更新
        // TODO(masaki): 直近5秒(仮)以内にロングタップしたか判定、早期リターン

        // TODO(masaki): 現在地点と正解のリストを比較
        //  正解した場合でもそのidが既に自身が選択しているものであれば、早期リターン

        // TODO(masaki): 正解した場合、そのidをfirestoreへ更新
        //  正解した場合、そのOffset周りに円を描画

        for (final e in answerOffsets) {
          const threshold = 26;
          final distance = (details.localPosition - e).distance;
          final isNearShowDifferenceOffset = distance < threshold;
          print(details.localPosition);
          print(isNearShowDifferenceOffset);
        }
      },
      child: SizedBox(
        width: 300,
        height: 300,
        child: GenericImage.rectangle(
          showDetailOnTap: false,
          aspectRatio: 560 / 578,
          imageUrl: path,
        ),
      ),
    );
  }
}