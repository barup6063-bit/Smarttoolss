import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoTool extends StatefulWidget {
  @override _VideoToolState createState() => _VideoToolState();
}

class _VideoToolState extends State<VideoTool> {
  File? file;
  VideoPlayerController? controller;

  Future pick() async {
    final x = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (x != null) {
      file = File(x.path);
      controller = VideoPlayerController.file(file!)
        ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Tool")),
      body: Column(children: [
        ElevatedButton(onPressed: pick, child: Text("Pick Video")),
        if (controller != null && controller!.value.isInitialized)
          AspectRatio(
            aspectRatio: controller!.value.aspectRatio,
            child: VideoPlayer(controller!),
          ),
        if (controller != null)
          ElevatedButton(
            onPressed: () => controller!.value.isPlaying ? controller!.pause() : controller!.play(),
            child: Text("Play/Pause"),
          ),
      ]),
    );
  }
}
