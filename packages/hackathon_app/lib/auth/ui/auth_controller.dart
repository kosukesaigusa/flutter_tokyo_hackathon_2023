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

  /// 表示名 [displayName] と画像 URL [imageUrl]（任意）を与え、匿名アカウントでサインイン
  /// する。
  Future<void> signInAnonymously({
    required String displayName,
    String? imageUrl,
  }) async {
    _overlayLoadingStateController.update((state) => true);
    try {
      await _authService.signInAnonymously(
        displayName: displayName,
        imageUrl: imageUrl,
      );
      _appUIFeedbackController.showSnackBar('サインインしました');
    } on AppException catch (e) {
      _appUIFeedbackController.showSnackBarByException(e);
    } on FirebaseAuthException catch (e) {
      _appUIFeedbackController.showSnackBarByFirebaseException(e);
    } finally {
      _overlayLoadingStateController.update((state) => false);
    }
  }

  /// [FirebaseAuth] からサインアウトする。
  Future<void> signOut() => _authService.signOut();
}
