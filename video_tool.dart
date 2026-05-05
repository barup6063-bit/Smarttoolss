import 'package:flutter/material.dart';

class VideoTool extends StatefulWidget {
  @override
  _VideoToolState createState() => _VideoToolState();
}

class _VideoToolState extends State<VideoTool> {
  TextEditingController c = TextEditingController();
  String url = "";

  void getThumb() {
    String id = c.text.split("v=")[1];
    setState(() {
      url = "https://img.youtube.com/vi/$id/0.jpg";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Tool")),
      body: Column(
        children: [
          TextField(controller: c),
          ElevatedButton(onPressed: getThumb, child: Text("Get Thumbnail")),
          if (url != "") Image.network(url),
        ],
      ),
    );
  }
}
