import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'exercise.dart';
import 'diet.dart';
import 'newActivity.dart';
import 'settings.dart';
import './data/theme.dart';

void main() {
  MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fit',
      theme: themeList[0],
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
  int _previousIndex = 0;
  double _offset = 0.0;
  bool _indexIsChanging = false;
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
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
      _indexIsChanging = controller.indexIsChanging;
      _currentIndex = controller.index;
      _previousIndex = controller.previousIndex;
      _offset = controller.offset;
    });
  }

  Widget tabIcon(IconData icon, int index, Color color) {
    Color iconColor;
    // if it is a tap, this is always true, as currentIndex immiediately switches to index
    if (_offset.abs() > 1.0) _offset = 1.0;
    if (_currentIndex == index) {
      iconColor = Color.lerp(color, Colors.grey, _offset.abs());
    }
    // Detect if user is tapping
    else if (_indexIsChanging) {
      if (_previousIndex == index) {
        iconColor = Color.lerp(Colors.grey, color, _offset.abs());
      }
      else {
        iconColor = Colors.grey;
      }
    }
    // Swiping right or left
    else if (index == _currentIndex + 1 && _offset > 0.0 || index == _currentIndex - 1 && _offset < 0.0) {
      iconColor = Color.lerp(Colors.grey, color, _offset.abs());
    }
    else {
      iconColor = Colors.grey;
    }
    return new Icon(
      icon,
      color: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    double _value = _offset + _currentIndex;
    return new Theme(
      data: themeList[0],
      child: new Scaffold(

        body: new Container(
          color: Colors.grey[50],
          child: new TabBarView(
            controller: controller,
            children: <Widget>[
              new ExerciseScreen(counter: _counter),
              new DietScreen(),
              new SettingsScreen(),
            ],
          ),
        ),

        floatingActionButton: (_currentIndex == 0 && _offset == 0.0) ? new FloatingActionButton(
          // onPressed: _incrementCounter,
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new NewActivityScreen(),
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
            indicatorColor:
              (0.0 <= _value && _value <= 1.0)
              ? Color.lerp(Colors.blue, Colors.green, _value)
              : Color.lerp(Colors.green, Colors.blueGrey, _value - 1.0),
            controller: controller,
            tabs: <Widget>[
              new Tab(
                icon: tabIcon(Icons.directions_run, 0, Colors.blue),
                //icon: new Icon(Icons.directions_run),
              ),
              new Tab(
                icon: tabIcon(Icons.fastfood, 1, Colors.green),
                //icon: new Icon(Icons.fastfood),
              ),
              new Tab(
                icon: tabIcon(Icons.settings, 2, Colors.blueGrey),
                //icon: new Icon(Icons.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
