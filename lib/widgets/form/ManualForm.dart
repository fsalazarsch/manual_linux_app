import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:manual_linux/widgets/listview/ListViewManuals.dart';

class ManualForm extends StatefulWidget {
  const ManualForm({Key? key}) : super(key: key);

  @override
  ManualFormState createState() {
    return ManualFormState();
  }
}

class ManualFormState extends State<ManualForm> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'Manual 1';
  final  _nombreController = TextEditingController();
  final  _descrController = TextEditingController();
  final  _nroController = TextEditingController(text: '10');

  bool pressed = false;
  List _items = [];

  int count = 1;
  Future<void> readManuals(String nombre, String descripcion, String manual) async {
    _items = [];

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    String filePath = '';
    filePath = '$path/man'+manual+'.json';
    final File file = File(filePath);

    final String response = await file.readAsString();
    final data = await json.decode(response);
      setState(() {
        List data_items = data;
        for(final item in data_items){
          if ((descripcion == true) || (descripcion.isEmpty)) {
            if (item["NOMBRE"].toLowerCase().contains(nombre.toLowerCase()))     
              _items.add(item);
          }
          else{
            if ((nombre == true) || (nombre.isEmpty)){
              if (item["NOMBRE"].toLowerCase().contains(descripcion.toLowerCase()))
                _items.add(item);
            }
            else
              if ( (item?["NOMBRE"].toLowerCase().contains(descripcion.toLowerCase())) || (item["NOMBRE"].toLowerCase().contains(nombre.toLowerCase())) ) {
              _items.add(item);
            }
          }
        }
        });
    }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children:[
        Card(
        margin: EdgeInsets.all(12),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children:[ 
                Icon(Icons.extension),
                SizedBox(width: 20),
                DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.blueAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['Manual 1', 'Manual 1x', 'Manual 2', 'Manual 3', 'Manual 4', 'Manual 5', 'Manual 6', 'Manual 7', 'Manual 8']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                      );
                    }).toList(),
                  ),
                ]),
              TextFormField(
                controller : _nombreController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.menu_book),
                    hintText: '',
                    labelText: 'Nombre',
                    ),
                validator: (value) {
                  if ( ( _descrController.text ==null || _descrController.text.isEmpty) && (value == null || value.isEmpty)) {
                    return 'Debe ingresar algo';
                  }
                  return null;
                  },
              ),
              TextFormField(
                  controller : _descrController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.library_books),
                    hintText: '',
                    labelText: 'Descripcion',
                    ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (( _nombreController.text ==null || _nombreController.text.isEmpty) && (value == null || value.isEmpty)) {
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
                  String descripcion =_descrController.text;
                  String nombre = _nombreController.text;
                  /*ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text('Processing Data:'+descripcion+', '+nombre+';'+dropdownValue.replaceAll("Manual ","man"))
                      ),
                      );*/

                  setState(() {
                    pressed = true;
                    readManuals(_nombreController.text, _descrController.text, dropdownValue.replaceAll("Manual ",""));
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
                child: ListViewManuals(items: _items, nro: _nroController.text),
                ),
              )]
            ),
            );
            }
}