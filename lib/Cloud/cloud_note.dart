import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:friends2/Cloud/cloud_storage_consts.dart';

@immutable
class CloudNote {
  final String ownerUserId;
  final String documentId;
  final String text;

  const CloudNote(
      {required this.ownerUserId,
      required this.documentId,
      required this.text});
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
