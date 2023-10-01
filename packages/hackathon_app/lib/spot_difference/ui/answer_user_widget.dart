import 'package:dart_flutter_common/dart_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AnswerUserWidget extends StatelessWidget {
  const AnswerUserWidget({
    super.key,
    required this.ranking,
    required this.name,
    required this.imageUrl,
    required this.totalPoints,
    required this.answerPoints,
  });

  final int ranking;
  final String name;
  final String imageUrl;
  final int totalPoints;
  final int answerPoints;

  TextStyle _textStyle(int ranking) {
    switch (ranking) {
      case 1:
        return const TextStyle(fontSize: 30, fontWeight: FontWeight.w900);
      case 2:
        return const TextStyle(fontSize: 25, fontWeight: FontWeight.w800);
      case 3:
        return const TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
      default:
        return const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(2, 8, 2, 0),
      decoration: BoxDecoration(
        color:
            Theme.of(context).buttonTheme.colorScheme?.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Row(
          children: [
            Container(
              width: 30,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                ranking.toString(),
                style: _textStyle(ranking),
                textAlign: TextAlign.center,
              ),
            ),
            GenericImage.circle(
              imageUrl: imageUrl,
              size: 30,
              showDetailOnTap: false,
            ),
            const Gap(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '$answerPoints/$totalPoints',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
