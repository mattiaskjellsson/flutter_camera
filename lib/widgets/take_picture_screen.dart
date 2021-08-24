import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'dispay_picture_screen.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  var _flashState = FlashMode.off;
  late CameraDescription _camera = widget.camera;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      _camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _toggleFlashState() {
    print('update flash state $_flashState');

    setState(() {
      _flashState =
          _flashState == FlashMode.off ? FlashMode.always : FlashMode.off;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              padding: const EdgeInsets.all(0),
              alignment: Alignment.centerRight,
              icon: (_flashState == FlashMode.off
                  ? Icon(
                      Icons.flash_off_outlined,
                      color: Colors.grey[400],
                      size: 24.0,
                      semanticLabel: 'Flash on',
                    )
                  : Icon(
                      Icons.flash_on_outlined,
                      color: Colors.grey[400],
                      size: 24.0,
                      semanticLabel: 'Flash off',
                    )),
              color: Colors.red[500],
              onPressed: _toggleFlashState,
            ),
          ),
        ],
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Expanded(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _controller.setFlashMode(_flashState);
              final scale = 1 /
                  (_controller.value.aspectRatio *
                      MediaQuery.of(context).size.aspectRatio);
              return Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: CameraPreview(_controller),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Color(0x88dddddd),
        height: 100.0,
        child: Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: _takePicture,
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
                ),
                GestureDetector(
                  onTap: _changeCamera,
                  child: Icon(
                    Icons.change_circle_outlined,
                    size: 24,
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  _changeCamera() {
    setState(() async {
      final cameras = await availableCameras();

      _camera == cameras.first ? cameras.last : cameras.first;
      _controller = CameraController(
        cameras.last,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
    });
  }

  _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
