import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'exercise.dart';
import 'diet.dart';
import 'newActivity.dart';
import 'settings.dart';
import 'startActivity.dart';
import './data/newActivityList.dart';

void main() {
  MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(
    App(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      accentColor: Colors.deepOrangeAccent,
      child: MyHomePage(),
    ),
  );
}

class _InheritedApp extends InheritedWidget {
  final AppState data;
  _InheritedApp({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);
  @override
  bool updateShouldNotify(_InheritedApp old) => true;
}

class App extends StatefulWidget {
  final Widget child;
  final Brightness brightness;
  final Color primaryColor;
  final Color accentColor;

  App({
    @required this.child,
    @required this.brightness,
    @required this.primaryColor,
    @required this.accentColor,
  });

  static AppState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedApp)
            as _InheritedApp)
        .data;
  }

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  final String _key = 'darkMode';
  Brightness brightness;
  Color primaryColor;
  Color accentColor;

  @override
  void initState() {
    super.initState();
    brightness = widget.brightness;
    primaryColor = widget.primaryColor;
    accentColor = widget.accentColor;
    _loadBrightness().then((darkMode) {
      setState(() {
        brightness = darkMode ? Brightness.dark : Brightness.light;
      });
    });
  }

  void changeColors(Color newPrimaryColor, Color newAccentColor) {
    setState(() {
      primaryColor = newPrimaryColor;
      accentColor = newAccentColor;
    });
  }

  void changeBrightness(Brightness newBrightness) async {
    setState(() {
      brightness = newBrightness;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, brightness == Brightness.dark);
  }

  Future<bool> _loadBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(_key) ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedApp(
      data: this,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fit',
        theme: ThemeData(
          brightness: brightness,
          primaryColor: primaryColor,
          accentColor: accentColor,
        ),
        home: widget.child,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int index = 0;
  TabController controller;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 3);
    controller.addListener(changeScreen);
    var initializationSettingsAndroid =
        AndroidInitializationSettings('icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
  }

  @override
  void dispose() {
    controller.removeListener(changeScreen);
    controller.dispose();
    super.dispose();
  }

  IconData getIconFromName(String name) {
    IconData iconData;
    packageList.forEach((package) {
      if (package.name == name) iconData = package.icon;
    });
    if (iconData != null) return iconData;
    allTasks.forEach((task) {
      if (task.name == name) iconData = task.icon;
    });
    return iconData;
  }

  int getId(String name) {
    int id;
    for (int i = 0; i < packageList.length; i++) {
      if (packageList[i].name == name) id = i;
    }
    if (id != null) return id;
    for (int j = 0; j < allTasks.length; j++) {
      if (allTasks[j].name == name) id = packageList.length + j;
    }
    return id;
  }

  Future onSelectNotification(String payload) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartActivityScreen(
              name: payload,
              icon: getIconFromName(payload),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.lightBlue
                  : Colors.blue,
            ),
      ),
    );
  }

  Future showNotification(String name, bool late) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      name,
      name,
      'Notification for $name exercise',
      color: Colors.blue,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        getId(name),
        late ? 'Oh No!' : 'Heads Up!',
        late
            ? 'You missed your $name exercise. But better late than never!'
            : 'Your $name exercise will begin in 20 mins!',
        platformChannelSpecifics,
        payload: name);
  }

  void changeScreen() {
    index = controller.index;
    bool darkMode = Theme.of(context).brightness == Brightness.dark;
    if (index == 0 && !darkMode)
      changeColor(Colors.blue, Colors.deepOrangeAccent);
    else if (index == 0)
      changeColor(Colors.grey[900], Colors.deepOrangeAccent);
    else if (index == 1 && !darkMode)
      changeColor(Colors.green, Colors.limeAccent);
    else if (index == 1)
      changeColor(Colors.grey[900], Colors.limeAccent[700]);
    else if (index == 2 && !darkMode)
      changeColor(Colors.blueGrey, Colors.blueGrey);
    else
      changeColor(Colors.grey[900], Colors.blueGrey);
  }

  void changeColor(Color newPrimaryColor, Color newAccentColor) {
    App.of(context).changeColors(newPrimaryColor, newAccentColor);
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        color: Colors.grey[50],
        child: TabBarView(
          controller: controller,
          children: <Widget>[
            ExerciseScreen(),
            DietScreen(),
            SettingsScreen(),
          ],
        ),
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton(
              onPressed: () async {
                String value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      maintainState: true,
                      builder: (context) => NewActivityScreen(),
                    ));
                if (value != null) {
                  showNotification(value, false);
                }
              },
              tooltip: 'New Activity',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: Material(
        color: darkMode ? Colors.grey[850] : Colors.white,
        elevation: 8.0,
        child: TabIcons(
          controller: controller,
        ),
      ),
    );
  }
}

class TabIcons extends StatefulWidget {
  TabIcons({Key key, this.controller}) : super(key: key);
  final TabController controller;
  _TabIconsState createState() => _TabIconsState();
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
    Color inactiveColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[600]
        : Colors.grey[400];
    // if it is a tap, this is always true, as currentIndex immiediately switches to index
    if (_offset.abs() > 1.0) _offset = 1.0;
    if (_currentIndex == index) {
      iconColor = Color.lerp(color, inactiveColor, _offset.abs());
    }
    // Detect if user is tapping
    else if (_indexIsChanging) {
      if (_previousIndex == index) {
        iconColor = Color.lerp(inactiveColor, color, _offset.abs());
      } else {
        iconColor = inactiveColor;
      }
    }
    // Swiping right or left
    else if (index == _currentIndex + 1 && _offset > 0.0 ||
        index == _currentIndex - 1 && _offset < 0.0) {
      iconColor = Color.lerp(inactiveColor, color, _offset.abs());
    } else {
      iconColor = inactiveColor;
    }
    return Icon(
      icon,
      color: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return TabBar(
      indicator: const BoxDecoration(),
      controller: widget.controller,
      tabs: <Widget>[
        Tab(
          icon: tabIcon(Icons.directions_run, 0,
              darkMode ? Colors.lightBlue : Colors.blue),
        ),
        Tab(
          icon: tabIcon(
              Icons.restaurant, 1, darkMode ? Colors.green[400] : Colors.green),
        ),
        Tab(
          icon: tabIcon(Icons.settings, 2,
              darkMode ? Colors.deepOrange : Colors.blueGrey),
        ),
      ],
    );
  }
}
