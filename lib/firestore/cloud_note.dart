import 'package:cloud_firestore/cloud_firestore.dart';

const userIdField = "user_id";
const textField = "text";

class CloudNote {
  final String documentId;
  final String userId;
  final String text;

  CloudNote(
      {required this.documentId, required this.userId, required this.text});

  CloudNote.formFirestore({
    required QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  })  : documentId = snapshot.id,
        userId = snapshot.data()[userIdField],
        text = snapshot.data()[textField];
}
