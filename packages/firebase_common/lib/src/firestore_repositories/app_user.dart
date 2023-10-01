import '../../firebase_common.dart';

class AppUserRepository {
  final _query = AppUserQuery();

  /// ユーザーを作成する。
  Future<void> set({
    required String userId,
    required String displayName,
    String imageUrl = '',
  }) =>
      _query.set(
        userId: userId,
        createAppUser:
            CreateAppUser(displayName: displayName, imageUrl: imageUrl),
      );

  Future<ReadAppUser?> fetch({required String userId}) async =>
      _query.fetchDocument(userId: userId);

  /// 指定した [userId] に一致する [AppUser] を購読する
  Stream<ReadAppUser?> subscribeUser({
    required String userId,
  }) =>
      _query.subscribeDocument(userId: userId);
}
