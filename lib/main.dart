import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fit',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
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
  int _counter = 0;

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
            onPressed: () {}
          ),
        ],
      ),
      body: new Container(
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
                  new RaisedButton(
                    color: Colors.white,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.all(
                        const Radius.circular(8.0),
                      ),
                    ),
                    onPressed: () {},
                    child: new Container(
                      padding: new EdgeInsets.all(8.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new IconTheme(
                            data: new IconThemeData(
                              size: 64.0,
                              color: Colors.blue,
                            ),
                            child: new Icon(Icons.directions_run),
                          ),
                          new Text(
                            'Running',
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.black87,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                              ),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new IconTheme(
                                data: new IconThemeData(
                                  color: Colors.green,
                                ),
                                child: new Icon(Icons.check),
                              ),
                              new Text(
                                ' Completed',
                                style: new TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  new RaisedButton(
                    color: Colors.white,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.all(
                        const Radius.circular(8.0),
                      ),
                    ),
                    onPressed: () {},
                    child: new Container(
                      padding: new EdgeInsets.all(8.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new IconTheme(
                            data: new IconThemeData(
                              size: 64.0,
                              color: Colors.blue,
                            ),
                            child: new Icon(Icons.directions_walk),
                          ),
                          new Text(
                            'Random',
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.black87,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                              ),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new IconTheme(
                                data: new IconThemeData(
                                  color: Colors.purple,
                                ),
                                child: new Icon(Icons.timer),
                              ),
                              new Text(
                                ' Pending',
                                style: new TextStyle(
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  new RaisedButton(
                    color: Colors.white,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.all(
                        const Radius.circular(8.0),
                      ),
                    ),
                    onPressed: () {},
                    child: new Container(
                      padding: new EdgeInsets.all(8.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new IconTheme(
                            data: new IconThemeData(
                              size: 64.0,
                              color: Colors.blue,
                            ),
                            child: new Icon(Icons.directions_walk),
                          ),
                          new Text(
                            'Random',
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.black87,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                              ),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new IconTheme(
                                data: new IconThemeData(
                                  color: Colors.red,
                                ),
                                child: new Icon(Icons.warning),
                              ),
                              new Text(
                                ' Incomplete',
                                style: new TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: new BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new Icon(Icons.directions_run),
            title: new Text('Exercise')
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.fastfood),
            title: new Text('Diet')
          ),
        ],
      )
    );
  }
}
