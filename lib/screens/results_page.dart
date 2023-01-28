import 'package:flutter/material.dart';
import 'package:foodradar/model/api_result.dart';

class ResultsPage extends StatefulWidget {
  static const String routeName = "/resultPage";

  final ApiResult apiResult;
  const ResultsPage({Key? key, required this.apiResult}) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(

    );
  }
}
