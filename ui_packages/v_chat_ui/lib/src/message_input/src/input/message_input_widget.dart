import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_ui/src/core/extension.dart';
import 'package:v_chat_ui/src/message_input/src/input/widgets/emoji_keyborad.dart';
import 'package:v_chat_ui/src/message_input/src/input/widgets/message_record_btn.dart';
import 'package:v_chat_ui/src/message_input/src/input/widgets/message_send_btn.dart';
import 'package:v_chat_ui/src/message_input/src/input/widgets/message_text_filed.dart';

import '../../../core/platfrom_widgets/platform_cache_image_widget.dart';
import '../../../core/utils/app_pick.dart';
import '../media_picker/media_picker_widget.dart';
import '../recorder/record_widget.dart';

class VMessageInputWidget extends StatefulWidget {
  final Function(String message) onSubmitText;
  final Function(String text) onMentionRequireSearch;
  final Function(List<PlatformFileSource> files) onSubmitMedia;
  final Function(List<PlatformFileSource> files) onSubmitFiles;
  final Function(VLocationMessageData data) onSubmitLocation;
  final Function(VMessageVoiceData data) onSubmitVoice;
  final Function(RoomTypingEnum typing) onTypingChange;
  final Widget? replyWidget;
  final Widget? stopChatWidget;

  const VMessageInputWidget({
    super.key,
    required this.onSubmitText,
    required this.onMentionRequireSearch,
    required this.onSubmitMedia,
    required this.onSubmitVoice,
    required this.onSubmitFiles,
    required this.onSubmitLocation,
    required this.onTypingChange,
    this.replyWidget,
    this.stopChatWidget,
  });

  @override
  State<VMessageInputWidget> createState() => _VMessageInputWidgetState();
}

class _VMessageInputWidgetState extends State<VMessageInputWidget> {
  bool _isEmojiShowing = false;
  String _text = "";
  RoomTypingEnum _typingType = RoomTypingEnum.stop;
  int _textOffset = 0;
  final _textEditingController = AnnotationEditingController();
  final _focusNode = FocusNode();
  List<Map<String, dynamic>> _usersMap = [];

  bool get _isRecording => _typingType == RoomTypingEnum.recording;

  bool get _isTyping => _typingType == RoomTypingEnum.typing;

  bool get _isSendBottomEnable => _isTyping || _isRecording;
  final recordStateKey = GlobalKey<RecordWidgetState>();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_textEditListener);
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
      return widget.stopChatWidget!;
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color:
                        //todo fix
                        context.isDark ? const Color(0xf7232121) : Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (widget.replyWidget != null)
                        widget.replyWidget!
                      else
                        const SizedBox.shrink(),
                      if (_isRecording)
                        RecordWidget(
                          key: recordStateKey,
                          onCancel: () {
                            _changeTypingType(RoomTypingEnum.stop);
                          },
                        )
                      else
                        MessageTextFiled(
                          suggestionBuilder: (data) {
                            return SafeArea(
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 1,
                                ),
                                leading: PlatformCacheImageWidget(
                                  source: PlatformFileSource.fromUrl(
                                    url: data['image'].toString(),
                                  ),
                                  size: const Size(25, 25),
                                  fit: BoxFit.contain,
                                ),
                                title: data['display']
                                    .toString()
                                    .text
                                    .color(Colors.black),
                              ),
                            );
                          },
                          searchData: _usersMap,
                          onSearchChanged: (String trigger, String value) {
                            if (value == _text) {
                              return;
                            }
                            widget.onMentionRequireSearch(value);
                          },
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
                          onShowEmoji: showEmoji,
                          onAttachFilePress: () => _onAttachFilePress(context),
                          onCameraPress: () => _onCameraPress(context),
                        )
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
                        await recordStateKey.currentState!.stopRecord(),
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
                  onRecordClick: () {
                    _changeTypingType(RoomTypingEnum.recording);
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
    );
  }

  Future showEmoji() async {
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

  @override
  void dispose() {
    if (_typingType != RoomTypingEnum.stop) {
      widget.onTypingChange(RoomTypingEnum.stop);
    }
    _focusNode.dispose();
    if (_isRecording) {
      //todo stop recorder
    }
    _textEditingController.dispose();
    super.dispose();
  }

  void _onAttachFilePress(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      elevation: 0,
      enableDrag: true,
      isDismissible: true,
      builder: (context) {
        return MediaPickerWidget(
          onSubmitFiles: widget.onSubmitFiles,
          onSubmitLocation: widget.onSubmitLocation,
          onSubmitMedia: widget.onSubmitMedia,
        );
      },
    );
  }

  void _onCameraPress(BuildContext context) async {
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
}
