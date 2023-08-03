import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friends2/Cloud/cloud_note.dart';
import 'package:friends2/Cloud/cloud_storage_consts.dart';
import 'cloud_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes.snapshots().map((event) => event.docs
        .map((e) => CloudNote.fromSnapshot(e))
        .where((element) => element.ownerUserId == ownerUserId));
  }

  Future<void> deleteNote({required String documnetId}) async {
    try {
      await notes.doc(documnetId).delete();
    } catch (e) {
      throw CouldNotDeleteNote();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNote();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final documentReference = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final note = await documentReference.get();
    return CloudNote(ownerUserId: ownerUserId, documentId: note.id, text: '');
  }

  void getNotes({required String ownerUserId}) async {
    return await notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .get()
        .then((value) => value.docs.map((e) => CloudNote.fromSnapshot(e)));
  }

  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}
