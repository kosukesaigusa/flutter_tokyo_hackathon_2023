import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_ui_feedback_controller.dart';
import '../../exception.dart';
import '../auth.dart';

final authControllerProvider = Provider.autoDispose<AuthController>(
  (ref) => AuthController(
    authService: ref.watch(authServiceProvider),
    appUIFeedbackController: ref.watch(appUIFeedbackControllerProvider),
  ),
);

class AuthController {
  const AuthController({
    required AuthService authService,
    required AppUIFeedbackController appUIFeedbackController,
  })  : _authService = authService,
        _appUIFeedbackController = appUIFeedbackController;

  final AuthService _authService;

  final AppUIFeedbackController _appUIFeedbackController;

  /// 匿名アカウントでサインインする。
  Future<void> signInAnonymously() async {
    try {
      await _authService.signInAnonymously();
    } on AppException catch (e) {
      _appUIFeedbackController.showSnackBarByException(e);
    } on FirebaseAuthException catch (e) {
      _appUIFeedbackController.showSnackBarByFirebaseException(e);
    }
  }

  /// [FirebaseAuth] からサインアウトする。
  Future<void> signOut() => _authService.signOut();
}
