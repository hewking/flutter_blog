import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './screen/blog_list_page.dart';
import './config/api_url.dart';
import './entity/type.dart';
import 'screen/detail.dart';
import './widgets/keep_alive_wrapper.dart';

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
      home: const HomePage(title: 'MyBlog'),
      routes: {
        'blog_detail': (context) =>
            Detail(id: ModalRoute.of(context)?.settings.arguments as int),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<Type> _tabs = <Type>[];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    fetchTypeList();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          tabs: _tabs
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(e.typeName ?? '',
                        style: const TextStyle(fontSize: 16)),
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
          children: _tabs.map((e) {
            return KeepAliveWrapper(child: BlogList(type: e));
          }).toList(),
          controller: _tabController),
    );
  }

  void fetchTypeList() async {
    try {
      var response = await Dio().get(servicePath['getTypeInfo'] ?? '');
      final list = response.data['data'] as List;
      var typeList = list.map((e) {
        return Type()
          ..id = e['id']
          ..orderNum = e['orderNum']
          ..typeName = e['typeName']
          ..icon = e['icon'];
      }).toList();
      typeList.insert(
          0,
          Type()
            ..typeName = '首页'
            ..id = -1);
      setState(() {
        _tabs.clear();
        _tabs.addAll(typeList);
        _tabController = TabController(length: _tabs.length, vsync: this);
        // _tabController.animateTo(0);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
