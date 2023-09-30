import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'rooms',
  documentName: 'room',
)
class Room {
  const Room({
    required this.spotDifferenceId,
    required this.roomStatus,
    required this.maxAnswerCount,
    required this.startAt,
  });

  final String spotDifferenceId;

  @_roomStatusTypeConverter
  final RoomStatus roomStatus;

  @ReadDefault(10)
  final int maxAnswerCount;

  final DateTime? startAt;
}

enum RoomStatus {
  pending,
  playing,
  completed,
  ;

  /// 与えられた文字列に対応する [RoomStatus] を返す。
  factory RoomStatus.fromString(String messageTypeString) {
    switch (messageTypeString) {
      case 'pending':
        return RoomStatus.pending;
      case 'playing':
        return RoomStatus.playing;
      case 'completed':
        return RoomStatus.completed;
    }
    throw ArgumentError('メッセージ種別が正しくありません。');
  }
}

const _roomStatusTypeConverter = _RoomStatusConverter();

class _RoomStatusConverter implements JsonConverter<RoomStatus, String> {
  const _RoomStatusConverter();

  @override
  RoomStatus fromJson(String json) => RoomStatus.fromString(json);

  @override
  String toJson(RoomStatus roomStatusType) => roomStatusType.name;
}
