import 'package:cloudnote/firestore/cloud_note.dart';
import 'package:cloudnote/firestore/cloud_service.dart';
import 'package:flutter/material.dart';

class UpdateNoteView extends StatefulWidget {
  const UpdateNoteView({Key? key}) : super(key: key);

  @override
  State<UpdateNoteView> createState() => UpdateNoteViewState();
}

class UpdateNoteViewState extends State<UpdateNoteView> {
  late final TextEditingController _existingNoteTextController;
  late final CloudService _cloudService;
  late final CloudNote _existingCloudNote;

  @override
  void initState() {
    _existingNoteTextController = TextEditingController();
    _cloudService = CloudService();
    super.initState();
  }

  @override
  void dispose() {
    updateNoteWhileDisposing(
        existingCloudNote: _existingCloudNote,
        text: _existingNoteTextController.text);
    _existingNoteTextController.dispose();
    super.dispose();
  }

  void updateNoteWhileDisposing({
    required CloudNote existingCloudNote,
    required String text,
  }) async {
    await _cloudService.updateNoteOnCloud(
      documentid: existingCloudNote.documentId,
      text: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    _existingCloudNote =
        ModalRoute.of(context)!.settings.arguments as CloudNote;
    _existingNoteTextController.text = _existingCloudNote.text;
    return Scaffold(
      appBar: AppBar(title: const Text("Update Your Note")),
      body: TextField(
        controller: _existingNoteTextController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
