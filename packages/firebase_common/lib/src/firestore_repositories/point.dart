import '../firestore_documents/_export.dart';

class PointRepository {
  final _query = PointQuery();

  /// 指定した [spotDifferenceId] に一致する SpotDifference 配下の[ReadPoint] のリストを購読する
  Stream<List<ReadPoint>?> subscribePoints({
    required String spotDifferenceId,
  }) =>
      _query.subscribeDocuments(spotDifferenceId: spotDifferenceId);
}
