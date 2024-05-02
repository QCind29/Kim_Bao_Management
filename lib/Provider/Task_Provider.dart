import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:kbstore/Model/Task.dart';
import 'package:kbstore/Service/Task_Service.dart';

class Task_Provider extends ChangeNotifier {
  final Task_Service _task_service = Task_Service();
  bool isLoading = true;
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  User? user = FirebaseAuth.instance.currentUser;

  Task_Provider() {
    getAll();
  }
  getAll() async {
    try {
      final newTask = await _task_service.getTasks();
      _tasks = newTask;
      isLoading = false;
      notifyListeners();
    } catch (error) {
      print("Error: $error");
      return -1;
    }
  }

  addNote(String content) async {
    try {
      final newNote = Task(
        Userid: user!.email.toString(),
        DateCreate: DateTime.now().toString(),
        Done: false,
        SentByMe: false,
        Content: content,
        DateDone: "",
      );
      _tasks.add(newNote);
      notifyListeners();
      await _task_service.addTaskToFirebase(content);
    } catch (error) {
      print("Error creating note: $error");
      return -1;
    }
  }

  List<Task> getFilteredTask(String searchQuery) {
    return tasks!
        .where((element) =>
            element.Content!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  updateTask(Task note1) async {
    if (tasks.isNotEmpty) {
      int indexofNote =
          tasks.indexOf(tasks.firstWhere((element) => element.id == note1.id));
      if (indexofNote != -1) {
        tasks[indexofNote] = note1;
        await _task_service.updateTask(note1.id!, !note1.Done, note1.Content!);
        notifyListeners();
      } else {
        print('Note not found in the list.');
      }
    } else {
      print('Notes list is empty.');
    }
  }
  deleteTask(Task note1) async {
    if (tasks.isNotEmpty) {
      int indexofNote =
      tasks.indexOf(tasks.firstWhere((element) => element.id == note1.id));
      if (indexofNote != -1) {
        tasks[indexofNote] = note1;
        await _task_service.deleteTask(note1.id!);
        notifyListeners();
      } else {
        print('Note not found in the list.');
      }
    } else {
      print('Notes list is empty.');
    }
  }


}
