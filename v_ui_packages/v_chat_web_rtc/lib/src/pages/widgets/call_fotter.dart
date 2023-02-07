import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class CallFotter extends StatelessWidget {
  final VoidCallback onClose;

  const CallFotter({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return    Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xff4f3434),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            PhosphorIcons.speakerHighFill,
            color: Colors.grey,
            size: 35,
          ),
          Icon(
            PhosphorIcons.videoCameraFill,
            color: Colors.grey,
            size: 35,
          ),
          Icon(
            PhosphorIcons.microphoneFill,
            color: Colors.grey,
            size: 35,
          ),
          InkWell(
            onTap: onClose,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}
