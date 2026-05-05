import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfTool extends StatefulWidget {
  @override
  _PdfToolState createState() => _PdfToolState();
}

class _PdfToolState extends State<PdfTool> {
  TextEditingController c = TextEditingController(
      text: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf');
  String status = "Masukkan URL PDF lalu download";

  Future downloadPdf() async {
    setState(() => status = "Downloading...");
    try {
      final res = await http.get(Uri.parse(c.text));
      if (res.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('\${dir.path}/smarttools_\${DateTime.now().millisecondsSinceEpoch}.pdf');
        await file.writeAsBytes(res.bodyBytes);
        setState(() {
          status = "Berhasil disimpan!\n\${file.path}\nUkuran: \${(res.bodyBytes.length/1024).toStringAsFixed(1)} KB";
        });
      } else {
        setState(() => status = "Gagal: HTTP \${res.statusCode}");
      }
    } catch (e) {
      setState(() => status = "Error: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Tool - API")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: c,
              decoration: InputDecoration(
                labelText: "URL PDF",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: downloadPdf,
              icon: Icon(Icons.download),
              label: Text("Download via HTTP API"),
            ),
            SizedBox(height: 20),
            Text(status, textAlign: TextAlign.center),
            Spacer(),
            Text("Tip: ganti URL dengan API kompres PDF kamu nanti", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
