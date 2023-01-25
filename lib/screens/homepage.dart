import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '/helper/api_key.dart';
import '../model/api_result.dart';
import 'package:camera/camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = "/homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String displayText = "Image not uploaded yet";
  bool imageSelected = false;
  File? img;
  File? compressedFile;
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  Future<void>? cameraInitializer;

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

  @override
  void initState() {
    super.initState();
    setupCamera();
  }

  setupCamera() async {
    try {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      cameraInitializer = cameraController?.initialize();
      cameraController?.setFlashMode(FlashMode.off);
    } on CameraException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  fetchResults() async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api-2445582032290.production.gw.apicast.io/v1/foodrecognition?user_key=$api_key',
        ));

    File file = compressedFile!;
    request.files.add(
      http.MultipartFile.fromBytes('picture', File(file.path).readAsBytesSync(),
          filename: file.path),
    );

    var response = await request.send();
    var decodedResponse = await http.Response.fromStream(response);
    final responseData = json.decode(decodedResponse.body);
    var result = ApiResult.fromJson(responseData);
    setState(() {
      displayText = "";
      for (Results r in result.results) {
        displayText = "$displayText ${r.group}";
      }
    });

    log(responseData.toString());
  }

  captureImage() async {
    final XFile? image = await cameraController?.takePicture();
    File file = File(image!.path);
    setState(() {
      img = file;
      imageSelected = true;
    });
    await compress();
    await fetchResults();
  }

  compress() async {
    compressedFile = await FlutterNativeImage.compressImage(
      img!.path,
      quality: 80,
      targetWidth: 544,
      targetHeight: 544,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: captureImage,
        child: const Icon(Icons.camera_alt),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!imageSelected)
                FutureBuilder(
                  future: cameraInitializer,
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.done) {
                      return CameraPreview(cameraController!);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              if (imageSelected) Image.file(img!),
              if (imageSelected)
                TextButton(
                    onPressed: () {
                      setState(() {
                        imageSelected = false;
                      });
                    },
                    child: const Text("Try Again")),
              Text(displayText),
            ],
          ),
        ),
      ),
    );
  }
}
