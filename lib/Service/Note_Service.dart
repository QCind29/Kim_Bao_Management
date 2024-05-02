import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kbstore/Model/Note.dart';

class Note_Service {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> deleteNote(String id) async {
    final databaseReference = FirebaseDatabase.instance.ref().child('note');

    try {
      await databaseReference.child('noteId/$id').remove();
      print('Note delete successfully.');
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> updateNote(
      String id, String? receiver, String? name, String? content) async {
    final databaseReference = FirebaseDatabase.instance.ref().child('note');
    String? a = DateTime.now().toString(); // Reference to the child node
    try {
      if (name != null && content != null) {
        await databaseReference.child('noteId/$id').update({
          'Content': content,
          'Name': name,
          'Receiver': receiver,
          'DateDone': a
        });
        print('Note content updated successfully.');
      } else {
        await databaseReference
            .child('taskId/$id')
            .update({'Receiver': receiver, 'DateDone': a});
        print("Update note state successfully");
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> addTaskToFirebase(String Content, String Name) async {
    final databaseReference = FirebaseDatabase.instance.ref().child('note');

    String? noteId = databaseReference.push().key;

    // Create a new Task object
    Note note = Note(
        id: noteId,
        Userid: user!.email.toString(),
        Content: Content,
        Name: Name,
        Receiver: "",
        DateDone: "",
        DateCreate: DateTime.now().toString());

    // Serialize the Task object to Map
    Map<String, dynamic> noteMap = note.toMap();

    // Add data to Firebase
    await databaseReference.child('noteId').push().set(noteMap).then((value) {
      print('Note added successfully.');
    }).catchError((error) {
      print('Failed to add note: $error');
    });
  }

  //Get all Note

  Future<List<Note>> getNotes() async {
    // Get a reference to the 'task' node in Firebase Realtime Database
    final databaseReference = FirebaseDatabase.instance.ref().child('note');

    try {
      // Fetch data from the database as a DataSnapshot
      final DatabaseEvent databaseEvent = await databaseReference.once();
      final DataSnapshot dataSnapshot = databaseEvent.snapshot;

      // Check if data exists
      if (dataSnapshot.exists) {
        // Cast the snapshot value to a dynamic map if necessary
        final Map<Object?, Object?> noteData =
            dataSnapshot.value as Map<Object?, Object?>;

        if (noteData != null) {
          final List<Note> notes = [];

          // Iterate through each child node (task) in the snapshot
          for (final childSnapshot in dataSnapshot.children) {
            // Cast the child's value to a dynamic map

            final Map<Object?, Object?> childData =
                childSnapshot.value as Map<Object?, Object?>;
            // print("Line 183 Task_Service + " +childData.toString());
            // Convert _Map<Object?, Object?> to Map<dynamic, Map<dynamic, dynamic>>
            final Map<dynamic, Map<dynamic, dynamic>> childData1 =
                childData.map((key, value) {
              return MapEntry(key, value as Map<dynamic, dynamic>);
            });
            childData1.forEach((key, innerMap) {
              Map<dynamic, dynamic>? innerMap = childData1[key];
              if (childData != null) {
                final Note note = Note(
                  id: key.toString(),
                  DateDone: innerMap?['DateDone']?.toString()??"",
                  Userid: innerMap?['Userid']?.toString() ?? "",
                  Content: innerMap?['Content']?.toString() ?? "",
                  DateCreate: innerMap?['DateCreate']?.toString() ?? '',
                  Name: innerMap?['Name']?.toString() ?? "",
                  Receiver: innerMap?['Receiver']?.toString() ?? "",
                );


                notes.add(note);
                notes.sort((a, b) => DateTime.parse(a.DateCreate)
                    .compareTo(DateTime.parse(b.DateCreate)));


              }
            });
          }

          return notes;
        } else {
          print('List Note is null');
          return [];
        }
      } else {
        print('No note found in the database');
        return [];
      }
    } on Exception catch (e) {
      print('Error fetching note: $e');
      return [];
    }
  }
}
