import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:firebase_common/firebase_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

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

    final answers = ref.watch(answersStreamProvider(roomId)).valueOrNull;
    if (answers == null) {
      return const SizedBox();
    }
    final myAnswer = answers.firstWhereOrNull((e) => e.answerId == userId);

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
                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(
                                    '間違いを見つけて長押ししてね',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Row(
                                  children: [
                                    _SpotDifference(
                                      roomId: roomId,
                                      answerId: userId,
                                      answerPoints: points,
                                      completedPointIds:
                                          myAnswer?.pointIds ?? [],
                                      path: spotDifference.leftImageUrl,
                                    ),
                                    const Gap(2),
                                    _SpotDifference(
                                      roomId: roomId,
                                      answerId: userId,
                                      answerPoints: points,
                                      completedPointIds:
                                          myAnswer?.pointIds ?? [],
                                      path: spotDifference.rightImageUrl,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _Ranking(
                          roomId: roomId,
                          spotDifference: spotDifference,
                          answers: answers,
                        ),
                      ],
                    ),
                    if (ref.watch(answerStatusProvider) ==
                        AnswerStatus.restricted)
                      const _AnswerStatusPopUp(
                        message: '不正解...',
                        animationPath: 'assets/lottie/loading_slider.json',
                      ),
                    if (ref.watch(answerStatusProvider) ==
                        AnswerStatus.celebrated)
                      const _AnswerStatusPopUp(
                        message: '正解！！',
                        animationPath: 'assets/lottie/celebration.json',
                      ),
                  ],
                );
              },
              error: (_, __) =>
                  const Center(child: Text('間違い探しルームの取得に失敗しました。')),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
      ),
    );
  }
}

class _AnswerStatusPopUp extends StatelessWidget {
  const _AnswerStatusPopUp({
    required this.message,
    required this.animationPath,
  });

  final String message;
  final String animationPath;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black26,
      child: SizedBox.expand(
        child: Center(
          child: Container(
            width: 240,
            height: 240,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(16),
                  Flexible(
                    child: Lottie.asset(
                      animationPath,
                      repeat: true,
                      reverse: false,
                      animate: true,
                    ),
                  ),
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
    required this.roomId,
    required this.answerId,
    required this.path,
    required this.answerPoints,
    required this.completedPointIds,
  });

  final String roomId;
  final String answerId;
  final String path;
  final List<ReadPoint> answerPoints;
  final List<String> completedPointIds;
  final GlobalKey _key = GlobalKey();
  final threshold = 20;
  final defaultDifferenceSize = 300;
  final defaultAnsweredCircleDiameter = 40.0;

  /// answerPointsの中でcompletedPointIdsに含まれるReadPointのリスト
  List<ReadPoint> get completedPoints {
    return answerPoints
        .where(
          (element) => completedPointIds.contains(element.pointId),
        )
        .toList();
  }

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

    return Expanded(
      child: Stack(
        children: [
          GestureDetector(
            onLongPressStart: (details) {
              // 現在地点と正解のリストを比較
              for (final e in scaledAnswerPoints.value) {
                final scaledThreshold =
                    threshold * size.value.height / defaultDifferenceSize;

                final scaledAnswerOffset = Offset(e.x, e.y);
                final distance =
                    (details.localPosition - scaledAnswerOffset).distance;
                final isNearShowDifferenceOffset = distance < scaledThreshold;

                //  正解している場合
                if (isNearShowDifferenceOffset) {
                  // 既に正解している箇所であれば処理を終了（不正解とまではしない）
                  if (completedPointIds.contains(e.pointId)) {
                    return;
                  }

                  //  データの更新とお祝いポップアップの表示
                  ref.read(spotDifferenceServiceProvider).addPoint(
                        roomId: roomId,
                        answerId: answerId,
                        pointId: e.pointId,
                      );

                  ref.read(spotDifferenceControllerProvider).celebrate();
                  return;
                }
              }
              // 不正解の場合、制限をかける
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
      ),
    );
  }
}

/// 正解した箇所に表示される赤丸
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
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.red,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

enum AnswerStatus {
  /// 不正解による制限中
  restricted,

  /// 正解によるお祝い中
  celebrated,

  /// 通常
  normal,
}

/// 回答の状況を管理するProvider
final answerStatusProvider = StateProvider<AnswerStatus>(
  (_) => AnswerStatus.normal,
);

final spotDifferenceControllerProvider =
    Provider.autoDispose<SpotDifferenceController>(
  (ref) {
    return SpotDifferenceController(
      answerStatusController: ref.watch(
        answerStatusProvider.notifier,
      ),
    );
  },
);

class SpotDifferenceController {
  SpotDifferenceController({
    required StateController<AnswerStatus> answerStatusController,
  }) : _answerStatusController = answerStatusController;

  final StateController<AnswerStatus> _answerStatusController;

  /// 利用をアニメーションに合わせて約5秒間制限する
  Future<void> restrict() async {
    _answerStatusController.update((state) => AnswerStatus.restricted);
    await Future<void>.delayed(const Duration(milliseconds: 5200));
    _answerStatusController.update((state) => AnswerStatus.normal);
  }

  /// お祝いポップアップを表示する
  Future<void> celebrate() async {
    _answerStatusController.update((state) => AnswerStatus.celebrated);
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    _answerStatusController.update((state) => AnswerStatus.normal);
  }
}

class _Ranking extends HookConsumerWidget {
  const _Ranking({
    required this.roomId,
    required this.spotDifference,
    required this.answers,
  });

  final String roomId;
  final ReadSpotDifference spotDifference;
  final List<ReadAnswer> answers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (answers.isNotEmpty) {
      answers.sort((a, b) {
        if (a.updatedAt == null || b.updatedAt == null) {
          return 0;
        }
        if (a.pointIds.length > b.pointIds.length) {
          return -1;
        } else if (a.pointIds.length < b.pointIds.length) {
          return 1;
        } else {
          return a.updatedAt!.compareTo(b.updatedAt!);
        }
      });
    }

    return Container(
      width: 180,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        children: [
          ref.watch(roomStreamProvider(roomId)).when(
                data: (room) {
                  if (room == null || room.startAt == null) {
                    return const SizedBox();
                  }
                  return ProgressTimeWidget(
                    startTime: room.startAt!,
                  );
                },
                error: (_, __) => const SizedBox(
                  height: 50,
                  child: Center(child: Text('開始時間の取得に失敗しました。')),
                ),
                loading: () => const SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          const Divider(
            height: 2,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                final appUser = ref
                    .watch(
                      appUsersStreamProvider(answers[index].answerId),
                    )
                    .valueOrNull;
                return AnswerUserWidget(
                  ranking: index + 1,
                  name: appUser?.displayName ?? '・・・',
                  imageUrl: appUser?.imageUrl ?? '',
                  answerPoints: answers[index].pointIds.length,
                  totalPoints: spotDifference.pointIds.length,
                );
              },
            ),
          ),
        ],
      ),
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
