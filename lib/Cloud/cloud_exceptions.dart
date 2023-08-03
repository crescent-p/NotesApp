class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CouldNotCreateNoteException extends CloudStorageExceptions{}

class CouldNotGetAllNotes extends CloudStorageExceptions{}

class CouldNotUpdateNoteException extends CloudStorageExceptions{}

class CouldNotReadNoteException extends CloudStorageExceptions{}

class CouldNotDeleteNote extends CloudStorageExceptions{}

class CouldNotDeleteAllNote extends CloudStorageExceptions{}

class CouldNotUpdateNote extends CloudStorageExceptions{}