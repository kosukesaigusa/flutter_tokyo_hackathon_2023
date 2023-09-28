import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_user/app_user.dart';
import '../exception.dart';

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

  /// [FirebaseAuth] に Google でサインインする。
  ///
  /// https://firebase.flutter.dev/docs/auth/social/#google に従っている。
  /// 得られた Google アカウントの情報でユーザードキュメントを作成または更新する。
  Future<UserCredential> signInWithGoogle() async {
    final result = await _getGoogleAuthCredential();
    final userCredential = await _auth.signInWithCredential(result.credential);
    await _appUserService.createOrUpdateUser(
      userId: userCredential.user!.uid,
      displayName: result.displayName ?? '',
      imageUrl: result.imageUrl ?? '',
    );
    return userCredential;
  }

  /// Google認証から [AuthCredential] と表示名、プロフィール画像の URL を取得する。
  ///
  /// [GoogleSignIn] ライブラリを使用してユーザーにGoogleでのログインを求め、
  /// 成功した場合はその認証情報からFirebase用の [AuthCredential] オブジェクトを生成して返す
  Future<({AuthCredential credential, String? displayName, String? imageUrl})>
      _getGoogleAuthCredential() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw const AppException(message: 'キャンセルされました。');
      }
      final displayName = googleUser.displayName;
      final imageUrl = googleUser.photoUrl;
      final googleAuth = await googleUser.authentication;
      return (
        credential: GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ),
        displayName: displayName,
        imageUrl: imageUrl,
      );
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        throw const AppException(
          message: '接続できませんでした。\nネットワーク状況を確認してください。',
        );
      }
      throw const AppException(message: 'Google サインインに失敗しました。');
    }
  }

  /// [FirebaseAuth] にメールアドレスとパスワードでサインインする。
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  /// [FirebaseAuth] からサインアウトする。
  /// [GoogleSignIn] からもサインアウトする。
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
