import 'package:flutter/cupertino.dart';

class EmptyUI extends StatelessWidget {
  final String content;

  const EmptyUI({
    // required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("List is empty!"),
    );
  }
}
