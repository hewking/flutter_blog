import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config//api_url.dart';
import '../entity/blog_detail.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class Detail extends StatefulWidget {
  const Detail({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  BlogDetail? _blogDetail;

  @override
  void initState() {
    super.initState();
    fetchBlogDetail();
  }

  void fetchBlogDetail() async {
    try {
      var response =
          await Dio().get('${servicePath['getArticleById']}/${widget.id}');
      final data = (response.data['data'] as List).take(1).toList()[0];
      final blogDetail = BlogDetail()
        ..id = data['id']
        ..title = data['title']
        ..introduce = data['introduce']
        ..article_content = data['article_content']
        ..addTime = data['addTime']
        ..view_count = data['view_count']
        ..typeName = data['typeName'];
      setState(() {
        _blogDetail = blogDetail;
      });
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
          title: Text(_blogDetail?.title ?? ''),
        ),
        body: SafeArea(
            child: Markdown(
                data: _blogDetail?.article_content ?? '',
                extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  [
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                  ],
                ))),
        floatingActionButton: FloatingActionButton(
          onPressed: _addMark,
          child: const Icon(Icons.favorite),
        ));
  }

  void _addMark () {
    print('addMark');
  }

}
