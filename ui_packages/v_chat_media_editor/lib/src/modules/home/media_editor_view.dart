import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/horz_media_item.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/media_item.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../core/core.dart';
import 'media_editor_controller.dart';

class MediaEditorView extends StatefulWidget {
  final List<VPlatformFileSource> files;
  final MediaEditorConfig config;

  const MediaEditorView({
    super.key,
    required this.files,
    this.config = const MediaEditorConfig(),
  });

  @override
  State<MediaEditorView> createState() => _MediaEditorViewState();
}

class _MediaEditorViewState extends State<MediaEditorView> {
  late final MediaEditorController controller;

  @override
  void initState() {
    controller = MediaEditorController(widget.files, widget.config);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.updater,
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: controller.isLoading
              ? null
              : FloatingActionButton.small(
                  elevation: 0,
                  onPressed: () => controller.onSubmitData(context),
                  child: controller.isCompressing
                      ? const CupertinoActivityIndicator()
                      : const Icon(Icons.send),
                ),
          backgroundColor: Colors.black26,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    onPageChanged: controller.changeImageIndex,
                    controller: controller.pageController,
                    itemBuilder: (BuildContext context, int index) {
                      return MediaItem(
                        mediaFile: controller.mediaFiles[index],
                        onCloseClicked: () => controller.onEmptyPress(context),
                        onDelete: (item) => controller.onDelete(item, context),
                        onCrop: (item) => controller.onCrop(
                            item as MediaEditorImage, context),
                        onPlayVideo: (item) =>
                            controller.onPlayVideo(item, context),
                        onStartDraw: (item) {
                          if (item is MediaEditorVideo) {
                            return controller.onStartEditVideo(item, context);
                          } else if (item is MediaEditorImage) {
                            return controller.onStartDraw(item, context);
                          }
                        },
                        isActive: kIsWeb ? false : !controller.isLoading,
                      );
                    },
                    itemCount: controller.mediaFiles.length,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(5),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 5,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          controller.changeImageIndex(index);
                        },
                        child: HorzMediaItem(
                          mediaFile: controller.mediaFiles[index],
                          isLoading: controller.isLoading,
                        ),
                      );
                    },
                    itemCount: controller.mediaFiles.length,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
