import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'exercise.dart';
import 'diet.dart';
import 'newActivity.dart';

void main() {
  MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fit',
      theme: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        accentColor: Colors.deepOrangeAccent,
      ),
      home: new MyHomePage(title: 'Fit'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 500;
  int _currentIndex = 0;
  double _offset = 0.0;
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
    controller.animation.addListener(updateScrollValues);
  }

  @override
  void dispose() {
    controller.animation.removeListener(updateScrollValues);
    controller.dispose();
    super.dispose();
  }

  void updateScrollValues() {
    setState(() {
      _currentIndex = controller.index;
      _offset = controller.offset;
      print(_offset);
    });
  }

  Widget tabIcon(IconData icon, int index, Color color) {
    return new Icon(
      icon,
      color:
        (_currentIndex == index)
          ? Color.lerp(color, Colors.grey, _offset.abs())
          : Color.lerp(Colors.grey, color, _offset.abs()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: new Container(
        color: Colors.grey[100],
        child: new TabBarView(
          controller: controller,
          children: <Widget>[
            new ExerciseScreen(counter: _counter),
            new DietScreen(),
          ],
        ),
      ),

      floatingActionButton: (_currentIndex == 0 && _offset == 0.0) ? new FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new NewActivityScreen()
            )
          );
        },
        tooltip: 'New Activity',
        child: new Icon(Icons.add),
      ) : null,

      bottomNavigationBar: new Material(
        color: Colors.white,
        elevation: 8.0,
        child: new TabBar(
          indicatorColor: (_currentIndex == 0)
            ? Color.lerp(Colors.blue, Colors.green, _offset.abs())
            : Color.lerp(Colors.green, Colors.blue, _offset.abs()),
          controller: controller,
          tabs: <Widget>[
            new Tab(
              icon: tabIcon(Icons.directions_run, 0, Colors.blue),
            ),
            new Tab(
              icon: tabIcon(Icons.fastfood, 1, Colors.green),
            ),
          ],
        ),
      )
    );
  }
}
