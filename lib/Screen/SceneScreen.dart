import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:qr_bar_code/qr/qr.dart';

import '../Models/Scene.dart';

var DATA = null;

class SceneScreen extends StatefulWidget {
  const SceneScreen({super.key});

  @override
  State<SceneScreen> createState() => _SceneScreenState();
}

class _SceneScreenState extends State<SceneScreen> {
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storage = new LocalStorage('scenes.json');
  @override
  Widget build(BuildContext context) {
    var sceneName = TextEditingController();
    var sceneLink = TextEditingController();

    Future DeleteSceneDialog(var data) => showDialog(
          context: context,
          builder: (context) => Dialog(
            child: data != null
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Color(0xff22323C), width: 6),
                    ),
                    height: MediaQuery.of(context).size.height / 2,
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  data[index]['title'],
                                  style: TextStyle(
                                    fontSize: 24,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  var result = DeleteItemFromStorage(
                                    data[index]['title'],
                                    data,
                                  );
                                  storage.setItem("scenes", result);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(fontSize: 24),
                                ),
                              )
                            ],
                          );
                        },
                        itemCount: data.length,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      "No Scenes Loaded",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
          ),
        );

    Future AddSceneDialog() => showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 6,
                    color: Color(0xff22323C),
                  ),
                  borderRadius: BorderRadius.circular(25)),
              padding: EdgeInsets.all(24),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Add Scene",
                    style: TextStyle(fontSize: 44, fontWeight: FontWeight.w500),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 24),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter scene name';
                              }
                              return null;
                            },
                            controller: sceneName,
                            decoration: InputDecoration(
                                label: Text("Name of scene"),
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 24),
                          child: TextFormField(
                            validator: (value) {
                              return ValidateLink(value);
                            },
                            controller: sceneLink,
                            decoration: InputDecoration(
                                label: Text("Link to scene"),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        var previous = storage.getItem('scenes');

                        var newScene =
                            new Scene(sceneName.text, sceneLink.text).toJson();

                        var result;

                        if (previous != null) {
                          previous.add(newScene);
                          storage.setItem("scenes", previous);
                        } else {
                          result = [newScene];
                          storage.setItem("scenes", result);
                        }
                        Navigator.pop(context);
                        sceneName.clear();
                        sceneLink.clear();
                        setState(() {});
                      }
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff22323C),
                      ),
                      child: Center(
                        child: Text(
                          "Save Scene",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Image.asset("assets/icon.png"),
          ),
        ],
      ),
      body: FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == true) {
            DATA = storage.getItem('scenes');
            if (DATA == null) {
              return NoScenesWidget();
            }

            return SceneListViewer(DATA);
          } else {
            return Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: Color(0xff22323C),
                  ),
                  NoScenesWidget(),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: FloatingActionButton(
              backgroundColor: Color(0xff22323C),
              foregroundColor: Colors.white,
              onPressed: () {
                // storage.clear();
                AddSceneDialog();
              },
              child: Icon(Icons.add),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff22323C),
            foregroundColor: Colors.white,
            onPressed: () {
              // storage.clear();
              DeleteSceneDialog(storage.getItem('scenes'));
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SceneListViewer extends StatelessWidget {
  var data;
  SceneListViewer(this.data);

  @override
  Widget build(BuildContext context) {
    Future QRCodeDialog(String link) => showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.8,
              child: Center(child: QRCode(data: link)),
            ),
          ),
        );
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  data[index]['title'],
                  style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  width: 500,
                  height: 300,
                  child: Image.network(get_thumbnail(data[index]['link']),
                      fit: BoxFit.contain)),
              InkWell(
                onTap: () {
                  QRCodeDialog(data[index]['link']);
                },
                child: QRCode(
                  data: data[index]['link'],
                  size: 400,
                ),
              ),
            ],
          ),
        );
      },
      itemCount: data.length,
    );
  }
}

class NoScenesWidget extends StatelessWidget {
  const NoScenesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No Scenes available",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            "Add a new scene",
            style: TextStyle(fontSize: 28),
          ),
        ],
      ),
    );
  }
}

ValidateLink(String? link) {
  if (link!.isEmpty) {
    return 'Incorrect link. Expecting seequent.com link';
  } else if (!link.contains("https://publicscenes.seequent.com")) {
    return 'Please enter a valid link';
  }
}

DeleteItemFromStorage(var sceneName, var data) {
  for (var i = 0; i < data.length; i++) {
    if (data[i]['title'] == sceneName) {
      data.removeAt(i);
      break;
    }
  }

  return data;
}
