import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'exercise.dart';
import 'diet.dart';
import 'newActivity.dart';
import 'settings.dart';
import 'startActivity.dart';
import 'fileManager.dart';
import 'steps.dart';

void main() {
  MaterialPageRoute.debugEnableFadingRoutes = true;
  runApp(App());
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
  Brightness brightness = Brightness.light;
  Color primaryColor = Colors.grey[200];
  Color accentColor = Colors.deepOrangeAccent;
  Map<String, dynamic> exerciseContents = {};
  Map<String, dynamic> dietContents = {};

  @override
  void initState() {
    super.initState();
    _loadBrightness().then((darkMode) {
      if (darkMode) {
        setState(() {
          brightness = Brightness.dark;
          primaryColor = Colors.grey[800];
          accentColor = Colors.limeAccent;
        });
      }
    });
    _loadContents().then((list) {
      bool hasExercises = list[0] != null && list[0].length > 0;
      bool hasDiet = list[1] != null && list[1].length > 0;
      if (hasExercises || hasDiet) {
        setState(() {
          if (hasExercises) exerciseContents = list[0];
          if (hasDiet) dietContents = list[1];
        });
      }
    });
  }

  void update() {
    setState(() {});
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

  void changeExercises(Map<String, dynamic> contents) {
    setState(() {
      exerciseContents = contents;
    });
  }

  void changeDiet(Map<String, dynamic> contents) {
    setState(() {
      dietContents = contents;
    });
  }

  Future<bool> _loadBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(_key) ?? false);
  }

  Future<List<Map<String, dynamic>>> _loadContents() async {
    return [
      await FileManager.readFile('exercise.json'),
      await FileManager.readFile('diet.json')
    ];
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
          primaryColorBrightness: Brightness.dark,
          accentColor: accentColor,
        ),
        home: MyHomePage(),
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
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 3);
    controller.addListener(changeScreen);
    var initializationSettingsAndroid = AndroidInitializationSettings('icon');
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

  bool isPackage(String name) {
    bool boolean = false;
    packageList.forEach((package) {
      if (package.name == name) boolean = true;
    });
    return boolean;
  }

  Package getPackage(String name) {
    Package data;
    packageList.forEach((package) {
      if (package.name == name) data = package;
    });
    return data;
  }

  Task getTask(String name) {
    Task data;
    allTasks.forEach((task) {
      if (task.name == name) data = task;
    });
    return data;
  }

  int getId(String name, int number) {
    int id, totalNo = packageList.length + allTasks.length;
    for (int i = 0; i < packageList.length; i++) {
      if (packageList[i].name == name) id = i;
    }
    if (id != null) return id + number * totalNo;
    for (int j = 0; j < allTasks.length; j++) {
      if (allTasks[j].name == name) id = packageList.length + j;
    }
    return id + number * totalNo;
  }

  Future onSelectNotification(String payload) async {
    Package package = getPackage(payload);
    Task task;
    if (package == null) task = getTask(payload);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartActivityScreen(
              package: package ?? null,
              task: task ?? null,
            ),
      ),
    );
  }

  Future showNotification(
      int hour, int minute, String name, bool late, int number,
      [String day]) async {
    Time time = Time(hour, minute, 0);
    if (!late && minute < 20)
      time = Time(hour > 0 ? hour - 1 : 23, 40 + minute, 0);
    else if (!late) time = Time(hour, minute - 20, 0);
    var bigTextStyleInformation = BigTextStyleInformation(
      late
          ? 'You missed your $name exercise. But better late than never!'
          : 'Your $name exercise will begin in 20 mins!',
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      name,
      name,
      'Notification for $name exercise',
      color: Colors.blue,
      importance: Importance.Max,
      priority: Priority.High,
      style: AndroidNotificationStyle.BigText,
      styleInformation: bigTextStyleInformation,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    if (day == null) {
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          getId(name, number),
          late ? 'Oh No!' : 'Heads Up!',
          late
              ? 'You missed your $name exercise. But better late than never!'
              : 'Your $name exercise will begin in 20 mins!',
          time,
          platformChannelSpecifics,
          payload: name);
    } else {
      Day dayOfWeek;
      if (day == 'Monday') dayOfWeek = Day.Monday;
      else if (day == 'Tuesday') dayOfWeek = Day.Tuesday;
      else if (day == 'Wednesday') dayOfWeek = Day.Wednesday;
      else if (day == 'Thursday') dayOfWeek = Day.Thursday;
      else if (day == 'Friday') dayOfWeek = Day.Friday;
      else if (day == 'Saturday') dayOfWeek = Day.Saturday;
      else if (day == 'Sunday') dayOfWeek = Day.Sunday;
      if (!late && time.hour == 23 && time.minute > 39) {
        for (int i = 0; i < 7; i++) {
          if (dayOfWeek == Day(i + 1)) dayOfWeek = Day(i == 0 ? 7 : i);
        }
      }
      await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
          getId(name, number),
          late ? 'Oh No!' : 'Heads Up!',
          late
              ? 'You missed your $name exercise. But better late than never!'
              : 'Your $name exercise will begin in 20 mins!',
          dayOfWeek,
          time,
          platformChannelSpecifics,
          payload: name);
    }
  }

  void changeScreen() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
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
              backgroundColor:
                  darkMode ? Colors.grey[800] : Colors.deepOrangeAccent,
              onPressed: () async {
                dynamic value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewActivityScreen(),
                    ));
                if (value != null) {
                  if (value[1] == 'Weekly') {
                    assert(value.length > 4);
                    showNotification(value[2][0][0], value[2][0][1], value[0],
                        false, 0, value[4]);
                    showNotification(value[3][0][0], value[3][0][1], value[0],
                        true, 1, value[4]);
                  } else {
                    for (int i = 0; i < value[2].length; i++) {
                      showNotification(
                          value[2][i][0], value[2][i][1], value[0], false, i);
                      showNotification(
                          value[3][i][0], value[3][i][1], value[0], true, i + value[2].length);
                    }
                  }
                }
              },
              tooltip: 'New Activity',
              child: Icon(
                Icons.add,
                color: darkMode ? Colors.limeAccent : Colors.white,
              ),
            )
          : null,
      bottomNavigationBar: Material(
        color: darkMode ? Colors.grey[850] : Colors.white,
        elevation: 8.0,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 0.0
                      : 72.0),
          child: TabIcons(
            controller: controller,
          ),
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
