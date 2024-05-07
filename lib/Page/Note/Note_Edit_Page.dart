import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kbstore/Model/Note.dart';
import 'package:kbstore/Model/Task.dart';
import 'package:kbstore/Provider/Note_Provider.dart';
import 'package:kbstore/Widget/CustomAppBar.dart';
import 'package:provider/provider.dart';

class NoteEditPage extends StatefulWidget {
  final bool isUpdate;
  final Note? note;

  const NoteEditPage({Key? key, required this.isUpdate, this.note})
      : super(key: key);

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  TextEditingController contentController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  Note_Provider _note_provider = Note_Provider();
  String Title = "Tạo mới ghi chú";

  @override
  void initState() {
    super.initState();

    if (widget.isUpdate) {
      nameController.text = widget.note!.Name!;
      contentController.text = widget.note!.Content;
      Title = "Chỉnh sửa ghi chú";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: Title,
          actions: [
            IconButton(
              onPressed: () {
                if (widget.isUpdate == true) {
                  updateNote();
                } else {
                  addNote();
                }
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: nameController,
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.isEmpty || value == " ") {
                            return 'Vui lòng điền Tiêu đề ghi chú';
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.white38, width: 1)),
                            hintText: "Tiêu đề",
                            labelText: "Nhập tiêu đề")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: contentController,
                        maxLines: 30,
                        validator: (value) {
                          if (value == null || value.isEmpty || value == " ") {
                            return 'Vui lòng điền Nội dung ghi chú';
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.white38, width: 1)),
                            hintText: "Nội dung",
                            labelText: "Nhập nội dung")),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> addNote() async {
    String c = contentController.text;
    String n = nameController.text;
    if (c != null && n != null || c != "" && n != "") {
      try {
        await _note_provider.addNote(c, n);
      } on Exception catch (e) {
        print(e);
      }
    } else {
      print("Error");
    }
  }

  updateNote() {
    widget.note!.Name = nameController.text;
    widget.note!.Content = contentController.text;

    Provider.of<Note_Provider>(context, listen: false).updateNote(widget.note!);
    // Navigator.pop(context);
    // showDialog(
    //     context: context,
    //     builder: (context) => CustomAlertDialog(
    //           content: "Bạn cần đăng nhập để thực hiện chức năng này",
    //         ));
  }
}
