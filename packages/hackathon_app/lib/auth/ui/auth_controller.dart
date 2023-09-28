import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_ui_feedback_controller.dart';
import '../../exception.dart';
import '../../loading/ui/loading.dart';
import '../auth.dart';

final authControllerProvider = Provider.autoDispose<AuthController>(
  (ref) => AuthController(
    authService: ref.watch(authServiceProvider),
    overlayLoadingStateController:
        ref.watch(overlayLoadingStateProvider.notifier),
    appUIFeedbackController: ref.watch(appUIFeedbackControllerProvider),
  ),
);

class AuthController {
  const AuthController({
    required AuthService authService,
    required StateController<bool> overlayLoadingStateController,
    required AppUIFeedbackController appUIFeedbackController,
  })  : _authService = authService,
        _overlayLoadingStateController = overlayLoadingStateController,
        _appUIFeedbackController = appUIFeedbackController;

  final AuthService _authService;

  final StateController<bool> _overlayLoadingStateController;

  final AppUIFeedbackController _appUIFeedbackController;

  /// Google サインインする。
  Future<void> signInWithGoogle() async {
    _overlayLoadingStateController.update((state) => true);
    try {
      final userCredential = await _authService.signInWithGoogle();
      // await _setFcmToken(userCredential);
      _appUIFeedbackController.showSnackBar('サインインしました');
    } on AppException catch (e) {
      _appUIFeedbackController.showSnackBarByException(e);
    } on FirebaseAuthException catch (e) {
      _appUIFeedbackController.showSnackBarByFirebaseException(e);
    } finally {
      _overlayLoadingStateController.update((state) => false);
    }
  }

  /// メールアドレスとパスワードでサインする。
  /// サインイン後、必要性を確認して [UserMode] を `UserMode.Host` にする。
  /// デバッグ目的でのみ使用する。
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on AppException catch (e) {
      _appUIFeedbackController.showSnackBarByException(e);
    }
  }

  // /// サインインで得られた [UserCredential] を与え、それに対応するユーザーの FCM トークンを
  // /// 保存する。
  // Future<void> _setFcmToken(UserCredential userCredential) async {
  //   final uid = userCredential.user?.uid;
  //   if (uid == null) {
  //     return;
  //   }
  //   await _fcmTokenService.setUserFcmToken(userId: uid);
  // }

  /// [FirebaseAuth] からサインアウトする。
  Future<void> signOut() => _authService.signOut();
}
