import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';

final _userAnswerStreamProvider = StreamProvider.autoDispose
    .family<ReadAnswer?, ({String roomId, String appUserId})>((ref, param) {
  final repository = ref.watch(answerRepositoryProvider);
  return repository.subscribeRoomUserAnswer(
    appUserId: param.appUserId,
    roomId: param.roomId,
  );
});

/// 指定した `roomId`, `appUserId` に一致する、正解した [Point] の id のリストを取得するプロバイダー
final answeredPointIdsProvider = Provider.autoDispose
    .family<List<String>, ({String roomId, String appUserId})>((ref, param) {
  return ref.watch(_userAnswerStreamProvider(param)).valueOrNull?.pointIds ??
      [];
});

/// 指定した [SpotDifference] の答えの [Point] のリストを購読する StreamProvider
final correctAnswerPointIdsProvider = StreamProvider.autoDispose
    .family<List<ReadPoint>?, String>((ref, spotDifferenceId) {
  final repository = ref.watch(pointRepositoryProvider);
  return repository.subscribePoints(spotDifferenceId: spotDifferenceId);
});

/// 指定した `roomId` の [Answer] のリストを返すStreamProvider
final answersStreamProvider =
    StreamProvider.autoDispose.family<List<ReadAnswer>?, String>((ref, roomId) {
  final repository = ref.watch(answerRepositoryProvider);
  return repository.subscribeRoomAnswers(roomId: roomId);
});

/// 指定した `roomId` に一致する [Room] を購読する StreamProvider
final _roomStreamProvider =
    StreamProvider.autoDispose.family<ReadRoom?, String>(
  (ref, roomId) {
    return ref.watch(roomRepositoryProvider).subscribeRoom(roomId: roomId);
  },
);

/// 指定した `roomId` に一致する [Room] の開始時刻から現在時刻までの経過時間を返すプロバイダー
final elapsedTimeProvider = Provider.autoDispose.family<String, String>(
  (ref, roomId) {
    final room = ref.watch(_roomStreamProvider(roomId)).valueOrNull;
    if (room == null || room.startAt == null) return '';
    final startTime = room.startAt!;
    final elapsedTime = DateTime.now().difference(startTime);
    return elapsedTime.toString().split('.').first;
  },
);
