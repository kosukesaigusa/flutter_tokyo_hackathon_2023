import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'app_user.flutterfire_gen.dart';

@FirestoreDocument(path: 'appUsers', documentName: 'user')
class AppUser {
  const AppUser({
    required this.displayName,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  @ReadDefault('')
  final String displayName;

  @ReadDefault('')
  @CreateDefault('')
  final String imageUrl;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  final DateTime? createdAt;

  @AlwaysUseFieldValueServerTimestampWhenCreating()
  @AlwaysUseFieldValueServerTimestampWhenUpdating()
  final DateTime? updatedAt;
}
