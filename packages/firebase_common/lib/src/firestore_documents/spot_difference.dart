import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'spot_difference.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'spotDifferences',
  documentName: 'spotDifference',
)
class SpotDifference {
  const SpotDifference({
    required this.name,
    required this.leftImageUrl,
    required this.rightImageUrl,
    required this.pointIds,
  });

  @ReadDefault('')
  final String name;

  @ReadDefault('')
  final String leftImageUrl;

  @ReadDefault('')
  final String rightImageUrl;

  // NOTE: .length が回答すべきポイント数に一致している。
  @ReadDefault(<String>[])
  final List<String> pointIds;
}
