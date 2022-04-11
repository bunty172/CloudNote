import 'package:cloudnote/firestore/cloud_service.dart';
import 'package:flutter/material.dart';
import '../firebase/auth_service.dart';

class TakeNoteView extends StatefulWidget {
  const TakeNoteView({Key? key}) : super(key: key);

  @override
  State<TakeNoteView> createState() => _TakeNoteViewState();
}

class _TakeNoteViewState extends State<TakeNoteView> {
  late final TextEditingController _noteTextController;
  late final CloudService _cloudService;
  final String email = AuthService.firebase().currentUser!.email;
  @override
  void initState() {
    _cloudService = CloudService();
    _noteTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    saveNoteIfTextNotEmpty();
    _noteTextController.dispose();
    super.dispose();
  }

  void saveNoteIfTextNotEmpty() async {
    if (_noteTextController.text.isNotEmpty) {
      final user = AuthService.firebase().currentUser;
      await _cloudService.createNewNoteOnCloud(
          userid: user!.userId, text: _noteTextController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Take Your Note"),
        ),
        body: TextField(
          decoration: const InputDecoration(hintText: "Take Your Note here"),
          controller: _noteTextController,
        ));
  }
}
