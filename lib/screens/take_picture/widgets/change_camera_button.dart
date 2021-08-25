import 'package:flutter/material.dart';

class ChangeCameraButton extends StatefulWidget {
  final Function() changeCamera;
  ChangeCameraButton({Key? key, required this.changeCamera}) : super(key: key);

  @override
  _ChangeCameraButtonState createState() => _ChangeCameraButtonState();
}

class _ChangeCameraButtonState extends State<ChangeCameraButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.changeCamera,
      child: Icon(
        Icons.change_circle_outlined,
        size: 48,
      ),
    );
  }
}
