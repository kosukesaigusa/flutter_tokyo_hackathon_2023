import '../firestore_documents/_export.dart';

class RoomRepository {
  final _query = RoomQuery();

  /// 全ての [Room] を購読する
  Stream<List<ReadRoom>?> subscribeRooms() => _query.subscribeDocuments(
        queryBuilder: (query) =>
            query.where('roomStatus', isNotEqualTo: RoomStatus.completed.name),
      );

  /// 指定した [roomId] に一致する [Room] を購読する
  Stream<ReadRoom?> subscribeRoom({required String roomId}) =>
      _query.subscribeDocument(roomId: roomId);

  /// [createdByAppUserId] が、指定した [spotDifferenceId] を持つ [Room] を作成する。
  Future<void> createRoom({
    required String spotDifferenceId,
    required String createdByAppUserId,
  }) async {
    await _query.add(
      createRoom: CreateRoom(
        spotDifferenceId: spotDifferenceId,
        roomStatus: RoomStatus.pending,
        createdByAppUserId: createdByAppUserId,
      ),
    );
  }

  /// 指定した [roomId] に一致する [Room] の roomStatus を変更する
  Future<void> updateRoom({
    required String roomId,
    required RoomStatus roomStatus,
  }) async {
    await _query.update(
      roomId: roomId,
      updateRoom: UpdateRoom(
        roomStatus: roomStatus,
      ),
    );
  }
}
