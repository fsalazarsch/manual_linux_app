import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class CommandDetail extends StatelessWidget {

  final item;
  CommandDetail({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(item["NOMBRE"].split(" - ")[0].toUpperCase()),
        ),
      body: ListView.builder(
      itemCount: item.length,
      padding: const EdgeInsets.all(8),

      itemBuilder: (BuildContext context, int index) {
        String key = item.keys.elementAt(index);

        return ListTile(
          title: Text("$key"),
          subtitle: Text(item["$key"]),
          );
      } 
      )
      );
  } 
}