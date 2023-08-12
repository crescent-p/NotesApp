import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends2/Cloud/cloud_note.dart';
import 'package:friends2/Cloud/firebase_cloud_storage.dart';
import 'package:friends2/Pages/notes/note_list_view.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_services.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_bloc.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_event.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_state.dart';
import 'package:friends2/consts/routes.dart';
import 'package:friends2/dialog_box/show_logout_dialog.dart';

import '../../consts/auth/auth_exceptions/login_exceptions.dart';
import '../../dialog_box/loading_dialog_box.dart';
import '../../dialog_box/show_error_dialog.dart';
import '../../enums/menu_action.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthServices.firebase().currentUser!.id;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              content: 'User not found',
              context: context,
            );
          } else if (state is WrongPasswordAuthException) {
            await showErrorDialog(
              content: "Wrong Credentials",
              context: context,
            );
          } else if (state is GenericAuthException) {
            await showErrorDialog(
              content: "Authentication Error",
              context: context,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createUpdateNoteView);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout =
                        await showLogoutMessage(context: context);
                    if (shouldLogout) {
                      context.read<AuthBloc>().add(const AuthEventLogout());
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log out'),
                  ),
                ];
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NoteListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documnetId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createUpdateNoteView,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
