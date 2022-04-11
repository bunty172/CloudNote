import 'package:cloudnote/firestore/cloud_note.dart';
import 'package:cloudnote/firestore/cloud_service.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../dialogs/delete_dialog.dart';

class NotesListView extends StatelessWidget {
  final List<CloudNote> notesList;
  const NotesListView({Key? key, required this.notesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CloudService _cloudService;
    _cloudService = CloudService();
    return ListView.builder(
      itemBuilder: ((context, index) {
        final note = notesList[index];
        return ListTile(
          title: Text(
            note.text,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                await _cloudService.deleteNoteOnCloud(
                    documentId: note.documentId);
              }
            },
          ),
          onTap: () {
            Navigator.of(context).pushNamed(updatenoteRoute, arguments: note);
          },
        );
      }),
      itemCount: notesList.length,
    );
  }
}
