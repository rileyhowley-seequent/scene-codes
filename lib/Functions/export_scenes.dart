import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testapp/Screen/SceneScreen.dart';
import 'dart:io';

exportScenes() async {
  String json = jsonEncode(list_scenes);
  final directory = await getDownloadsDirectory();
  final path = directory!.path;
  File file = File('$path' + '/scenes.json');

  print(file.path);

  file.writeAsString(json);
}

importScenes() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path.toString());
    final contents = await file.readAsString();

    list_scenes.add(jsonDecode(contents));
  }
}
