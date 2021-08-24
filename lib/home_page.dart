import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'widgets/take_picture_screen.dart';

class HomePage extends StatefulWidget {
  final camera;
  const HomePage({Key? key, required CameraDescription this.camera})
      : super(key: key);

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
                          builder: (context) =>
                              TakePictureScreen(camera: widget.camera)),
                    );
                  },
                  child: Text("Camera"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
