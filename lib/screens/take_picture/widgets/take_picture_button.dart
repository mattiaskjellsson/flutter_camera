import 'package:flutter/material.dart';

class TakePictureButton extends StatefulWidget {
  final Function() takePicture;
  final Function() startVideoRecording;
  final Function() stopVideoRecording;

  TakePictureButton({
    Key? key,
    required this.takePicture,
    required this.startVideoRecording,
    required this.stopVideoRecording,
  }) : super(key: key);

  @override
  _TakePictureButtonState createState() => _TakePictureButtonState();
}

class _TakePictureButtonState extends State<TakePictureButton> {
  var isRecording = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      onLongPress: startRecording,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(80 / 2),
        ),
        child: Center(
          child: Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: isRecording ? Colors.red : Colors.grey,
              borderRadius: BorderRadius.circular(72 / 2),
            ),
          ),
        ),
      ),
    );
  }

  tap() {
    if (isRecording) {
      stopRecording();
    } else {
      widget.takePicture();
    }
  }

  startRecording() {
    setState(() {
      isRecording = true;
    });

    widget.startVideoRecording();
  }

  stopRecording() {
    setState(() {
      isRecording = false;
    });

    widget.stopVideoRecording();
  }
}
