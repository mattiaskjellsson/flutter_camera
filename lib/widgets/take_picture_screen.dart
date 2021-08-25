import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/widgets/change_camera_button.dart';
import 'package:flutter_camera/widgets/take_picture_button.dart';

import 'dispay_picture_screen.dart';
import 'top_bar.dart';

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
      await _controller.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
      print('wiiiii');
    } catch (e) {
      print(e);
    }
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
      appBar: TopBar(
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
        toggleFlashState: _toggleFlashState,
      ),
      body: _buildBody(),
      bottomNavigationBar: Container(
        color: Color(0x88000000),
        height: 100.0,
        child: Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TakePictureButton(takePicture: _takePicture),
                ChangeCameraButton(changeCamera: _changeCamera)
              ]),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
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
    );
  }

  _changeCamera() {
    // setState(() async {
    //   final cameras = await availableCameras();
    //   cameras.forEach((element) {
    //     print(element.toString());
    //   });

    //   _camera = _camera.lensDirection == CameraLensDirection.back
    //       ? cameras.firstWhere(
    //           (element) => element.lensDirection == CameraLensDirection.front)
    //       : cameras.firstWhere(
    //           (element) => element.lensDirection == CameraLensDirection.back);

    //   _controller = CameraController(
    //     _camera,
    //     ResolutionPreset.medium,
    //   );

    //   _initializeControllerFuture = _controller.initialize();
    // });
    _toggleCameraLens();
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

////////////////////////////
  void _toggleCameraLens() {
    try {
      final lensDirection = _controller.description.lensDirection;
      print('Current lens direction: ${lensDirection.toString()}');
      print('----------------------------------------------------------------');
      widget.availableCameras.forEach((element) {
        print(element.toString());
      });
      print('----------------------------------------------------------------');
      CameraDescription newDescription =
          lensDirection == CameraLensDirection.front
              ? widget.availableCameras.firstWhere((description) =>
                  description.lensDirection == CameraLensDirection.back)
              : widget.availableCameras.firstWhere((description) =>
                  description.lensDirection == CameraLensDirection.front);

      print('New camera description: ${newDescription.toString()}');
      _initCamera(newDescription);
    } catch (e) {
      print(e.toString());
    }
  }
}
