import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }


  Future<String> get_root_path() async {
        final path = await _localPath;
        return path;
            }

  Future<String> downloadFile(String url, String fileName, bool flag) async {
        final path = await _localPath;

        HttpClient httpClient = new HttpClient();
        File file;
        String filePath = '';
        String myUrl = '';
    	
        //flag false para no sobreescribir, true para si

        try {

          if ((File('$path/$fileName').existsSync()) && (flag == false)){
          	debugPrint("El archivo $path/$fileName ya existe");
          }
          else{
          	myUrl = url+'/'+fileName;
          
          	var request = await httpClient.getUrl(Uri.parse(myUrl));
          	var response = await request.close();
          	if(response.statusCode == 200) {
	            var bytes = await consolidateHttpClientResponseBytes(response);
    	        filePath = '$path/$fileName';
        	    file = File(filePath);
            	await file.writeAsBytes(bytes);
            	//debugPrint(filePath);

				}
				else
		            filePath = 'Error code: '+response.statusCode.toString();
          }
        }
        catch(ex){
          //debugPrint(ex.toString());
          filePath = 'Can not fetch url';
        }
    	debugPrint(filePath);
        return filePath;
      }
