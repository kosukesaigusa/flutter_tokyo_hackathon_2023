import '../firestore_documents/_export.dart';

class AnswerRepository {
  final _query = AnswerQuery();

  /// 指定した [appUserId], [roomId] に一致する [Answer] を購読する
  Stream<ReadAnswer?> subscribeRoomUserAnswer({
    required String appUserId,
    required String roomId,
  }) =>
      _query.subscribeDocument(roomId: roomId, answerId: appUserId);
}
