import '../firestore_documents/_export.dart';

class SpotDifferenceRepository {
  final _query = SpotDifferenceQuery();

  /// 指定した [spotDifferenceId] に一致する [ReadSpotDifference] を購読する
  Stream<ReadSpotDifference?> subscribeSpotDifference({
    required String spotDifferenceId,
  }) =>
      _query.subscribeDocument(spotDifferenceId: spotDifferenceId);

  Future<ReadSpotDifference?> fetchSpotDifference({
    required String spotDifferenceId,
  }) =>
      _query.fetchDocument(spotDifferenceId: spotDifferenceId);
}
