import '../firestore_documents/_export.dart';

class RoomRepository {
  final _query = RoomQuery();

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

  /// 指定した [roomId] に一致する [Room] の roomStatus を completed に変更する
  Future<void> completeRoom({required String roomId}) async {
    await _query.update(
      roomId: roomId,
      updateRoom: const UpdateRoom(
        roomStatus: RoomStatus.completed,
      ),
    );
  }
}
