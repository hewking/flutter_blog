import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config//api_url.dart';
import '../entity/blog_detail.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final BlogDetail? _blogDetail = null;

  void fetchBlogDetail() async {
    try {
      var response = await Dio().get(servicePath['getArticleById'] ?? '');
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
        ),
        body: Center(child: Text('Detail')));
  }
}
