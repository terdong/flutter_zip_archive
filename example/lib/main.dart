import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_zip_archive/flutter_zip_archive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _controller = TextEditingController(text: "1234");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Password:"),
                  Expanded(
                      child: TextField(
                    controller: _controller,
                  ))
                ],
              ),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  _zip();
                },
                child: Text("ZIP FILE"),
              ),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  _unzip();
                },
                child: Text("UNZIP"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _zip() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    Directory _cacheDir = await getTemporaryDirectory();
    if (file == null) {
      return;
    }
    Directory _testDir = Directory(_cacheDir.path + "/test/");
    _testDir.createSync();
    file.saveTo(_cacheDir.path + "/test/${file.name}");
    var _map = await FlutterZipArchive.zip(_cacheDir.path + "/test",
        _cacheDir.path + "/123.zip", _controller.text);
    print("_map:" + _map.toString());
    Share.shareFiles([_map['path']], text: 'ZIP FILE');
  }

  Future _unzip() async {
    Directory _cacheDir = await getTemporaryDirectory();
    var _map = await FlutterZipArchive.unzip(
        _cacheDir.path + "/123.zip", _cacheDir.path, _controller.text);
    print("_map:" + _map.toString());
  }
}
