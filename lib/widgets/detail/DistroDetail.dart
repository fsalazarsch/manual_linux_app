import 'dart:convert';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DistroDetail extends StatelessWidget {

  final item;
  final base;
  

  DistroDetail({Key? key, required this.item, required this.base}) : super(key: key);

  Future<void> get_distro( BuildContext context, String nombre) async {
  
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    String filePath = '';
    filePath = '$path/distros.json';
    final File file = File(filePath);

    final String response = await file.readAsString();
    final data = await json.decode(response);
    List data_items = data;

    for(final item in data_items){
      if (item["Nombre"] == nombre){

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  DistroDetail(item: item, base: this.base)),
          );
      }
    }
  }

  String formato_fecha(String fecha){
    List<String> aux = fecha.split(".");
    List<String> meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
    String ret;

    ret = meses[int.parse(aux[1])-1]+" de "+aux[0];
    if (aux.length == 3)
      ret = aux[2]+" de "+ret;

    return ret;
  }


  @override
  Widget build(BuildContext context){
    //print(this.base);
    Image canvas;

    if (item["Img"] == null)
      canvas = Image.asset("assets/img/linux.png");
    else{
      Uint8List _bytesImage;
      _bytesImage = Base64Decoder().convert(item["Img"]);
      canvas  = Image.memory(_bytesImage);
      //canvas = Image.file( new File(this.base+"/"+item["Img"]), height: 400, width: 400);
    }
    
    return Scaffold(
      appBar: AppBar(
        title:  Text(item["Nombre"]),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
          canvas,
          Card(
            child: Column(
              children: <Widget>[
              ListTile(
                title: Text("Comienzo"),
                subtitle: Text( formato_fecha(item["Comienzo"])),
              ),
              ListTile(
                title: Text("Termino"),
                subtitle: Text( (item["Termino"].isEmpty) ? "--" : formato_fecha(item["Termino"])),
              ),
              ListTile(
                title: Text("Descripcion"),
                subtitle: Text(item["Descripcion"]),
              ),
              ListTile(
                title: Text("Distribucion padre"),
                subtitle: Text( (item["Padre"].isEmpty) ? "--" : item["Padre"]),

                onTap :() { get_distro(context, item["Padre"]);},
                ),
              ],
              ),
            ),
          ],
          ),
        ),
      );
  }
}