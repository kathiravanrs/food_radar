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
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Image.file(compressedFile!, height: 200),
    ),
  );

  List<Widget> foodGroup = [];

  buildFoodGroups(){
    List<Results>? res = widget.apiResult?.results;
    for(Results results in res!){
      foodGroup.add(Text(results.group));
    }
  }


  @override
  Widget build(BuildContext context) {
    buildFoodGroups();
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                imgPreview,
                if (widget.apiResult?.isFood == false)
                  const Text("Contains No Food"),
                if (widget.apiResult?.isFood == true)
                  const Text("Contains Food"),
              ],
            ),
            if (widget.apiResult?.isFood == true) Column(children: foodGroup),
          ],
        ),
      ),
    );
  }
}
