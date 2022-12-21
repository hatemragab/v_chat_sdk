import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:place_picker/entities/localization_item.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:v_chat_input_ui/src/input/widgets/emoji_keyborad.dart';
import 'package:v_chat_input_ui/src/input/widgets/message_record_btn.dart';
import 'package:v_chat_input_ui/src/input/widgets/message_send_btn.dart';
import 'package:v_chat_input_ui/src/input/widgets/message_text_filed.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_chat_mention_controller/v_chat_mention_controller.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../v_chat_input_ui.dart';
import '../permission_manager.dart';
import '../recorder/record_widget.dart';

///this widget used to render the footer of messages page
class VMessageInputWidget extends StatefulWidget {
  ///callback when user send text
  final Function(String message) onSubmitText;

  ///callback when user send images or videos or mixed
  final Function(List<VBaseMediaRes> files) onSubmitMedia;

  ///callback when user send files
  final Function(List<VPlatformFileSource> files) onSubmitFiles;

  ///callback when user send location will call only if [googleMapsApiKey] has value
  final Function(VLocationMessageData data) onSubmitLocation;

  ///callback when user submit voice
  final Function(VMessageVoiceData data) onSubmitVoice;

  ///callback when user start typing or recording or stop
  final Function(VRoomTypingEnum typing) onTypingChange;

  ///callback when user clicked send attachment
  final Future<VAttachEnumRes?> Function()? onAttachIconPress;

  ///callback if you want to implement custom mention item builder
  final Widget Function(MentionWithPhoto)? mentionItemBuilder;

  ///callback when user start add '@' or '@...' if text is empty that means the user just start type '@'
  final Future<List<MentionWithPhoto>> Function(String)? onMentionSearch;

  /// widget to render if user select to reply
  final Widget? replyWidget;

  /// widget to render if the chat has been closed my be this user leave group or has banned!
  final Widget? stopChatWidget;

  /// set max timeout for recording
  final Duration maxRecordTime;

  ///if not provided the the user cant see the option of send location
  final String? googleMapsApiKey;

  ///text-field hint
  final VInputLanguage language;

  ///google maps localizations
  final String googleMapsLangKey;

  const VMessageInputWidget({
    super.key,
    required this.onSubmitText,
    required this.onSubmitMedia,
    required this.onSubmitVoice,
    required this.onSubmitFiles,
    required this.onSubmitLocation,
    required this.onTypingChange,
    this.replyWidget,
    this.mentionItemBuilder,
    this.maxRecordTime = const Duration(minutes: 30),
    this.onAttachIconPress,
    this.stopChatWidget,
    this.onMentionSearch,
    this.googleMapsApiKey,
    this.language = const VInputLanguage(),
    this.googleMapsLangKey = "en",
  });

  @override
  State<VMessageInputWidget> createState() => _VMessageInputWidgetState();
}

class _VMessageInputWidgetState extends State<VMessageInputWidget> {
  bool _isEmojiShowing = false;
  String _text = "";
  VRoomTypingEnum _typingType = VRoomTypingEnum.stop;
  final _textEditingController = VChatTextMentionController();
  final _focusNode = FocusNode();
  final _vMediaEditorHelpers = VMediaEditorHelpers();

  bool get _isRecording => _typingType == VRoomTypingEnum.recording;

  bool get _isTyping => _typingType == VRoomTypingEnum.typing;

