import 'package:flutter/material.dart';
import 'package:kbstore/theme.dart';

class CustomField extends StatelessWidget {
  final String iconUrl;
  final String hint;
  final TextEditingController textEditingController ;
  final bool isPassword;

  const CustomField({
    this.iconUrl = '',
    this.hint = '',
    required this.isPassword,
    required this.textEditingController, // Added required keyword
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            height: 26,
            width: 26,
            margin: EdgeInsets.only(right: 18),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  iconUrl,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              obscureText: isPassword!,
              controller: textEditingController,
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle: whiteTextStyle.copyWith(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              style: whiteTextStyle.copyWith(
                color: Colors.black,
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
