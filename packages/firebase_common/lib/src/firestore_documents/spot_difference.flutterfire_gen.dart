// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spot_difference.dart';

class ReadSpotDifference {
  const ReadSpotDifference({
    required this.spotDifferenceId,
    required this.path,
    required this.leftImageUrl,
    required this.rightImageUrl,
    required this.pointIds,
  });

  final String spotDifferenceId;

  final String path;

  final String leftImageUrl;

  final String rightImageUrl;

  final List<String> pointIds;

  factory ReadSpotDifference._fromJson(Map<String, dynamic> json) {
    return ReadSpotDifference(
      spotDifferenceId: json['spotDifferenceId'] as String,
      path: json['path'] as String,
      leftImageUrl: json['leftImageUrl'] as String? ?? '',
      rightImageUrl: json['rightImageUrl'] as String? ?? '',
      pointIds: (json['pointIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );
  }

  factory ReadSpotDifference.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadSpotDifference._fromJson(<String, dynamic>{
      ...data,
      'spotDifferenceId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateSpotDifference {
  const CreateSpotDifference({
    required this.leftImageUrl,
    required this.rightImageUrl,
    required this.pointIds,
  });

  final String leftImageUrl;
  final String rightImageUrl;
  final List<String> pointIds;

  Map<String, dynamic> toJson() {
    return {
      'leftImageUrl': leftImageUrl,
      'rightImageUrl': rightImageUrl,
      'pointIds': pointIds,
    };
  }
}

class UpdateSpotDifference {
  const UpdateSpotDifference({
    this.leftImageUrl,
    this.rightImageUrl,
    this.pointIds,
  });

  final String? leftImageUrl;
  final String? rightImageUrl;
  final List<String>? pointIds;

  Map<String, dynamic> toJson() {
    return {
      if (leftImageUrl != null) 'leftImageUrl': leftImageUrl,
      if (rightImageUrl != null) 'rightImageUrl': rightImageUrl,
      if (pointIds != null) 'pointIds': pointIds,
    };
  }
}

class DeleteSpotDifference {}

/// Provides a reference to the spotDifferences collection for reading.
final readSpotDifferenceCollectionReference = FirebaseFirestore.instance
    .collection('spotDifferences')
    .withConverter<ReadSpotDifference>(
      fromFirestore: (ds, _) => ReadSpotDifference.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a spotDifference document for reading.
DocumentReference<ReadSpotDifference> readSpotDifferenceDocumentReference({
  required String spotDifferenceId,
}) =>
    readSpotDifferenceCollectionReference.doc(spotDifferenceId);

/// Provides a reference to the spotDifferences collection for creating.
final createSpotDifferenceCollectionReference = FirebaseFirestore.instance
    .collection('spotDifferences')
    .withConverter<CreateSpotDifference>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a spotDifference document for creating.
DocumentReference<CreateSpotDifference> createSpotDifferenceDocumentReference({
  required String spotDifferenceId,
}) =>
    createSpotDifferenceCollectionReference.doc(spotDifferenceId);

/// Provides a reference to the spotDifferences collection for updating.
final updateSpotDifferenceCollectionReference = FirebaseFirestore.instance
    .collection('spotDifferences')
    .withConverter<UpdateSpotDifference>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a spotDifference document for updating.
DocumentReference<UpdateSpotDifference> updateSpotDifferenceDocumentReference({
  required String spotDifferenceId,
}) =>
    updateSpotDifferenceCollectionReference.doc(spotDifferenceId);

/// Provides a reference to the spotDifferences collection for deleting.
final deleteSpotDifferenceCollectionReference = FirebaseFirestore.instance
    .collection('spotDifferences')
    .withConverter<DeleteSpotDifference>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a spotDifference document for deleting.
DocumentReference<DeleteSpotDifference> deleteSpotDifferenceDocumentReference({
  required String spotDifferenceId,
}) =>
    deleteSpotDifferenceCollectionReference.doc(spotDifferenceId);

/// Manages queries against the spotDifferences collection.
class SpotDifferenceQuery {
  /// Fetches [ReadSpotDifference] documents.
  Future<List<ReadSpotDifference>> fetchDocuments({
    GetOptions? options,
    Query<ReadSpotDifference>? Function(Query<ReadSpotDifference> query)?
        queryBuilder,
    int Function(ReadSpotDifference lhs, ReadSpotDifference rhs)? compare,
  }) async {
    Query<ReadSpotDifference> query = readSpotDifferenceCollectionReference;
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

  /// Subscribes [SpotDifference] documents.
  Stream<List<ReadSpotDifference>> subscribeDocuments({
    Query<ReadSpotDifference>? Function(Query<ReadSpotDifference> query)?
        queryBuilder,
    int Function(ReadSpotDifference lhs, ReadSpotDifference rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadSpotDifference> query = readSpotDifferenceCollectionReference;
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

  /// Fetches a specific [ReadSpotDifference] document.
  Future<ReadSpotDifference?> fetchDocument({
    required String spotDifferenceId,
    GetOptions? options,
  }) async {
    final ds = await readSpotDifferenceDocumentReference(
      spotDifferenceId: spotDifferenceId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [SpotDifference] document.
  Stream<ReadSpotDifference?> subscribeDocument({
    required String spotDifferenceId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readSpotDifferenceDocumentReference(
      spotDifferenceId: spotDifferenceId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [SpotDifference] document.
  Future<DocumentReference<CreateSpotDifference>> add({
    required CreateSpotDifference createSpotDifference,
  }) =>
      createSpotDifferenceCollectionReference.add(createSpotDifference);

  /// Sets a [SpotDifference] document.
  Future<void> set({
    required String spotDifferenceId,
    required CreateSpotDifference createSpotDifference,
    SetOptions? options,
  }) =>
      createSpotDifferenceDocumentReference(
        spotDifferenceId: spotDifferenceId,
      ).set(createSpotDifference, options);

  /// Updates a specific [SpotDifference] document.
  Future<void> update({
    required String spotDifferenceId,
    required UpdateSpotDifference updateSpotDifference,
  }) =>
      updateSpotDifferenceDocumentReference(
        spotDifferenceId: spotDifferenceId,
      ).update(updateSpotDifference.toJson());

  /// Deletes a specific [SpotDifference] document.
  Future<void> delete({
    required String spotDifferenceId,
  }) =>
      deleteSpotDifferenceDocumentReference(
        spotDifferenceId: spotDifferenceId,
      ).delete();
}
