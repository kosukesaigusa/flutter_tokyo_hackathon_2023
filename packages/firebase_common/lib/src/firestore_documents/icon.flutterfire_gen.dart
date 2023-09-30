// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon.dart';

class ReadIcon {
  const ReadIcon({
    required this.iconId,
    required this.path,
    required this.name,
    required this.imageUrl,
  });

  final String iconId;

  final String path;

  final String name;

  final String imageUrl;

  factory ReadIcon._fromJson(Map<String, dynamic> json) {
    return ReadIcon(
      iconId: json['iconId'] as String,
      path: json['path'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  factory ReadIcon.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadIcon._fromJson(<String, dynamic>{
      ...data,
      'iconId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateIcon {
  const CreateIcon({
    required this.name,
    required this.imageUrl,
  });

  final String name;
  final String imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

class UpdateIcon {
  const UpdateIcon({
    this.name,
    this.imageUrl,
  });

  final String? name;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

class DeleteIcon {}

/// Provides a reference to the icons collection for reading.
final readIconCollectionReference =
    FirebaseFirestore.instance.collection('icons').withConverter<ReadIcon>(
          fromFirestore: (ds, _) => ReadIcon.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a icon document for reading.
DocumentReference<ReadIcon> readIconDocumentReference({
  required String iconId,
}) =>
    readIconCollectionReference.doc(iconId);

/// Provides a reference to the icons collection for creating.
final createIconCollectionReference =
    FirebaseFirestore.instance.collection('icons').withConverter<CreateIcon>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a icon document for creating.
DocumentReference<CreateIcon> createIconDocumentReference({
  required String iconId,
}) =>
    createIconCollectionReference.doc(iconId);

/// Provides a reference to the icons collection for updating.
final updateIconCollectionReference =
    FirebaseFirestore.instance.collection('icons').withConverter<UpdateIcon>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a icon document for updating.
DocumentReference<UpdateIcon> updateIconDocumentReference({
  required String iconId,
}) =>
    updateIconCollectionReference.doc(iconId);

/// Provides a reference to the icons collection for deleting.
final deleteIconCollectionReference =
    FirebaseFirestore.instance.collection('icons').withConverter<DeleteIcon>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a icon document for deleting.
DocumentReference<DeleteIcon> deleteIconDocumentReference({
  required String iconId,
}) =>
    deleteIconCollectionReference.doc(iconId);

/// Manages queries against the icons collection.
class IconQuery {
  /// Fetches [ReadIcon] documents.
  Future<List<ReadIcon>> fetchDocuments({
    GetOptions? options,
    Query<ReadIcon>? Function(Query<ReadIcon> query)? queryBuilder,
    int Function(ReadIcon lhs, ReadIcon rhs)? compare,
  }) async {
    Query<ReadIcon> query = readIconCollectionReference;
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

  /// Subscribes [Icon] documents.
  Stream<List<ReadIcon>> subscribeDocuments({
    Query<ReadIcon>? Function(Query<ReadIcon> query)? queryBuilder,
    int Function(ReadIcon lhs, ReadIcon rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadIcon> query = readIconCollectionReference;
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

  /// Fetches a specific [ReadIcon] document.
  Future<ReadIcon?> fetchDocument({
    required String iconId,
    GetOptions? options,
  }) async {
    final ds = await readIconDocumentReference(
      iconId: iconId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [Icon] document.
  Stream<ReadIcon?> subscribeDocument({
    required String iconId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readIconDocumentReference(
      iconId: iconId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [Icon] document.
  Future<DocumentReference<CreateIcon>> add({
    required CreateIcon createIcon,
  }) =>
      createIconCollectionReference.add(createIcon);

  /// Sets a [Icon] document.
  Future<void> set({
    required String iconId,
    required CreateIcon createIcon,
    SetOptions? options,
  }) =>
      createIconDocumentReference(
        iconId: iconId,
      ).set(createIcon, options);

  /// Updates a specific [Icon] document.
  Future<void> update({
    required String iconId,
    required UpdateIcon updateIcon,
  }) =>
      updateIconDocumentReference(
        iconId: iconId,
      ).update(updateIcon.toJson());

  /// Deletes a specific [Icon] document.
  Future<void> delete({
    required String iconId,
  }) =>
      deleteIconDocumentReference(
        iconId: iconId,
      ).delete();
}
