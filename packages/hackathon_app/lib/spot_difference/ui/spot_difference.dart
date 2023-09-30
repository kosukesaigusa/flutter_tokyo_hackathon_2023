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
    // TODO 座標リストを取得
    final completedAnswers = [];
    const answerOffsets = [Offset(12.3, 58.4)];
    const completedOffsets = [Offset(15.5, 57.1)];
    final deviceWidth = MediaQuery.of(context).size.width;
    // TODO: 超仮りなので
    final appUsers = [
      const AppUser(displayName: '太郎', imageUrl: ''),
      const AppUser(displayName: '二郎', imageUrl: ''),
      const AppUser(displayName: '三郎', imageUrl: ''),
      const AppUser(displayName: '知ろう', imageUrl: ''),
      const AppUser(displayName: '吾郎', imageUrl: ''),
      const AppUser(displayName: 'ろくろう', imageUrl: ''),
      const AppUser(displayName: '太郎', imageUrl: ''),
      const AppUser(displayName: '二郎', imageUrl: ''),
      const AppUser(displayName: '三郎', imageUrl: ''),
      const AppUser(displayName: '知ろう', imageUrl: ''),
      const AppUser(displayName: '吾郎', imageUrl: ''),
      const AppUser(displayName: 'ろくろう', imageUrl: ''),
      const AppUser(displayName: '太郎', imageUrl: ''),
      const AppUser(displayName: '二郎', imageUrl: ''),
      const AppUser(displayName: '三郎', imageUrl: ''),
      const AppUser(displayName: '知ろう', imageUrl: ''),
      const AppUser(displayName: '吾郎', imageUrl: ''),
      const AppUser(displayName: 'ろくろう', imageUrl: ''),
      const AppUser(displayName: '太郎', imageUrl: ''),
      const AppUser(displayName: '二郎', imageUrl: ''),
      const AppUser(displayName: '三郎', imageUrl: ''),
      const AppUser(displayName: '知ろう', imageUrl: ''),
      const AppUser(displayName: '吾郎', imageUrl: ''),
      const AppUser(displayName: 'ろくろう', imageUrl: ''),
    ];

    return SafeArea(
      child: Scaffold(
        body: ref.watch(spotDifferenceFutureProvider(roomId)).when(
              data: (spotDifference) {
                if (spotDifference == null) {
                  return const Center(child: CircularProgressIndicator());
                }
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
                                        answerOffsets: answerOffsets,
                                        completedOffsets: completedOffsets,
                                        path: spotDifference.leftImageUrl,
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(20),
                                Expanded(
                                  child: _SpotDifference(
                                    answerOffsets: answerOffsets,
                                    completedOffsets: completedOffsets,
                                    path: spotDifference.rightImageUrl,
                                  ),
                                ),
                                // TODO 解答状況を描画
                                Container(
                                  color: Colors.grey[100],
                                  width: deviceWidth / 8,
                                  child: Column(
                                    children: [
                                      ProgressTimeWidget(
                                        startTime: DateTime.now(),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: appUsers.length,
                                          itemBuilder: (context, index) {
                                            return AnswerUserWidget(
                                              ranking: index + 1,
                                              name: appUsers[index].displayName,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
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
              loading: () => const Center(child: CircularProgressIndicator()),
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
    required this.answerOffsets,
    required this.completedOffsets,
  });

  final String path;
  final List<Offset> answerOffsets;
  final List<Offset> completedOffsets;
  final GlobalKey _key = GlobalKey();
  final threshold = 26;
  final defaultDifferenceSize = 300;
  final defaultAnsweredCircleDiameter = 30.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaledAnswerOffsets = useState<List<Offset>>([]);
    final scaledCompletedOffsets = useState<List<Offset>>([]);
    final size = useState<Size>(Size.zero);
    final offset = useState<Offset>(Offset.zero);
    final answeredCircleDiameter =
        useState<double>(defaultAnsweredCircleDiameter);

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

          answeredCircleDiameter.value = defaultAnsweredCircleDiameter *
              size.value.height /
              defaultDifferenceSize;

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

    return Stack(
      children: [
        GestureDetector(
          onLongPressStart: (details) {
            // TODO(masaki): 現在地点と正解のリストを比較
            //  正解した場合でもそのidが既に自身が選択しているものであれば、早期リターン

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
            // タップ出来ない期間中はそもそも何か表示したい
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
          completedOffsets.length,
          (index) => _PositionedCircle(
            dx: completedOffsets[index].dx,
            dy: completedOffsets[index].dy,
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
          // TODO デバイスサイズによってサイズを変更
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
