import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerView extends StatelessWidget {
  final String url;

  const ImageViewerView(this.url);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(url),
          ),
          Positioned(
              top: 20,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
              )),
        ],
      ),
    );
  }
}
