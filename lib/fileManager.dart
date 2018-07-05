import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class FileManager {
  FileManager._();

  static Future<String> getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getFile(String fileName) async {
    final String path = await getPath();
    return File('$path/$fileName');
  }

  static Future<Map<String, dynamic>> readFile(String fileName) async {
    File file = await getFile(fileName);
    Map<String, dynamic> jsonFileContents;
    if (file.existsSync()) jsonFileContents = json.decode(file.readAsStringSync());
    return jsonFileContents;
  }

  static Future<File> createFile(String fileName, Map<String, dynamic> content) async {
    File file = await getFile(fileName);
    file.create();
    print(file);
    return file.writeAsString(json.encode(content));
  }

  static Future<File> writeToFile(String fileName, String key, dynamic value) async {
    Map<String, dynamic> content = {key: value};
    File file = await getFile(fileName);
    Map<String, dynamic> jsonFileContent = await readFile(fileName);
    if (jsonFileContent != null) {
      jsonFileContent.addAll(content);
      return file.writeAsStringSync(json.encode(jsonFileContent));
    }
    else return createFile(fileName, content);
  }

  static Future<File> removeFromFile(String fileName, String key) async {
    File file = await getFile(fileName);
    Map<String, dynamic> jsonFileContent = await readFile(fileName);
    if (jsonFileContent == null) return null;
    jsonFileContent.remove(key);
    return file.writeAsStringSync(json.encode(jsonFileContent));
  }

  static Future<File> removeFile(String fileName) async {
    File file = await getFile(fileName);
    return file.deleteSync();
  }
}
