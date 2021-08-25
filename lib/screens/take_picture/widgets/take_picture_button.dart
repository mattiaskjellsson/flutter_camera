import 'package:flutter/material.dart';

class TakePictureButton extends StatefulWidget {
  final Function() takePicture;
  TakePictureButton({Key? key, required this.takePicture}) : super(key: key);

  @override
  _TakePictureButtonState createState() => _TakePictureButtonState();
}

class _TakePictureButtonState extends State<TakePictureButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.takePicture,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(80 / 2),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}