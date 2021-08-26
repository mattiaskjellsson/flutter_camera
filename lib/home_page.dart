import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_camera/screens/photo_library/photo_library.dart';

import 'screens/take_picture/take_picture_screen.dart';

class HomePage extends StatefulWidget {
  final camera;
  final availableCameras;
  final imagePicker;

  const HomePage({
    Key? key,
    required CameraDescription this.camera,
    required List<CameraDescription> this.availableCameras,
    required ImagePicker this.imagePicker,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera and photo library app')),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TakePictureScreen(
                              camera: widget.camera,
                              availableCameras: widget.availableCameras,
                              imagePicker: widget.imagePicker)),
                    );
                  },
                  child: Text("Camera"),
                ),
              ),
              Container(
                child: OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhotoLibrary()));
                  },
                  child: Text("Library"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
