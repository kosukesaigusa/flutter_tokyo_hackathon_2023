import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../firestore_repository.dart';

final appUserService = Provider.autoDispose<AppUserService>(
  (ref) =>
      AppUserService(appUserRepository: ref.watch(appUserRepositoryProvider)),
);

class AppUserService {
  AppUserService({required AppUserRepository appUserRepository})
      : _appUserRepository = appUserRepository;

  final AppUserRepository _appUserRepository;

  /// 指定した [userId] のユーザーを作成または更新する。
  Future<void> createOrUpdateUser({
    required String userId,
    required String displayName,
    String imageUrl = '',
  }) =>
      _appUserRepository.set(
        userId: userId,
        displayName: displayName,
        imageUrl: imageUrl,
      );
}
