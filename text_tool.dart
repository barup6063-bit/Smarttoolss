import 'package:flutter/material.dart';

class TextTool extends StatefulWidget {
  @override
  _TextToolState createState() => _TextToolState();
}

class _TextToolState extends State<TextTool> {
  TextEditingController c = TextEditingController();
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text Tool")),
      body: Column(
        children: [
          TextField(controller: c),
          ElevatedButton(
              onPressed: () => setState(() => result = c.text.toUpperCase()),
              child: Text("UPPER")),
          ElevatedButton(
              onPressed: () =>
                  setState(() => result = "Jumlah: ${c.text.length}"),
              child: Text("COUNT")),
          Text(result)
        ],
      ),
    );
  }
}
