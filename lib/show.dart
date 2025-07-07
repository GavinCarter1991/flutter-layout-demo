// 构造函数传参直接通过 widget 属性获取
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Show extends StatefulWidget {
  final dynamic data;
  const Show({super.key, required this.data});

  @override
  State<Show> createState() => _ShowState();
}

class _ShowState extends State<Show> {
  int _currentIndex = 0;
  List<String> _items = List.generate(20, (index) => "Item $index");
  bool _isHidden = false; // 控制文本是否隐藏
  bool _isIgnoring = true;

  final List<Widget> _pages = [
    PageWidget(title: "页面1", color: Colors.red),
    PageWidget(title: "页面2", color: Colors.green),
    PageWidget(title: "页面3", color: Colors.blue),
  ];

  static const String _viewType = 'com.example/NativeTimeView';
  late Timer _timer;
  String _currentTime = '';
  // 平台通道用于与原生代码通信
  static const platform = MethodChannel('com.example/time_channel');

  bool _isShown = true;

  void _toggleVisibility() {
    setState(() {
      _isShown = !_isShown;

      // 每秒更新时间
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateTime();
      });
      // 初始获取时间
      _updateTime();
    });
  }

  Future<void> _updateTime() async {
    try {
      final time = await platform.invokeMethod('getCurrentTime');
      setState(() {
        _currentTime = time;
      });
    } on PlatformException catch (e) {
      setState(() {
        _currentTime = "时间获取失败: ${e.message}";
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.data['data']),
      ),
      body: _getWidget(context),
    );
  }

  Widget _getWidget(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var orientation = MediaQuery.of(context).orientation;
    switch (widget.data['data']) {
      case 'Container':
        return Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Text('Hello World'),
        );

      case 'Row':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 主轴均匀分布
          crossAxisAlignment: CrossAxisAlignment.center, // 交叉轴居中
          children: [
            Container(width: 50, height: 50, color: Colors.red),
            Expanded(
                child: Container(height: 30, color: Colors.green)), // 弹性填充剩余空间
            Container(width: 50, height: 50, color: Colors.blue),
          ],
        );

      case 'Column':
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 主轴均匀分布
          crossAxisAlignment: CrossAxisAlignment.center, // 交叉轴居中
          children: [
            Container(width: 50, height: 50, color: Colors.red),
            Expanded(
                child: Container(height: 30, color: Colors.green)), // 弹性填充剩余空间
            Container(width: 50, height: 50, color: Colors.blue),
          ],
        );

      case 'Stack':
        return Stack(
          alignment: Alignment.center, // 所有子Widget居中
          children: [
            Container(width: 200, height: 200, color: Colors.blue), // 底层
            Positioned(
              bottom: 10,
              right: 10,
              child:
                  Container(width: 50, height: 50, color: Colors.red), // 定位到右下
            ),
            const Text("Stack Example"), // 文字居中
          ],
        );

      case 'Expanded':
        return Row(
          children: [
            Expanded(flex: 2, child: Container(color: Colors.red)), // 占2/3空间
            Expanded(flex: 1, child: Container(color: Colors.green)), // 占1/3空间
          ],
        );

      case 'Flexible':
        return Row(
          children: [
            Flexible(
              child: Container(height: 50, color: Colors.red),
            ),
            Flexible(
              child: Container(
                  height: 100,
                  color: Colors
                      .green), // 这个容器高度100，但Row高度由最高子Widget决定（100），红色容器高度50，但会被拉伸到100（因为Row交叉轴是垂直方向，默认是stretch）
            ),
          ],
        );

      case 'Wrap':
        return const Wrap(
          spacing: 8.0, // 水平间距
          runSpacing: 4.0, // 垂直间距（行间距）
          children: [
            Chip(label: Text('标签1')),
            Chip(label: Text('标签2')),
            Chip(label: Text('标签3')),
            Chip(label: Text('标签4')),
            Chip(label: Text('标签5')),
            Chip(label: Text('标签6')),
            Chip(label: Text('标签7')),
            Chip(label: Text('标签8')),
            Chip(label: Text('标签9')),
            Chip(label: Text('标签10')),
            Chip(label: Text('标签11')),
            Chip(label: Text('标签12')),
          ],
        );

      case 'ListView':
        return ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Item $index'),
            );
          },
        );

      case 'GridView':
        var array = [Colors.blue, Colors.red, Colors.yellow];
        return GridView.count(
          crossAxisCount: 3, // 每行3列
          childAspectRatio: 1.0, // 宽高比
          children: List.generate(
              9,
              (index) => Container(
                    decoration: BoxDecoration(
                      color: array[index % 3],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(child: Text('Item $index')),
                  )),
        );

      case 'Flex':
        return Flex(
          // 等价于Column
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 1, // 占1/3高度
              child: Container(color: Colors.red),
            ),
            Expanded(
              flex: 2, // 占2/3高度
              child: Container(color: Colors.blue),
            ),
          ],
        );

      case 'Flow':
        return Flow(
          delegate: MyFlowDelegate(),
          children: List.generate(
              5,
              (index) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.primaries[index],
                  )),
        );

      case 'Table':
        return Table(
          columnWidths: const {
            0: FixedColumnWidth(80), // 第一列固定宽度
            1: FlexColumnWidth(2), // 第二列弹性宽度（占比更大）
            2: IntrinsicColumnWidth(), // 第三列自适应内容宽度
          },
          border: TableBorder.all(color: Colors.black, width: 1.0),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle, // 垂直居中
          children: const [
            TableRow(
              // 表头行
              decoration: BoxDecoration(color: Colors.grey),
              children: [
                Text('姓名', textAlign: TextAlign.center),
                Text('性别', textAlign: TextAlign.center),
                Text('年龄', textAlign: TextAlign.center),
              ],
            ),
            TableRow(
              // 数据行
              children: [
                Text('张三'),
                Text('男'),
                Text('25'),
              ],
            ),
          ],
        );

      case 'CustomScrollView':
        return CustomScrollView(
          slivers: <Widget>[
            // 1. 可折叠的吸顶AppBar
            SliverAppBar(
              pinned: true,
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Demo'),
                background: Image.network(
                    'https://upload-images.jianshu.io/upload_images/1976231-d7cab59e26a42a4c.png',
                    fit: BoxFit.cover),
              ),
            ),

            // 2. 网格布局
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 两列网格
                mainAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    Container(color: Colors.red[100 * (index % 9)]),
                childCount: 20,
              ),
            ),

            // 3. 列表布局
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(title: Text('Item $index')),
                childCount: 50,
              ),
            ),
          ],
        );

      case 'IndexedStack':
        return Column(
          children: [
            // 切换按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(0, "页面1"),
                _buildButton(1, "页面2"),
                _buildButton(2, "页面3"),
              ],
            ),

            // IndexedStack区域
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            )
          ],
        );

      case 'ListBody':
        return SingleChildScrollView(
          // 提供滚动支持
          child: ListBody(
            mainAxis: Axis.vertical,
            reverse: false,
            children: <Widget>[
              Container(height: 100, color: Colors.blue[50]),
              Container(height: 100, color: Colors.blue[100]),
              Container(height: 100, color: Colors.blue[200]),
            ],
          ),
        );

      case 'Padding':
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              "Flutter Padding 背景颜色示例",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );

      case 'Align':
        return Container(
          height: 200,
          width: 200,
          color: Colors.grey,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(width: 50, height: 50, color: Colors.red),
          ),
        );

      case 'Center':
        return Center(
          child: Container(
            width: 200,
            height: 100,
            color: Colors.blue,
            child: const Text(
              "居中内容",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );

      case 'AspectRatio':
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(color: Colors.blue),
        );

      case 'ConstrainedBox':
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 200,
            minHeight: 50,
            maxHeight: 100,
          ),
          child: Container(color: Colors.red),
        );

      case 'UnconstrainedBox':
        return ListView(
          children: [
            // 原始Container被拉伸至屏幕宽度
            Container(width: 200, height: 100, color: Colors.red),

            // 使用UnconstrainedBox保持原始尺寸
            UnconstrainedBox(
              child: Container(width: 200, height: 100, color: Colors.blue),
            ),
          ],
        );

      case 'SizedBox':
        return SizedBox(
          width: 100,
          height: 100,
          child: Container(color: Colors.green),
        );

      case 'FractionallySizedBox':
        return Container(
          width: 200,
          height: 200,
          color: Colors.blue,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 0.5,
            child: Container(color: Colors.red),
          ),
        );

      case 'Transform':
        return Transform.rotate(
          angle: 3.14 / 4, // 45度
          child: Container(width: 100, height: 100, color: Colors.blue),
        );

      case 'Baseline':
        return const Row(
          children: [
            Baseline(
              baseline: 50.0,
              baselineType: TextBaseline.alphabetic,
              child: Text('Hello', style: TextStyle(fontSize: 20)),
            ),
            Baseline(
              baseline: 50.0,
              baselineType: TextBaseline.alphabetic,
              child: Text('World', style: TextStyle(fontSize: 30)),
            ),
          ],
        );

      case 'FittedBox':
        return Container(
          width: 200,
          height: 100,
          color: Colors.amber,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.network(
                'https://upload-images.jianshu.io/upload_images/1976231-cb638ee25dbc7368.png'),
          ),
        );

      case 'OverflowBox':
        return Container(
          color: Colors.green,
          width: 200.0,
          height: 200.0,
          padding: const EdgeInsets.all(50.0),
          child: OverflowBox(
            alignment: Alignment.topLeft,
            maxWidth: 400.0,
            maxHeight: 400.0,
            child: Container(
              color: Colors.blueGrey,
              width: 300.0,
              height: 300.0,
            ),
          ),
        );

      case 'LimitedBox':
        return Row(
          children: [
            Container(
              color: Colors.grey,
              width: 100.0,
            ),
            LimitedBox(
              maxWidth: 150.0,
              maxHeight: 150.0,
              child: Container(
                color: Colors.lightGreen,
                width: 250.0,
                height: 250.0,
              ),
            ),
          ],
        );

      case 'IntrinsicWidth/Height':
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IntrinsicWidth(
              stepWidth: 100,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Container(
                    color: Colors.red,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ],
        );

      case 'CustomSingleChildLayout':
        return CustomSingleChildLayout(
          delegate: _MyDelegate(),
          child: Container(color: Colors.blue),
        );

      case 'CustomMultiChildLayout':
        return Container(
          width: 200.0,
          height: 100.0,
          color: Colors.yellow,
          child: CustomMultiChildLayout(
            delegate: TestLayoutDelegate(),
            children: <Widget>[
              LayoutId(
                id: TestLayoutDelegate.title,
                child: Container(
                  color: Colors.red,
                  child: const Text('Title'),
                ),
              ),
              LayoutId(
                id: TestLayoutDelegate.description,
                child: Container(
                  color: Colors.green,
                  child: const Text('Description'),
                ),
              ),
            ],
          ),
        );

      case 'Placeholder':
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Placeholder(
                      fallbackWidth: 100,
                      color: Colors.green,
                      strokeWidth: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    Placeholder(
                      fallbackHeight: 100,
                      color: Colors.green,
                      strokeWidth: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 'Spacer':
        return Column(
          children: [
            const Text(
              "顶部标题",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            const Spacer(flex: 1),
            const Row(
              children: [
                Text(
                  "左侧文本",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Spacer(flex: 2),
                Text("中间文本",
                    style: TextStyle(
                      color: Colors.red,
                    )),
                Spacer(flex: 1),
                Icon(Icons.star),
              ],
            ),
            const Spacer(flex: 3), // 下方大面积留白
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                "确认",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );

      case 'Positioned':
        return Stack(
          fit: StackFit.expand, // 填充父容器
          children: [
            Positioned(
              left: 10,
              right: 10,
              height: 80,
              child: Container(color: Colors.orange), // 水平居中且宽度自适应
            ),
            Positioned(
              top: 10,
              bottom: 10,
              width: 80,
              child: Container(color: Colors.purple), // 垂直居中且高度自适应
            ),
          ],
        );

      case 'PositionedDirectional':
        return Directionality(
          // 设置文本方向（ltr 或 rtl）
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              PositionedDirectional(
                start: 20.0, // 在 rtl 环境下对应 right=20
                top: 50.0,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                  child: const Center(child: Text('动态定位')),
                ),
              ),
              // 其他子组件...
            ],
          ),
        );

      case 'SingleChildScrollView':
        return Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                    .split('')
                    .map((c) => Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 4.0,
                                offset: const Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          child: Text(
                            c,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 24.0),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        );

      case 'PageView':
        return PageView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.green),
              child: const Text("页面 0",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.red),
              child: const Text("页面 1",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.blue),
              child: const Text("页面 2",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        );

      case 'Scrollbar':
        return Scrollbar(
          child: ListView.builder(
            itemCount: 40,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  child: Text('$index'),
                ),
              );
            },
          ),
        );

      case 'RefreshIndicator':
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_items[index]),
              );
            },
          ),
        );

      case 'DraggableScrollableSheet':
        return Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Text('背景内容'),
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 1.0,
              builder: (_, controller) {
                return Container(
                  color: Theme.of(context).cardColor,
                  child: Scrollbar(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Item $index'),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );

      case 'NestedScrollView':
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: const Text('NestedScrollView Example'),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                expandedHeight: 160.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    "https://miaobi-lite.bj.bcebos.com/miaobi/5mao/b%275aS05YOPYXBwXzE3MzM3NjcxODMuODQyNDgz%27/0.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ];
          },
          body: ListView.builder(
            itemCount: 50,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('List Item $index'),
              );
            },
          ),
        );

      case 'ScrollConfiguration':
        return ScrollConfiguration(
          behavior: MyCustomBehavior(),
          child: ListView.separated(
            itemCount: 20,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (_, index) {
              return Container(
                height: 56,
                alignment: Alignment.center,
                child: Text("这是第 ${index + 1} 项"),
              );
            },
          ),
        );

      case 'SliverList':
        return CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('SliverList 示例'),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item #$index'),
                  );
                },
                childCount: 20, // 列表项数目
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.blue[100 * (index % 9)],
                    child: Text("list item $index"),
                  );
                },
                childCount: 50,
              ),
            ),
          ],
        );

      case 'SliverGrid':
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              // 可折叠标题栏
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                      'https://miaobi-lite.bj.bcebos.com/miaobi/5mao/b%275aS05YOPYXBwXzE3MzM3NjcxODMuODQyNDgz%27/0.png',
                      fit: BoxFit.cover)),
            ),
            SliverGrid(
              // 网格区域
              delegate: SliverChildBuilderDelegate((ctx, i) => Container(
                    color: [
                      Colors.red,
                      Colors.blue,
                      Colors.black,
                      Colors.yellow,
                      Colors.green
                    ][i % 5],
                  )),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150, // 自适应宽度
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
            ),
          ],
        );

      case 'SliverAppBar':
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: const Text('SliverAppBar Example'),
                      background: Image.network(
                        'https://img.win3000.com/m00/76/6a/3fb7a5729f51fedf4261cb02addbd133.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    bottom: const TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.home), text: 'Home'),
                        Tab(icon: Icon(Icons.settings), text: 'Settings'),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Container(
                              height: 85,
                              alignment: Alignment.center,
                              color: Colors
                                  .primaries[index % Colors.primaries.length],
                              child: Text(
                                '$index',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            );
                          },
                          childCount: 25,
                        ),
                      ),
                    ],
                  ),
                  CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Container(
                              height: 85,
                              alignment: Alignment.center,
                              color: Colors
                                  .primaries[index % Colors.primaries.length],
                              child: Text(
                                '$index',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            );
                          },
                          childCount: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

      case 'SliverPadding':
        return CustomScrollView(
          slivers: [
            const SliverAppBar(title: Text('SliverPadding 示例')),
            SliverPadding(
              padding: const EdgeInsets.all(20), // 全局边距
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                    title: Text("列表项 $index"),
                  ),
                  childCount: 20,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 30, bottom: 50), // 仅上下边距
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    color: Colors.blue,
                    child: Center(child: Text("网格 $index")),
                  ),
                  childCount: 6,
                ),
              ),
            ),
          ],
        );

      case 'SliverToBoxAdapter':
        return CustomScrollView(
          slivers: [
            // 1. 顶部 Banner
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
                ),
                child: const Center(
                    child: Text('欢迎页', style: TextStyle(fontSize: 24))),
              ),
            ),

            // 2. 分隔标题
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('产品列表',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),

            // 3. 网格布局
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    Card(child: Center(child: Text('产品 $index'))),
                childCount: 6,
              ),
            ),

            // 4. 底部按钮
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('加载更多'),
                ),
              ),
            ),
          ],
        );

      case 'SliverFillRemaining':
        return CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Flexible Space'),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 500,
                    color: Colors.amber,
                    alignment: Alignment.center,
                    child: const Text('List Item'),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text('Fill Remaining Space',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );

      case 'SliverPersistentHeader':
        return CustomScrollView(
          slivers: <Widget>[
            // 创建一个固定在页面顶部的 SliverPersistentHeader
            SliverPersistentHeader(
              pinned: true, // 固定在页面顶部
              delegate: _MyHeaderDelegate(),
            ),
            // 添加一个普通的 SliverList
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item $index'),
                    leading: CircleAvatar(child: Text('$index')),
                  );
                },
                childCount: 50,
              ),
            ),
          ],
        );

      case 'LayoutBuilder':
        return Center(
          child: Container(
            width: 300, // 父容器宽度
            height: 200, // 父容器高度
            color: Colors.blue,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 根据父容器宽度动态切换布局
                if (constraints.maxWidth > 200) {
                  return _buildWideLayout(constraints);
                } else {
                  return _buildNarrowLayout(constraints);
                }
              },
            ),
          ),
        );

      case 'OrientationBuilder':
        return OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildVerticalLayout()
                : _buildHorizontalLayout();
          },
        );

      case 'MediaQuery':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Screen Size: ${screenSize.width} x ${screenSize.height}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              'Text Scale Factor: $textScaleFactor',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              'Orientation: $orientation',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            if (orientation == Orientation.portrait)
              FilledButton(
                onPressed: () {},
                child: Text('Button for Portrait Mode'),
              )
            else
              FilledButton(
                onPressed: () {},
                child: Text('Button for Landscape Mode'),
              ),
            SizedBox(height: 20),
            FilledButton(
              onPressed: () {},
              child: Text(
                'Custom Font Size Button',
                style: TextStyle(fontSize: 16 * textScaleFactor),
              ),
            ),
          ],
        );

      case 'SafeArea':
        return SafeArea(
          // 2. 关闭底部安全区域（自定义底部栏时使用）
          bottom: false,
          child: Column(
            children: [
              // 3. 顶部标题栏（自动避开状态栏）
              const AppHeader(),
              // 4. 内容区域（使用Expanded填充剩余空间）
              Expanded(
                child: ListView(
                  children: List.generate(
                      20, (i) => ListTile(title: Text("Item $i"))),
                ),
              ),
              // 5. 自定义底部导航栏（需手动避开系统栏）
              const CustomBottomBar(),
            ],
          ),
        );

      case 'PlatformView':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flutter 文本显示原生视图传回的时间
            Text('Flutter 显示: $_currentTime',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            // 原生视图容器
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Platform.isAndroid
                  ? const AndroidView(
                      viewType: _viewType,
                      creationParams: {'textColor': '#FF0000'}, // 红色文本
                      creationParamsCodec: StandardMessageCodec(),
                    )
                  : const UiKitView(
                      viewType: _viewType,
                      creationParams: {'textSize': 24.0}, // iOS 文本大小
                      creationParamsCodec: StandardMessageCodec(),
                    ),
            ),
          ],
        );

      case 'Offstage':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 使用 Offstage 控制文本显示
            Offstage(
              offstage: _isHidden,
              child: const Text(
                'Hello, Offstage!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // 切换按钮
            ElevatedButton(
              onPressed: () {
                setState(() => _isHidden = !_isHidden);
              },
              child: Text(_isHidden ? '显示文本' : '隐藏文本'),
            ),
          ],
        );

      case 'Visibility':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: _isShown,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _toggleVisibility,
                child: Text(_isShown ? '隐藏盒子' : '显示盒子'),
              ),
            ],
          ),
        );

      case 'IgnorePointer':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 使用 IgnorePointer 包裹按钮
            IgnorePointer(
              ignoring: _isIgnoring,
              child: ElevatedButton(
                onPressed: () {
                  print('按钮被点击');
                },
                child: const Text('可点击按钮'),
              ),
            ),
            const SizedBox(height: 20),
            // 切换开关
            Switch(
              value: _isIgnoring,
              onChanged: (value) {
                setState(() {
                  _isIgnoring = value;
                });
              },
              activeTrackColor: Colors.blueGrey,
              activeColor: Colors.blue,
            ),
            const Text('开关开启时按钮不可点击'),
          ],
        );

      case 'AbsorbPointer':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 外层可点击区域
              GestureDetector(
                // ignore: avoid_print
                onTap: () => print('外层点击'),
                child: Container(
                  color: Colors.grey,
                  padding: const EdgeInsets.all(16),
                  child: AbsorbPointer(
                    absorbing: true, // 禁用子组件交互
                    child: Row(
                      children: [
                        ElevatedButton(
                          // ignore: avoid_print
                          onPressed: () => print('按钮点击'),
                          child: const Text('禁用按钮'),
                        ),
                        const SizedBox(width: 16),
                        const Text('不可点击区域'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 对比示例（交互正常）
              GestureDetector(
                // ignore: avoid_print
                onTap: () => print('外层点击'),
                child: Container(
                  color: Colors.grey,
                  padding: const EdgeInsets.all(16),
                  child: AbsorbPointer(
                    absorbing: false, // 启用子组件交互
                    child: ElevatedButton(
                      // ignore: avoid_print
                      onPressed: () => print('正常按钮'),
                      child: const Text('可点击按钮'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
    }

    return const Text('temp page');
  }

  Widget _buildVerticalLayout() {
    return ListView(
      children: const <Widget>[
        ListTile(title: Text('项目 1')),
        ListTile(title: Text('项目 2')),
        ListTile(title: Text('项目 3')),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return GridView.count(
      crossAxisCount: 3,
      children: <Widget>[
        Container(
          color: Colors.red,
          child: const Center(child: Text('项目 1')),
        ),
        Container(
          color: Colors.green,
          child: const Center(child: Text('项目 2')),
        ),
        Container(
          color: Colors.blue,
          child: const Center(child: Text('项目 3')),
        ),
      ],
    );
  }

  // 宽布局：水平排列
  Widget _buildWideLayout(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: constraints.maxWidth * 0.3, // 宽度占父级30%
          height: 50,
          color: Colors.red,
        ),
        Container(
          width: constraints.maxWidth * 0.5, // 宽度占父级50%
          height: 80,
          color: Colors.green,
        ),
      ],
    );
  }

  // 窄布局：垂直排列
  Widget _buildNarrowLayout(BoxConstraints constraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.8, // 宽度占父级80%
          height: 40,
          color: Colors.orange,
        ),
        const SizedBox(height: 20),
        Container(
          width: constraints.maxWidth * 0.6, // 宽度占父级60%
          height: 60,
          color: Colors.purple,
        ),
      ],
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _items = List.generate(20, (index) => "Refreshed Item $index");
    });
  }

  Widget _buildButton(int index, String text) {
    return ElevatedButton(
      onPressed: () => setState(() => _currentIndex = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: _currentIndex == index ? Colors.amber : null,
      ),
      child: Text(text),
    );
  }
}

// 自定义顶部组件
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.all(16),
      child: const Text("SafeArea Demo", style: TextStyle(color: Colors.white)),
    );
  }
}

