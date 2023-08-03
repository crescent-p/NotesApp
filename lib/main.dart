import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends2/Pages/notes/note_view.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_services.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_bloc.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_event.dart';
import 'package:friends2/consts/auth/auth_exceptions/bloc/auth_state.dart';
import 'package:friends2/consts/auth/auth_exceptions/firebase_auth_services.dart';
import 'Pages/notes/update_create_note_view.dart';
import 'Pages/verifyemail.dart';
import 'Pages/login.dart';
import 'Pages/register.dart';
import 'package:friends2/consts/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
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
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NoteView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerficationPage();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );

    // return FutureBuilder(
    //   future: AuthServices.firebase().initialize(),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    //         final user = AuthServices.firebase().currentUser;
    //         if (user != null) {
    //           if (user.isEmailVerified) {
    //             return const NoteView();
    //           } else {
    //             return const VerficationPage();
    //           }
    //         } else {
    //           return const Register();
    //         }
    //       default:
    //         return const Text("loading");
    //     }
    //   },
    // );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _textEditingController;

//   @override
//   void initState() {
//     _textEditingController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Testing'),
//         ),
//         body: BlocConsumer<CounterBloc, CounterState>(
//           builder: (context, state) {
//             final invalidValue =
//                 (state is CounterStateInvalid) ? state.invalidValue : '';
//             return Column(children: [
//               Text('${state.value}'),
//               Visibility(
//                 visible: context is! CounterStateValid,
//                 child: const Text('Invalid text'),
//               ),
//               TextField(
//                 controller: _textEditingController,
//                 decoration: const InputDecoration(hintText: 'Increment value'),
//                 keyboardType: TextInputType.number,
//               ),
//               Row(
//                 children: [
//                   TextButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(DecrementEvent(_textEditingController.text));
//                       },
//                       child: const Text("-")),
//                   TextButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(IncrementEvent(_textEditingController.text));
//                       },
//                       child: const Text('+'))
//                 ],
//               )
//             ]);
//           },
//           listener: (context, state) {
//             _textEditingController.clear();
//           },
//         ),
//       ),
//     );
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;

//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }

// class CounterStateInvalid extends CounterState {
//   final String invalidValue;

//   const CounterStateInvalid({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }

// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalid(
//           invalidValue: event.value,
//           //the previous value will be the current state value.
//           previousValue: state.value,
//         ));
//       } else {
//         emit(CounterStateValid(state.value + integer));
//       }
//     });
//     on<DecrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalid(
//           invalidValue: event.value,
//           previousValue: state.value,
//         ));
//       } else {
//         emit (CounterStateValid(state.value - integer));
//       }
//     });
//   }
// }
