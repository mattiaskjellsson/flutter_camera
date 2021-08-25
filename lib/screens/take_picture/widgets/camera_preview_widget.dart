import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  final initializeControllerFuture;
  final controller;
  final flashState;

  const CameraPreviewWidget({
    Key? key,
    required Future this.initializeControllerFuture,
    required CameraController this.controller,
    required FlashMode this.flashState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<void>(
        future: initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            controller.setFlashMode(flashState);
            final scale = 1 /
                (controller.value.aspectRatio *
                    MediaQuery.of(context).size.aspectRatio);
            return Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: CameraPreview(controller),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
