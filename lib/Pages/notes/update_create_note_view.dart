import 'package:flutter/material.dart';
import 'package:friends2/consts/auth/auth_exceptions/auth_services.dart';
import 'package:friends2/utilities/get_arguments.dart';
import 'package:friends2/Cloud/cloud_note.dart';
import 'package:friends2/Cloud/firebase_cloud_storage.dart';
import 'package:friends2/Cloud/cloud_exceptions.dart';
import 'package:share_plus/share_plus.dart';

import '../../dialog_box/show_cannotshareemptydialog.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _noteServices;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _noteServices = FirebaseCloudStorage();
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

  Future<CloudNote> createOrUpdateNote(BuildContext context) async {
    final args = context.getArgument<CloudNote>();
    if (args != null) {
      _note = args;
      _textEditingController.text = args.text;
      return args;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    } else {
      final currentUser = AuthServices.firebase().currentUser!;
// #TODO these two functions not working
      final userId = currentUser.id;
      final note = await _noteServices.createNewNote(ownerUserId: userId);
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
      _noteServices.updateNote(
        text: text,
        documentId: note.documentId,
      );
      // print(_textEditingController.text);
    }
  }

  void _setupTextControllerListner() async {
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
      await _noteServices.deleteNote(documnetId: note.documentId);
    }
  }

  void _saveNoteIfNoteNotEmpty() async {
    final text = _textEditingController.text;
    final note = _note;

    if (note != null && _textEditingController.text.isNotEmpty) {
      await _noteServices.updateNote(documentId: note.documentId, text: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewNote'),
        actions: [
          IconButton(
              onPressed: () async {
                final text = _textEditingController.text;
                if (text.isEmpty || _note == null) {
                  await cannotShareEmptyText(context: context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(Icons.share))
        ],
      ),
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
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
