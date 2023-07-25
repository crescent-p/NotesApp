import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:friends2/Pages/notes/note_view.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_services.dart';
import 'Pages/notes/update_create_note_view.dart';
import 'Pages/verifyemail.dart';
import 'Pages/login.dart';
import 'Pages/register.dart';
import 'package:friends2/consts/routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(),
      routes: {
        loginView: (context) => const LoginView(),
        registerView: (context) => const Register(),
        verifyView: (context) => const VerficationPage(),
        noteView: (context) => const NoteView(),
        createUpdateNoteView: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthServices.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthServices.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NoteView();
              } else {
                return const VerficationPage();
              }
            } else {
              return const Register();
            }
          default:
            return const Text("loading");
        }
      },
    );
  }
}
