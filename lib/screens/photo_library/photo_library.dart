import 'package:flutter/material.dart';
import 'widgets/media_grid.dart';

class PhotoLibrary extends StatefulWidget {
  PhotoLibrary({Key? key}) : super(key: key);

  @override
  _PhotoLibraryState createState() => _PhotoLibraryState();
}

class _PhotoLibraryState extends State<PhotoLibrary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select a photo or video'),
        ),
        body: MediaGrid(),
      ),
    );
  }
}
