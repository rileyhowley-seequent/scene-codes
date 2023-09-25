import 'package:flutter/material.dart';
import 'package:qr_bar_code/qr/qr.dart';
import 'package:testapp/Functions/export_scenes.dart';

import '../Models/Scene.dart';

List<Scene> list_scenes = [];

class SceneScreen extends StatefulWidget {
  const SceneScreen({super.key});

  @override
  State<SceneScreen> createState() => _SceneScreenState();
}

class _SceneScreenState extends State<SceneScreen> {
  @override
  Widget build(BuildContext context) {
    var sceneName = TextEditingController();
    var sceneLink = TextEditingController();

    Future AddSceneDialog() => showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              padding: EdgeInsets.all(24),
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.height / 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Add Scene",
                    style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: sceneName,
                    decoration: InputDecoration(
                        label: Text("Name of scene"),
                        border: OutlineInputBorder()),
                  ),
                  TextField(
                    controller: sceneLink,
                    decoration: InputDecoration(
                        label: Text("Link to scene"),
                        border: OutlineInputBorder()),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        list_scenes
                            .add(new Scene(sceneName.text, sceneLink.text));
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text("Submit"))
                ],
              ),
            ),
          ),
        );
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  list_scenes[index].title,
                  style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                ),
                Container(
                    width: 500,
                    height: 300,
                    child: Image.network(get_thumbnail(list_scenes[index].link),
                        fit: BoxFit.contain)),
                QRCode(
                  data: list_scenes[index].link,
                  size: 400,
                ),
              ],
            ),
          );
        },
        itemCount: list_scenes.length,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => AddSceneDialog(), child: Icon(Icons.add)),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  importScenes();
                  setState(() {});
                },
                child: Text("Import Scenes")),
            ElevatedButton(
                onPressed: exportScenes, child: Text("Export Scenes"))
          ],
        ),
      ),
    );
  }
}
