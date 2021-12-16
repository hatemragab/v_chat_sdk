import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerView extends StatelessWidget {
  final String url;

  const ImageViewerView(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context).index == 0;
    FocusScope.of(context).unfocus();
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          PhotoView(
            imageProvider: NetworkImage(url),
          ),
          if (isRtl)
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            )
          else
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
