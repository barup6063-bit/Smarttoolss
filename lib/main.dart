import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const SmartToolsApp());
}

class SmartToolsApp extends StatelessWidget {
  const SmartToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartTools',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartTools'), centerTitle: true),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildCard(context, 'Kompres Foto', Icons.photo, Colors.blue, const PhotoPage()),
          _buildCard(context, 'Gambar ke PDF', Icons.picture_as_pdf, Colors.red, const PdfPage()),
          _buildCard(context, 'Teks Tools', Icons.text_fields, Colors.green, const TextPage()),
          _buildCard(context, 'Coming Soon', Icons.videocam, Colors.grey, const ComingSoonPage()),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext c, String title, IconData icon, Color color, Widget page) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => page)),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});
  @override State<PhotoPage> createState() => _PhotoPageState();
}
class _PhotoPageState extends State<PhotoPage> {
  String status = 'Pilih foto untuk dikompres';
  Future<void> compress() async {
    setState(() => status = 'Pilih foto...');
    final res = await FilePicker.platform.pickFiles(type: FileType.image);
    if (res == null) return setState(() => status = 'Dibatalkan');
    final file = File(res.files.single.path!);
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return;
    setState(() => status = 'Mengkompres...');
    final resized = img.copyResize(image, width: image.width > 1280? 1280 : image.width);
    final out = img.encodeJpg(resized, quality: 75);
    final dir = await getTemporaryDirectory();
    final outFile = File('${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await outFile.writeAsBytes(out);
    await Share.shareXFiles([XFile(outFile.path)], text: 'Hasil kompres SmartTools');
    setState(() => status = 'Selesai! ${(out.length/1024).toStringAsFixed(1)} KB');
  }
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Kompres Foto')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ElevatedButton.icon(onPressed: compress, icon: const Icon(Icons.compress), label: const Text('Pilih & Kompres')), const SizedBox(height:16), Text(status)])));
}

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});
  @override State<PdfPage> createState() => _PdfPageState();
}
class _PdfPageState extends State<PdfPage> {
  String status = 'Pilih beberapa gambar';
  Future<void> imagesToPdf() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
    if (res == null) return;
    setState(() => status = 'Membuat PDF...');
    final pdf = pw.Document();
    for (final f in res.files) {
      final bytes = await File(f.path!).readAsBytes();
      pdf.addPage(pw.Page(build: (c) => pw.Center(child: pw.Image(pw.MemoryImage(bytes)))));
    }
    final dir = await getTemporaryDirectory();
    final out = File('${dir.path}/smarttools.pdf');
    await out.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(out.path)]);
    setState(() => status = 'PDF jadi!');
  }
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Gambar ke PDF')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ElevatedButton.icon(onPressed: imagesToPdf, icon: const Icon(Icons.image), label: const Text('Pilih Gambar')), const SizedBox(height:16), Text(status)])));
}

class TextPage extends StatefulWidget {
  const TextPage({super.key});
  @override State<TextPage> createState() => _TextPageState();
}
class _TextPageState extends State<TextPage> {
  final ctrl = TextEditingController(text: 'Halo SmartTools');
  String result = '';
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Teks Tools')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [TextField(controller: ctrl, maxLines: 3, decoration: const InputDecoration(border: OutlineInputBorder())), const SizedBox(height: 12), Wrap(spacing: 8, children: [ElevatedButton(onPressed: () => setState(() => result = ctrl.text.toUpperCase()), child: const Text('UPPER')), ElevatedButton(onPressed: () => setState(() => result = ctrl.text.toLowerCase()), child: const Text('lower')), ElevatedButton(onPressed: () => setState(() => result = ctrl.text.split('').reversed.join()), child: const Text('Balik'))]), const SizedBox(height: 20), SelectableText(result)])));
}

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Video Tools')), body: const Center(child: Text('Fitur video akan hadir di update berikutnya')));
}
