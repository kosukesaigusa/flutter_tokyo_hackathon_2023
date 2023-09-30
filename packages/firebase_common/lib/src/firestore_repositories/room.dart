import '../firestore_documents/_export.dart';

class RoomRepository {
  final _query = RoomQuery();

  Stream<ReadRoom?> subscribeRoom({required String roomId}) =>
      _query.subscribeDocument(roomId: roomId);

  Future<void> createRoom({required String spotDifferenceId}) async {
    await _query.add(
      createRoom: CreateRoom(
        spotDifferenceId: spotDifferenceId,
        roomStatus: RoomStatus.pending,
      ),
    );
  }

  Future<void> completeRoom({required String roomId}) async {
    await _query.update(
      roomId: roomId,
      updateRoom: const UpdateRoom(
        roomStatus: RoomStatus.completed,
      ),
    );
  }
}
