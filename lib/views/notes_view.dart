import 'package:cloudnote/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../constants/popupmenu_constants.dart';
import '../constants/routes.dart';
import '../dialogs/logout_dialog.dart';
import '../firebase/auth_service.dart';
import '../firestore/cloud_note.dart';
import '../firestore/cloud_service.dart';
import 'noteslist_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => NotesViewState();
}

class NotesViewState extends State<NotesView> {
  late final CloudService _cloudService = CloudService();
  final user = AuthService.firebase().currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(takenoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuItem>(
            onSelected: ((value) async {
              switch (value) {
                case MenuItem.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logout();
                    context.read<AuthBloc>().add(const AuthEventLoggedOut());
                  }
              }
            }),
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.logout,
                  child: Text("Logout"),
                )
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _cloudService.getStreamOfNotesFromCloud(userid: user!.userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final notesFromStream = snapshot.data as List<CloudNote>;
                return NotesListView(
                  notesList: notesFromStream,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
