// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room.dart';

class ReadRoom {
  const ReadRoom({
    required this.roomId,
    required this.path,
    required this.spotDifferenceId,
    required this.createdByAppUserId,
    required this.roomStatus,
    required this.maxAnswerCount,
    required this.startAt,
  });

  final String roomId;

  final String path;

  final String spotDifferenceId;

  final String createdByAppUserId;

  final RoomStatus roomStatus;

  final int maxAnswerCount;

  final DateTime? startAt;

  factory ReadRoom._fromJson(Map<String, dynamic> json) {
    return ReadRoom(
      roomId: json['roomId'] as String,
      path: json['path'] as String,
      spotDifferenceId: json['spotDifferenceId'] as String,
      createdByAppUserId: json['createdByAppUserId'] as String,
      roomStatus:
          _roomStatusTypeConverter.fromJson(json['roomStatus'] as String),
      maxAnswerCount: json['maxAnswerCount'] as int? ?? 10,
      startAt: (json['startAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadRoom.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadRoom._fromJson(<String, dynamic>{
      ...data,
      'roomId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateRoom {
  const CreateRoom({
    required this.spotDifferenceId,
    required this.createdByAppUserId,
    required this.roomStatus,
    this.maxAnswerCount = 10,
    this.startAt,
  });

  final String spotDifferenceId;
  final String createdByAppUserId;
  final RoomStatus roomStatus;
  final int maxAnswerCount;
  final DateTime? startAt;

  Map<String, dynamic> toJson() {
    return {
      'spotDifferenceId': spotDifferenceId,
      'createdByAppUserId': createdByAppUserId,
      'roomStatus': _roomStatusTypeConverter.toJson(roomStatus),
      'maxAnswerCount': maxAnswerCount,
      'startAt': startAt,
    };
  }
}

class UpdateRoom {
  const UpdateRoom({
    this.spotDifferenceId,
    this.createdByAppUserId,
    this.roomStatus,
    this.maxAnswerCount,
    this.startAt,
  });

  final String? spotDifferenceId;
  final String? createdByAppUserId;
  final RoomStatus? roomStatus;
  final int? maxAnswerCount;
  final DateTime? startAt;

  Map<String, dynamic> toJson() {
    return {
      if (spotDifferenceId != null) 'spotDifferenceId': spotDifferenceId,
      if (createdByAppUserId != null) 'createdByAppUserId': createdByAppUserId,
      if (roomStatus != null)
        'roomStatus': _roomStatusTypeConverter.toJson(roomStatus!),
      if (maxAnswerCount != null) 'maxAnswerCount': maxAnswerCount,
      if (startAt != null) 'startAt': startAt,
    };
  }
}

class DeleteRoom {}

/// Provides a reference to the rooms collection for reading.
final readRoomCollectionReference =
    FirebaseFirestore.instance.collection('rooms').withConverter<ReadRoom>(
          fromFirestore: (ds, _) => ReadRoom.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a room document for reading.
DocumentReference<ReadRoom> readRoomDocumentReference({
  required String roomId,
}) =>
    readRoomCollectionReference.doc(roomId);

/// Provides a reference to the rooms collection for creating.
final createRoomCollectionReference =
    FirebaseFirestore.instance.collection('rooms').withConverter<CreateRoom>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a room document for creating.
DocumentReference<CreateRoom> createRoomDocumentReference({
  required String roomId,
}) =>
    createRoomCollectionReference.doc(roomId);

/// Provides a reference to the rooms collection for updating.
final updateRoomCollectionReference =
    FirebaseFirestore.instance.collection('rooms').withConverter<UpdateRoom>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a room document for updating.
DocumentReference<UpdateRoom> updateRoomDocumentReference({
  required String roomId,
}) =>
    updateRoomCollectionReference.doc(roomId);

/// Provides a reference to the rooms collection for deleting.
final deleteRoomCollectionReference =
    FirebaseFirestore.instance.collection('rooms').withConverter<DeleteRoom>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a room document for deleting.
DocumentReference<DeleteRoom> deleteRoomDocumentReference({
  required String roomId,
}) =>
    deleteRoomCollectionReference.doc(roomId);

/// Manages queries against the rooms collection.
class RoomQuery {
  /// Fetches [ReadRoom] documents.
  Future<List<ReadRoom>> fetchDocuments({
    GetOptions? options,
    Query<ReadRoom>? Function(Query<ReadRoom> query)? queryBuilder,
    int Function(ReadRoom lhs, ReadRoom rhs)? compare,
  }) async {
    Query<ReadRoom> query = readRoomCollectionReference;
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

  /// Subscribes [Room] documents.
  Stream<List<ReadRoom>> subscribeDocuments({
    Query<ReadRoom>? Function(Query<ReadRoom> query)? queryBuilder,
    int Function(ReadRoom lhs, ReadRoom rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadRoom> query = readRoomCollectionReference;
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

  /// Fetches a specific [ReadRoom] document.
  Future<ReadRoom?> fetchDocument({
    required String roomId,
    GetOptions? options,
  }) async {
    final ds = await readRoomDocumentReference(
      roomId: roomId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [Room] document.
  Stream<ReadRoom?> subscribeDocument({
    required String roomId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readRoomDocumentReference(
      roomId: roomId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [Room] document.
  Future<DocumentReference<CreateRoom>> add({
    required CreateRoom createRoom,
  }) =>
      createRoomCollectionReference.add(createRoom);

  /// Sets a [Room] document.
  Future<void> set({
    required String roomId,
    required CreateRoom createRoom,
    SetOptions? options,
  }) =>
      createRoomDocumentReference(
        roomId: roomId,
      ).set(createRoom, options);

  /// Updates a specific [Room] document.
  Future<void> update({
    required String roomId,
    required UpdateRoom updateRoom,
  }) =>
      updateRoomDocumentReference(
        roomId: roomId,
      ).update(updateRoom.toJson());

  /// Deletes a specific [Room] document.
  Future<void> delete({
    required String roomId,
  }) =>
      deleteRoomDocumentReference(
        roomId: roomId,
      ).delete();
}
