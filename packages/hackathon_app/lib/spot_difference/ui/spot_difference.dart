import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    const answerOffsets = [Offset(35.6, 102.8)];
    const completedOffsets = [Offset(21.7, 146.2)];

    return SafeArea(
      child: Scaffold(
        body: Center(
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
                  const Gap(20),
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

class _SpotDifference extends HookConsumerWidget {
  _SpotDifference({
    required this.path,
    required this.answerOffsets,
    required this.completedOffsets,
  });

  final String path;
  final List<Offset> answerOffsets;
  final List<Offset> completedOffsets;
  final GlobalKey _key = GlobalKey();
  final threshold = 26;
  final defaultDifferenceSize = 300;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaledAnswerOffsets = useState<List<Offset>>([]);
    final scaledCompletedOffsets = useState<List<Offset>>([]);
    final size = useState<Size>(Size.zero);
    final offset = useState<Offset>(Offset.zero);

    Offset scaleOffset(
      Offset answerOffset,
    ) {
      final scaleX = size.value.width / defaultDifferenceSize;
      final scaleY = size.value.height / defaultDifferenceSize;

      final newX = answerOffset.dx * scaleX;
      final newY = answerOffset.dy * scaleY;

      return Offset(newX, newY);
    }

    Size getSize() {
      final renderBox = _key.currentContext!.findRenderObject()! as RenderBox;
      return renderBox.size;
    }

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          size.value = getSize();

          offset.value = scaleOffset(answerOffsets.first);

          for (final e in answerOffsets) {
            scaledAnswerOffsets.value =
                scaledAnswerOffsets.value + [scaleOffset(e)];
          }

          for (final e in completedOffsets) {
            scaledCompletedOffsets.value =
                scaledCompletedOffsets.value + [scaleOffset(e)];
          }
        });
        return;
      },
      [],
    );

    return GestureDetector(
      onLongPressStart: (details) {
        // TODO(masaki): 最新タップ日時を更新
        // TODO(masaki): 直近5秒(仮)以内にロングタップしたか判定、早期リターン

        // TODO(masaki): 現在地点と正解のリストを比較
        //  正解した場合でもそのidが既に自身が選択しているものであれば、早期リターン

        // TODO(masaki): 正解した場合、そのidをfirestoreへ更新
        //  正解した場合、そのOffset周りに円を描画

        for (final e in scaledAnswerOffsets.value) {
          final scaledThreshold =
              threshold * size.value.height / defaultDifferenceSize;
          final distance = (details.localPosition - e).distance;
          final isNearShowDifferenceOffset = distance < scaledThreshold;
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
          key: _key,
        ),
      ),
    );
  }
}
