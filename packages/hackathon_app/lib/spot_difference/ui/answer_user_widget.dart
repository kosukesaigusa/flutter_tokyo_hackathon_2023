import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AnswerUserWidget extends StatelessWidget {
  const AnswerUserWidget({
    super.key,
    required this.ranking,
    required this.name,
  });

  final int ranking;
  final String name;

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
      color: Colors.blue[50],
      child: Center(
        child: Row(
          children: [
            const Gap(16),
            SizedBox(
              width: 30,
              child: Text(
                ranking.toString(),
                style: _textStyle(ranking),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
                child: Text(
              name,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
      ),
    );
  }
}
