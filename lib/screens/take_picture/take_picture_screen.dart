import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_camera/screens/photo_library/photo_library.dart';

import '../display_picture/dispay_picture_screen.dart';
import 'widgets/bottom_bar.dart';
import 'widgets/camera_preview_widget.dart';
import 'widgets/top_bar.dart';

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
        takePicture: () => _takePicture(context),
        openGallery: () => _openGallery(context),
        startVideoRecording: _startVideoRecording,
        stopVideoRecording: () => _stopVideoRecording(context),
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

  _takePicture(BuildContext context) async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      GallerySaver.saveImage(image.path);

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

  _startVideoRecording() async {
    try {
      await _initializeControllerFuture;
      await _controller.startVideoRecording();
    } catch (e) {
      print(e.toString());
    }
  }

  _stopVideoRecording(BuildContext context) async {
    try {
      final video = await _controller.stopVideoRecording();

      bool? success = await GallerySaver.saveVideo(video.path);

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            videoPath: video.path,
          ),
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  _openGallery(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoLibrary()));
  }

  _openImageOnlyGallery() async {
    try {
      final file =
          await widget.imagePicker.pickImage(source: ImageSource.gallery);

      if (file == null) {
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: file.path,
          ),
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
