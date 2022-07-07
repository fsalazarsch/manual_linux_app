import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:manual_linux/widgets/listview/ListViewDistros.dart';
import 'package:manual_linux/widgets/functions/files.dart';



class DistroForm extends StatefulWidget {
  const DistroForm({Key? key}) : super(key: key);



  @override
  DistroFormState createState() {
    return DistroFormState();
  }
}

class DistroFormState extends State<DistroForm> {
  
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'Manual 1';
  final  _nombreController = TextEditingController();
  final  _nroController = TextEditingController(text: '10');
  late Future<String> _bar;
  String url ="";

  bool pressed = false;

    List _items = [];

    Future<void> readDistros(String nombre) async {
    _items = [];

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    String filePath = '';
    filePath = '$path/distros.json';
    final File file = File(filePath);

    final String response = await file.readAsString();
    final data = await json.decode(response);
      setState(() {
      List data_items = data;
      for(final item in data_items){
          if (item["Nombre"].toLowerCase().contains(nombre.toLowerCase())){
            _items.add(item);
          }
        }
    });
  }


  @override
  void initState() {
    super.initState();
    _bar = get_root_path();
  }

  @override
  Widget build(BuildContext context) {

    
    //get_root_path().then((data) {
    
    //url = data;
    //}); 
    //debugPrint("desde distroform:" +url);
    return Form(
      key: _formKey,
      child: Column(
        children:[

        
        FutureBuilder<String>(
          future: _bar,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              url = snapshot.data.toString();
              return Visibility(child: Text("${snapshot.data}"),visible: false,);
              
            } else {
              return Text('Error');
            }
          },
        ),


        Card(
        margin: EdgeInsets.all(12),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller : _nombreController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.edit),
                    hintText: '',
                    labelText: 'Nombre',
                    ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                    return 'Debe ingresar algo';
                  }
                  return null;
                  },
                  ),
              TextFormField(
                controller : _nroController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: const InputDecoration(
                  icon: Icon(Icons.list),
                  hintText: '',
                  labelText: 'Numero de resultados',
                  ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Debe ingresar algo';
                  }
                  return null;
                  },
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      String nombre = _nombreController.text;
                      /*ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Buscando...')
                          ),
                        );*/

                      setState(() {
                        pressed = true;
                        readDistros(_nombreController.text);
                        });
                    }
                    },
                    child: const Text('Buscar'),
                    ),
                ),
              ],
              ),
          ),
        ),
        Visibility(
          visible: pressed,
          child:
          Expanded( 
            child: ListViewDistros(items: _items, nro: _nroController.text, path: url),
            ),
          )
        ]
        ),
      );
  }

  Future<String> get_root_path() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;

    }
}