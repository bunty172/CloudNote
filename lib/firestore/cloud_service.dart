// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudnote/firestore/firestore_exceptions.dart';
import 'cloud_note.dart';

class CloudService {
  factory CloudService() => _shared;
  static final CloudService _shared = CloudService._sharedInstance();
  CloudService._sharedInstance();

  final notes = FirebaseFirestore.instance.collection("notes");
  
  Future<CloudNote> createNewNoteOnCloud(
      {required String userid, required String text}) async {
    final documnetReference = await notes.add({
      userIdField: userid,
      textField: text,
    });
    final createdCloudNoteDocument = await documnetReference.get();
    return CloudNote(
        documentId: createdCloudNoteDocument.id, userId: userid, text: text);
  }

  Future<void> updateNoteOnCloud(
      {required String documentid, required String text}) async {
    final documentReference = notes.doc(documentid);
    try {
      await documentReference.update({textField: text});
    } on Exception catch (_) {
      throw const CouldNotUpdateNoteOnCloudException();
    }
  }

  Future<void> deleteNoteOnCloud({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (_) {
      throw const CouldNotDeleteNoteOnCloudException();
    }
  }

  Future<Iterable<CloudNote>> getAllNotesFromCloud(
      {required String userid}) async {
    final query = notes.where(
      userIdField,
      isEqualTo: userid,
    );
    final querySnapshot = await query.get();
    final listOfQueryDocumentSnapshot = querySnapshot.docs;
    final iterableOfCloudNote = listOfQueryDocumentSnapshot.map(
        (queryDocumnetSnapshot) =>
            CloudNote.formFirestore(snapshot: queryDocumnetSnapshot));
    return iterableOfCloudNote;
  }

  Stream<List<CloudNote>>? getStreamOfNotesFromCloud(
      {required String userid}) {
    final streamOfQuerySnapshots = notes.snapshots();
    final streamOfIterableCloudNote =
        streamOfQuerySnapshots.map((querySnapshot) {
      return querySnapshot.docs.map((queryDocumentSnapshot) {
        return CloudNote.formFirestore(snapshot: queryDocumentSnapshot);
      }).where((cloudnote) => cloudnote.userId == userid).toList();
    });
    return streamOfIterableCloudNote;
  }
}
