import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';

class ShowDifferencePage extends StatelessWidget {
  const ShowDifferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO 座標リストを取得
    const answerOffsets = [Offset(21.7, 146.2)];
    const completedOffsets = [Offset(21.7, 146.2)];

    return const SafeArea(
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
                        'https://firebasestorage.googleapis.com/v0/b/flutter-tokyo-hackathon-2023.appspot.com/o/left1.png?alt=media&token=33a33476-d6d8-496b-8397-4057380de429&_gl=1*dc8t3*_ga*MTM4NTI5NTQxMS4xNjI0NDA2OTE5*_ga_CW55HF8NVT*MTY5NjA1ODQ4MC4yODguMS4xNjk2MDU4NDg1LjU1LjAuMA..',
                  ),
                  SizedBox(width: 20),
                  _SpotDifference(
                    answerOffsets: answerOffsets,
                    completedOffsets: completedOffsets,
                    path:
                        'https://firebasestorage.googleapis.com/v0/b/flutter-tokyo-hackathon-2023.appspot.com/o/right2.png?alt=media&token=460c5614-9947-4581-8537-f672a9f8c55d&_gl=1*gsujs6*_ga*MTM4NTI5NTQxMS4xNjI0NDA2OTE5*_ga_CW55HF8NVT*MTY5NjA1ODQ4MC4yODguMS4xNjk2MDU4NTA4LjMyLjAuMA..',
                  ),
                ],
              ),
            ],
          ),
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
        ),);
  }
}
