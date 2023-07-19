
import 'package:friends2/consts/auth/auth_exceptions/crud/crud_exceptions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';



class NoteServices {
  Database? _db;
  Future<Iterable<DatabaseNote>> getAllNotes({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(notesTable);

    return notes.map((fromRow) => DatabaseNote.fromRow(fromRow));
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final noDeleted =
        await db.delete(notesTable, where: 'user_id: ?', whereArgs: [id]);
    if (noDeleted == 0) {
      throw NoteNotDeleted;
    }
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updatedNotes = await db.update(notesTable, {
      textColoumn: text,
      syncedOrNotColoumn: false,
    });
    if (updatedNotes != 0) {
      throw CouldNotUpdateNote();
    } else {
      return getNote(id: note.id);
    }
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final note =
        await db.query(notesTable, where: 'id:? ', whereArgs: [id], limit: 1);
    if (note.isEmpty) {
      throw CouldNotFindNote();
    }
    return DatabaseNote.fromRow(note.first);
  }

  Future<int> deleteAllNotes() {
    final db = _getDatabaseOrThrow();
    //db.delete delets the whole file and returns the number of rows deleted.
    final deletedRows = db.delete(notesTable);
    return deletedRows;
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    // make sure owner exists in the database with the correct id
    final dbUser = await findUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    final noteId = await db.insert(notesTable, {
      userColoumnId: owner.id,
      textColoumn: '',
      syncedOrNotColoumn: 1,
    });

    return DatabaseNote(
        id: noteId, userId: owner.id, notes: 'notes', isSyncedInCloud: true);
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpen();
    } else {
      return db;
    }
  }

  Future<DatabaseUser> findUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final count = await db
        .query(userTable, where: 'email: ?', whereArgs: [email.toLowerCase()]);
    if (count.isEmpty) {
      throw UserNotFoundException;
    } else {
      return DatabaseUser.fromRow(count.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final foundUsers = await db.query(userTable,
        where: 'email: ?', limit: 1, whereArgs: [email.toLowerCase()]);
    if (foundUsers.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(userTable, {emailColumn: email});
    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    int deleted = await db.delete(
      userTable,
      where: 'email: ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deleted != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<void> close() async {
    if (_db == null) {
      throw DatabaseNotOpen();
    } else {
      final db = _db;
      await db?.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw NoteAlreadyOpenException;
    }
    try {
      final path = await getApplicationDocumentsDirectory();
      final dbpath = join(path.path, name);
      final db = await openDatabase(dbpath);
      _db = db;
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw PathNotFound;
    }
  }
}

class DatabaseUser {
  int id;
  String email;
  DatabaseUser({required this.id, required this.email});
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  int id;
  int userId;
  String notes;
  bool isSyncedInCloud;
  DatabaseNote(
      {required this.id,
      required this.userId,
      required this.notes,
      required this.isSyncedInCloud});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userColoumnId] as int,
        notes = map[textColoumn] as String,
        isSyncedInCloud = (map[syncedOrNotColoumn] as int) == 1 ? true : false;
  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}

const userTable = 'user';
const notesTable = 'notes';
const name = 'notes.db';
const idColumn = 'ID';
const emailColumn = 'email';
const syncedOrNotColoumn = 'is_synced_with_server';
const userColoumnId = 'user_id';
const textColoumn = 'text';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "User" (
	"ID"	INTEGER,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("ID")
);''';
const createNoteTable = ''' CREATE TABLE IF NOT EXISTS "NOTE" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER,
	"text"	INTEGER,
	"is_synced_with_server"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
