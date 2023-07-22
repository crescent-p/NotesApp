import 'package:flutter/material.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_services.dart';
import 'package:friends2/consts/auth/auth_exceptions/crud/crud_services.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
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

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    } else {
      final currentUser = AuthServices.firebase().currentUser!;
      final email = currentUser.email!;
      print(email);
      final owner = await _noteServices.createUser(email: email);
      return await _noteServices.createNote(owner: owner);
    }
  }

  void _textControllerListner() {
    final note = _note;
    if (note == null) {
      return;
    } else {
      final text = _textEditingController.text;
      _noteServices.updateNote(note: note, text: text);
    }
  }

  void _setupTextControllerListner() {
    _textEditingController.removeListener(() {
      _textControllerListner();
    });
    _textEditingController.addListener(() {
      _textControllerListner();
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
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data;
              print(_note);
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
