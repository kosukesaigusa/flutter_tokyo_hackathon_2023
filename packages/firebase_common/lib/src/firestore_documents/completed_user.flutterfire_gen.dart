// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'completed_user.dart';

class ReadCompletedUser {
  const ReadCompletedUser({
    required this.completedUserId,
    required this.path,
    required this.createdAt,
  });

  final String completedUserId;

  final String path;

  final DateTime? createdAt;

  factory ReadCompletedUser._fromJson(Map<String, dynamic> json) {
    return ReadCompletedUser(
      completedUserId: json['completedUserId'] as String,
      path: json['path'] as String,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadCompletedUser.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadCompletedUser._fromJson(<String, dynamic>{
      ...data,
      'completedUserId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateCompletedUser {
  const CreateCompletedUser();

  Map<String, dynamic> toJson() {
    return {
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateCompletedUser {
  const UpdateCompletedUser({
    this.createdAt,
  });

  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}

class DeleteCompletedUser {}

/// Provides a reference to the completedUsers collection for reading.
CollectionReference<ReadCompletedUser> readCompletedUserCollectionReference({
  required String roomId,
}) =>
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('completedUsers')
        .withConverter<ReadCompletedUser>(
          fromFirestore: (ds, _) => ReadCompletedUser.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a completedUser document for reading.
DocumentReference<ReadCompletedUser> readCompletedUserDocumentReference({
  required String roomId,
  required String completedUserId,
}) =>
    readCompletedUserCollectionReference(roomId: roomId).doc(completedUserId);

/// Provides a reference to the completedUsers collection for creating.
CollectionReference<CreateCompletedUser>
    createCompletedUserCollectionReference({
  required String roomId,
}) =>
        FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .collection('completedUsers')
            .withConverter<CreateCompletedUser>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (obj, _) => obj.toJson(),
            );

/// Provides a reference to a completedUser document for creating.
DocumentReference<CreateCompletedUser> createCompletedUserDocumentReference({
  required String roomId,
  required String completedUserId,
}) =>
    createCompletedUserCollectionReference(roomId: roomId).doc(completedUserId);

/// Provides a reference to the completedUsers collection for updating.
CollectionReference<UpdateCompletedUser>
    updateCompletedUserCollectionReference({
  required String roomId,
}) =>
        FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .collection('completedUsers')
            .withConverter<UpdateCompletedUser>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (obj, _) => obj.toJson(),
            );

/// Provides a reference to a completedUser document for updating.
DocumentReference<UpdateCompletedUser> updateCompletedUserDocumentReference({
  required String roomId,
  required String completedUserId,
}) =>
    updateCompletedUserCollectionReference(roomId: roomId).doc(completedUserId);

/// Provides a reference to the completedUsers collection for deleting.
CollectionReference<DeleteCompletedUser>
    deleteCompletedUserCollectionReference({
  required String roomId,
}) =>
        FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .collection('completedUsers')
            .withConverter<DeleteCompletedUser>(
              fromFirestore: (_, __) => throw UnimplementedError(),
              toFirestore: (_, __) => throw UnimplementedError(),
            );

/// Provides a reference to a completedUser document for deleting.
DocumentReference<DeleteCompletedUser> deleteCompletedUserDocumentReference({
  required String roomId,
  required String completedUserId,
}) =>
    deleteCompletedUserCollectionReference(roomId: roomId).doc(completedUserId);

/// Manages queries against the completedUsers collection.
class CompletedUserQuery {
  /// Fetches [ReadCompletedUser] documents.
  Future<List<ReadCompletedUser>> fetchDocuments({
    required String roomId,
    GetOptions? options,
    Query<ReadCompletedUser>? Function(Query<ReadCompletedUser> query)?
        queryBuilder,
    int Function(ReadCompletedUser lhs, ReadCompletedUser rhs)? compare,
  }) async {
    Query<ReadCompletedUser> query =
        readCompletedUserCollectionReference(roomId: roomId);
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

  /// Subscribes [CompletedUser] documents.
  Stream<List<ReadCompletedUser>> subscribeDocuments({
    required String roomId,
    Query<ReadCompletedUser>? Function(Query<ReadCompletedUser> query)?
        queryBuilder,
    int Function(ReadCompletedUser lhs, ReadCompletedUser rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadCompletedUser> query =
        readCompletedUserCollectionReference(roomId: roomId);
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

  /// Fetches a specific [ReadCompletedUser] document.
  Future<ReadCompletedUser?> fetchDocument({
    required String roomId,
    required String completedUserId,
    GetOptions? options,
  }) async {
    final ds = await readCompletedUserDocumentReference(
      roomId: roomId,
      completedUserId: completedUserId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [CompletedUser] document.
  Stream<ReadCompletedUser?> subscribeDocument({
    required String roomId,
    required String completedUserId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readCompletedUserDocumentReference(
      roomId: roomId,
      completedUserId: completedUserId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [CompletedUser] document.
  Future<DocumentReference<CreateCompletedUser>> add({
    required String roomId,
    required CreateCompletedUser createCompletedUser,
  }) =>
      createCompletedUserCollectionReference(roomId: roomId)
          .add(createCompletedUser);

  /// Sets a [CompletedUser] document.
  Future<void> set({
    required String roomId,
    required String completedUserId,
    required CreateCompletedUser createCompletedUser,
    SetOptions? options,
  }) =>
      createCompletedUserDocumentReference(
        roomId: roomId,
        completedUserId: completedUserId,
      ).set(createCompletedUser, options);

  /// Updates a specific [CompletedUser] document.
  Future<void> update({
    required String roomId,
    required String completedUserId,
    required UpdateCompletedUser updateCompletedUser,
  }) =>
      updateCompletedUserDocumentReference(
        roomId: roomId,
        completedUserId: completedUserId,
      ).update(updateCompletedUser.toJson());

  /// Deletes a specific [CompletedUser] document.
  Future<void> delete({
    required String roomId,
    required String completedUserId,
  }) =>
      deleteCompletedUserDocumentReference(
        roomId: roomId,
        completedUserId: completedUserId,
      ).delete();
}
