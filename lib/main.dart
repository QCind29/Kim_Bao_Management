import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kbstore/Page/CheckAuthState.dart';
import 'package:kbstore/Page/More/More_Page.dart';
import 'package:kbstore/Page/Note/Note_Page.dart';
import 'package:kbstore/Page/Product/Product_Page.dart';
import 'package:kbstore/Page/Task/Task_Page.dart';
import 'package:kbstore/Page/Login/Login_Page.dart';
import 'package:provider/provider.dart';
import 'package:kbstore/Provider/Task_Provider.dart';
import 'package:kbstore/Provider/Note_Provider.dart';
import 'package:kbstore/Provider/Product_Provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  final presenceRef = FirebaseDatabase.instance.ref("disconnectmessage");
// Write a string when this client loses connection
  presenceRef.onDisconnect().set("I disconnected!");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => Task_Provider()),
    ChangeNotifierProvider(create: (context) => Note_Provider()),
    ChangeNotifierProvider(create: (context) => Product_Provider()),
  ], child: MaterialApp(title: "Kim Bao", home: AuthenticationWrapper())));
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  final List<Widget> listBody = [
    const Product_Page(),
    const Task_Page(),
    const Note_Page(),
    const More_Page()

  ];

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (context) => NoteProvider(),
    //     builder: (context, child){
    return Scaffold(
      body: listBody[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueAccent,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_sharp), label: 'Danh sách'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Nhắc nhở'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Ghi chú'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Khác')
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );

    // const MaterialApp(
    // home: Home_Activity(),
  }

  @override
  bool get wantKeepAlive => true;
}
