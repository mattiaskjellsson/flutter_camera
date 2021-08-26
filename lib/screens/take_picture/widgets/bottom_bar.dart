import 'package:flutter/material.dart';

import 'change_camera_button.dart';
import 'open_gallery_button.dart';
import 'take_picture_button.dart';

class BottomBar extends StatelessWidget {
  final Function() takePicture;
  final Function() changeCamera;
  final Function() openGallery;
  final Function() startVideoRecording;
  final Function() stopVideoRecording;

  const BottomBar({
    Key? key,
    required this.takePicture,
    required this.changeCamera,
    required this.openGallery,
    required this.startVideoRecording,
    required this.stopVideoRecording,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x88000000),
      height: 100.0,
      child: Expanded(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: OpenGalleryButton(openGallery: openGallery),
              ),
              TakePictureButton(
                takePicture: takePicture,
                startVideoRecording: startVideoRecording,
                stopVideoRecording: stopVideoRecording,
              ),
              Expanded(
                child: ChangeCameraButton(changeCamera: changeCamera),
              ),
            ]),
      ),
    );
  }
}
