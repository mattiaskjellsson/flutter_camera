import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'widgets/camera_preview_widget.dart';
import '../display_picture/dispay_picture_screen.dart';
import 'widgets/top_bar.dart';
import 'widgets/bottom_bar.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
    required this.availableCameras,
  }) : super(key: key);

  final CameraDescription camera;
  final List<CameraDescription> availableCameras;
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

  Future<void> _initCamera(CameraDescription description) async {
    _controller =
        CameraController(description, ResolutionPreset.max, enableAudio: true);

    try {
      _initializeControllerFuture = _controller.initialize();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  _toggleFlashState() {
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
      appBar: TopBar(
        icon: (_flashState == FlashMode.off
            ? Icon(
                Icons.flash_off_outlined,
                color: Colors.white,
                size: 24.0,
                semanticLabel: 'Flash on',
              )
            : Icon(
                Icons.flash_on_outlined,
                color: Colors.white,
                size: 24.0,
                semanticLabel: 'Flash off',
              )),
        toggleFlashState: _toggleFlashState,
      ),
      body: CameraPreviewWidget(
        initializeControllerFuture: _initializeControllerFuture,
        controller: _controller,
        flashState: _flashState,
      ),
      bottomNavigationBar: BottomBar(
        changeCamera: _changeCamera,
        takePicture: _takePicture,
      ), //newMethod(),
    );
  }

  _changeCamera() {
    try {
      final lensDirection = _controller.description.lensDirection;

      CameraDescription newDescription =
          lensDirection == CameraLensDirection.front
              ? widget.availableCameras.firstWhere((description) =>
                  description.lensDirection == CameraLensDirection.back)
              : widget.availableCameras.firstWhere((description) =>
                  description.lensDirection == CameraLensDirection.front);

      _initCamera(newDescription);
    } catch (e) {
      print(e.toString());
    }
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