// 自定义底部组件（需单独处理安全边距）
class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    // 6. 为底部栏单独添加SafeArea
    return SafeArea(
      top: false, // 关闭顶部边距
      minimum: const EdgeInsets.only(bottom: 10), // 追加额外外边距
      child: Container(
        height: 50,
        color: Colors.green,
        child: const Center(child: Text("Bottom Bar")),
      ),
    );
  }
}

// 定义一个 SliverPersistentHeaderDelegate
class _MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 获取状态栏高度
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // 构建头部组件
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      color: Colors.blue,
      alignment: Alignment.center,
      child: const Text('Header'),
    );
  }

  @override
  double get maxExtent => 120; // 最大高度

  @override
  double get minExtent => 40; // 最小高度

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _MyDelegate extends SingleChildLayoutDelegate {
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen(); // 解除子组件约束
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(size.width / 2, 0); // 顶部居中
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    // TODO: implement shouldRelayout
    throw UnimplementedError();
  }
}

class TestLayoutDelegate extends MultiChildLayoutDelegate {
  static const String title = 'title';
  static const String description = 'description';

  @override
  void performLayout(Size size) {
    final BoxConstraints constraints = BoxConstraints(maxWidth: size.width);
    final Size titleSize = layoutChild(title, constraints);
    positionChild(title, const Offset(0.0, 0.0));
    final double descriptionY = titleSize.height;
    layoutChild(description, constraints);
    positionChild(description, Offset(0.0, descriptionY));
  }

  @override
  bool shouldRelayout(TestLayoutDelegate oldDelegate) => false;
}

class MyFlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    var x = 0.0, y = 0.0;
    for (var i = 0; i < context.childCount; i++) {
      // 动态计算每个子组件位置
      final childSize = context.getChildSize(i)!;
      context.paintChild(i, transform: Matrix4.translationValues(x, y, 0));
      x += childSize.width * 0.8; // 重叠效果
      y += childSize.height * 0.2;
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => true;
}

// 带状态的页面组件（验证状态保留）
class PageWidget extends StatefulWidget {
  final String title;
  final Color color;

  PageWidget({required this.title, required this.color});

  @override
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color.withOpacity(0.3),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title, style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () => setState(() => _counter++),
              child: Text("计数: $_counter"),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    // 自定义滚动条样式
    return GlowingOverscrollIndicator(
      axisDirection: axisDirection,
      color: Colors.grey, // 设置滚动条颜色为灰色
      child: child,
    );
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // 使用 ClampingScrollPhysics 防止过度滚动
    return const ClampingScrollPhysics();
  }
}
