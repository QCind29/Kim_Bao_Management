import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kbstore/Model/Note.dart';
import 'package:kbstore/Page/Note/Note_Edit_Page.dart';
import 'package:kbstore/Provider/Note_Provider.dart';
import 'package:kbstore/Util.dart';
import 'package:kbstore/Widget/EmptyUI.dart';
import 'package:kbstore/Widget/LoadingUI.dart';
import 'package:kbstore/Widget/UpdateFormDialog.dart';
import 'package:provider/provider.dart';

class Note_Page extends StatefulWidget {
  const Note_Page({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _Note_PageState createState() => _Note_PageState();
}

class _Note_PageState extends State<Note_Page> {
  final Note_Provider _note_provider = Note_Provider();

  String searchKey = "";
  refresh() async {
    final provider = Provider.of<Note_Provider>(context, listen: false);

    // setState(() {
    await provider.getAllNote();
    // });

    // print("line 26 Task_page: " + _tasks[1].Done.toString());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    setState(() {
      refresh();
    });
    super.initState();
  }

  List<Note> ListNote = [];
  bool isDone = true;
  int selectChoice = 1; // Set default value here

  handleClick(int value, List<Note> listA, List<Note> listB, List<Note> listC) {
    selectChoice = value;
    print("Function is working");

    switch (value) {
      case 1:
        setState(() {
          selectChoice = value;
          ListNote = listA;
          refresh();
          print("Value is 1 " + ListNote.toString());

          // Add logic to filter tasks based on selected choice if needed
        });
        // Show all tasks

        break;
      case 2:
        setState(() {
          selectChoice = value;
          ListNote = listB;
          print(ListNote);
          refresh();
        });
        // Show only completed tasks

        break;
      case 3:
        setState(() {
          selectChoice = value;
          ListNote = listC;
          refresh();

          print(ListNote);
        });
        // Show only incomplete tasks

        break;
    }
  }

  // checkStateDone(int value, bool a){
  //   if(value == 2){
  //     a = true;
  //   }else
  // }

  @override
  Widget build(BuildContext context) {
    Note_Provider notesProvider = Provider.of<Note_Provider>(context);

    List<Note> SListNote = notesProvider.getFilteredNote(searchKey);
    // List<Note> doneList =
    //     SListNote!.where((note) => note.Receiver != "").toList();
    // List<Note> notDoneList =
    //     SListNote!.where((note) => note.Receiver == "").toList();
    //
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Ghi chú", style: TextStyle(
            color: Colors.white,
                fontWeight: FontWeight.bold
          ),),
          backgroundColor: Colors.blueAccent,
          actions: [
            PopupMenuButton<int>(
              color: Colors.white,
              initialValue: selectChoice,
              onSelected: (value) {
                setState(() {
                  selectChoice = value;
                  // handleClick(value, SListNote, doneList, notDoneList);
                });
                print("Selected: $value");
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text('Tất cả'),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text('Đã trả'),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Text('Còn nợ'),
                  ),
                ];
              },
            ),
          ]),
      body: (_note_provider.isLoading == false)
          ? SafeArea(
              child: (_note_provider.notes!.length > 0)
                  ? Column(
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
                        (_note_provider.getFilteredNote(searchKey).length > 0)
                            ? Expanded(
                                child: ListNoteUI(SListNote, selectChoice))
                            : const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "No notes found!",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ],
                    )
                  : EmptyUI(
                      content: "Danh sách ghi chú đang rỗng",
                    ))
          : LoadingUI(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
                  context,
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) =>
                          NoteEditPage(note: null, isUpdate: false)))
              .then((value) => refresh());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget ListNoteUI(List<Note>? a, int c) {
    switch (c) {
      case 1:
        a = a;
        break;
      case 2:
        a = a!.where((note) => note.Receiver != "").toList();
        break;
      case 3:
        a = a!.where((note) => note.Receiver == "").toList();
        break;
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: a?.length,
      itemBuilder: (context, index) {
        Note currentNote = a![index];
        bool checkState = currentNote.Receiver != "" ? true : false;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => NoteEditPage(
                            note: currentNote,
                            isUpdate: true,
                          )));
              // Navigator.push(context, CupertinoPageRoute(builder: (context) => Test()));
            },
            onLongPress: () {
              _showAlertDialog(context, currentNote);
            },
            child: Card(
              // Set the shape of the card using a rounded rectangle border with a 8 pixel radius
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: checkState
                      ? Colors.green
                      : Colors.red, // Set the desired border color here
                  width: 1, // Set the desired border width
                ),
              ),
              // Set the clip behavior of the card
              clipBehavior: Clip.antiAliasWithSaveLayer,
              // Define the child widgets of the card
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Add a container with padding that contains the card's title, text, and buttons
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Display the card's title using a font size of 24 and a dark grey color
                          Text(
                            maxLines: 2,
                            currentNote.Name,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey[800],
                            ),
                          ),
                          // Add a space between the title and the text
                          Container(height: 10),
                          // Display the card's text using a font size of 15 and a light grey color
                          Text(
                            currentNote.Content,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                          // Add a row with two buttons spaced apart and aligned to the right side of the card
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // const Spacer(),

                              Text(
                                " Ngày thiếu: " +
                                    DateFormat('dd/MM/yy HH:mm')
                                        .format(DateTime.parse(
                                            currentNote.DateCreate))
                                        .toString(),
                                style: TextStyle(fontSize: 18),
                              ),

                              TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.transparent,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        checkState
                                            ? "Đã trả ngày: " +
                                                DateFormat('dd/MM/yy HH:mm')
                                                    .format(DateTime.parse(
                                                        currentNote.DateDone))
                                                    .toString()
                                            : "Chưa trả",
                                        style: TextStyle(
                                            color: checkState
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                      Icon(
                                        checkState
                                            ? Icons.check_circle_rounded
                                            : Icons
                                                .radio_button_unchecked_rounded,
                                        color: checkState
                                            ? Colors.green
                                            : Colors.red,
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    _showUpdateFormDialog(context, currentNote);
                                    refresh();
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Add a small space between the card and the next widget
                    Container(height: 10),
                  ],
                ),
                Positioned(
                  top: 8.0, // Adjust top padding
                  left: 310.0, // Adjust left padding
                  child: Text(
                    checkState
                        ? "Người nhận: " + currentNote.Receiver
                        : "", // Replace with your desired label text
                    style: TextStyle(
                        color: Colors.black, fontSize: 16.0), // Adjust style
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa'),
          content: Text('Có muốn xóa?'),
          actions: <Widget>[
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
                  deleteNote(note);
                  showDeletionNotification(context, "Xóa thành công");
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [const Text("Xóa "), Icon(Icons.delete)],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  deleteNote(Note note) async {
    await _note_provider.deleteNote(note);
    refresh();
  }

  updateNote(Note note) async {
    await _note_provider.updateNote(note);
  }

  void _showUpdateFormDialog(BuildContext context, Note note) {
    //
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateFormDialog(
          note: note,
        );
      },
    ).then((_) {
      // Trigger a reload when the second page is popped
      refresh();
    });
  }
}
