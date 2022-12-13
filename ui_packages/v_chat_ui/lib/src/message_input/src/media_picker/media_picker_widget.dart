import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:place_picker/entities/localization_item.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../core/utils/app_pick.dart';
import '../input/widgets/media_tile.dart';

class MediaPickerWidget extends StatelessWidget {
  final Function(List<PlatformFileSource> files) onSubmitMedia;
  final Function(List<PlatformFileSource> files) onSubmitFiles;
  final Function(VLocationMessageData data) onSubmitLocation;

  const MediaPickerWidget({
    super.key,
    required this.onSubmitMedia,
    required this.onSubmitFiles,
    required this.onSubmitLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () => Navigator.maybePop(context),
                child: const Icon(
                  Icons.close,
                ),
              ),
              Text(
                "contentAndTools",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox()
            ],
          ),
        ),
        Flexible(
          child: ListView(
            children: <Widget>[
              ModalTile(
                title: "gallery",
                subtitle: "shareMedia",
                icon: PhosphorIcons.image,
                bkColor: const Color(0xffA603D0),
                onTap: () async {
                  context.pop();
                  final files = await AppPick.getMedia();
                  if (files != null) {
                    onSubmitMedia(files);
                  }
                },
              ),
              ModalTile(
                title: "file",
                subtitle: "shareFiles",
                bkColor: const Color(0xffFF9700),
                icon: PhosphorIcons.file,
                onTap: () async {
                  context.pop();
                  final files = await AppPick.getFiles();
                  if (files != null) {
                    onSubmitFiles(files);
                  }
                },
              ),
              // ModalTile(
              //   title: "Contact",
              //   subtitle: "Share contacts",
              //   icon: Icons.contacts,
              //   onTap: () {},
              // ),
              Visibility(
                visible: Platforms.isMobile,
                child: ModalTile(
                  //todo fix
                  title: "location",
                  subtitle: "shareALocation",
                  icon: Icons.location_pin,
                  onTap: () async {
                    context.pop();
                    final LocationResult? result =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlacePicker(
                          AppConstants.mapsApiKey,
                          //todo fix trans
                          localizationItem:
                              LocalizationItem(languageCode: "en"),
                        ),
                      ),
                    );
                    if (result != null &&
                        result.latLng != null &&
                        result.latLng != null) {
                      // final localFile = await DefaultCacheManager().getSingleFile(
                      //   "https://maps.googleapis.com/maps/api/staticmap?center=${result.latLng!.latitude},${result.latLng!.longitude}&zoom=15&size=800x400&key=${AppConstants.mapsApiKey}",
                      // );
                      final location = VLocationMessageData(
                        latLng: LatLng(
                          result.latLng!.latitude,
                          result.latLng!.longitude,
                        ),
                        linkPreviewData: VLinkPreviewData(
                          title: result.name,
                          desc: result.formattedAddress,
                          link:
                              "https://maps.google.com/?q=${result.latLng!.latitude},${result.latLng!.longitude}",
                        ),
                      );
                      onSubmitLocation(location);
                    }
                  },
                  bkColor: const Color(0xff8e6b39),
                ),
              ),
              // ModalTile(
              //   title: "Schedule Call",
              //   subtitle: "Arrange a skype call and get reminders",
              //   icon: Icons.schedule,
              //   onTap: () {},
              // ),
              // ModalTile(
              //   title: "Create Poll",
              //   subtitle: "Share polls",
              //   icon: Icons.poll,
              //   onTap: () {},
              // )
            ],
          ),
        ),
      ],
    );

    // return CupertinoActionSheet(
    //   cancelButton: CupertinoActionSheetAction(
    //     child: const Text("Cancel"),
    //     onPressed: () {
    //       return Navigator.pop(ctx);
    //     },
    //   ),
    //   actions: [
    //     CupertinoActionSheetAction(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: const [
    //           Icon(Icons.image, size: 24),
    //           SizedBox(
    //             width: 15,
    //           ),
    //           Text("photo"),
    //         ],
    //       ),
    //       onPressed: () async {
    //         final picker = ImagePicker();
    //         final pickedFile =
    //             await picker.pickImage(source: ImageSource.gallery);
    //
    //         if (pickedFile != null) {
    //           if (File(pickedFile.path).lengthSync() >
    //               AppConstants.maxMediaSize) {
    //             File(pickedFile.path).deleteSync();
    //             InfoAlert().show(text: "file Is Too Large");
    //             Navigator.pop(ctx);
    //           }
    //           return Navigator.pop(
    //             ctx,
    //             {"type": "photo", "path": pickedFile.path},
    //           );
    //         }
    //         Navigator.pop(ctx);
    //       },
    //     ),
    //     CupertinoActionSheetAction(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: const [
    //           Icon(Icons.attach_file, size: 24),
    //           SizedBox(
    //             width: 25,
    //           ),
    //           Text("File"),
    //         ],
    //       ),
    //       onPressed: () async {
    //         final FilePickerResult? result =
    //             await FilePicker.platform.pickFiles();
    //         if (result != null) {
    //           if (File(result.files.first.path!).lengthSync() >
    //               AppConstants.maxMediaSize) {
    //             File(result.files.first.path!).deleteSync();
    //             InfoAlert().show(text: "file Is Too Large");
    //             return Navigator.pop(ctx);
    //           }
    //           return Navigator.pop(
    //             ctx,
    //             {"type": "file", "path": result.files.first.path},
    //           );
    //         }
    //         return Navigator.pop(ctx);
    //       },
    //     ),
    //     CupertinoActionSheetAction(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: const [
    //           Icon(Icons.video_call, size: 24),
    //           SizedBox(
    //             width: 15,
    //           ),
    //           Text("Video"),
    //         ],
    //       ),
    //       onPressed: () async {
    //         final FilePickerResult? result =
    //             await FilePicker.platform.pickFiles(
    //           type: FileType.custom,
    //           allowedExtensions: ['mp4', 'mkv', 'avi', 'm4p', 'flv'],
    //         );
    //         if (result != null) {
    //           if (File(result.files.first.path!).lengthSync() >
    //               AppConstants.maxMediaSize) {
    //             File(result.files.first.path!).deleteSync();
    //             InfoAlert().show(text: "file Is Too Large");
    //             return Navigator.pop(ctx);
    //           }
    //           return Navigator.pop(
    //             ctx,
    //             {"type": "video", "path": result.files.first.path},
    //           );
    //         }
    //         return Navigator.pop(ctx);
    //       },
    //     ),
    //   ],
    // );
  }
}
