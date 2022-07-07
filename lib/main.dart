import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:manual_linux/widgets/form/DistroForm.dart';
import 'package:manual_linux/widgets/form/ManualForm.dart';
import 'package:manual_linux/widgets/functions/files.dart';

//resolucion distro grande 300X300
//resolucion distro logo 40X40


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(TabBarDemo());
    });
}

class TabBarDemo extends StatelessWidget {
  TabBarDemo({Key? key}) : super(key: key);

  final String root = "";

  void get_data(BuildContext context, bool flag){


    const snackBar = SnackBar(
      content: Text('Datos importados'),
      );
    downloadFile("https://raw.githubusercontent.com/fsalazarsch/linux_commands/master", "distros.json", flag);    
    List<String> list = ['1', '1x', '2', '3', '4', '5', '6', '7', '8'];
    list.forEach((element) => downloadFile("https://raw.githubusercontent.com/fsalazarsch/linux_commands/master", "man"+element+".json", flag));
    if (flag == true)
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }


  @override
  Widget build(BuildContext context) {
    get_data(context, false);
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
            PopupMenuButton<String>(
              itemBuilder: (context) => [
              PopupMenuItem(
                value: "Actualizar datos",
                child: Text("Actualizar datos"),
                onTap: () => get_data(context, true),
                )],
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Manual",
                  icon: Icon(Icons.book)),
                Tab(
                  text: "Distros",
                  icon: ImageIcon(
                    AssetImage("assets/img/tux.png"),
                    color: Colors.white,
                    size: 30,
                    ),
                  ),
              ],
            ),
            title: const Text('Manual linux'),
          ),
          body: const TabBarView(
            children: [
              ManualForm(),
              DistroForm(),

            ],

          ),

        ),
      ),
    );
  }

}