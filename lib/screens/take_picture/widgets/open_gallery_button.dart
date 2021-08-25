import 'package:flutter/material.dart';

class OpenGalleryButton extends StatefulWidget {
  final Function() openGallery;
  OpenGalleryButton({Key? key, required this.openGallery}) : super(key: key);

  @override
  _OpenGalleryButtonState createState() => _OpenGalleryButtonState();
}

class _OpenGalleryButtonState extends State<OpenGalleryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.openGallery,
      child: Icon(Icons.image_outlined, size: 48, color: Colors.white),
    );
  }
}
