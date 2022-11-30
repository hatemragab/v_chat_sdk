import 'package:core_example/app/modules/http/controllers/http_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

import '../../http_model.dart';

class HttpItem extends StatelessWidget {
  final HttpModel httpModel;
  final HttpController controller;

  const HttpItem({
    Key? key,
    required this.httpModel,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          httpModel.method.name.toUpperCase().text.black,
          const SizedBox(
            width: 10,
          ),
          httpModel.endpoint.text.bold.color(Colors.green)
        ],
      ),
      trailing: Icon(
        httpModel.isExpanded
            ? Icons.keyboard_arrow_up_outlined
            : Icons.keyboard_arrow_down_outlined,
      ),
      children: <Widget>[
        ListTile(
          title: "Body".text,
          subtitle: CupertinoTextField(),
        ),
        ListTile(
          title: "Query".text,
          subtitle: CupertinoTextField(),
        ),
      ],
      onExpansionChanged: (bool expanded) {
        httpModel.isExpanded = expanded;
        controller.onExpansionChanged(httpModel);
      },
    );
  }
}
