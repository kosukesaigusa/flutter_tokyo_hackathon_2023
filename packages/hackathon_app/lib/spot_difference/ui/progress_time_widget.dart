import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProgressTimeWidget extends HookWidget {
  const ProgressTimeWidget({super.key, required this.startTime});
  final DateTime startTime;

  @override
  Widget build(BuildContext context) {
    final _elapsedSeconds =
        useState<int>(DateTime.now().difference(startTime).inSeconds);

    useEffect(
      () {
        final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _elapsedSeconds.value++;
        });
        return timer.cancel;
      },
      const [],
    );

    String formatTime(int seconds) {
      final minute = seconds ~/ 60;
      final second = seconds % 60;
      return '${minute.toString().padLeft(2, '0')}:'
          '${second.toString().padLeft(2, '0')}';
    }

    return Container(
      height: 50,
      color: Theme.of(context).buttonTheme.colorScheme?.primary ?? Colors.green,
      child: Center(
        child: Text(
          '経過時間:${formatTime(_elapsedSeconds.value)}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
