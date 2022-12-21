import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:v_chat_media_editor/src/core/core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VideoItem extends StatelessWidget {
  final VMediaVideoRes video;
  final VoidCallback onCloseClicked;
  final Function(VMediaVideoRes item) onDelete;
  final Function(VMediaVideoRes item) onPlayVideo;

  const VideoItem(
      {Key? key,
      required this.video,
      required this.onCloseClicked,
      required this.onDelete,
      required this.onPlayVideo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: () => onCloseClicked(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: () => onDelete(video),
                      icon: const Icon(
                        PhosphorIcons.trash,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (video.data.thumbImage != null)
                VPlatformCacheImageWidget(
                  source: video.data.thumbImage!.fileSource,
                )
              else
                Container(
                  color: Colors.black87,
                ),
              InkWell(
                onTap: () => onPlayVideo(video),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: const Icon(
                        PhosphorIcons.playFill,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
