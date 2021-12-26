import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:v_chat_sdk/src/modules/rooms/cubit/room_cubit.dart';

class ImageViewerView extends StatefulWidget {
  final String url;

  const ImageViewerView(this.url, {Key? key}) : super(key: key);

  @override
  State<ImageViewerView> createState() => _ImageViewerViewState();
}

class _ImageViewerViewState extends State<ImageViewerView> {
  @override
  void initState() {
    super.initState();
    RoomCubit.instance.isOpenMessageImageOrVideo = true;
  }

  @override
  void dispose() {
    RoomCubit.instance.isOpenMessageImageOrVideo = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    final isRtl = Directionality.of(context).index == 0;
    FocusScope.of(context).unfocus();
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          PhotoView(
            imageProvider: NetworkImage(widget.url),
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
