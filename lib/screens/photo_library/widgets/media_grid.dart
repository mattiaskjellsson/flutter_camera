import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_camera/screens/display_picture/dispay_picture_screen.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGrid extends StatefulWidget {
  final imageFormats = ['.jpg', 'heic', '.png'];

  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  List<Widget> _mediaList = [];
  int currentPage = 0;
  int lastPage = 0;
  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  Future<AssetPathEntity> _requestAlbums() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    return albums[0];
  }

  Future<List<AssetEntity>> _getMediaPage(
      {required AssetPathEntity album,
      required int page,
      required int itemsToGet}) async {
    return await album.getAssetListPaged(page, itemsToGet);
  }

  bool _fileIsImage(String filePath) {
    final extention = filePath.substring(filePath.length - 4).toLowerCase();
    final ret = widget.imageFormats.contains(extention);
    return ret;
  }

  List<Widget> _parseMediaList(List<AssetEntity> media) {
    List<Widget> temp = [];
    for (var asset in media) {
      temp.add(
        FutureBuilder(
          future: asset.thumbDataWithSize(256, 256),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return GestureDetector(
                onTap: () async {
                  final file = await asset.loadFile();
                  final path = file?.path ?? '';

                  if (_fileIsImage(path)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayPictureScreen(
                          imagePath: path,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayPictureScreen(
                          videoPath: path,
                        ),
                      ),
                    );
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data as Uint8List,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (asset.type == AssetType.video)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 5),
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            return Container();
          },
        ),
      );
    }
    return temp;
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {
      AssetPathEntity recents = await _requestAlbums();

      List<AssetEntity> media = await _getMediaPage(
          album: recents, page: currentPage, itemsToGet: 60);

      List<Widget> temp = _parseMediaList(media);

      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return true;
      },
      child: GridView.builder(
          itemCount: _mediaList.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            return _mediaList[index];
          }),
    );
  }
}
