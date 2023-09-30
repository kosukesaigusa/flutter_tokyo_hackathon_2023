import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'point.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'spotDifferences/{spotDifferenceId}/points',
  documentName: 'point',
)
class Point {
  const Point({
    required this.x,
    required this.y,
  });

  final double x;

  final double y;
}
