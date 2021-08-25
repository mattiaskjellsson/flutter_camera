import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      home: HomePage(
        camera: firstCamera,
        availableCameras: cameras,
      ),
    ),
  );
}