  bool get _isSendBottomEnable => _isTyping || _isRecording;
  final _recordStateKey = GlobalKey<RecordWidgetState>();
  bool _showMentionList = false;
  final _mentionsWithPhoto = <MentionWithPhoto>[];

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_textEditListener);
    _textEditingController.onSearch = (String? value) async {
      _mentionsWithPhoto.clear();
      if (value == null && _showMentionList) {
        setState(() {
          _showMentionList = false;
        });
        return;
      }
      if (widget.onMentionSearch != null && value != null) {
        final res = await widget.onMentionSearch!(value);
        if (res.isNotEmpty) {
          _mentionsWithPhoto.addAll(res);
          _showMentionList = true;
        } else {
          _showMentionList = false;
        }
        setState(() {});
      }
    };
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isEmojiShowing = false;
        });
      }
    });
    if (!VPlatforms.isMobile) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stopChatWidget != null) {
      _typingType = VRoomTypingEnum.stop;
      _isEmojiShowing = false;
      _textEditingController.clear();
      _text = "";
      return widget.stopChatWidget!;
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 6,
                      right: 6,
                      top: 8,
                      bottom: 8,
                    ),
                    decoration: context.vInputTheme.containerDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_showMentionList)
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                if (widget.mentionItemBuilder != null) {
                                  return InkWell(
                                    onTap: () {
                                      _textEditingController.addMention(
                                          _mentionsWithPhoto[index]);
                                    },
                                    child: widget.mentionItemBuilder!(
                                      _mentionsWithPhoto[index],
                                    ),
                                  );
                                }
                                return ListTile(
                                  leading: VCircleAvatar(
                                    fullUrl: _mentionsWithPhoto[index].photo,
                                    radius: 20,
                                  ),
                                  dense: false,
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () {
                                    _textEditingController
                                        .addMention(_mentionsWithPhoto[index]);
                                  },
                                  title:
                                      Text(_mentionsWithPhoto[index].display),
                                );
                              },
                              itemCount: _mentionsWithPhoto.length,
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        if (widget.replyWidget != null)
                          widget.replyWidget!
                        else
                          const SizedBox.shrink(),
                        if (_isRecording)
                          RecordWidget(
                            key: _recordStateKey,
                            maxTime: widget.maxRecordTime,
                            onCancel: () {
                              _changeTypingType(VRoomTypingEnum.stop);
                            },
                          )
                        else
                          MessageTextFiled(
                            focusNode: _focusNode,
                            hint: widget.language.textFieldHint,
                            isTyping: _typingType == VRoomTypingEnum.typing,
                            onSubmit: (v) {
                              if (v.isNotEmpty) {
                                widget.onSubmitText(
                                    _textEditingController.markupText);
                                _text = "";
                                _textEditingController.clear();
                                _changeTypingType(VRoomTypingEnum.stop);
                              }
                            },
                            textEditingController: _textEditingController,
                            onShowEmoji: _showEmoji,
                            onAttachFilePress: () =>
                                _onAttachFilePress(context, widget.language),
                            onCameraPress: () => _onCameraPress(context),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                if (_isSendBottomEnable)
                  MessageSendBtn(
                    onSend: () async {
                      if (_isRecording) {
                        widget.onSubmitVoice(
                          await _recordStateKey.currentState!.stopRecord(),
                        );
                        _changeTypingType(VRoomTypingEnum.stop);
                      } else if (_text.isNotEmpty) {
                        widget.onSubmitText(_textEditingController.markupText);
                        _text = "";
                        _textEditingController.clear();
                      }
                    },
                  )
                else
                  MessageRecordBtn(
                    onRecordClick: () async {
                      final isAllowRecord =
                          await PermissionManager.isAllowRecord();
                      if (isAllowRecord) {
                        _changeTypingType(VRoomTypingEnum.recording);
                      } else {
                        final isAllowRecord =
                            await PermissionManager.askForRecord();
                        if (isAllowRecord) {
                          _changeTypingType(VRoomTypingEnum.recording);
                        }
                      }
                    },
                  )
              ],
            ),
          ),
          if (VPlatforms.isMac)
            const SizedBox.shrink()
          else
            EmojiKeyboard(
              controller: _textEditingController,
              isEmojiShowing: _isEmojiShowing,
            ),
        ],
      ),
    );
  }

  Future<void> _showEmoji() async {
    _focusNode.unfocus();
    _focusNode.canRequestFocus = true;
    await Future.delayed(const Duration(milliseconds: 50));
    _isEmojiShowing = !_isEmojiShowing;
    setState(() {});
  }

  void _onAttachFilePress(BuildContext context, VInputLanguage language) async {
    late VAttachEnumRes? res;
    if (widget.onAttachIconPress != null) {
      res = await widget.onAttachIconPress!();
    } else {
      final x = await VAppAlert.showModalSheet(content: [
        ModelSheetItem<VAttachEnumRes>(
          title: language.media,
          id: VAttachEnumRes.media,
          iconData: Icons.image,
        ),
        ModelSheetItem<VAttachEnumRes>(
            title: language.files,
            id: VAttachEnumRes.files,
            iconData: Icons.attach_file),
        if (widget.googleMapsApiKey != null)
          ModelSheetItem<VAttachEnumRes>(
            title: language.location,
            iconData: Icons.location_on_outlined,
            id: VAttachEnumRes.location,
          ),
      ], context: context, title: language.shareMediaAndLocation);
      if (x == null) return null;
      res = x.id as VAttachEnumRes;
    }
    if (res != null) {
      switch (res) {
        case VAttachEnumRes.media:
          final files = await VAppPick.getMedia();
          if (files != null) {
            final resFiles = await _processFilesToSubmit(files);
            widget.onSubmitMedia(resFiles);
          }
          break;
        case VAttachEnumRes.files:
          final files = await VAppPick.getFiles();
          if (files != null) {
            widget.onSubmitFiles(files);
          }
          break;
        case VAttachEnumRes.location:
          if (widget.googleMapsApiKey == null) return;
          final LocationResult? result = await context.toPage<LocationResult?>(
            PlacePicker(
              widget.googleMapsApiKey!,
              localizationItem:
                  LocalizationItem(languageCode: widget.googleMapsLangKey),
            ),
          );
          if (result != null &&
              result.latLng != null &&
              result.latLng != null) {
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
            widget.onSubmitLocation(location);
          }
          break;
      }
    }
  }

  void _onCameraPress(BuildContext context) async {
    final isCameraAllowed = await PermissionManager.isCameraAllowed();
    if (!isCameraAllowed) {
      final x = await PermissionManager.askForCamera();
      if (!x) return;
    }
    final entity = await VAppPick.pickFromWeAssetCamera(
      (p0, p1) {
        _sendWeChatImage(VPlatformFileSource.fromPath(
          filePath: p0.path,
        ));
        return true;
      },
      context,
    );
    if (entity == null) return;
    widget.onSubmitMedia(await _processFilesToSubmit([entity]));
  }

  Future<void> _sendWeChatImage(VPlatformFileSource entity) async {
    widget.onSubmitMedia(await _processFilesToSubmit([entity]));
  }

  void _textEditListener() {
    _text = _textEditingController.text;
    if (_text.isNotEmpty && _typingType != VRoomTypingEnum.typing) {
      _changeTypingType(VRoomTypingEnum.typing);
    } else if (_text.isEmpty && _typingType != VRoomTypingEnum.stop) {
      _changeTypingType(VRoomTypingEnum.stop);
    }
  }

  void _changeTypingType(VRoomTypingEnum typingType) {
    if (typingType != _typingType) {
      setState(() {
        _typingType = typingType;
      });
      widget.onTypingChange(typingType);
    }
  }

  @override
  void dispose() {
    if (_typingType != VRoomTypingEnum.stop) {
      widget.onTypingChange(VRoomTypingEnum.stop);
    }
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  Future<List<VBaseMediaRes>> _processFilesToSubmit(
    List<VPlatformFileSource> files,
  ) async {
    final resFiles = <VBaseMediaRes>[];
    for (final sourceFile in files) {
      if (sourceFile.isImage) {
        final compressedImage =
            await _vMediaEditorHelpers.compressIoImage(fileSource: sourceFile);
        final imageData = await _vMediaEditorHelpers.getImageInfo(
            fileSource: compressedImage);
        resFiles.add(
          VMediaImageRes(
            data: VMessageImageData(
              fileSource: compressedImage,
              height: imageData.image.height,
              width: imageData.image.width,
            ),
          ),
        );
      } else if (sourceFile.isVideo) {
        final videoDuration =
            await _vMediaEditorHelpers.getVideoDurationMill(sourceFile);
        final thumbData =
            await _vMediaEditorHelpers.getVideoThumb(fileSource: sourceFile);
        resFiles.add(
          VMediaVideoRes(
            data: VMessageVideoData(
              fileSource: sourceFile,
              duration: videoDuration,
              thumbImage: thumbData,
            ),
          ),
        );
      }
    }
    return resFiles;
  }
}
