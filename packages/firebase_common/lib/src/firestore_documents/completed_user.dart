import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'completed_user.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'rooms/{roomId}/completedUsers',
  documentName: 'completedUser',
)
class CompletedUser {
  const CompletedUser({
    required this.appUserId,
    this.createdAt,
  });

  final String appUserId;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;
}
