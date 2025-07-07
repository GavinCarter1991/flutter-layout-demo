import 'package:flutter/material.dart';
import 'package:flutter_application_1/show.dart';

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
      routes: {
        '/home': (context) => const MyHomePage(title: ''),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/show') {
          dynamic args = settings.arguments; // 自定义对象参数
          return MaterialPageRoute(
            builder: (context) => Show(data: args),
          );
        }
        return null;
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _getBody(context),
    );
  }

  Widget _getBody(BuildContext context) {
    var array = [
      'Container',
      'Row',
      'Column',
      'Stack',
      'Expanded',
      'Flexible',
      'Wrap',
      'ListView',
      'GridView',
      'Flex',
      'Flow',
      'Table',
      'CustomScrollView',
      'IndexedStack',
      'ListBody',
      'Padding',
      'Align',
      'Center',
      'AspectRatio',
      'ConstrainedBox',
      'UnconstrainedBox',
      'SizedBox',
      'FractionallySizedBox',
      'Transform',
      'Baseline',
      'FittedBox',
      'OverflowBox',
      'LimitedBox',
      'IntrinsicWidth/Height',
      'CustomSingleChildLayout',
      'CustomMultiChildLayout',
      'Placeholder',
      'Spacer',
      'Positioned',
      'PositionedDirectional',
      'SingleChildScrollView',
      'PageView',
      'Scrollbar',
      'RefreshIndicator',
      'DraggableScrollableSheet',
      'NestedScrollView',
      'ScrollConfiguration',
      'SliverList',
      'SliverGrid',
      'SliverAppBar',
      'SliverPadding',
      'SliverToBoxAdapter',
      'SliverFillRemaining',
      'SliverPersistentHeader',
      'LayoutBuilder',
      'OrientationBuilder',
      'MediaQuery',
      'AspectRatio',
      'SafeArea',
      'PlatformView',
      'Offstage',
      'Visibility',
      'IgnorePointer',
      'AbsorbPointer',
    ];
    return ListView.builder(
      itemCount: array.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/show',
              arguments: {'data': array[index]}, // 参数以 Map 形式传递
            );
          }, // 点击回调
          child: ListTile(
            title: Text(array[index]),
          ),
        );
      },
    );
  }
}
