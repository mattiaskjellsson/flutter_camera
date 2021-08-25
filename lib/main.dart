import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/home_page.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  final imagePicker = ImagePicker();
  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      home: HomePage(
        camera: firstCamera,
        availableCameras: cameras,
        imagePicker: imagePicker,
      ),
    ),
  );
}
