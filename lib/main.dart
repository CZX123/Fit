import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './exercise.dart';
import './diet.dart';
import './newTask.dart';
import './settings.dart';

void main() => runApp(new MyApp());

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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 500;
  bool _homePage = true;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _determineHomePage(int index) {
    setState(() {
      (index == 0) ? _homePage = true : _homePage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new SettingsScreen(),
                )
              );
            },
          ),
        ],
      ),
      body: _homePage
        ? new ExerciseScreen(
          counter: _counter,
          orientation: orientation,
        )
        : new DietScreen(
          orientation: orientation,
        ),
      floatingActionButton: _homePage ? new FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new NewTaskScreen()
            )
          );
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ) : null,
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _homePage ? 0 : 1,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new Icon(Icons.directions_run),
            title: new Text('Exercise')
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.fastfood),
            title: new Text('Diet'),
          ),
        ],
        onTap: _determineHomePage,
      )
    );
  }
}
