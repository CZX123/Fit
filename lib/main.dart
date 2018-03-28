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
        accentColor: Colors.pinkAccent,
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
      body: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
        child: new Column(
        // Column is also layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug paint" (press "p" in the console where you ran
        // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
        // window in IntelliJ) to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        children: <Widget>[
          new Text(
            '$_counter',
            style: Theme.of(context).textTheme.display3,
          ),
          new Padding(
            padding: new EdgeInsets.only(bottom: 16.0),
            child: new Text(
              'Steps',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
          new Card(
            child: new Column(
              children: <Widget>[
                new Padding(
                padding: new EdgeInsets.symmetric(vertical: 16.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new IconTheme(
                          data: new IconThemeData(
                            color: Colors.grey,
                            size: 64.0
                          ),
                          child: new Icon(Icons.directions_walk),
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text('15', style: new TextStyle(fontSize: 36.0),),
                            new Text('pushups everyday')
                          ],
                        ),
                      ],
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(right: 32.0),
                      child: new Text('START', style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                ),
                new Divider(height: 2.0,),
                new Padding(
                  padding: new EdgeInsets.all(12.0),
                  child: new Row(
                    children: <Widget>[
                      new Icon(Icons.check, color: Colors.green),
                      new Padding(
                        padding: new EdgeInsets.only(left: 12.0),
                        child: new Text(
                          'Completed',
                          style: new TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
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
