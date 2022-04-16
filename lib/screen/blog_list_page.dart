import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../entity/blog_item.dart';
import '../config/api_url.dart';
import 'package:dio/dio.dart';
import '../widgets/icon_text.dart';
import '../entity/type.dart';

class BlogList extends StatefulWidget {
  const BlogList({Key? key, this.type}) : super(key: key);

  final Type? type;

  @override
  State<BlogList> createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  final _blogList = <BlogItem>[];

  void fetchArticleList() async {
    try {
      final url = widget.type?.id == -1
          ? servicePath['getAriticleList']
          : '${servicePath['getListById'] ?? ''}/${widget.type?.id}';
      var response =
          await Dio().get(url ?? servicePath['getAriticleList'] ?? '');
      final data = response.data;
      final list = data['data'] as List;
      final blogList = <BlogItem>[];
      for (final item in list) {
        final blogItem = BlogItem()
          ..id = item['id']
          ..title = item['title']
          ..introduce = item['introduce']
          ..addTime = item['addTime']
          ..view_count = item['view_count']
          ..typeName = item['typeName'];
        blogList.add(blogItem);
      }
      setState(() {
        _blogList.clear();
        _blogList.addAll(blogList);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchArticleList();
    return Container(
      child: ListView.builder(
        itemCount: _blogList.length,
        itemBuilder: (context, index) {
          return _blogItem(_blogList[index]);
        },
      ),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
    );
  }

  Widget _blogItem(BlogItem item) {
    return GestureDetector(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  item.introduce ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                child: _bottomMenu(item),
              )
            ],
          ),
        ),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color.fromARGB(255, 214, 207, 207)))),
      ),
      onTap: () {
        Navigator.pushNamed(context, 'blog_detail', arguments: item);
      },
    );
  }

  Widget _bottomMenu(BlogItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconText.icon(
            icon: const Icon(Icons.article_outlined, size : 18, color: Colors.grey),
            label: Text(
              item.typeName ?? '',
              style: const TextStyle(fontSize: 10),
            )),
        IconText.icon(
          icon: const Icon(Icons.visibility_outlined, size : 18, color: Colors.grey),
          label: Text(item.view_count.toString(),
              style: const TextStyle(fontSize: 10)),
        ),
        IconText.icon(
          icon: const Icon(Icons.access_time, size: 18,  color: Colors.grey),
          label: Text(item.addTime ?? '', style: const TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}
