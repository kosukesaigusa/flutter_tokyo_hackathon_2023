import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_gen_annotation/flutterfire_gen_annotation.dart';

part 'icon.flutterfire_gen.dart';

@FirestoreDocument(
  path: 'icons',
  documentName: 'icon',
)
class Icon {
  const Icon({
    required this.name,
    required this.imageUrl,
  });

  final String name;

  final String imageUrl;
}
