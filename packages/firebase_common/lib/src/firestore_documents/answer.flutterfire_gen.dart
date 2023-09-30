// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'answer.dart';

class ReadAnswer {
  const ReadAnswer({
    required this.answerId,
    required this.path,
    required this.roomId,
    required this.pointIds,
    required this.createdAt,
    required this.updatedAt,
  });

  final String answerId;

  final String path;

  final String roomId;

  final List<String> pointIds;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  factory ReadAnswer._fromJson(Map<String, dynamic> json) {
    return ReadAnswer(
      answerId: json['answerId'] as String,
      path: json['path'] as String,
      roomId: json['roomId'] as String,
      pointIds:
          (json['pointIds'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadAnswer.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadAnswer._fromJson(<String, dynamic>{
      ...data,
      'answerId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateAnswer {
  const CreateAnswer({
    required this.roomId,
    required this.pointIds,
  });

  final String roomId;
  final FirestoreData<List<String>> pointIds;

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'pointIds': pointIds.value,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateAnswer {
  const UpdateAnswer({
    this.roomId,
    this.pointIds,
    this.createdAt,
  });

  final String? roomId;
  final FirestoreData<List<String>>? pointIds;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (roomId != null) 'roomId': roomId,
      if (pointIds != null) 'pointIds': pointIds!.value,
      if (createdAt != null) 'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class DeleteAnswer {}

/// Provides a reference to the answers collection for reading.
CollectionReference<ReadAnswer> readAnswerCollectionReference({
  required String roomId,
}) =>
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('answers')
        .withConverter<ReadAnswer>(
          fromFirestore: (ds, _) => ReadAnswer.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a answer document for reading.
DocumentReference<ReadAnswer> readAnswerDocumentReference({
  required String roomId,
  required String answerId,
}) =>
    readAnswerCollectionReference(roomId: roomId).doc(answerId);

/// Provides a reference to the answers collection for creating.
CollectionReference<CreateAnswer> createAnswerCollectionReference({
  required String roomId,
}) =>
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('answers')
        .withConverter<CreateAnswer>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a answer document for creating.
DocumentReference<CreateAnswer> createAnswerDocumentReference({
  required String roomId,
  required String answerId,
}) =>
    createAnswerCollectionReference(roomId: roomId).doc(answerId);

/// Provides a reference to the answers collection for updating.
CollectionReference<UpdateAnswer> updateAnswerCollectionReference({
  required String roomId,
}) =>
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('answers')
        .withConverter<UpdateAnswer>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a answer document for updating.
DocumentReference<UpdateAnswer> updateAnswerDocumentReference({
  required String roomId,
  required String answerId,
}) =>
    updateAnswerCollectionReference(roomId: roomId).doc(answerId);

/// Provides a reference to the answers collection for deleting.
CollectionReference<DeleteAnswer> deleteAnswerCollectionReference({
  required String roomId,
}) =>
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('answers')
        .withConverter<DeleteAnswer>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a answer document for deleting.
DocumentReference<DeleteAnswer> deleteAnswerDocumentReference({
  required String roomId,
  required String answerId,
}) =>
    deleteAnswerCollectionReference(roomId: roomId).doc(answerId);

/// Manages queries against the answers collection.
class AnswerQuery {
  /// Fetches [ReadAnswer] documents.
  Future<List<ReadAnswer>> fetchDocuments({
    required String roomId,
    GetOptions? options,
    Query<ReadAnswer>? Function(Query<ReadAnswer> query)? queryBuilder,
    int Function(ReadAnswer lhs, ReadAnswer rhs)? compare,
  }) async {
    Query<ReadAnswer> query = readAnswerCollectionReference(roomId: roomId);
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

  /// Subscribes [Answer] documents.
  Stream<List<ReadAnswer>> subscribeDocuments({
    required String roomId,
    Query<ReadAnswer>? Function(Query<ReadAnswer> query)? queryBuilder,
    int Function(ReadAnswer lhs, ReadAnswer rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadAnswer> query = readAnswerCollectionReference(roomId: roomId);
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

  /// Fetches a specific [ReadAnswer] document.
  Future<ReadAnswer?> fetchDocument({
    required String roomId,
    required String answerId,
    GetOptions? options,
  }) async {
    final ds = await readAnswerDocumentReference(
      roomId: roomId,
      answerId: answerId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [Answer] document.
  Stream<ReadAnswer?> subscribeDocument({
    required String roomId,
    required String answerId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readAnswerDocumentReference(
      roomId: roomId,
      answerId: answerId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [Answer] document.
  Future<DocumentReference<CreateAnswer>> add({
    required String roomId,
    required CreateAnswer createAnswer,
  }) =>
      createAnswerCollectionReference(roomId: roomId).add(createAnswer);

  /// Sets a [Answer] document.
  Future<void> set({
    required String roomId,
    required String answerId,
    required CreateAnswer createAnswer,
    SetOptions? options,
  }) =>
      createAnswerDocumentReference(
        roomId: roomId,
        answerId: answerId,
      ).set(createAnswer, options);

  /// Updates a specific [Answer] document.
  Future<void> update({
    required String roomId,
    required String answerId,
    required UpdateAnswer updateAnswer,
  }) =>
      updateAnswerDocumentReference(
        roomId: roomId,
        answerId: answerId,
      ).update(updateAnswer.toJson());

  /// Deletes a specific [Answer] document.
  Future<void> delete({
    required String roomId,
    required String answerId,
  }) =>
      deleteAnswerDocumentReference(
        roomId: roomId,
        answerId: answerId,
      ).delete();
}
