import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'completed_user.flutterfire_gen.dart';

// documentId は appUserId に一致する
@FirestoreDocument(
  path: 'rooms/{roomId}/completedUsers',
  documentName: 'completedUser',
)
class CompletedUser {
  const CompletedUser({
    this.createdAt,
  });

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;
}
