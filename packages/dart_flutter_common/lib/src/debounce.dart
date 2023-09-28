import 'dart:async';

import 'package:flutter/material.dart';

/// デバウンス処理を提供するクラス。高頻度で発生するイベントを一定時間間隔で処理する。
class Debounce {
  /// コンストラクタ。遅延させる時間をミリ秒で指定する。
  Debounce({required int milliseconds, bool cancelPrevious = true})
      : _milliseconds = milliseconds,
        _cancelPrevious = cancelPrevious;

  /// 遅延させる時間を（ミリ秒）。
  final int _milliseconds;

  /// キャンセル可能なタイマーの設定を行うオプション。
  /// `true` の場合、新しいアクションが来たら以前のタイマーをキャンセルする。
  final bool _cancelPrevious;

  /// 実行されるべきアクションを保持する。
  VoidCallback? _action;

  /// アクションを遅延させるための [Timer] オブジェクト。
  Timer? _timer;

  /// 遅延させたいアクションを登録する。
  /// 前に登録されたアクションがあればキャンセルされ、新しいアクションが設定される。
  void call(VoidCallback action) {
    _action = action;
    if (_cancelPrevious) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: _milliseconds), _execute);
  }

  /// 設定されたアクションを実行する。
  /// アクションが `null` の場合は何も実行されない。
  void _execute() {
    if (_action != null) {
      _action!();
      _action = null;
    }
  }
}
