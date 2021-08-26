import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String videoPath;

  const DisplayPictureScreen(
      {Key? key, this.imagePath = '', this.videoPath = ''});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late VideoPlayerController _controller;
  late Image image;

  @override
  initState() {
    super.initState();
    if (widget.imagePath.isNotEmpty) {
      image = Image.file(File(widget.imagePath));
    } else if (widget.videoPath.isNotEmpty) {
      _controller = VideoPlayerController.file(File(widget.videoPath));

      _controller.addListener(() {
        setState(() {});
      });
      _controller.setLooping(true);
      _controller.initialize().then((_) => setState(() {}));
      _controller.play();
    }
  }

  videoController() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(_controller),
            VideoProgressIndicator(_controller, allowScrubbing: true),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: widget.imagePath.isNotEmpty ? image : videoController(),
    );
  }
}
