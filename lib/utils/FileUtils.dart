import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
//import 'package:simple_permissions/simple_permissions.dart';

import 'package:retailappcount/utils/Permissions.dart';
import 'dart:io';

class FileUtils {
  //static Permission permission1 = Permission.WriteExternalStorage;
  static Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get getFile async {
    //final path = await getFilePath;
    // final path = await FilePicker.getFilePath(type: FileType.ANY);
    final path = await downloadFile();
    return File('$path/info.txt');
  }

  static Future<File> saveToFile(String data) async {
    final file = await getFile;
    print("entre a descargar");
    print(file.path);
    print("escribire "+ data.toString());
    return file.writeAsString(data.toString());
  }

  static Future<String> readFromFile() async {
    List<String> allowd = new List<String>();
    allowd.add("txt");
    if (PermissionsService().requestStoragePermission() != false) {
      try {
        //final file = await getFile;
        final file =
        await FilePicker.getFile(type: FileType.custom, allowedExtensions: allowd );
        String fileContents = await file.readAsString();

        //  print(fileContents);
        return fileContents;
      } catch (e) {
        return e.toString()+"";
      }

    }else{
      return "error";
    }

  }

  static Future<String> downloadFile() async {
    String dirloc = "";

    // ignore: unrelated_type_equality_checks
    if (PermissionsService().requestStoragePermission() != false) {
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }
    }

    /* bool checkPermission1 =
        await SimplePermissions.checkPermission(permission1);
    // print(checkPermission1);
    if (checkPermission1 == false) {
      await SimplePermissions.requestPermission(permission1);
      checkPermission1 = await SimplePermissions.checkPermission(permission1);
    }
    if (checkPermission1 == true) {
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }
    } else {
      print("Permission Denied!");
    }*/
    return dirloc;
  }
}
