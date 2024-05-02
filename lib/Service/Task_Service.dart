import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kbstore/Model/Task.dart';

class Task_Service {
  User? user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.ref().child('task');

//Create
  Future<void> addTaskToFirebase(String Content) async {
    String? taskId = databaseReference.push().key;

    // Create a new Task object
    Task task = Task(
        id: taskId,
        Userid: user!.email.toString(),
        Content: Content,
        Done: false,
        DateDone: "",
        SentByMe: false,
        DateCreate: DateTime.now().toString());

    // Serialize the Task object to Map
    Map<String, dynamic> taskMap = task.toMap();

    // Add data to Firebase
    await databaseReference.child('taskId').push().set(taskMap).then((value) {
      print('Task added successfully.');
    }).catchError((error) {
      print('Failed to add task: $error');
    });
  }

//Delete by ID

  Future<void> updateTask(String id, bool? state, String? content) async {
    DatabaseReference taskRef = FirebaseDatabase.instance.ref("task");
    DatabaseReference taskIDRef = taskRef.child("taskId");
    String? a = DateTime.now().toString(); // Reference to the child node
    try {
      if (state != null && content != null && a != null) {
        await databaseReference.child('taskId/$id').update({
          'Content': content,
          'Done': state,
          'DateDone': a,
        });
        print('Task content updated successfully.');
      } else {
        await databaseReference.child('taskId/$id').update({'Done': state});
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await databaseReference.child('taskId/$id').remove();
      print('Task delete successfully.');
    } on Exception catch (e) {
      print(e);
    }
  }

//Get by ID
  Future<Task?> getTaskById(String taskId) async {
    final databaseReference1 =
        FirebaseDatabase.instance.ref().child('taskId/$taskId');
    final snapshot = await databaseReference1.get();

    if (snapshot.exists) {
      Map<String, dynamic> taskData = snapshot.value as Map<String, dynamic>;
      return Task(
          id: taskData['id'],
          Userid: taskData['Userid'],
          Content: taskData['Content'],
          DateCreate: taskData['DateCreate'],
          Done: taskData['Done'],
          SentByMe: taskData['SentByMe'],
          DateDone: taskData['DateDone']);
    } else {
      print('Task with ID $taskId not found');
      return null; // Indicate task not found
    }
  }

  Future<List<Task>> getTasks() async {
    // Get a reference to the 'task' node in Firebase Realtime Database
    final databaseReference = FirebaseDatabase.instance.ref().child('task');

    try {
      // Fetch data from the database as a DataSnapshot
      final DatabaseEvent databaseEvent = await databaseReference.once();
      final DataSnapshot dataSnapshot = databaseEvent.snapshot;

      // Check if data exists
      if (dataSnapshot.exists) {
        // Cast the snapshot value to a dynamic map if necessary
        final Map<Object?, Object?> taskData =
            dataSnapshot.value as Map<Object?, Object?>;

        if (taskData != null) {
          final List<Task> tasks = [];

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
                final Task task = Task(
                  id: key.toString(),
                  Done: innerMap?['Done'],
                  // Use lowercase 'done' for consistency
                  Userid: innerMap?['Userid']?.toString() ?? "",
                  Content: innerMap?['Content']?.toString() ?? "",
                  DateCreate: innerMap?['DateCreate']?.toString() ?? '',
                  SentByMe: innerMap!['SentByMe'] ?? false,
                  DateDone: innerMap?['DateDone']?.toString() ?? "",
                );
                // print("Line 158 Task_serice:  " + task.toString());

                // Set 'done' and 'sentByMe' properties based on user email (optional)
                if (task.Userid == user?.email) {
                  // task.Done = true;
                  task.SentByMe = true;
                }

                tasks.add(task);
                tasks.sort((a, b) => DateTime.parse(a.DateCreate)
                    .compareTo(DateTime.parse(b.DateCreate)));
              }
            });
            // print("Line 145 Task_service: " + childData.toString());

            // Create a new Task object from the child's data
          }

          return tasks;
        } else {
          print('List Task is null');
          return [];
        }
      } else {
        print('No tasks found in the database');
        return [];
      }
    } on Exception catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }
}
