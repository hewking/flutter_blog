import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'config/api_url.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MyBlog'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlogList(),
    );
  }
}

class BlogItem {
  int? id;
  String? title;
  String? introduce;
  String? addTime;
  int? view_count;
  String? typeName;
}

class BlogList extends StatefulWidget {
  const BlogList({Key? key}) : super(key: key);

  @override
  State<BlogList> createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  final _blogList = <BlogItem>[];

  void fetchArticleList() async {
    try {
      var response = await Dio().get(articleListUrl);
      final data = response.data;
      final list = data['data'] as List;
      final blogList = <BlogItem>[];
      for (final item in list) {
        final blogItem = BlogItem();
        blogItem.id = item['id'];
        blogItem.title = item['title'];
        blogItem.introduce = item['introduce'];
        blogItem.addTime = item['addTime'];
        blogItem.view_count = item['view_count'];
        blogItem.typeName = item['typeName'];
        blogList.add(blogItem);
      }
      setState(() {
        _blogList.clear();
        _blogList.addAll(blogList);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchArticleList();
    print('blogList: ' + _blogList.toString());
    return Container(
      child: ListView.builder(
        itemCount: _blogList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_blogList[index].title ?? ''),
            subtitle: Text(_blogList[index].introduce ?? ''),
          );
        },
      ),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
    );
  }
}
