import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appUserRepositoryProvider = Provider.autoDispose<AppUserRepository>(
  (_) => AppUserRepository(),
);
