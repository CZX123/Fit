import 'dart:async' show Future;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'exercise.dart';
import 'diet.dart';
import 'newActivity.dart';
import 'settings.dart';
import 'startActivity.dart';

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
        primarySwatch: brightness == Brightness.dark ? Colors.lightBlue : Colors.blue,
        brightness: brightness,
        accentColor: Colors.deepOrangeAccent,
      ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          debugShowCheckedModeBanner: false,
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int _counter = 500;
  int index = 0;
  TabController controller;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
    controller = new TabController(vsync: this, length: 3);
    controller.addListener(changeScreen);
  }

  @override
  void dispose() {
    controller.removeListener(changeScreen);
    controller.dispose();
    super.dispose();
  }

  void changeScreen() {
    index = controller.index;
    bool darkMode = Theme.of(context).brightness == Brightness.dark;
    if (index == 0 && !darkMode) changeColor(Colors.blue, Colors.deepOrangeAccent);
    else if (index == 0) changeColor(Colors.grey[900], Colors.deepOrangeAccent);
    else if (index == 1 && !darkMode) changeColor(Colors.green, Colors.limeAccent);
    else if (index == 1) changeColor(Colors.grey[900], Colors.limeAccent[700]);
    else if (index == 2 && !darkMode) changeColor(Colors.blueGrey, Colors.blueGrey);
    else changeColor(Colors.grey[900], Colors.blueGrey);
  }

  void changeColor(Color primaryColor, Color accentColor) {
    DynamicTheme.of(context).setThemeData(new ThemeData(
      brightness: Theme.of(context).brightness,
      primaryColor: primaryColor,
      accentColor: accentColor,
    ));
  }

  Future onSelectNotification(String payload) async {
    Activity selectedActivity;
    activeActivityList.forEach((activity) {
      if (activity.name == payload) selectedActivity = activity;
    });
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new StartActivityScreen(
        name: selectedActivity.name,
        icon: selectedActivity.icon,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.lightBlue : Colors.blue,
      )),
    );
  }

  Future showNotification(String name, bool late) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'id',
      'name',
      'description',
      color: Colors.blue,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, late ? 'Oh No!' : 'Heads Up!', late ? 'You missed your $name exercise. But better late than never!' : 'Your $name exercise will begin in 20 mins!', platformChannelSpecifics,
        payload: name);
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

      floatingActionButton: index == 0 ? new FloatingActionButton(
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
      ) : new FloatingActionButton(
        onPressed: () {
          showNotification('Cycling', false);
        },
        child: new Icon(Icons.notifications_active),
      ),
      bottomNavigationBar: new Material(
        color: darkMode ? Colors.grey[850] : Colors.white,
        elevation: 8.0,
        child: new TabIcons(
          controller: controller,
        ),
      ),
    );
  }
}

class TabIcons extends StatefulWidget {
  TabIcons({Key key, this.controller}) : super(key: key);
  final TabController controller;
  _TabIconsState createState() => new _TabIconsState();
}

class _TabIconsState extends State<TabIcons> {
  int _currentIndex = 0;
  int _previousIndex = 0;
  double _offset = 0.0;
  bool _indexIsChanging = false;

  void updateScrollValues() {
    setState(() {
      _indexIsChanging = widget.controller.indexIsChanging;
      _currentIndex = widget.controller.index;
      _previousIndex = widget.controller.previousIndex;
      _offset = widget.controller.offset;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.animation.addListener(updateScrollValues);
  }

  @override
  void dispose() {
    widget.controller.animation.removeListener(updateScrollValues);
    super.dispose();
  }

  Widget tabIcon(IconData icon, int index, Color color) {
    Color iconColor;
    Color inactiveColor = Theme.of(context).brightness == Brightness.dark ? Colors.grey[600] : Colors.grey[400];
    // if it is a tap, this is always true, as currentIndex immiediately switches to index
    if (_offset.abs() > 1.0) _offset = 1.0;
    if (_currentIndex == index) {
      iconColor = Color.lerp(color, inactiveColor, _offset.abs());
    }
    // Detect if user is tapping
    else if (_indexIsChanging) {
      if (_previousIndex == index) {
        iconColor = Color.lerp(inactiveColor, color, _offset.abs());
      }
      else {
        iconColor = inactiveColor;
      }
    }
    // Swiping right or left
    else if (index == _currentIndex + 1 && _offset > 0.0 || index == _currentIndex - 1 && _offset < 0.0) {
      iconColor = Color.lerp(inactiveColor, color, _offset.abs());
    }
    else {
      iconColor = inactiveColor;
    }
    return new Icon(
      icon,
      color: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return new TabBar(
      indicator: new BoxDecoration(),
      controller: widget.controller,
      tabs: <Widget>[
        new Tab(
          icon: tabIcon(Icons.directions_run, 0, darkMode ? Colors.lightBlue : Colors.blue),
        ),
        new Tab(
          icon: tabIcon(Icons.restaurant_menu, 1, darkMode ? Colors.green : Colors.green),
        ),
        new Tab(
          icon: tabIcon(Icons.settings, 2, darkMode ? Colors.deepOrange : Colors.blueGrey),
        ),
      ],
    );
  }
}
