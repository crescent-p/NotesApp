import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_services.dart';
import 'package:friends2/consts/auth/auth_exceptions/crud/crud_services.dart';
import '../consts/routes.dart';
import '../dialog_box/show_logout_dialog.dart';
import '../enums/menu_action.dart';

class MAINpage extends StatefulWidget {
  const MAINpage({super.key});

  @override
  State<MAINpage> createState() => _MAINpageState();
}

class _MAINpageState extends State<MAINpage> {
  late final NoteServices _noteServices;
  final userEmail = FirebaseAuth.instance.currentUser!.email!;
  @override
  void initState() {
    _noteServices = NoteServices();
    //_noteServices.open();
    //we will ensure db is open in every function before using it so we don't need to use this.
    super.initState();
  }

  @override
  void dispose() {
    _noteServices.close();
    super.dispose();
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
                  title: const Text('MAIN UI'),
                  // actions: [
                  //   PopupMenuButton<menuAction>(
                  //     onSelected: (value) async {
                  //       switch (value) {
                  //         case menuAction.logout:
                  //           final somename1 = await showLogoutDialog(context);
                  //           if (somename1) {
                  //             await AuthServices.firebase().initialize();
                  //             AuthServices.firebase().logOut();
                  //             Navigator.pushNamedAndRemoveUntil(
                  //                 context, loginView, (route) => false);
                  //           }
                  //           break;
                  //       }
                  //     },
                  //     itemBuilder: (context) {
                  //       return [
                  //         const PopupMenuItem<menuAction>(
                  //             value: menuAction.logout, child: Text('Logout')),
                  //       ];
                  //     },
                  //   )
                  // ],
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
                              case ConnectionState.waiting:
                                return const Text("waiting for data");
                              default:
                                return const Text("done");
                            }
                          },
                        );
                      default:
                        return Text('ok');
                    }
                  },
                ),
              );
            default:
              return Text('done');
          }
        });
  }
}
