import 'package:flutter/material.dart';
import 'package:friends2/Pages/notes/show_delete_dialog.dart';
import 'package:friends2/consts/auth/auth_exceptions/crud/crud_services.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NoteListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final DeleteNoteCallback onDeleteNote;
  const NoteListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.notes,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          trailing: IconButton(onPressed: (
          ) async {
            final shouldDelete = await showDeleteDialog(context: context);
            if(shouldDelete){
              onDeleteNote(note);
            }
          },
          icon: const Icon(Icons.delete),),
        );
      },
    );
  }
}
