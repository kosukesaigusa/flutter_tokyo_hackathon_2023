import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:flutterfire_gen_utils/flutterfire_gen_utils.dart';

part 'answer.flutterfire_gen.dart';

// documentId は appUserId に一致する
@FirestoreDocument(
  path: 'rooms/{roomId}/answers',
  documentName: 'answer',
)
class Answer {
  const Answer({
    required this.roomId,
    required this.pointIds,
    this.createdAt,
    this.updatedAt,
  });

  final String roomId;

  @AllowFieldValue()
  final List<String> pointIds;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? updatedAt;
}
