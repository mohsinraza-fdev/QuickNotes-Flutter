import 'note_model.dart';

class AppUser {
  String email;
  String password;
  String uid;
  List<Note> notes = <Note>[];

  AppUser({
    required this.email,
    required this.password,
    required this.uid,
  });

  //Only for testing
  factory AppUser.defined({email, password, uid, notes}) {
    var x = AppUser(email: email, password: password, uid: uid);
    x.setNotes(notes);
    return x;
  }

  setNotes(List<Note> notes) {
    this.notes = notes;
  }

  updateNote(int index, Note note) {
    notes[index] = note;
  }

  deleteNote(int index) {
    notes.removeAt(index);
  }

  addNote() {
    notes.insert(0, Note());
  }
}
