import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'exercise.dart';
import 'diet.dart';
import 'newActivity.dart';
import 'settings.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.blue,
        brightness: brightness,
        accentColor: Colors.deepOrangeAccent,
      ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          title: 'Fit',
          theme: theme,
          home: new MyHomePage(title: 'Fit'),
        );
      }
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
    controller.addListener(changeScreen);
  }

  @override
  void dispose() {
    controller.animation.removeListener(updateScrollValues);
    controller.removeListener(changeScreen);
    controller.dispose();
    super.dispose();
  }

  void changeScreen() {
    int index = controller.index;
    if (index == 0) changeColor(Colors.blue, Colors.deepOrangeAccent);
    else if (index == 1) changeColor(Colors.green, Colors.amberAccent);
    else changeColor(Colors.blueGrey, Colors.blueGrey);
  }

  void updateScrollValues() {
    setState(() {
      _indexIsChanging = controller.indexIsChanging;
      _currentIndex = controller.index;
      _previousIndex = controller.previousIndex;
      _offset = controller.offset;
    });
  }

  void changeColor(Color primaryColor, Color accentColor) {
    DynamicTheme.of(context).setThemeData(new ThemeData(
      brightness: Theme.of(context).brightness,
      primaryColor: primaryColor,
      accentColor: accentColor,
    ));
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
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return new Scaffold(
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
        color: darkMode ? Colors.grey[850] : Colors.white,
        elevation: 8.0,
        child: new TabBar(
          indicator: new BoxDecoration(),
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
    );
  }
}
