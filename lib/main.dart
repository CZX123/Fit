import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
        accentColor: Colors.limeAccent,
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
      body: _homePage ? new Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: const Alignment(0.0, -1.0),
            end: const Alignment(0.0, 0.6),
            colors: <Color>[
              const Color(0xFF2196F3),
              const Color(0x112196F3)
            ],
          ),
        ),
        child: new CustomScrollView(
          slivers: <Widget>[
            new SliverPadding(
              padding: new EdgeInsets.all(16.0),
              sliver: new SliverToBoxAdapter(
                child: new Column(
                  children: <Widget>[
                    new Text(
                      '$_counter',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 56.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    new Text(
                      _counter == 1 ? 'Step' : 'Steps',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 36.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new SliverPadding(
              padding: new EdgeInsets.all(8.0),
              sliver: new SliverGrid.count(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: <Widget>[
                  new Activity(
                    image: new AssetImage('assets/icons/pushup.webp'),
                    name: 'Push Ups',
                    completionState: 'Completed',
                    onPressed: () {},
                  ),
                  new Activity(
                    image: new AssetImage('assets/icons/cycling.webp'),
                    name: 'Cycling',
                    completionState: 'Pending',
                    onPressed: () {},
                  ),
                  new Activity(
                    image: new AssetImage('assets/icons/running.webp'),
                    name: 'Running',
                    completionState: 'Incomplete',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ) : new Center(
        child: new Text("You're Fat"),
      ),
      floatingActionButton: (_homePage) ? new FloatingActionButton(
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
        currentIndex: (_homePage) ? 0 : 1,
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

class Activity extends StatelessWidget {
  const Activity({
    this.icon: const Icon(Icons.help),
    this.image,
    @required this.name,
    @required this.completionState,
    @required this.onPressed,
  });
  final Icon icon;
  final ImageProvider<dynamic> image;
  final String name;
  final String completionState;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      color: Colors.white,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.all(
          const Radius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
      child: new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            (image != null)
              ? new Image(
                  height: 64.0,
                  image: image,
                )
              : new IconTheme(
                data: new IconThemeData(
                  size: 64.0,
                  color: Colors.blue,
                ),
                child: icon,
                ),
            new Text(
              name,
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.black87,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                ),
            ),
            new CompletionState(completionState),
          ],
        ),
      ),
    );
  }
}

class CompletionState extends StatelessWidget {
  const CompletionState(this.completionState);
  final String completionState;
  @override
  Widget build(BuildContext context) {
    if (completionState == 'Completed') {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconTheme(
            data: new IconThemeData(
              color: Colors.green,
            ),
            child: new Icon(Icons.check_circle),
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: new Text(
              'Completed',
              style: new TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        ],
      );
    }
    else if (completionState == 'Pending') {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconTheme(
            data: new IconThemeData(
              color: Colors.purple,
            ),
            child: new Icon(Icons.timer),
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: new Text(
              'Pending',
              style: new TextStyle(
                color: Colors.purple,
              ),
            ),
          ),
        ],
      );
    }
    else {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new IconTheme(
            data: new IconThemeData(
              color: Colors.red,
            ),
            child: new Icon(Icons.warning),
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: new Text(
              'Incomplete',
              style: new TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    }
  }
}
