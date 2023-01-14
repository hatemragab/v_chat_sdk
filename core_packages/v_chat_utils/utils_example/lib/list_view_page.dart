import 'package:flutter/material.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListViewPageState();
  }
}

class ListViewPageState extends State<ListViewPage> {
  final l = List.generate(20, (index) => "$index");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          l.insert(0, "element ${DateTime.now()}");
          setState(() {});
        },
      ),
      appBar: AppBar(),
      body: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          title: Text(l[index].toString()),
        ),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: l.length,
        reverse: true,
      ),
    );
  }
}
