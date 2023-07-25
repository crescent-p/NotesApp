import 'package:flutter/material.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_services.dart';
import 'package:friends2/consts/auth/auth_exceptions/crud/crud_services.dart';
import 'package:friends2/utilities/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NoteServices _noteServices;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _noteServices = NoteServices();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _saveNoteIfNoteNotEmpty();
    _deleteNoteIfTextIsEmpty();

    _textEditingController.dispose();
    super.dispose();
  }

  Future<DatabaseNote> createOrUpdateNote(BuildContext context) async {
    final args = context.getArgument<DatabaseNote>();
    if (args != null) {
      _note = args;
      _textEditingController.text = args.notes;
      return args;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    } else {
      final currentUser = AuthServices.firebase().currentUser!;
      final email = currentUser.email;
// #TODO these two functions not working
      final owner = await _noteServices.getOrCreateUser(email: email);
      final note = await _noteServices.createNote(owner: owner);

      _note = note;
      return note;
    }
  }

  void _textControllerListner() {
    final note = _note;

    if (note == null) {
      print('there was no databasenote');
      return;
    } else {
      final text = _textEditingController.text;
      _noteServices.updateNote(note: note, text: text);
      // print(_textEditingController.text);
    }
  }

  void _setupTextControllerListner() async {
    final owner =
        await _noteServices.getOrCreateUser(email: 'crescent.appu@gmail.com');
    _note = await _noteServices.createNote(owner: owner);
    _textEditingController.removeListener(() {
      _textControllerListner();
    });
    _textEditingController.addListener(() {
      _textControllerListner();
      print('called');
    });
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      await _noteServices.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfNoteNotEmpty() async {
    final text = _textEditingController.text;
    final note = _note;

    if (note != null && _textEditingController.text.isNotEmpty) {
      await _noteServices.updateNote(note: note, text: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NewNote')),
      body: FutureBuilder(
        future: createOrUpdateNote(context),
        builder: (context, snapshot) {
          _note = snapshot.data;
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListner();
              return TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration:
                    const InputDecoration(hintText: "type your notes here"),
              );
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
