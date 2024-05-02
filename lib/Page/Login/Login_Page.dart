import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:kbstore/Page/Product/Product_Page.dart';
import 'package:kbstore/Service/Auth_Service.dart';
import 'package:kbstore/Widget/Notification.dart';
import 'package:kbstore/Widget/field.dart';
import 'package:kbstore/main.dart';
import 'package:kbstore/Util.dart';
import 'package:kbstore/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login_Page> {

  AuthService authService = AuthService();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: bgColor,
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Image.asset(
              'assets/Logo1.png',
            ),
          ),
          SizedBox(
            height: 5,
          ),
          CustomField(
            isPassword: false,
            iconUrl: 'assets/img_email.png',
            hint: 'Email',
            textEditingController: email,
          ),
          CustomField(
            isPassword: true,
            iconUrl: 'assets/img_password.png',
            hint: 'Password',
            textEditingController: password,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "",
              style: whiteTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
          ),
          ElevatedButton(
            child: Text("Đăng Nhập"),
            onPressed: () async {
              if (email.text != null &&
                  email.text != "" &&
                  password != null &&
                  password != "") {

                String _email = email.text;
                String _password = password.text;
                bool checkEmail = await checkEmailFormat(_email);
                if(checkEmail == true ) {
                  await loginCheck(_email, _password);

                } else{
                  showAutoDismissDialog(
                      context, "Email không hợp lệ!");
                }
              } else {
                showAutoDismissDialog(
                    context, "Vui lòng điền đầy đủ tài khoản và mật khẩu");
              }
            },
          ),
          // margin: EdgeInsets.only(top: 50),
        ],
      ),
    );
  }

  loginCheck(String a, String b) async {
    try {
      UserCredential userCredential =
          await authService.signInWithEmailAndPassword(a.trim(), b);

      if (userCredential != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } else {
        showAutoDismissDialog(context, 'Sai tên tài khoản hoặc mật khẩu');
      }
    } on Exception catch (e) {
      // Check if the error is due to badly formatted email address
      if (e == 'invalid-email') {
        // Show a notification about the badly formatted email address
        showAutoDismissDialog(context, 'Email không hợp lệ');
      } else {
        // Handle other errors or exceptions
        showAutoDismissDialog(context, "Sai tên tài khoản hoặc mật khẩu");
      }
      // TODO
    }
  }
}
