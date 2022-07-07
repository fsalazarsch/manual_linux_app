import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:manual_linux/widgets/functions/files.dart';
import 'package:manual_linux/widgets/detail/DistroDetail.dart';
import 'dart:convert';
import 'dart:typed_data';

class ListViewDistros extends StatelessWidget {

  final List items; 
  final String nro;
  final String path;

  ListViewDistros({
    required this.items, 
    required this.nro,
    required this.path
  });
    



  @override
  Widget build(BuildContext context) { 
    debugPrint("url desde listviewdistros: "+this.path);
    return ListView.builder(

      itemCount: items.length < int.parse(this.nro) ? items.length : int.parse(this.nro),
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final item = items[index];

    Image canvas_logo;

    if (item["logo"] == null)
      canvas_logo = Image.asset("assets/img/tux.png");
    else{
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(item["logo"]);
      canvas_logo  = Image.memory(_bytesImage);
    }
      //canvas_logo = Image.file( new File(this.path+"/"+item["Nombre"]+".png"), height: 30, width: 30);
      //canvas_logo = Image.file( new File(this.path+"/"+item["logo"]), height: 30, width: 30);

   

        return GestureDetector(
          onTap :() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  DistroDetail(item: item, base: this.path)),
              );
            },
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                ListTile(
                  leading:  canvas_logo,
                 //   AssetImage( item["logo"] == null  ? "assets/img/tux.png" : item["logo"] ),
                 //   size: 30,
                 // ),
                  title: Text(item["Nombre"]),
                  subtitle: Text(item["Comienzo"]),
                  )],
                ),
              )
            );
        },
        );
  }
}