import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;

import '/helper/api_key.dart';
import '/model/api_result.dart';
import 'package:camera/camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = "/homepage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool imageSelected = false;
  File? img;
  File? compressedFile;
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  Future<void>? cameraInitializer;
  ApiResult? result;
  double aspRatio = 1;
  bool cameraListGenerated = false;

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
      setState(() {
        cameraListGenerated = true;
      });
      cameraController = CameraController(cameras.first, ResolutionPreset.max);
      cameraInitializer = cameraController?.initialize();
    } on CameraException {
      if (kDebugMode) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Camera Failed!")));
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
    dev.log(responseData.toString());
    result = ApiResult.fromJson(responseData);
  }

  captureImage() async {
    final XFile? image = await cameraController?.takePicture();
    File file = File(image!.path);
    setState(() {
      img = file;
    });
    await crop();
    await fetchResults();
  }

  crop() async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(img!.path);
    int height = properties.height ?? 0;
    int width = properties.width ?? 0;

    int minSize = min(height, width);
    int originX = ((width - minSize) / 2).round();
    int originY = ((height - minSize) / 2).round();
    compressedFile = await FlutterNativeImage.cropImage(
        img!.path, originX, originY, minSize, minSize);
    await compress();
    setState(() {
      imageSelected = true;
    });
    //
    // final directory = await getApplicationDocumentsDirectory();
    // final String path = directory.path;
    // final result = await ImageGallerySaver.saveFile(img!.path);
    // final result2 = await ImageGallerySaver.saveFile(compressedFile!.path);
    // print(result);
    // print(result2);
  }

  compress() async {
    compressedFile = await FlutterNativeImage.compressImage(
        compressedFile!.path,
        targetHeight: 544,
        targetWidth: 544);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    var camPreviewCropped = FutureBuilder(
      future: cameraInitializer,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.done) {
          aspRatio = cameraController?.value.aspectRatio ?? 16 / 9;
          return SizedBox(
            width: size,
            height: size,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: SizedBox(
                    width: size,
                    height: size * aspRatio,
                    child: CameraPreview(cameraController!),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
    var camPreview = FutureBuilder(
      future: cameraInitializer,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.done) {
          aspRatio = cameraController?.value.aspectRatio ?? 16 / 9;
          return CameraPreview(cameraController!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );

    if (cameraListGenerated) {
      cameraController?.setFlashMode(FlashMode.off);
      return Scaffold(
        appBar: appBar,
        bottomNavigationBar: bottomBar,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //
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
                if (!imageSelected) camPreviewCropped,
                if (imageSelected)
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    child: Image.file(compressedFile!),
                  ),
                // if (imageSelected) Image.file(img!),
                // if (imageSelected) Image.file(compressedFile!),
                if (imageSelected)
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              imageSelected = false;
                            });
                          },
                          child: const Text("Try Again")),
                      TextButton(
                          onPressed: () {
                            setState(() async {});
                          },
                          child: const Text("Scan")),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
