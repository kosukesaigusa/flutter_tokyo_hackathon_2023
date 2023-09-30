import 'package:flutter/material.dart';

class AnswerUserWidget extends StatelessWidget {
  const AnswerUserWidget({
    super.key,
    required this.ranking,
    required this.name,
    required this.totalPoints,
    required this.answerPoints,
  });

  final int ranking;
  final String name;
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
    return Column(
      children: [
        SizedBox(
          height: 50,
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
        ),
        const Divider(
          height: 2,
        ),
      ],
    );
  }
}
