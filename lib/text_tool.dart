import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextTool extends StatefulWidget {
  @override _TextToolState createState() => _TextToolState();
}

class _TextToolState extends State<TextTool> {
  TextEditingController c = TextEditingController();
  String out = "";

  void process(String mode) {
    final t = c.text;
    setState(() {
      if (mode == 'upper') out = t.toUpperCase();
      if (mode == 'lower') out = t.toLowerCase();
      if (mode == 'reverse') out = t.split('').reversed.join();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text Tool")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: c, maxLines: 4, decoration: InputDecoration(labelText: "Masukkan teks")),
          Wrap(spacing: 8, children: [
            ElevatedButton(onPressed: () => process('upper'), child: Text("UPPER")),
            ElevatedButton(onPressed: () => process('lower'), child: Text("lower")),
            ElevatedButton(onPressed: () => process('reverse'), child: Text("Reverse")),
            ElevatedButton(onPressed: () => Clipboard.setData(ClipboardData(text: out)), child: Text("Copy")),
          ]),
          SizedBox(height: 20),
          Text("Hasil:", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(out),
        ]),
      ),
    );
  }
}
