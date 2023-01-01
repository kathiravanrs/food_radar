import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:foodradar/model/api_result.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '/helper/api_key.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = "/homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var appBar = AppBar(
    elevation: 0,
    centerTitle: true,
    title: const Text("Food Radar"),
  );

  var bottomBar = const BottomAppBar(
    shape: CircularNotchedRectangle(),
    notchMargin: 5,
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(""),
    ),
  );

  String displayText = "Image not uploaded yet";
  bool imageSelected = false;

  late File img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: getImage,
        child: const Icon(Icons.camera_alt_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageSelected) Image.file(img),
              TextButton(onPressed: crop, child: Text("Crop")),
              TextButton(onPressed: uploadFile, child: Text("upload")),
              Text(displayText),
            ],
          ),
        ),
      ),
    );
  }

  uploadFile() async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api-2445582032290.production.gw.apicast.io/v1/foodrecognition?user_key=$api_key',
        ));

    File file = img;
    request.files.add(http.MultipartFile.fromBytes('picture', File(file.path).readAsBytesSync(),
        filename: file.path));

    var response = await request.send();
    var decodedResponse = await http.Response.fromStream(response);
    final responseData = json.decode(decodedResponse.body);
    var result = ApiResult.fromJson(responseData);
    setState(() {
      for (Results r in result.results) {
        displayText = "$displayText ${r.group}";
      }
    });

    log(responseData.toString());
  }

  Future<File> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(maxHeight: 544, maxWidth: 544, source: ImageSource.gallery);
    File file = File(image!.path);
    setState(() {
      img = file;
      imageSelected = true;
    });
    return file;
  }

  crop() async {
    File compressedFile = await FlutterNativeImage.compressImage(
      img.path,
      quality: 80,
      targetWidth: 544,
      targetHeight: 544,
    );
    setState(() {
      img = compressedFile;
    });
  }
}
