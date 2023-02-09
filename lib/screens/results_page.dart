import 'package:flutter/material.dart';
import 'package:foodradar/model/api_result.dart';
import 'package:foodradar/widgets/app_bar.dart';

import '../helper/temp_data.dart';

class ResultsPage extends StatefulWidget {
  static const String routeName = "/resultPage";

  final ApiResult? apiResult;

  const ResultsPage({Key? key, required this.apiResult}) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  var imgPreview = Hero(
    tag: "compressedImage",
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(40)),
      child: Image.file(compressedFile!, height: 200),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                imgPreview,
                Text("Contains Food"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
