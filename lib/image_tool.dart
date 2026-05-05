import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageTool extends StatefulWidget {
  @override _ImageToolState createState() => _ImageToolState();
}
class _ImageToolState extends State<ImageTool> {
  File? file;
  Future pick() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => file = File(x.path));
  }
  Future compress() async {
    final bytes = await file!.readAsBytes();
    final image = img.decodeImage(bytes)!;
    final resized = img.copyResize(image, width: 600);
    final dir = await getTemporaryDirectory();
    final path = "${dir.path}/out.jpg";
    File(path).writeAsBytesSync(img.encodeJpg(resized, quality: 70));
    setState(() => file = File(path));
  }
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Image Tool")),
      body: Column(children: [
        ElevatedButton(onPressed: pick, child: Text("Pick Image")),
        if (file != null) Image.file(file!),
        ElevatedButton(onPressed: compress, child: Text("Compress"))
      ]));
  }
}
