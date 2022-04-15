import 'package:flutter/material.dart';
import '../entity/blog_item.dart';
import '../config/api_url.dart';
import 'package:dio/dio.dart';
import '../widgets/icon_text.dart';

class BlogList extends StatefulWidget {
  const BlogList({Key? key, this.type}) : super(key: key);

  final String? type;

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
    return Container(
      // onTap: () {
      //   Navigator.pushNamed(context, '/blog_detail', arguments: item);
      // },
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
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconText.icon(
                      icon: const Icon(Icons.category, color: Colors.grey),
                      label: Text(
                        item.typeName ?? '',
                        style: const TextStyle(fontSize: 10),
                      )),
                  IconText.icon(
                    icon: const Icon(Icons.remove_red_eye),
                    label: Text(item.view_count.toString(),
                        style: const TextStyle(fontSize: 10)),
                  ),
                  IconText.icon(
                    icon: const Icon(Icons.access_time, color: Colors.grey),
                    label: Text(item.addTime ?? '',
                        style: const TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromARGB(255, 214, 207, 207)))),
    );
  }
}
