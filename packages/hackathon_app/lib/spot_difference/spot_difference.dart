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
final appUsersFutureProvider =
    FutureProvider.autoDispose.family<ReadAppUser?, String>(
  (ref, userId) async {
    return ref.watch(appUserRepositoryProvider).fetch(userId: userId);
  },
);

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

// final spotDifferenceStreamProvider3 = StreamProvider.autoDispose<
//     List<({ReadRoom room, ReadSpotDifference spotDifference})>?>(
//   (ref) {
//     final repository = ref.watch(spotDifferenceRepositoryProvider);
//     return ref.watch(roomsStreamProvider).when(
//           data: (rooms) {
//             if (rooms == null) {
//               return Stream.value(null);
//             }
//             return Stream.value(
//               rooms.map(
//                 (room) async {
//                   final spotDifference = repository.subscribeSpotDifference(
//                     spotDifferenceId: room.spotDifferenceId,
//                   );
//                   return {
//                     'room': room,
//                     'spotDifference': spotDifference,
//                   };
//                 },
//               ).toList(),
//             );
//           },
//           error: (_, __) => Stream.value(null),
//           loading: () => Stream.value(null),
//         );
//   },
// );

/// 指定した `roomId` の [Answer] のリストを返すStreamProvider
final answersStreamProvider =
    StreamProvider.autoDispose.family<List<ReadAnswer>?, String>((ref, roomId) {
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

/// [CompletedUser] のリストから [AppUser] のリストを変換する FutureProvider
final completedAppUsersFutureProvider =
    FutureProvider.autoDispose.family<List<ReadAppUser?>, String>(
  (ref, roomId) async {
    final appUserRepository = ref.watch(appUserRepositoryProvider);
    final completedUsers =
        ref.watch(completedUsersStreamProvider(roomId)).valueOrNull ?? [];
    return Future.wait(
      completedUsers
          .map(
            (user) async {
              return appUserRepository.fetch(userId: user.completedUserId);
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
}
