import 'package:flutter/material.dart';
import 'package:kbstore/Model/Note.dart';
import 'package:kbstore/Model/Product.dart';
import 'package:kbstore/Model/Task.dart';
import 'package:kbstore/Provider/Note_Provider.dart';
import 'package:kbstore/Provider/Task_Provider.dart';
import 'package:kbstore/Widget/Notification.dart';

class UpdateFormDialog extends StatelessWidget {
  final Task? task;
  final Note? note;
  final Product? product;
  UpdateFormDialog({Key? key, this.task, this.note, this.product})
      : super(key: key);
  final Task_Provider _task_provider = Task_Provider();
  final Note_Provider _note_provider = Note_Provider();

  bool isTask = false;
  bool isNote = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    if (task != null) {
      controller = TextEditingController(text: task!.Content);
      isTask = true;
    } else if (note != null) {
      isNote = true;
      controller = TextEditingController(text: note!.Receiver);
    }

    return AlertDialog(
      title: Text(isTask
          ? "Chỉnh sửa nhắc nhở"
          : isNote
              ? "Người nhận"
              : "Chỉnh sửa"),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
            // hintText: 'Enter new value',
            ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color of the button
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10), // Padding around the button content
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [Text("Hủy bỏ"), Icon(Icons.cancel)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color of the button
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10), // Padding around the button content
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                onPressed: () {
                  isTask
                      ? updateTask(task!, controller.text)
                      : isNote
                          ? updateNoteState(note!, controller.text)
                          : null;
                  _showDeletionNotification(context, "Chỉnh sửa thành công!");
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [const Text("Chỉnh sửa "), Icon(Icons.edit)],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  updateTask(Task task, String content) async {
    Task _task = Task(
        id: task.id,
        Content: content,
        Userid: task.Userid,
        Done: task.Done,
        DateDone: task.DateDone,
        DateCreate: task.DateCreate,
        SentByMe: task.SentByMe);
    await _task_provider.updateTask(_task);
  }

  void _showDeletionNotification(BuildContext context, String content) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        // Show the dialog
        return NotificationDialog(
          content: content,
        );
      },
    );
    // Automatically close the dialog after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  updateNoteState(Note note, String receiver) async {
    if (receiver != null) {
      Note note1 = Note(
          id: note.id,
          Userid: note.Userid,
          DateDone: note.DateDone,
          DateCreate: note.DateCreate,
          Name: note.Name,
          Content: note.Content,
          Receiver: receiver);
      await _note_provider.updateNote1(note1);
    } else {
      Note note1 = Note(
          id: note.id,
          Userid: note.Userid,
          DateDone: note.DateDone,
          DateCreate: note.DateCreate,
          Name: note.Name,
          Content: note.Content,
          Receiver: "");
      await _note_provider.updateNote1(note1);
    }
  }
}
