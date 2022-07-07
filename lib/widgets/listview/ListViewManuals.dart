import 'dart:core';
import 'package:flutter/material.dart';
import 'package:manual_linux/widgets/detail/CommandDetail.dart';

class ListViewManuals extends StatelessWidget {

  final List items; 
  final String nro;

   ListViewManuals({
    required this.items, 
    required this.nro,
  });

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: items.length < int.parse(this.nro) ? items.length : int.parse(this.nro),
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap :() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  CommandDetail(item: item)),
              );
            },
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                ListTile(
                  leading: ImageIcon(
                    AssetImage("assets/img/tux.png"),
                    size: 30,
                    ),
                  title: Text(item["NOMBRE"].split(" - ")[0].trim()),
                  subtitle: Text( (item["NOMBRE"].split(" - ").length > 1) ?  item["NOMBRE"].split(" - ")[1].trim() : ""),
                  )],
                ),
              )
            );
        },  
        );
  }
}