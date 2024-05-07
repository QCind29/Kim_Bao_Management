import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kbstore/Model/Task.dart';
import 'package:kbstore/Provider/Task_Provider.dart';
import 'package:kbstore/Service/Auth_Service.dart';
import 'package:kbstore/Widget/CustomAlertDialog.dart';
import 'package:kbstore/Widget/CustomAppBar.dart';

import 'package:kbstore/Widget/UpdateFormDialog.dart';
import 'package:provider/provider.dart';
import 'package:kbstore/Util.dart';

class Task_Page extends StatefulWidget {
  const Task_Page({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _Task_PageState createState() => _Task_PageState();
}

class _Task_PageState extends State<Task_Page> {
  Color checkColor = Colors.white;
  Icon checkIcon = Icon(Icons.abc);
  TextEditingController message = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Task_Provider _task_provider = Task_Provider();
  String searchKey = "";
  final AuthService _authService = AuthService();

  refresh() async {
    final provider = Provider.of<Task_Provider>(context, listen: false);

    // setState(() {
    await provider.getAll();
    // });

    // print("line 26 Task_page: " + _tasks[1].Done.toString());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    refresh();
    setState(() {
      refresh();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Task_Provider task_provider = Provider.of<Task_Provider>(context);

    final List<Task>? ListTask = task_provider.getFilteredTask(searchKey);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Cần làm",
      ),
      body: (task_provider.isLoading == false)
          ? SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          searchKey = val;
                        });
                      },
                      decoration: InputDecoration(hintText: "Search"),
                    ),
                  ),
                  (task_provider.getFilteredTask(searchKey).length > 0)
                      ? Expanded(flex: 9, child: ListUI(ListTask!))
                      : const Expanded(
                          // padding: EdgeInsets.all(20),
                          flex: 9,
                          child: Text("Không tìm thấy!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 40,
                              )),
                        ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: message,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                hintText: "Nhập nội dung..."),
                            onSubmitted: (text) async {
                              bool isLoggedIn =
                                  await _authService.isUserLoggedIn();
                              if (isLoggedIn) {
                                await message.text.isNotEmpty
                                    ? setState(() {
                                        task_provider.addNote(text);
                                        message.clear();
                                        refresh();
                                        // Scroll to the bottom after adding the message
                                        _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeOut,
                                        );
                                      })
                                    : {};
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => CustomAlertDialog(
                                    content:
                                        "Bạn cần đăng nhập để thực hiện chức năng này",
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              await message.text.isNotEmpty
                                  ? setState(() {
                                      task_provider.addNote(message.text);
                                      message.clear();
                                      refresh();
                                    })
                                  : {};
                            },
                            icon: Icon(Icons.send_sharp))
                      ],
                    ),
                  ),
                ],
              ),
            )
          : LoadingUI(),
    );
  }

  Widget ListUI(List<Task> a) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      reverse: true,
      shrinkWrap: true,
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      itemCount: a?.length,
      itemBuilder: (context, index) {
        Task currentNote = a![index];

        bool checkState = currentNote.Done ? true : false;

        void toggleTaskCompletion() async {
          await _task_provider.updateTask(currentNote);
          refresh();
        }

        print('LINE 163 Task_Page ' +
            a[index].Content.toString() +
            "  " +
            a[index].Done.toString());

        return GestureDetector(
          onTap: () {},
          onLongPress: () async {
            bool isLoggedIn = await _authService.isUserLoggedIn();
            if (isLoggedIn) {
              _showAlertDialog(context, currentNote);
            } else {
              showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  content: "Bạn cần đăng nhập để thực hiện chức năng này",
                ),
              );
              // print("Line 80 Product_Page chưa đăng nhập");
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Align(
              alignment: currentNote.SentByMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: currentNote.SentByMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: a![index].SentByMe
                              ? Colors.blue
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a![index].Content,
                              style: TextStyle(
                                fontSize: 25,
                                color: a![index].SentByMe
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              softWrap: true,
                              maxLines: null,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              DateFormat('dd/MM/yy HH:mm')
                                  .format(DateTime.parse(a[index].DateCreate)),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: a![index].SentByMe
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            checkState ? "Hoàn thành" : "Chưa hoàn thành",
                            style: TextStyle(
                              color: checkState ? Colors.green : Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              bool isLoggedIn =
                                  await _authService.isUserLoggedIn();
                              if (isLoggedIn) {
                                toggleTaskCompletion();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => CustomAlertDialog(
                                    content:
                                        "Bạn cần đăng nhập để thực hiện chức năng này",
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              checkState
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: checkState ? Colors.green : Colors.red,
                            ),
                          ),
                          Container(
                            child: Text(
                              a![index].Done == true && a![index].DateDone != ""
                                  ? DateFormat('dd/MM/yy HH:mm')
                                      .format(DateTime.parse(a[index].DateDone))
                                  : '',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context, Task task) {
    // Task_Provider notesProvider =
    //     Provider.of<Task_Provider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tùy chỉnh'),
          content: Text('Chỉnh sửa hay xóa ?'),
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
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    onPressed: () {
                      _showUpdateFormDialog(context, task);
                    },
                    child: Row(
                      children: [Text("Chỉnh sửa"), Icon(Icons.edit)],
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
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    onPressed: () {
                      deleteTask(task);
                      showDeletionNotification(context, "Xóa thành công");
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [const Text("Xóa "), Icon(Icons.delete)],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void deleteTask(Task task) async {
    await _task_provider.deleteTask(task);
    refresh();
  }

  Widget LoadingUI() {
    return const Center(child: CircularProgressIndicator());
  }

  void _showUpdateFormDialog(BuildContext context, Task task) {
    //
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateFormDialog(
          task: task,
        );
      },
    );
  }
}
