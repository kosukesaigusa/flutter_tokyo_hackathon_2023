import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_user/app_user.dart';

/// [FirebaseAuth] のインスタンスを提供する [Provider].
final _authProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

/// [FirebaseAuth] の [User] を返す [StreamProvider].
/// ユーザーの認証状態が変更される（ログイン、ログアウトする）たびに更新される。
final authUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(_authProvider).userChanges(),
);

/// 現在のユーザー ID を提供する [Provider].
/// [authUserProvider] の変更を watch しているので、ユーザーの認証状態が変更され
/// るたびに、この [Provider] も更新される。
final userIdProvider = Provider<String?>((ref) {
  ref.watch(authUserProvider);
  return ref.watch(_authProvider).currentUser?.uid;
});

/// ユーザーがログインしているかどうかを示す bool 値を提供する Provider.
/// [userIdProvider] の変更を watch しているので、ユーザーの認証状態が変更される
/// たびに、この [Provider] も更新される。
final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(userIdProvider) != null,
);

final authServiceProvider = Provider.autoDispose<AuthService>(
  (ref) => AuthService(appUserService: ref.watch(appUserService)),
);

/// [FirebaseAuth] の認証関係の振る舞いを記述するモデル。
class AuthService {
  const AuthService({required AppUserService appUserService})
      : _appUserService = appUserService;

  final AppUserService _appUserService;

  static final _auth = FirebaseAuth.instance;

  /// 表示名 [displayName] と画像 URL [imageUrl]（任意）を与え、匿名アカウントでサインインし、
  /// ユーザードキュメントを作成する。
  Future<UserCredential> signInAnonymously({
    required String displayName,
    String? imageUrl,
  }) async {
    final userCredential = await _auth.signInAnonymously();
    await _appUserService.createOrUpdateUser(
      userId: userCredential.user!.uid,
      displayName: displayName,
      imageUrl: imageUrl ?? '',
    );
    return userCredential;
  }

  /// [FirebaseAuth] からサインアウトする。
  Future<void> signOut() => _auth.signOut();
}
