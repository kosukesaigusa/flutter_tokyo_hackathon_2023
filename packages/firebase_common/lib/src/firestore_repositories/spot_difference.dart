import '../firestore_documents/_export.dart';

class SpotDifferenceRepository {
  final _query = SpotDifferenceQuery();

  /// [ReadSpotDifference] を全件購読する
  Stream<List<ReadSpotDifference>> subscribeSpotDifferences() =>
      _query.subscribeDocuments();

  /// 指定した [spotDifferenceId] に一致する [ReadSpotDifference] を購読する
  Stream<ReadSpotDifference?> subscribeSpotDifference({
    required String spotDifferenceId,
  }) =>
      _query.subscribeDocument(spotDifferenceId: spotDifferenceId);

  /// 指定した [spotDifferenceId] に一致する [ReadSpotDifference] を取得する
  Future<ReadSpotDifference?> fetchSpotDifference({
    required String spotDifferenceId,
  }) =>
      _query.fetchDocument(spotDifferenceId: spotDifferenceId);
}
