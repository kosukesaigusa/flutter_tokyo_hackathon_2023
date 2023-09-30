import '../firestore_documents/icon.dart';

class IconRepository {
  final _query = IconQuery();

  /// 全ての [Icon] を購読する
  Stream<List<ReadIcon>?> subscribeIcons() => _query.subscribeDocuments();
}
