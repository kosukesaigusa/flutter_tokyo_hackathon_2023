import '../firestore_documents/_export.dart';

class RoomRepository {
  final _query = RoomQuery();

  /// 全ての [Room] を購読する
  Stream<List<ReadRoom>?> subscribeRooms() => _query.subscribeDocuments();

  /// 指定した [roomId] に一致する [Room] を購読する
  Stream<ReadRoom?> subscribeRoom({required String roomId}) =>
      _query.subscribeDocument(roomId: roomId);

  /// 指定した [spotDifferenceId] を持つ [Room] を作成する
  Future<void> createRoom({required String spotDifferenceId}) async {
    await _query.add(
      createRoom: CreateRoom(
        spotDifferenceId: spotDifferenceId,
        roomStatus: RoomStatus.pending,
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
