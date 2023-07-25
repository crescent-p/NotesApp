import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friends2/Cloud/cloud_note.dart';
import 'package:friends2/Cloud/cloud_storage_consts.dart';
import 'package:friends2/consts/auth/auth_exceptions/crud/crud_exceptions.dart';

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
    required String noteId,
    required String text,
  }) async {
    try {
      await notes.doc(noteId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNote();
    }
  }

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
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
