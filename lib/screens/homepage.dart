import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
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
  String disp = "Image not uploaded yet";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(""),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.abc),
        onPressed: () {
          uploadFile();
        },
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Food Radar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(disp),
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
            'https://api-2445582032290.production.gw.apicast.io/v1/foodrecognition?user_key=$api_key'));

    File file = await getImage();
    request.files.add(http.MultipartFile.fromBytes('picture', File(file.path).readAsBytesSync(),
        filename: file.path));

    var response = await request.send();
    var decodedResponse = await http.Response.fromStream(response);
    final responseData = json.decode(decodedResponse.body);

    if (response.statusCode == 200) {
      print("SUCCESS");
    } else {
      print("ERROR");
    }
    setState(() {
      disp = responseData.toString();
    });
    log(responseData.toString());
  }

  Future<File> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    return file;
  }
}
