import 'dart:io';
import 'dart:typed_data';
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
    final tools = [
      _Tool('Kompres Foto', Icons.photo, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhotoPage()))),
      _Tool('Tools PDF', Icons.picture_as_pdf, Colors.red, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PdfPage()))),
      _Tool('Teks Tools', Icons.text_fields, Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TextPage()))),
      _Tool('Video Tools', Icons.videocam, Colors.purple, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoPage()))),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('SmartTools'), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: tools.length,
        itemBuilder: (c, i) {
          final t = tools[i];
          return InkWell(
            onTap: t.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(t.icon, size: 48, color: t.color),
                  const SizedBox(height: 12),
                  Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Tool {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _Tool(this.title, this.icon, this.color, this.onTap);
}

// ===== FOTO =====
class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});
  @override State<PhotoPage> createState() => _PhotoPageState();
}
class _PhotoPageState extends State<PhotoPage> {
  String? status;
  Future<void> compress() async {
    setState(() => status = 'Pilih foto...');
    final res = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
    if (res == null) return;
    final file = File(res.files.single.path!);
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return;
    setState(() => status = 'Kompres...');
    final resized = img.copyResize(image, width: image.width > 1280 ? 1280 : image.width);
    final out = img.encodeJpg(resized, quality: 75);
    final dir = await getTemporaryDirectory();
    final outFile = File('${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await outFile.writeAsBytes(out);
    await Share.shareXFiles([XFile(outFile.path)], text: 'Hasil kompres SmartTools');
    setState(() => status = 'Selesai! Ukuran: ${(out.length/1024).toStringAsFixed(1)} KB');
  }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Kompres Foto')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ElevatedButton.icon(onPressed: compress, icon: const Icon(Icons.compress), label: const Text('Pilih & Kompres')), if(status!=null) Padding(padding: const EdgeInsets.all(16), child: Text(status!))])));}

// ===== PDF =====
class PdfPage extends StatefulWidget {
  const PdfPage({super.key});
  @override State<PdfPage> createState() => _PdfPageState();
}
class _PdfPageState extends State<PdfPage> {
  String? status;
  Future<void> imagesToPdf() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
    if (res == null || res.files.isEmpty) return;
    setState(() => status = 'Membuat PDF...');
    final pdf = pw.Document();
    for (final f in res.files) {
      final bytes = await File(f.path!).readAsBytes();
      final image = pw.MemoryImage(bytes);
      pdf.addPage(pw.Page(build: (c) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain))));
    }
    final dir = await getTemporaryDirectory();
    final out = File('${dir.path}/smarttools_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await out.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(out.path)], text: 'PDF dari SmartTools');
    setState(() => status = 'PDF jadi!');
  }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Tools PDF')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ElevatedButton.icon(onPressed: imagesToPdf, icon: const Icon(Icons.image), label: const Text('Gambar 鈫� PDF')), if(status!=null) Padding(padding: const EdgeInsets.all(16), child: Text(status!))])));}

// ===== TEKS =====
class TextPage extends StatefulWidget {
  const TextPage({super.key});
  @override State<TextPage> createState() => _TextPageState();
}
class _TextPageState extends State<TextPage> {
  final ctrl = TextEditingController(text: 'Halo dari SmartTools');
  String result = '';
  void process(String mode) {
    final t = ctrl.text;
    setState(() {
      if (mode == 'upper') result = t.toUpperCase();
      else if (mode == 'lower') result = t.toLowerCase();
      else if (mode == 'reverse') result = t.split('').reversed.join();
      else result = 'Jumlah kata: ${t.trim().split(RegExp(r'\s+')).length}';
    });
  }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Teks Tools')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [TextField(controller: ctrl, maxLines: 4, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Masukkan teks')), const SizedBox(height: 12), Wrap(spacing: 8, children: [ElevatedButton(onPressed: () => process('upper'), child: const Text('UPPER')), ElevatedButton(onPressed: () => process('lower'), child: const Text('lower')), ElevatedButton(onPressed: () => process('reverse'), child: const Text('Balik')), ElevatedButton(onPressed: () => process('count'), child: const Text('Hitung'))]), const SizedBox(height: 20), SelectableText(result, style: const TextStyle(fontSize: 16))])));}

// ===== VIDEO =====
class VideoPage extends StatelessWidget {
  const VideoPage({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Video Tools')), body: const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Fitur ekstrak audio & kompres video akan aktif di update berikutnya. Untuk sekarang gunakan Kompres Foto dan PDF yang sudah jalan.', textAlign: TextAlign.center))));
}
