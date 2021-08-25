import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart';
import 'widgets/camera_preview_widget.dart';
import '../display_picture/dispay_picture_screen.dart';
import 'widgets/top_bar.dart';
import 'widgets/bottom_bar.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
    required this.availableCameras,
    required this.imagePicker,
  }) : super(key: key);

  final CameraDescription camera;
  final List<CameraDescription> availableCameras;
  final ImagePicker imagePicker;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  var _flashState = FlashMode.off;
  late CameraDescription _camera = widget.camera;

  final _flashIcons = <FlashMode, Icon>{
    FlashMode.off: Icon(
      Icons.flash_off_outlined,
      color: Colors.white,
      size: 24.0,
      semanticLabel: 'Flash on',
    ),
    FlashMode.always: Icon(
      Icons.flash_on_outlined,
      color: Colors.white,
      size: 24.0,
      semanticLabel: 'Flash off',
    ),
    FlashMode.auto: Icon(
      Icons.flash_auto_outlined,
      color: Colors.white,
      size: 24.0,
      semanticLabel: 'Flash on',
    )
  };

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: TopBar(
        icon: _flashIcons[_flashState] ?? Icon(Icons.error),
        toggleFlashState: _toggleFlashState,
      ),
      body: CameraPreviewWidget(
        initializeControllerFuture: _initializeControllerFuture,
        controller: _controller,
        flashState: _flashState,
      ),
      bottomNavigationBar: BottomBar(
        changeCamera: _changeCamera,
        takePicture: () async {
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
        },
        openGallery: () async {
          try {
            final file =
                await widget.imagePicker.pickImage(source: ImageSource.gallery);
            print('a');
            if (file == null) {
              return;
            }
            print('b');
            print(file.path);
            print(file.name);
            print('c');
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: file.path,
                ),
              ),
            );
            print('d');
            // print('b');
            // final appDir =
            //     await pathProvider.getApplicationDocumentsDirectory();
            // print('c');
            // final fileName = basename(file.path);
            // print('d');
            // await file.saveTo('${appDir.path}/$fileName');
            // print('e');
            // final f = File(file.path);
            // print('f');
            // final savedImage = await f.copy('${appDir.path}/$fileName');
            // print('g');
            // await Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => DisplayPictureScreen(
            //       imagePath: savedImage.path,
            //     ),
            //   ),
            // );
            print('h');
          } catch (e) {
            print(e.toString());
          }
        }, //_openGallery,
      ),
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
      switch (_flashState) {
        case FlashMode.off:
          _flashState = FlashMode.always;
          break;
        case FlashMode.always:
          _flashState = FlashMode.auto;
          break;
        default:
          _flashState = FlashMode.off;
          break;
      }
    });
  }

  // _takePicture() async {
  //   try {
  //     await _initializeControllerFuture;
  //     final image = await _controller.takePicture();

  //     await Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => DisplayPictureScreen(
  //           imagePath: image.path,
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  _openGallery() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    print('${file.toString()}');

    if (file == null) {
      return;
    }

    final appDir = await pathProvider.getApplicationDocumentsDirectory();
    final fileName = basename(file.path);
    await file.saveTo('${appDir.path}/$fileName');
    final f = File(file.path);
    final savedImage = await f.copy('${appDir.path}/$fileName');
  }
}
