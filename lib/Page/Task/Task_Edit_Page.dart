import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kbstore/Model/Task.dart';
import 'package:kbstore/Service/Task_Service.dart';
import 'package:kbstore/Util.dart';
import 'package:firebase_database/firebase_database.dart';

class TaskEditPage extends StatefulWidget {
  final bool isUpdate;
  final Task? note;

  const TaskEditPage({Key? key, required this.isUpdate, this.note})
      : super(key: key);

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  String title = "Thêm mới nhắc nhở";
  TextEditingController contentController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  Task_Service _task_service = Task_Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const Text("Cập nhật nhắc nhở", style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              onPressed: () {
                _task_service.addTaskToFirebase(contentController.text);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: const EdgeInsets.all(15),
            child: Container(
              margin: EdgeInsets.fromLTRB(10,20,10,10),
              child: TextFormField(
                  controller: contentController,
                  maxLines: null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: Colors.white38, width: 1)),
                      hintText: "Nội dung",
                      labelText: "Nhập nội dung")),
            ),
          ),
        ));
  }
}
