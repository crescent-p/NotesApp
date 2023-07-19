
import 'package:flutter/material.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_services.dart';
import '../consts/routes.dart';
import '../dialog_box/show_logout_dialog.dart';
import '../enums/menu_action.dart';
import '../main.dart';

class MAINpage extends StatefulWidget {
  const MAINpage({super.key});

  @override
  State<MAINpage> createState() => _MAINpageState();
}

class _MAINpageState extends State<MAINpage> {
  get somename => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAIN UI'),
        actions: [
          PopupMenuButton<menuAction>(
            onSelected: (value) async {
              switch (value) {
                case menuAction.logout:
                  final somename1 = await showLogoutDialog(context);
                  if (somename1) {
                    await AuthServices.firebase().initialize();
                    AuthServices.firebase().logOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, loginView, (route) => false);
                  }
                  somename.log(somename1.toString());
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
      body: const Text('HEllo'),
    );
  }
}
