import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfTool extends StatefulWidget {
  @override _PdfToolState createState() => _PdfToolState();
}

class _PdfToolState extends State<PdfTool> {
  TextEditingController c = TextEditingController(
    text: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'
  );
  String status = "";

  Future download() async {
    setState(() => status = "Downloading...");
    try {
      final res = await http.get(Uri.parse(c.text));
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/pdf_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(res.bodyBytes);
      setState(() => status = "Tersimpan: ${file.path}");
    } catch (e) {
      setState(() => status = "Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Tool")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: c,
            decoration: InputDecoration(labelText: "URL PDF")
          ),
          ElevatedButton(onPressed: download, child: Text("Download via API")),
          SizedBox(height: 20),
          Text(status),
        ]),
      ),
    );
  }
}
