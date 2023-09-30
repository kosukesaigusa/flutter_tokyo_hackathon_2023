import 'package:firebase_common/firebase_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appUserRepositoryProvider = Provider.autoDispose<AppUserRepository>(
  (_) => AppUserRepository(),
);

final roomRepositoryProvider = Provider.autoDispose<RoomRepository>(
  (_) => RoomRepository(),
);

final spotDifferenceRepositoryProvider =
    Provider.autoDispose<SpotDifferenceRepository>(
  (_) => SpotDifferenceRepository(),
);

final pointRepositoryProvider = Provider.autoDispose<PointRepository>(
  (_) => PointRepository(),
);

final answerRepositoryProvider = Provider.autoDispose<AnswerRepository>(
  (_) => AnswerRepository(),
);

final completedUserRepositoryProvider =
    Provider.autoDispose<CompletedUserRepository>(
  (_) => CompletedUserRepository(),
);

