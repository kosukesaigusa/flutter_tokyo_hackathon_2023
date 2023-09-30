import '../firestore_documents/_export.dart';

class CompletedUserRepository {
  final _query = CompletedUserQuery();

  /// 指定した [roomId], [appUserId] の [CompletedUser] を作成する
  Future<void> createCompleteUser({
    required String roomId,
    required String appUserId,
  }) async {
    await _query.set(
      roomId: roomId,
      completedUserId: appUserId,
      createCompletedUser: const CreateCompletedUser(),
    );
  }

  /// 指定した [roomId] の [CompletedUser] のリストを購読する
  Stream<List<ReadCompletedUser>> subscribeCompletedUsers({
    required String roomId,
  }) =>
      _query.subscribeDocuments(roomId: roomId);
}
