import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:place_picker/entities/localization_item.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:v_chat_input_ui/src/input/widgets/emoji_keyborad.dart';
import 'package:v_chat_input_ui/src/input/widgets/message_record_btn.dart';
import 'package:v_chat_input_ui/src/input/widgets/message_send_btn.dart';
import 'package:v_chat_input_ui/src/input/widgets/message_text_filed.dart';
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
  final Function(List<PlatformFileSource> files) onSubmitMedia;

  ///callback when user send files
  final Function(List<PlatformFileSource> files) onSubmitFiles;

  ///callback when user send location will call only if [googleMapsApiKey] has value
  final Function(VLocationMessageData data) onSubmitLocation;

  ///callback when user submit voice
  final Function(VMessageVoiceData data) onSubmitVoice;

  ///callback when user start typing or recording or stop
  final Function(RoomTypingEnum typing) onTypingChange;

  ///callback when user clicked send attachment
  final Future<AttachEnumRes?> Function()? onAttachIconPress;

  ///callback when user start add '@' or '@...' if text is empty that means the user just start type '@'
  final Future<List<MentionWithPhoto>> Function(String)? onMentionSearch;

  /// widget to render if user select to reply
  final Widget? replyWidget;

  /// widget to render if the chat has been closed my be this user leave group or has banned!
  final Widget? stopChatWidget;

  ///if not provided the the user cant see the option of send location
  final String? googleMapsApiKey;

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
    this.onAttachIconPress,
    this.stopChatWidget,
    this.onMentionSearch,
    this.googleMapsApiKey,
    this.googleMapsLangKey = "en",
  });

  @override
  State<VMessageInputWidget> createState() => _VMessageInputWidgetState();
}

class _VMessageInputWidgetState extends State<VMessageInputWidget> {
  bool _isEmojiShowing = false;
  String _text = "";
  RoomTypingEnum _typingType = RoomTypingEnum.stop;
  int _textOffset = 0;
  final _textEditingController = VChatTextMentionController();
  final _focusNode = FocusNode();

  bool get _isRecording => _typingType == RoomTypingEnum.recording;

  bool get _isTyping => _typingType == RoomTypingEnum.typing;

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
    if (!Platforms.isMobile) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stopChatWidget != null) {
      _typingType = RoomTypingEnum.stop;
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
                    decoration: BoxDecoration(
                      color:
                          //todo fix
                          context.isDark
                              ? const Color(0xf7232121)
                              : Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        if (_showMentionList)
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemBuilder: (context, index) => ListTile(
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
                                title: Text(_mentionsWithPhoto[index].display),
                              ),
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
                            onCancel: () {
                              _changeTypingType(RoomTypingEnum.stop);
                            },
                          )
                        else
                          MessageTextFiled(
                            focusNode: _focusNode,
                            isTyping: _typingType == RoomTypingEnum.typing,
                            onSubmit: (v) {
                              if (v.isNotEmpty) {
                                widget.onSubmitText(v);
                                _text = "";
                                _textEditingController.clear();
                                _changeTypingType(RoomTypingEnum.stop);
                              }
                            },
                            textEditingController: _textEditingController,
                            onShowEmoji: _showEmoji,
                            onAttachFilePress: () =>
                                _onAttachFilePress(context),
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
                        _changeTypingType(RoomTypingEnum.stop);
                      } else if (_text.isNotEmpty) {
                        widget.onSubmitText(_text);
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
                        _changeTypingType(RoomTypingEnum.recording);
                      } else {
                        final isAllowRecord =
                            await PermissionManager.askForRecord();
                        if (isAllowRecord) {
                          _changeTypingType(RoomTypingEnum.recording);
                        }
                      }
                    },
                  )
              ],
            ),
          ),
          if (Platforms.isMac)
            const SizedBox.shrink()
          else
            EmojiKeyboard(
              onBackspacePressed: () {
                _textOffset = _textOffset - 2;
                _textEditingController
                  ..text = _textEditingController.text.characters
                      .skipLast(1)
                      .toString()
                  ..selection = TextSelection.fromPosition(
                    TextPosition(
                      offset: _textOffset,
                    ),
                  );
              },
              onEmojiSelected: (e) {
                final String suffixText = _text.substring(_textOffset);
                final String prefixText = _text.substring(0, _textOffset);
                _textEditingController.text = prefixText + e.emoji + suffixText;
                _textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: _textOffset,
                  ),
                );
                _textOffset = _textOffset + 2;
              },
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
    if (_isEmojiShowing) {
      final of = _textEditingController.selection.base.offset;
      if (of != -1) {
        _textOffset = of;
      }
    }
    setState(() {});
  }

  void _onAttachFilePress(BuildContext context) async {
    late AttachEnumRes? res;
    if (widget.onAttachIconPress != null) {
      res = await widget.onAttachIconPress!();
    } else {
      final x = await VAppAlert.showModalSheet(content: [
        ModelSheetItem<AttachEnumRes>(
          title: 'Media',
          id: AttachEnumRes.media,
          iconData: Icons.image,
        ),
        ModelSheetItem<AttachEnumRes>(
            title: 'Files',
            id: AttachEnumRes.files,
            iconData: Icons.attach_file),
        if (widget.googleMapsApiKey != null)
          ModelSheetItem<AttachEnumRes>(
            title: 'Location',
            iconData: Icons.location_on_outlined,
            id: AttachEnumRes.location,
          ),
      ], context: context, title: "Share media and location");
      if (x == null) return null;
      res = x.id as AttachEnumRes;
    }
    if (res != null) {
      switch (res) {
        case AttachEnumRes.media:
          final files = await AppPick.getMedia();
          if (files != null) {
            widget.onSubmitMedia(files);
          }
          break;
        case AttachEnumRes.files:
          final files = await AppPick.getFiles();
          if (files != null) {
            widget.onSubmitFiles(files);
          }
          break;
        case AttachEnumRes.location:
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
    final entity = await AppPick.pickFromWeAssetCamera(
      (p0, p1) {
        widget.onSubmitMedia([
          PlatformFileSource.fromPath(
            filePath: p0.path,
          )
        ]);
        return true;
      },
      context,
    );
    if (entity == null) return;
    widget.onSubmitMedia([entity]);
  }

  void _textEditListener() {
    _text = _textEditingController.text;
    if (_text.isNotEmpty && _typingType != RoomTypingEnum.typing) {
      _changeTypingType(RoomTypingEnum.typing);
    } else if (_text.isEmpty && _typingType != RoomTypingEnum.stop) {
      _changeTypingType(RoomTypingEnum.stop);
    }
  }

  void _changeTypingType(RoomTypingEnum typingType) {
    if (typingType != _typingType) {
      setState(() {
        _typingType = typingType;
      });
      widget.onTypingChange(typingType);
    }
  }

  @override
  void dispose() {
    if (_typingType != RoomTypingEnum.stop) {
      widget.onTypingChange(RoomTypingEnum.stop);
    }
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}
