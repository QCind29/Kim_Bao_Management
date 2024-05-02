import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SearchBar({required this.onChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: widget.onChanged,
        decoration: InputDecoration(hintText: "Tìm kiếm"),
      ),
    );
  }
}
