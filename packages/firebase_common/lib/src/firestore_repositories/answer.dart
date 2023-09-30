import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_utils/flutterfire_gen_utils.dart';

import '../firestore_documents/_export.dart';

class AnswerRepository {
  final _query = AnswerQuery();

  /// 指定した [appUserId], [roomId] に一致する [Answer] を購読する
  Stream<ReadAnswer?> subscribeRoomUserAnswer({
    required String appUserId,
    required String roomId,
  }) =>
      _query.subscribeDocument(roomId: roomId, answerId: appUserId);

  /// 指定した [roomId] に一致する Room 配下の [Answer] の List を購読する
  Stream<List<ReadAnswer>?> subscribeRoomAnswers({
    required String roomId,
  }) =>
      _query.subscribeDocuments(roomId: roomId);

  /// 指定した [roomId] を持つ [Answer] を作成する
  Future<void> createAnswer({
    required String roomId,
    required String appUserId,
  }) async {
    await _query.set(
      roomId: roomId,
      answerId: appUserId,
      createAnswer: CreateAnswer(
        roomId: roomId,
        pointIds: const ActualValue([]),
      ),
    );
  }

  /// 指定した [roomId], [answerId] を持つ [Answer] に point を追加する
  Future<void> addPoint({
    required String roomId,
    required String answerId,
    required String pointId,
  }) async {
    await _query.update(
      roomId: roomId,
      answerId: answerId,
      updateAnswer: UpdateAnswer(
        pointIds: FieldValueData(
          FieldValue.arrayUnion(
            [pointId],
          ),
        ),
      ),
    );
  }
}
