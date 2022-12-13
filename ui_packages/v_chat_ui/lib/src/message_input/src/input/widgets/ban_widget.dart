import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

class BanWidget extends StatelessWidget {
  final bool isMy;
  final VoidCallback onUnBan;

  const BanWidget({super.key, required this.isMy, required this.onUnBan});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //todo trans
            "thisPersonNotAvailable".text.color(Colors.white).black,
          ],
        ),
      ),
    );
  }
}
