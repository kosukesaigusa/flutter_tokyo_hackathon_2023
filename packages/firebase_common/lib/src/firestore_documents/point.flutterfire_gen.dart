// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'point.dart';

class ReadPoint {
  const ReadPoint({
    required this.pointId,
    required this.path,
    required this.x,
    required this.y,
  });

  final String pointId;

  final String path;

  final double x;

  final double y;

  factory ReadPoint._fromJson(Map<String, dynamic> json) {
    return ReadPoint(
      pointId: json['pointId'] as String,
      path: json['path'] as String,
      x: json['x'] as double,
      y: json['y'] as double,
    );
  }

  factory ReadPoint.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadPoint._fromJson(<String, dynamic>{
      ...data,
      'pointId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreatePoint {
  const CreatePoint({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}

class UpdatePoint {
  const UpdatePoint({
    this.x,
    this.y,
  });

  final double? x;
  final double? y;

  Map<String, dynamic> toJson() {
    return {
      if (x != null) 'x': x,
      if (y != null) 'y': y,
    };
  }
}

class DeletePoint {}

/// Provides a reference to the points collection for reading.
CollectionReference<ReadPoint> readPointCollectionReference({
  required String spotDifferenceId,
}) =>
    FirebaseFirestore.instance
        .collection('spotDifferences')
        .doc(spotDifferenceId)
        .collection('points')
        .withConverter<ReadPoint>(
          fromFirestore: (ds, _) => ReadPoint.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a point document for reading.
DocumentReference<ReadPoint> readPointDocumentReference({
  required String spotDifferenceId,
  required String pointId,
}) =>
    readPointCollectionReference(spotDifferenceId: spotDifferenceId)
        .doc(pointId);

/// Provides a reference to the points collection for creating.
CollectionReference<CreatePoint> createPointCollectionReference({
  required String spotDifferenceId,
}) =>
    FirebaseFirestore.instance
        .collection('spotDifferences')
        .doc(spotDifferenceId)
        .collection('points')
        .withConverter<CreatePoint>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a point document for creating.
DocumentReference<CreatePoint> createPointDocumentReference({
  required String spotDifferenceId,
  required String pointId,
}) =>
    createPointCollectionReference(spotDifferenceId: spotDifferenceId)
        .doc(pointId);

/// Provides a reference to the points collection for updating.
CollectionReference<UpdatePoint> updatePointCollectionReference({
  required String spotDifferenceId,
}) =>
    FirebaseFirestore.instance
        .collection('spotDifferences')
        .doc(spotDifferenceId)
        .collection('points')
        .withConverter<UpdatePoint>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a point document for updating.
DocumentReference<UpdatePoint> updatePointDocumentReference({
  required String spotDifferenceId,
  required String pointId,
}) =>
    updatePointCollectionReference(spotDifferenceId: spotDifferenceId)
        .doc(pointId);

/// Provides a reference to the points collection for deleting.
CollectionReference<DeletePoint> deletePointCollectionReference({
  required String spotDifferenceId,
}) =>
    FirebaseFirestore.instance
        .collection('spotDifferences')
        .doc(spotDifferenceId)
        .collection('points')
        .withConverter<DeletePoint>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a point document for deleting.
DocumentReference<DeletePoint> deletePointDocumentReference({
  required String spotDifferenceId,
  required String pointId,
}) =>
    deletePointCollectionReference(spotDifferenceId: spotDifferenceId)
        .doc(pointId);

/// Manages queries against the points collection.
class PointQuery {
  /// Fetches [ReadPoint] documents.
  Future<List<ReadPoint>> fetchDocuments({
    required String spotDifferenceId,
    GetOptions? options,
    Query<ReadPoint>? Function(Query<ReadPoint> query)? queryBuilder,
    int Function(ReadPoint lhs, ReadPoint rhs)? compare,
  }) async {
    Query<ReadPoint> query =
        readPointCollectionReference(spotDifferenceId: spotDifferenceId);
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

  /// Subscribes [Point] documents.
  Stream<List<ReadPoint>> subscribeDocuments({
    required String spotDifferenceId,
    Query<ReadPoint>? Function(Query<ReadPoint> query)? queryBuilder,
    int Function(ReadPoint lhs, ReadPoint rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadPoint> query =
        readPointCollectionReference(spotDifferenceId: spotDifferenceId);
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

  /// Fetches a specific [ReadPoint] document.
  Future<ReadPoint?> fetchDocument({
    required String spotDifferenceId,
    required String pointId,
    GetOptions? options,
  }) async {
    final ds = await readPointDocumentReference(
      spotDifferenceId: spotDifferenceId,
      pointId: pointId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [Point] document.
  Stream<ReadPoint?> subscribeDocument({
    required String spotDifferenceId,
    required String pointId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readPointDocumentReference(
      spotDifferenceId: spotDifferenceId,
      pointId: pointId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [Point] document.
  Future<DocumentReference<CreatePoint>> add({
    required String spotDifferenceId,
    required CreatePoint createPoint,
  }) =>
      createPointCollectionReference(spotDifferenceId: spotDifferenceId)
          .add(createPoint);

  /// Sets a [Point] document.
  Future<void> set({
    required String spotDifferenceId,
    required String pointId,
    required CreatePoint createPoint,
    SetOptions? options,
  }) =>
      createPointDocumentReference(
        spotDifferenceId: spotDifferenceId,
        pointId: pointId,
      ).set(createPoint, options);

  /// Updates a specific [Point] document.
  Future<void> update({
    required String spotDifferenceId,
    required String pointId,
    required UpdatePoint updatePoint,
  }) =>
      updatePointDocumentReference(
        spotDifferenceId: spotDifferenceId,
        pointId: pointId,
      ).update(updatePoint.toJson());

  /// Deletes a specific [Point] document.
  Future<void> delete({
    required String spotDifferenceId,
    required String pointId,
  }) =>
      deletePointDocumentReference(
        spotDifferenceId: spotDifferenceId,
        pointId: pointId,
      ).delete();
}
