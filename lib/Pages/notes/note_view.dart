import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends2/Pages/notes/note_list_view.dart';
import 'package:friends2/Pages/notes/update_create_note_view.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_services.dart';
import 'package:friends2/consts/auth/auth_exceptions/crud/crud_services.dart';
import 'package:friends2/consts/routes.dart';
import 'package:friends2/dialog_box/show_logout_dialog.dart';

import '../../enums/menu_action.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final NoteServices _noteServices;
  final userEmail = FirebaseAuth.instance.currentUser!.email!;
  @override
  void initState() {
    _noteServices = NoteServices();
    // _noteServices.open();
    //we will ensure db is open in every function before using it so we don't need to use this.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthServices.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Note View'),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, createUpdateNoteView);
                        },
                        icon: const Icon(Icons.add)),
                    PopupMenuButton<menuAction>(
                      onSelected: (value) async {
                        switch (value) {
                          case menuAction.logout:
                            final somename1 =
                                await showLogoutMessage(context: context);
                            if (somename1 && context.mounted) {
                              await AuthServices.firebase().initialize();
                              await AuthServices.firebase().logOut();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, loginView, (route) => false);
                            }
                            break;
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem<menuAction>(
                              value: menuAction.logout, child: Text('Logout')),
                        ];
                      },
                    )
                  ],
                ),
                body: FutureBuilder(
                  future: _noteServices.getOrCreateUser(email: userEmail),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return StreamBuilder(
                          stream: _noteServices.allNotes,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.active:
                              case ConnectionState.waiting:
                                if (snapshot.hasData) {
                                  final allNotes =
                                      snapshot.data as List<DatabaseNote>;
                                  return NoteListView(
                                    notes: allNotes,
                                    onDeleteNote: (note) async {
                                      await _noteServices.deleteNote(
                                          id: note.id);
                                    },
                                    onTap: (note) {
                                      Navigator.of(context).pushNamed(
                                          createUpdateNoteView,
                                          arguments: note);
                                    },
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              default:
                                return const CircularProgressIndicator();
                            }
                          },
                        );
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                ),
              );
            default:
              return const Text('done');
          }
        });
  }
}
