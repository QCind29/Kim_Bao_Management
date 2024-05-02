import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:kbstore/Model/Note.dart';
import 'package:kbstore/Service/Note_Service.dart';

class Note_Provider extends ChangeNotifier {
  final Note_Service _note_service = Note_Service();
  bool isLoading = true;
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  User? user = FirebaseAuth.instance.currentUser;

  Note_Provider() {
    getAllNote();
  }

  getAllNote() async {
    try {
      final newNote = await _note_service.getNotes();
      _notes = newNote;
      isLoading = false;
      notifyListeners();
    } catch (error) {
      print("Error: $error");
      return -1;
    }
  }

  addNote(String content, String name) async {
    if (content == null || content.isEmpty || name == null || name.isEmpty || content == "" || name == "" ) {
      print("Content and Name is null");
    } else {
      try {
        final newNote = Note(
          Userid: user!.email.toString(),
          DateCreate: DateTime.now().toString(),
          Name: name,
          Content: content,
          Receiver: "",
          DateDone: "",
        );
        _notes.add(newNote);
        notifyListeners();
        await _note_service.addTaskToFirebase(content, name);
      } catch (error) {
        print("Error creating note: $error");
        return -1;
      }
    }
  }

  updateNote1(Note note1) async {
    if (notes.isNotEmpty) {
      int indexofNote =
          notes.indexOf(notes.firstWhere((element) => element.id == note1.id));
      if (indexofNote != -1) {
        notes[indexofNote] = note1;
        await _note_service.updateNote(
            note1.id!, note1.Receiver!, note1.Name!, note1.Content!);
        notifyListeners();
      } else {
        print('Note not found in the list.');
      }
    } else {
      print('Notes list is empty.');
    }
  }

  updateNote(Note note1) async {
    if (notes.isNotEmpty) {
      int indexofNote =
          notes.indexOf(notes.firstWhere((element) => element.id == note1.id));
      if (indexofNote != -1) {
        notes[indexofNote] = note1;
        await _note_service.updateNote(
            note1.id!, note1.Receiver!, note1.Name!, note1.Content!);
        notifyListeners();
      } else {
        print('Note not found in the list.');
      }
    } else {
      print('Notes list is empty.');
    }
  }

  deleteNote(Note note1) async {
    if (notes.isNotEmpty) {
      int indexofNote =
          notes.indexOf(notes.firstWhere((element) => element.id == note1.id));
      if (indexofNote != -1) {
        notes[indexofNote] = note1;
        await _note_service.deleteNote(note1.id!);
        notifyListeners();
      } else {
        print('Note not found in the list.');
      }
    } else {
      print('Notes list is empty.');
    }
  }

  List<Note> getFilteredNote(String searchQuery) {
    return notes!
        .where((element) =>
            element.Content!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            element.Name!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
}
