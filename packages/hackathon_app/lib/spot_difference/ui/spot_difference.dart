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
    final completedAnswers = [];
    const answerOffsets = [Offset(21.7, 146.2)];
    const completedOffsets = [Offset(21.7, 146.2)];
    final deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          _SpotDifference(
                            answerOffsets: answerOffsets,
                            completedOffsets: completedOffsets,
                            path:
                                'https://firebasestorage.googleapis.com/v0/b/flutter-tokyo-hackathon-2023.appspot.com/o/left1.png?alt=media&token=33a33476-d6d8-496b-8397-4057380de429',
                          ),
                          ...List.generate(
                            completedOffsets.length,
                            (index) => _PositionedCircle(
                              dx: completedOffsets[index].dx,
                              dy: completedOffsets[index].dy,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      child: _SpotDifference(
                        answerOffsets: answerOffsets,
                        completedOffsets: completedOffsets,
                        path:
                            'https://firebasestorage.googleapis.com/v0/b/flutter-tokyo-hackathon-2023.appspot.com/o/right2.png?alt=media&token=460c5614-9947-4581-8537-f672a9f8c55d',
                      ),
                    ),
                    // TODO 解答状況を描画
                    SizedBox(
                      width: deviceWidth / 8,
                    ),
                  ],
                ),
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

          //  正解している && 既に解答済みのものでなければ、正解と判断
          if (isNearShowDifferenceOffset && !completedOffsets.contains(e)) {
            // TODO(masaki): そのidをfirestoreへ更新
            //  正解した場合、そのOffset周りに円を描画
            return;
          }
        }
        // TODO(masaki): 正解しなかった場合は、お手つき防止用に最新タップ日時を更新
        // タップ出来ない期間中はそもそも何か表示したい
      },
      child: GenericImage.rectangle(
        showDetailOnTap: false,
        aspectRatio: 560 / 578,
        imageUrl: path,
        key: _key,
      ),
    );
  }
}

class _PositionedCircle extends StatelessWidget {
  const _PositionedCircle({
    required this.dx,
    required this.dy,
  });

  final double dx;
  final double dy;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dx,
      top: dy,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const RadialGradient(
            colors: [Colors.transparent, Colors.red],
            stops: [
              0.88,
              0.9,
            ], // Adjust to suit the diameter of the hole
          ).createShader(bounds);
        },
        child: Container(
          // TODO デバイスサイズによってサイズを変更
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

/// 解答済みの座標を保持するプロバイダー
final completedAnswerOffsetsProvider = StateProvider<List<Offset>>((_) => []);

final latestTryDateTimeProvider = StateProvider<DateTime?>((_) => null);
