// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

class ReadAppUser {
  const ReadAppUser({
    required this.userId,
    required this.path,
    required this.displayName,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  final String userId;

  final String path;

  final String displayName;

  final String imageUrl;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  factory ReadAppUser._fromJson(Map<String, dynamic> json) {
    return ReadAppUser(
      userId: json['userId'] as String,
      path: json['path'] as String,
      displayName: json['displayName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadAppUser.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadAppUser._fromJson(<String, dynamic>{
      ...data,
      'userId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateAppUser {
  const CreateAppUser({
    required this.displayName,
    this.imageUrl = '',
  });

  final String displayName;
  final String imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateAppUser {
  const UpdateAppUser({
    this.displayName,
    this.imageUrl,
    this.createdAt,
  });

  final String? displayName;
  final String? imageUrl;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (displayName != null) 'displayName': displayName,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (createdAt != null) 'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class DeleteAppUser {}

/// Provides a reference to the appUsers collection for reading.
final readAppUserCollectionReference = FirebaseFirestore.instance
    .collection('appUsers')
    .withConverter<ReadAppUser>(
      fromFirestore: (ds, _) => ReadAppUser.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a user document for reading.
DocumentReference<ReadAppUser> readAppUserDocumentReference({
  required String userId,
}) =>
    readAppUserCollectionReference.doc(userId);

/// Provides a reference to the appUsers collection for creating.
final createAppUserCollectionReference = FirebaseFirestore.instance
    .collection('appUsers')
    .withConverter<CreateAppUser>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a user document for creating.
DocumentReference<CreateAppUser> createAppUserDocumentReference({
  required String userId,
}) =>
    createAppUserCollectionReference.doc(userId);

/// Provides a reference to the appUsers collection for updating.
final updateAppUserCollectionReference = FirebaseFirestore.instance
    .collection('appUsers')
    .withConverter<UpdateAppUser>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a user document for updating.
DocumentReference<UpdateAppUser> updateAppUserDocumentReference({
  required String userId,
}) =>
    updateAppUserCollectionReference.doc(userId);

/// Provides a reference to the appUsers collection for deleting.
final deleteAppUserCollectionReference = FirebaseFirestore.instance
    .collection('appUsers')
    .withConverter<DeleteAppUser>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a user document for deleting.
DocumentReference<DeleteAppUser> deleteAppUserDocumentReference({
  required String userId,
}) =>
    deleteAppUserCollectionReference.doc(userId);

/// Manages queries against the appUsers collection.
class AppUserQuery {
  /// Fetches [ReadAppUser] documents.
  Future<List<ReadAppUser>> fetchDocuments({
    GetOptions? options,
    Query<ReadAppUser>? Function(Query<ReadAppUser> query)? queryBuilder,
    int Function(ReadAppUser lhs, ReadAppUser rhs)? compare,
  }) async {
    Query<ReadAppUser> query = readAppUserCollectionReference;
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final qs = await query.get(options);
    final result = qs.docs.map((qds) => qds.data()).toList();
    if (compare != null) {
      result.sort(compare);
    }
    return result;
  }

  /// Subscribes [AppUser] documents.
  Stream<List<ReadAppUser>> subscribeDocuments({
    Query<ReadAppUser>? Function(Query<ReadAppUser> query)? queryBuilder,
    int Function(ReadAppUser lhs, ReadAppUser rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadAppUser> query = readAppUserCollectionReference;
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    var streamQs =
        query.snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamQs = streamQs.where((qs) => !qs.metadata.hasPendingWrites);
    }
    return streamQs.map((qs) {
      final result = qs.docs.map((qds) => qds.data()).toList();
      if (compare != null) {
        result.sort(compare);
      }
      return result;
    });
  }

  /// Fetches a specific [ReadAppUser] document.
  Future<ReadAppUser?> fetchDocument({
    required String userId,
    GetOptions? options,
  }) async {
    final ds = await readAppUserDocumentReference(
      userId: userId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [AppUser] document.
  Stream<ReadAppUser?> subscribeDocument({
    required String userId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readAppUserDocumentReference(
      userId: userId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [AppUser] document.
  Future<DocumentReference<CreateAppUser>> add({
    required CreateAppUser createAppUser,
  }) =>
      createAppUserCollectionReference.add(createAppUser);

  /// Sets a [AppUser] document.
  Future<void> set({
    required String userId,
    required CreateAppUser createAppUser,
    SetOptions? options,
  }) =>
      createAppUserDocumentReference(
        userId: userId,
      ).set(createAppUser, options);

  /// Updates a specific [AppUser] document.
  Future<void> update({
    required String userId,
    required UpdateAppUser updateAppUser,
  }) =>
      updateAppUserDocumentReference(
        userId: userId,
      ).update(updateAppUser.toJson());

  /// Deletes a specific [AppUser] document.
  Future<void> delete({
    required String userId,
  }) =>
      deleteAppUserDocumentReference(
        userId: userId,
      ).delete();
}
