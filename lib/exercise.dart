import 'dart:async';
import 'package:flutter/material.dart';
import 'customWidgets.dart';
import 'startActivity.dart';
import 'sportsIcons.dart';
import 'newActivity.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';
import 'package:location/location.dart';
import 'package:haversine/haversine.dart';
import 'package:sensors/sensors.dart';

class ExerciseScreen extends StatefulWidget {
  ExerciseScreen({Key key}) : super(key: key);
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final String fileName = 'exercise.json';
  double top = 0.0;
  Map<String, dynamic> contents = {};
  Map<String, double> _currentLocation;
  Map<String, double> result;
  Map<String, double> _xLocation;

  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();
  String error;

  bool currentWidget = true;
  double _meter = 0.0;
  double _totalDistance = 0.0;
  double _strideLength = 0.7221;
  // stride length = height * 0.415(M) / height * 0.413(F)
  List<double> _userAccelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  int _steps = 0;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);

    initPlatformState();

    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (mounted) {
        setState(() {
          _userAccelerometerValues = <double>[event.x, event.y, event.z];
        });
      }
    }));

    _locationSubscription = _location.onLocationChanged.listen((result) {
      if (mounted &&
          result != _currentLocation &&
          ((_userAccelerometerValues[0] > 0.5 ||
                  _userAccelerometerValues[0] < -0.5) ||
              (_userAccelerometerValues[1] > 0.5 ||
                  _userAccelerometerValues[1] < -0.5) ||
              (_userAccelerometerValues[2] > 0.5 ||
                  _userAccelerometerValues[2] < -0.5))) {
        setState(() {
          _xLocation = _currentLocation;
          _currentLocation = result;

          _meter = (new Haversine.fromDegrees(
                  latitude1: _xLocation["latitude"],
                  longitude1: _xLocation["longitude"],
                  latitude2: _currentLocation["latitude"],
                  longitude2: _currentLocation["longitude"]))
              .distance();
          _totalDistance += _meter;
          _steps = (_totalDistance / _strideLength).round();
        });
      }
    });
  }

  initPlatformState() async {
    Map<String, double> location;

    location = await _location.getLocation;

    error = null;
    if (mounted) {
      setState(() {
        _currentLocation = location;
        _xLocation = location;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //Map<String, dynamic> contents = App.of(context).exerciseContents;
  }

  List<Activity> getActivities(Map<String, dynamic> contents) {
    List<Activity> activities = [];
    contents.forEach((key, value) {
      Package package = getPackage(key);
      Task task;
      if (package == null) task = getTask(key);
      if (task != null || package != null) {
        activities.add(
          Activity(
            package: package ?? null,
            task: task ?? null,
            completionState: getCompletionState(value),
            showNotification: showNotification,
          ),
        );
      }
    });
    return activities;
  }

  String getCompletionState(dynamic value) {
    TimeOfDay now = TimeOfDay.now();
    List<dynamic> startTimes = value[0].map((list) {
      return TimeOfDay(
        hour: list[0],
        minute: list[1],
      );
    }).toList();
    List<dynamic> endTimes = value[1].map((list) {
      return TimeOfDay(
        hour: list[0],
        minute: list[1],
      );
    }).toList();
    if (compareTime(endTimes[endTimes.length - 1], now)) {
      return 'Completed';
    } else {
      for (int i = 0; i < startTimes.length; i++) {
        if (compareTime(startTimes[i], now) && compareTime(now, endTimes[i]))
          return 'Ongoing';
        else if (i < startTimes.length - 1 &&
            compareTime(endTimes[i], now) &&
            compareTime(now, startTimes[i + 1])) return 'Pending';
      }
    }
    return 'Pending';
  }

  bool compareTime(TimeOfDay time1, TimeOfDay time2) {
    return time1.hour < time2.hour ||
        time1.hour == time2.hour && time1.minute <= time2.minute;
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
      context.ancestorStateOfType(TypeMatcher<MyHomePageState>()).context,
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
      if (day == 'Monday')
        dayOfWeek = Day.Monday;
      else if (day == 'Tuesday')
        dayOfWeek = Day.Tuesday;
      else if (day == 'Wednesday')
        dayOfWeek = Day.Wednesday;
      else if (day == 'Thursday')
        dayOfWeek = Day.Thursday;
      else if (day == 'Friday')
        dayOfWeek = Day.Friday;
      else if (day == 'Saturday')
        dayOfWeek = Day.Saturday;
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

  Widget activities(bool portrait) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    Map<String, dynamic> contents = App.of(context).exerciseContents;
    if (contents != null && contents.length > 0) {
      return Grid(
        children: getActivities(contents),
        columnCount: portrait ? 2 : 3,
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Icon(
            Icons.directions_run,
            color: darkMode ? Colors.white70 : Colors.white,
            size: 64.0,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            'Add some new exercises',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkMode ? Colors.white70 : Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    int counter = _steps;
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double height = MediaQuery.of(context).size.height;
    double windowTopPadding = MediaQuery.of(context).padding.top;
    double containerHeight = 175.0;
    return NotificationListener(
      onNotification: (v) {
        double oldTop = top;
        if (v is ScrollUpdateNotification) top += v.scrollDelta;
        if (top <= 0.0 && oldTop > 0.0 || oldTop <= 0.0 && top > 0.0)
          setState(() {});
      },
      child: Container(
        color: darkMode
            ? Colors.grey[900]
            : top <= 0.0 ? Colors.blue : Colors.blue[100],
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0.0,
                right: 0.0,
                left: 0.0,
                height: containerHeight + windowTopPadding,
                child: Container(
                  color: darkMode ? Colors.grey[900] : Colors.blue,
                ),
              ),
              Positioned(
                top: portrait
                    ? containerHeight - 1 + windowTopPadding
                    : windowTopPadding + 128.0,
                right: 0.0,
                left: 0.0,
                bottom: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        darkMode ? Colors.grey[900] : Colors.blue,
                        darkMode ? Colors.grey[900] : Colors.blue[100],
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: darkMode ? Colors.grey[900] : null,
                constraints: BoxConstraints(
                  minHeight: height - 48.0,
                ),
                padding: EdgeInsets.only(top: windowTopPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(portrait ? 16.0 : 72.0, 24.0,
                          portrait ? 16.0 : 72.0, 12.0),
                      child: const Text(
                        'Exercise',
                        style: TextStyle(
                          height: 1.2,
                          color: Colors.white,
                          fontFamily: 'Renner*',
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(portrait ? 16.0 : 72.0, 16.0,
                          portrait ? 16.0 : 72.0, 24.0),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            SportsIcons.footsteps,
                            size: 64.0,
                            color: Colors.white,
                            semanticLabel: 'Footstep',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '$counter',
                                  style: const TextStyle(
                                    fontFamily: 'Renner*',
                                    color: Colors.white,
                                    fontSize: 56.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  counter == 1 ? ' STEP' : ' STEPS',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: portrait ? height / 2 : height / 4,
                      ),
                      padding: EdgeInsets.fromLTRB(portrait ? 4.0 : 68.0, 4.0,
                          portrait ? 4.0 : 68.0, 32.0),
                      child: activities(portrait),
                    ),
                    const SizedBox(),
                    const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Activity extends StatelessWidget {
  const Activity({
    this.package,
    this.task,
    @required this.completionState,
    this.showNotification,
  });
  final Package package;
  final Task task;
  final String completionState;
  final Function showNotification;
  @override
  Widget build(BuildContext context) {
    IconData iconData;
    String name;
    if (task != null) {
      iconData = task.icon;
      name = task.name;
    } else {
      iconData = package.icon;
      name = package.name;
    }
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double width =
        portrait ? (screenWidth - 24.0) / 2 : (screenWidth - 160.0) / 3;
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Container(
      height: width / (portrait ? 1.1 : 1.05),
      width: width,
      margin: const EdgeInsets.all(4.0),
      child: RaisedButton(
        elevation: darkMode ? 0.0 : 2.0,
        highlightElevation: darkMode ? 0.0 : 8.0,
        color: darkMode ? Colors.grey[850] : Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        onPressed: () async {
          dynamic value = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StartActivityScreen(
                    task: task ?? null,
                    package: package ?? null,
                  ),
            ),
          );
          if (value != null) {
            if (value[1] == 'Weekly') {
              assert(value.length > 4);
              showNotification(
                  value[2][0][0], value[2][0][1], value[0], false, 0, value[4]);
              showNotification(
                  value[3][0][0], value[3][0][1], value[0], true, 1, value[4]);
            } else {
              for (int i = 0; i < value[2].length; i++) {
                showNotification(
                    value[2][i][0], value[2][i][1], value[0], false, i);
                showNotification(value[3][i][0], value[3][i][1], value[0], true,
                    i + value[2].length);
              }
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 64.0,
                width: 64.0,
                child: Hero(
                  tag: name + (isIos ? 'iosSucks' : 'a'),
                  child: FittedBox(
                    child: Icon(
                      iconData,
                      color: darkMode ? Colors.lightBlue : Colors.blue,
                    ),
                  ),
                ),
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.2,
                  fontFamily: 'Renner*',
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Transform.translate(
                offset: const Offset(0.0, -6.0),
                child: CompletionState(completionState),
              ),
            ],
          ),
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
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    Color color;
    IconData iconData;
    if (completionState == 'Completed') {
      color = darkMode ? Colors.green[400] : Colors.green;
      iconData = Icons.check_circle;
    } else if (completionState == 'Pending') {
      color = darkMode ? Colors.purple[300] : Colors.purple;
      iconData = Icons.timer;
    } else if (completionState == 'Ongoing') {
      color = darkMode ? Colors.lightBlue : Colors.blue;
      iconData = Icons.access_time;
    } else {
      color = darkMode ? Colors.redAccent[200] : Colors.red;
      iconData = Icons.warning;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          iconData,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            completionState,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
