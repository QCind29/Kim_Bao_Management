import 'package:flutter/material.dart';
import 'package:kbstore/theme.dart';


class CustomTextButton extends StatelessWidget {
  final String title;
  final EdgeInsets margin;
  final VoidCallback onPressed;

  const CustomTextButton({
    this.title = '',
    this.margin = EdgeInsets.zero,
    required this.onPressed, // Required callback function

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      margin: margin,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Color(0xffeeeeee),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          title,
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: bold,
          ),
        ),
      ),
    );
  }
}
