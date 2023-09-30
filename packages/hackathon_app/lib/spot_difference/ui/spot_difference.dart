import 'dart:async';

import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/ui/auth_controller.dart';
import '../spot_difference.dart';
import 'answer_user_widget.dart';
import 'progress_time_widget.dart';

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
    final spotDifference =
        ref.watch(spotDifferenceFutureProvider(roomId)).valueOrNull;

    if (spotDifference == null) {
      return const SizedBox();
    }

    return SafeArea(
      child: Scaffold(
        body: ref
            .watch(
              correctAnswerPointsProvider(
                spotDifference.spotDifferenceId,
              ),
            )
            .when(
              data: (points) {
                return Stack(
                  children: [
                    Center(
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
                                        answerPoints: points,
                                        completedPoints: const [],
                                        path: spotDifference.leftImageUrl,
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(20),
                                Expanded(
                                  child: _SpotDifference(
                                    answerPoints: points,
                                    completedPoints: const [],
                                    path: spotDifference.rightImageUrl,
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outlineVariant,
                                        width: 2, // ボーダーの太さ
                                      ),
                                    ),
                                  ),
                                  child: _Ranking(
                                    roomId: roomId,
                                    spotDifference: spotDifference,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (ref.watch(isRestrictedProvider))
                      // TODO ウィジェット作成
                      const _RestrictionLoading(),
                  ],
                );
              },
              error: (_, __) =>
                  const Center(child: Text('間違い探しルームの取得に失敗しました。')),
              loading: () => const Center(
                child: CircularProgressIndicator(),
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

class _RestrictionLoading extends StatelessWidget {
  const _RestrictionLoading();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black26,
      child: SizedBox.expand(
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '不正解！\n5秒利用禁止です！',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // TODO タイマー or 煽りアニメーション入れたい
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpotDifference extends HookConsumerWidget {
  _SpotDifference({
    required this.path,
    required this.answerPoints,
    required this.completedPoints,
  });

  final String path;
  final List<ReadPoint> answerPoints;
  final List<ReadPoint> completedPoints;
  final GlobalKey _key = GlobalKey();
  final threshold = 26;
  final defaultDifferenceSize = 300;
  final defaultAnsweredCircleDiameter = 30.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaledAnswerPoints = useState<List<_ScaledPoint>>([]);
    final scaledCompletedPoints = useState<List<_ScaledPoint>>([]);
    final size = useState<Size>(Size.zero);
    final answeredCircleDiameter =
        useState<double>(defaultAnsweredCircleDiameter);

    final windowSize = MediaQuery.of(context).size;

    _ScaledPoint scalePoint(
      ReadPoint answerPoint,
    ) {
      final scaleX = size.value.width / defaultDifferenceSize;
      final scaleY = size.value.height / defaultDifferenceSize;

      final newX = answerPoint.x * scaleX;
      final newY = answerPoint.y * scaleY;

      return _ScaledPoint(
        pointId: answerPoint.pointId,
        x: newX,
        y: newY,
      );
    }

    Size getSize() {
      final renderBox = _key.currentContext!.findRenderObject()! as RenderBox;
      return renderBox.size;
    }

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          size.value = getSize();

          answeredCircleDiameter.value = defaultAnsweredCircleDiameter *
              size.value.height /
              defaultDifferenceSize;

          for (final e in answerPoints) {
            scaledAnswerPoints.value =
                scaledAnswerPoints.value + [scalePoint(e)];
          }

          for (final e in completedPoints) {
            scaledCompletedPoints.value =
                scaledCompletedPoints.value + [scalePoint(e)];
          }
        });
        return;
      },
      [
        // ウィンドウサイズが変更される度にuseEffectを呼び出す
        windowSize,
      ],
    );

    return Stack(
      children: [
        GestureDetector(
          onLongPressStart: (details) {
            // 現在地点と正解のリストを比較
            //  正解した場合でもそのidが既に自身が選択しているものであれば、早期リターン

            for (final e in scaledAnswerPoints.value) {
              final scaledThreshold =
                  threshold * size.value.height / defaultDifferenceSize;

              final scaledAnswerOffset = Offset(e.x, e.y);
              final distance =
                  (details.localPosition - scaledAnswerOffset).distance;
              final isNearShowDifferenceOffset = distance < scaledThreshold;
              print(details.localPosition);
              print(isNearShowDifferenceOffset);

              //  正解している場合、idを追加&円を描画
              if (isNearShowDifferenceOffset) {
                // TODO(masaki): そのidをfirestoreへ更新
                //  正解した場合、そのOffset周りに円を描画
                return;
              }
            }
            ref.read(spotDifferenceControllerProvider).restrict();
          },
          child: GenericImage.rectangle(
            showDetailOnTap: false,
            aspectRatio: 560 / 578,
            imageUrl: path,
            key: _key,
          ),
        ),
        ...List.generate(
          completedPoints.length,
          (index) => _PositionedCircle(
            dx: scalePoint(completedPoints[index]).x,
            dy: scalePoint(completedPoints[index]).y,
            diameter: answeredCircleDiameter.value,
          ),
        ),
      ],
    );
  }
}

class _PositionedCircle extends StatelessWidget {
  const _PositionedCircle({
    required this.dx,
    required this.dy,
    required this.diameter,
  });

  final double dx;
  final double dy;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dx - diameter / 2,
      top: dy - diameter / 2,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const RadialGradient(
            colors: [Colors.transparent, Colors.red],
            stops: [
              0.82,
              0.9,
            ],
          ).createShader(bounds);
        },
        child: Container(
          width: diameter,
          height: diameter,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

/// 不正解による利用制限を管理するProvider
final isRestrictedProvider = StateProvider<bool>((_) {
  return false;
});

final spotDifferenceControllerProvider =
    Provider.autoDispose<SpotDifferenceController>(
  (ref) {
    return SpotDifferenceController(
      isRestrictedController: ref.watch(
        isRestrictedProvider.notifier,
      ),
    );
  },
);

class SpotDifferenceController {
  SpotDifferenceController({
    required StateController<bool> isRestrictedController,
  }) : _isRestrictedController = isRestrictedController;

  final StateController<bool> _isRestrictedController;

  /// 利用を5秒間制限する
  Future<void> restrict() async {
    _isRestrictedController.update((state) => true);
    await Future<void>.delayed(const Duration(seconds: 5));
    _isRestrictedController.update((state) => false);
  }
}

class _Ranking extends HookConsumerWidget {
  const _Ranking({required this.roomId, required this.spotDifference});

  final String roomId;
  final ReadSpotDifference spotDifference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ProgressTimeWidget(
          startTime: DateTime.now(),
        ),
        const Divider(
          height: 2,
        ),
        Expanded(
          child: ref.watch(answersStreamProvider(roomId)).when(
                data: (answers) {
                  if (answers == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: answers.length,
                    itemBuilder: (context, index) {
                      final appUsers = ref
                          .watch(
                            appUsersFutureProvider(answers[index].answerId),
                          )
                          .valueOrNull;
                      return AnswerUserWidget(
                        ranking: index + 1,
                        name: appUsers?.displayName ?? '',
                        answerPoints: answers[index].pointIds.length,
                        totalPoints: spotDifference.pointIds.length,
                      );
                    },
                  );
                },
                error: (_, __) => const Center(child: Text('回答者の取得に失敗しました。')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
        ),
      ],
    );
  }
}

/// 画面サイズに応じて変換された座標を持つクラス
class _ScaledPoint {
  _ScaledPoint({
    required this.pointId,
    required this.x,
    required this.y,
  });

  final String pointId;
  final double x;
  final double y;
}
