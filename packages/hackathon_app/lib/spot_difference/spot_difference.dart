import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../exception.dart';
import '../firestore_repository.dart';

final _userAnswerStreamProvider = StreamProvider.autoDispose
    .family<ReadAnswer?, ({String roomId, String appUserId})>((ref, param) {
  final repository = ref.watch(answerRepositoryProvider);
  return repository.subscribeRoomUserAnswer(
    appUserId: param.appUserId,
    roomId: param.roomId,
  );
});

/// 指定した `userId` に一致する [AppUser] を購読する StreamProvider
final appUsersStreamProvider =
    StreamProvider.autoDispose.family<ReadAppUser?, String>(
  (ref, userId) {
    return ref.watch(appUserRepositoryProvider).subscribeUser(userId: userId);
  },
);

/// 指定した `roomId`, `appUserId` に一致する、正解した [Point] の id のリストを取得するプロバイダー
final answeredPointIdsProvider = Provider.autoDispose
    .family<List<String>, ({String roomId, String appUserId})>((ref, param) {
  return ref.watch(_userAnswerStreamProvider(param)).valueOrNull?.pointIds ??
      [];
});

/// 指定した [SpotDifference] の答えの [Point] のリストを購読する StreamProvider
final correctAnswerPointsProvider = StreamProvider.autoDispose
    .family<List<ReadPoint>, String>((ref, spotDifferenceId) {
  final repository = ref.watch(pointRepositoryProvider);
  return repository.subscribePoints(spotDifferenceId: spotDifferenceId);
});

final roomsStreamProvider = StreamProvider.autoDispose<List<ReadRoom>?>((ref) {
  return ref.watch(roomRepositoryProvider).subscribeRooms();
});

// roomごとのspotDifferenceをとってくる必要あり
final roomAndSpotDifferencesFutureProvider =
    FutureProvider.autoDispose<List<(ReadRoom, ReadSpotDifference)>>(
  (ref) {
    final rooms = ref.watch(roomsStreamProvider).valueOrNull ?? [];
    final spotDifferenceRepository =
        ref.watch(spotDifferenceRepositoryProvider);

    return Future.wait(
      rooms.map((room) async {
        final spotDifference =
            await spotDifferenceRepository.fetchSpotDifference(
          spotDifferenceId: room.spotDifferenceId,
        );
        return (room, spotDifference!);
      }),
    );
  },
);

/// 指定した `roomId` の [Answer] のリストを返すStreamProvider
final answersStreamProvider =
    StreamProvider.autoDispose.family<List<ReadAnswer>, String>((ref, roomId) {
  final repository = ref.watch(answerRepositoryProvider);
  return repository.subscribeRoomAnswers(roomId: roomId);
});

/// 指定した `roomId` に一致する [Room] を購読する StreamProvider
final roomStreamProvider = StreamProvider.autoDispose.family<ReadRoom?, String>(
  (ref, roomId) {
    return ref.watch(roomRepositoryProvider).subscribeRoom(roomId: roomId);
  },
);

/// [SpotDifference] 全件を購読する [StreamProvider].
final allSpotDifferencesStreamProvider =
    StreamProvider.autoDispose<List<ReadSpotDifference>>(
  (ref) =>
      ref.watch(spotDifferenceRepositoryProvider).subscribeSpotDifferences(),
);

/// 指定した `roomId` の [SpotDifference] を購読する [FutureProvider].
final spotDifferenceFutureProvider = FutureProvider.family
    .autoDispose<ReadSpotDifference?, String>((ref, roomId) async {
  final room = await ref.watch(roomStreamProvider(roomId).future);
  if (room == null) {
    throw const AppException(message: '間違い探しルームの取得に失敗しました。');
  }
  return ref
      .watch(spotDifferenceRepositoryProvider)
      .fetchSpotDifference(spotDifferenceId: room.spotDifferenceId);
});

/// 指定した `roomId` に一致する [Room] の [CompletedUser] のリストを購読する StreamProvider
final completedUsersStreamProvider =
    StreamProvider.autoDispose.family<List<ReadCompletedUser>?, String>(
  (ref, roomId) {
    return ref
        .watch(completedUserRepositoryProvider)
        .subscribeCompletedUsers(roomId: roomId);
  },
);

/// [Answer] のリストから [AppUser] のリストを変換する FutureProvider
final answeredAppUsersFutureProvider =
    FutureProvider.autoDispose.family<List<ReadAppUser?>, String>(
  (ref, roomId) async {
    final appUserRepository = ref.watch(appUserRepositoryProvider);
    final answers = ref.watch(answersStreamProvider(roomId)).valueOrNull ?? [];
    // ignore: cascade_invocations
    answers.sort((a, b) {
      // pointIdsのサイズに基づいて比較
      final compareSize = b.pointIds.length.compareTo(a.pointIds.length);
      if (compareSize != 0) {
        return compareSize;
      }

      // updatedAtに基づいて比較
      final aUpdatedAt = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bUpdatedAt = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bUpdatedAt.compareTo(aUpdatedAt);
    });
    return Future.wait(
      answers
          .map(
            (user) async {
              return appUserRepository.fetch(userId: user.answerId);
            },
          )
          .toList()
          .reversed,
    );
  },
);

/// 指定した `roomId` に一致する [Room] の開始時刻から現在時刻までの経過時間を返すプロバイダー
final elapsedTimeProvider = Provider.autoDispose.family<String, String>(
  (ref, roomId) {
    final room = ref.watch(roomStreamProvider(roomId)).valueOrNull;
    if (room == null || room.startAt == null) {
      return '';
    }
    final startTime = room.startAt!;
    final elapsedTime = DateTime.now().difference(startTime);
    return elapsedTime.toString().split('.').first;
  },
);

final iconsSteamProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(iconRepositoryProvider).subscribeIcons(),
);

final spotDifferenceServiceProvider =
    Provider.autoDispose<SpotDifferenceService>(
  (ref) => SpotDifferenceService(
    answerRepository: ref.watch(answerRepositoryProvider),
    roomRepository: ref.watch(roomRepositoryProvider),
  ),
);

class SpotDifferenceService {
  const SpotDifferenceService({
    required AnswerRepository answerRepository,
    required RoomRepository roomRepository,
  })  : _answerRepository = answerRepository,
        _roomRepository = roomRepository;

  final AnswerRepository _answerRepository;

  final RoomRepository _roomRepository;

  /// [Point] を追加する
  Future<void> addPoint({
    required String roomId,
    required String answerId,
    required String pointId,
  }) async {
    await _answerRepository.addPoint(
      roomId: roomId,
      answerId: answerId,
      pointId: pointId,
    );
  }

  /// ログイン中のユーザー [userId] が、間違い探しを選択してルームを作成する。
  Future<void> createRoom({
    required String spotDifferenceId,
    required String userId,
  }) =>
      _roomRepository.createRoom(
        spotDifferenceId: spotDifferenceId,
        createdByAppUserId: userId,
      );

  /// 指定した [roomId] に対する最初の [Answer] を作成する（= ルームに参加する）。
  Future<void> createInitialAnswer({
    required String roomId,
    required String userId,
  }) =>
      _answerRepository.createInitialAnswer(roomId: roomId, appUserId: userId);

  /// 指定した [roomId] を playing にする。
  Future<void> playSpotDifference({required String roomId}) =>
      _roomRepository.playRoom(roomId: roomId);
}
