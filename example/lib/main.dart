import 'package:flutter/material.dart';
import 'package:flutter_group_list_view/flutter_group_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

List _elements = [
  {
    "storeName": "ASICS 旗舰店",
    "storeCode": "s01",
    "goodsList": [{}, {}]
  },
  {
    "storeName": "SALOMON 官方旗舰店",
    "storeCode": "s02",
    "goodsList": [{}]
  },
  {
    "storeName": "ASICS 旗舰店",
    "storeCode": "s01",
    "goodsList": [{}, {}]
  }
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          //导航栏
          title: const Text("GroupSliverListViewDemo"),
          actions: <Widget>[
            //导航栏右侧菜单
            IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            GroupSliverListView(
              sectionCount: _elements.length,
              itemInSectionCount: (int section) {
                return _elements[section]['goodsList'].length;
              },
              headerForSectionBuilder: (int section) {
                return Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 12, right: 12, top: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Colors.green,
                  ),
                  child: const Row(
                    children: [Text("this is header")],
                  ),
                );
              },
              itemInSectionBuilder: (BuildContext context, IndexPath indexPath) {
                return Container(
                  height: 90,
                  margin: const EdgeInsets.only(left: 12, right: 12),
                  color: Colors.white,
                  child: const Row(
                    children: [Text("this is item")],
                  ),
                );
              },
              separatorBuilder: (IndexPath indexPath) {
                return Container(
                  height: 1,
                  color: Colors.grey,
                );
              },
              footerForSectionBuilder: (int section) {
                return Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 12, right: 12),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    color: Colors.blue,
                  ),
                  child: const Row(
                    children: [Text("this is footer")],
                  ),
                );
              },
            )
          ],
        ));
  }
}
