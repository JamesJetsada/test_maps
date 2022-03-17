import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Layer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Layer")),
        body: ListView.separated(
          itemBuilder: (context, int i) {
            return ListTile(
                title: Text(_title(i).toString()),
                onTap: () {
                  // Navigator.pop(context, _value(i));
                });
          },
          separatorBuilder: (_, __) => Divider(),
          itemCount: 2,
        ));
  }

  String? _title(i) {
    switch (i) {
      case 0:
        return "Thaichote";
      case 1:
        return "Traffic";
      default:
        return null;
    }
  }

  // String? _value(i) {
  //   switch (i) {
  //     case 0:
  //       return Layers.LAYER_THAICHOTE;
  //     case 1:
  //       return Layers.LAYER_TRAFFIC;
  //     default:
  //       return null;
  //   }
  // }
}
