import 'dart:math';
import 'package:flutter/material.dart';
import 'main.dart' show App;
import 'picker.dart' show CupertinoPicker;
import 'fileManager.dart' show FileManager;
import 'addActivity.dart' show AddActivityScreen;
import 'customWidgets.dart' show FadingPageRoute;
import 'newActivity.dart';
import 'customExpansionPanel.dart';

class ExpansionPanelItem {
  ExpansionPanelItem({this.isExpanded, this.header, this.body, this.icon});
  bool isExpanded;
  final String header;
  final Widget body;
  final IconData icon;
}

class StartActivityScreen extends StatefulWidget {
  StartActivityScreen({
    this.package,
    this.task,
    Key key,
  }) : super(key: key);
  final Package package;
  final Task task;
  _StartActivityScreenState createState() => _StartActivityScreenState();
}

class _StartActivityScreenState extends State<StartActivityScreen> {
  String name;
  IconData iconData;
  List<Task> packageTasks;
  List<ExpansionPanelItem> items = [];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      name = widget.task.name;
      iconData = widget.task.icon;
    } else {
      name = widget.package.name;
      iconData = widget.package.icon;
      packageTasks = widget.package.packageTasks;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.package != null && packageTasks != null && items.length == 0) {
      for (int i = 0; i < packageTasks.length; i++) {
        items.add(
          ExpansionPanelItem(
            isExpanded: i == 0,
            header: packageTasks[i].name,
            icon: packageTasks[i].icon,
            body: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: timer(name, i, true),
            ),
          ),
        );
      }
    }
  }

  Widget timer(String name, int index, [bool isPackage]) {
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SizedBox(
      width: portrait
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.height,
      child: TimeTab(
        name: name,
        index: index,
        isPackage: isPackage ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    if (widget.task != null || packageTasks == null)
      return Scaffold(
        backgroundColor: darkMode ? Colors.grey[900] : Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              0.0, MediaQuery.of(context).padding.top + 4.0, 0.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: BackButton(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 16.0),
                    child: SizedBox(
                      height: 96.0,
                      width: 96.0,
                      child: Hero(
                        tag: name + 'a',
                        child: FittedBox(
                          child: Icon(
                            iconData,
                            color: darkMode ? Colors.lightBlue : Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Edit') {
                          Navigator.push(
                            context,
                            isIos
                                ? MaterialPageRoute(
                                    builder: (context) => AddActivityScreen(
                                          package: widget.package ?? null,
                                          task: widget.task ?? null,
                                          updateActivity: true,
                                        ),
                                  )
                                : FadingPageRoute(
                                    builder: (context) => AddActivityScreen(
                                          package: widget.package ?? null,
                                          task: widget.task ?? null,
                                          updateActivity: true,
                                        ),
                                  ),
                          );
                        } else if (value == 'Remove') {
                          FileManager
                              .removeFromFile('exercise.json', name)
                              .then((contents) {
                            App.of(context).changeExercises(contents);
                            Navigator.pop(context);
                          });
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                            value: 'Edit',
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.edit,
                                  color:
                                      darkMode ? Colors.white : Colors.black87,
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                const Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Remove',
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.delete,
                                  color:
                                      darkMode ? Colors.white : Colors.black87,
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                const Text('Remove'),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                ],
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.2,
                  fontFamily: 'Renner*',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              timer(name, 0)
            ],
          ),
        ),
      );
    else {
      return Scaffold(
        backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              0.0, MediaQuery.of(context).padding.top + 4.0, 0.0, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: BackButton(),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      height: 48.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        name,
                        style: const TextStyle(
                          height: 1.2,
                          fontFamily: 'Renner*',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Edit') {
                          Navigator.push(
                            context,
                            isIos
                                ? MaterialPageRoute(
                                    builder: (context) => AddActivityScreen(
                                          package: widget.package ?? null,
                                          task: widget.task ?? null,
                                          updateActivity: true,
                                        ),
                                  )
                                : FadingPageRoute(
                                    builder: (context) => AddActivityScreen(
                                          package: widget.package ?? null,
                                          task: widget.task ?? null,
                                          updateActivity: true,
                                        ),
                                  ),
                          );
                        } else if (value == 'Remove') {
                          FileManager
                              .removeFromFile('exercise.json', name)
                              .then((contents) {
                            App.of(context).changeExercises(contents);
                            Navigator.pop(context);
                          });
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuItem<String>>[
                          PopupMenuItem<String>(
                            value: 'Edit',
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.edit,
                                  color:
                                      darkMode ? Colors.white : Colors.black87,
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                const Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Remove',
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.delete,
                                  color:
                                      darkMode ? Colors.white : Colors.black87,
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                const Text('End Diet'),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4.0,
              ),
              CustomExpansionPanelList(
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    items[index].isExpanded = !items[index].isExpanded;
                  });
                },
                children: items.map((ExpansionPanelItem item) {
                  return ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return FlatButton(
                        shape: const RoundedRectangleBorder(),
                        child: Container(
                          constraints: const BoxConstraints(
                            minHeight: 72.0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: darkMode
                                    ? Colors.blueGrey[700]
                                    : Colors.blue,
                                child: Icon(
                                  item.icon,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    item.header,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      height: 1.2,
                                      fontFamily: 'Renner*',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              CustomExpandIcon(isExpanded),
                            ],
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            item.isExpanded = !item.isExpanded;
                          });
                        },
                      );
                    },
                    body: item.body,
                    isExpanded: item.isExpanded,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class TimeTab extends StatefulWidget {
  TimeTab({this.name, this.index, this.isPackage: false});
  final String name;
  final int index;
  final bool isPackage;
  _TimeTabState createState() => _TimeTabState();
}

class _TimeTabState extends State<TimeTab> with TickerProviderStateMixin {
  TabController tabController;
  int index = 0;
  AnimationController tabIconController;
  Animation<double> timerRotate;
  Animation<double> stopwatchRotate;
  AnimationController timerController;
  AnimationController timerFadeController;
  Stopwatch stopwatch = Stopwatch();
  AnimationController stopwatchController;
  bool timerAnimationStarted = false;
  String timerButtonText = 'START';
  String stopwatchButtonText = 'START';
  bool disableTouch = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabIconController = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    timerRotate = Tween<double>(
      begin: 0.5,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: tabIconController,
        curve: Interval(
          0.0,
          0.5,
          curve: Curves.easeIn,
        ),
      ),
    );
    stopwatchRotate = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: tabIconController,
        curve: Interval(
          0.5,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    tabController.addListener(indexChange);
    tabController.animation.addStatusListener(animationListener);
    timerController = AnimationController(
      vsync: this,
      duration: Duration(),
    );
    timerController.value = 1.0;
    timerController.addStatusListener(timerAnimationEnd);
    timerFadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    stopwatchController = AnimationController(
      vsync: this,
      duration: Duration(days: 7),
    );
  }

  @override
  void dispose() {
    tabController.removeListener(indexChange);
    tabController.animation.removeStatusListener(animationListener);
    tabController.dispose();
    tabIconController.dispose();
    timerController.removeStatusListener(timerAnimationEnd);
    timerController.dispose();
    timerFadeController.dispose();
    stopwatchController.dispose();
    super.dispose();
  }

  void indexChange() {
    setState(() {
      index = tabController.index;
    });
    if (index == 0) {
      tabIconController.reverse();
      stopwatchController.reset();
    } else
      tabIconController.forward();
  }

  void animationListener(AnimationStatus status) {
    setState(() {
      if (status == AnimationStatus.forward ||
          status == AnimationStatus.reverse) {
        index = 2;
        tabIconController.value = 0.5;
      } else
        indexChange();
    });
  }

  void timerAnimationEnd(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      setState(() {
        disableTouch = false;
        timerAnimationStarted = false;
        timerButtonText = 'RESTART';
        timerFadeController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: <Widget>[
        IgnorePointer(
          ignoring: disableTouch,
          child: Container(
            width: 96.0,
            child: Material(
              color: darkMode
                  ? (widget.isPackage ? Colors.grey[850] : Colors.grey[900])
                  : Colors.white,
              borderRadius: BorderRadius.all(Radius.zero),
              child: TabBar(
                indicatorColor: darkMode ? Colors.lightBlue : Colors.blue,
                labelColor: darkMode ? Colors.lightBlue : Colors.blue,
                unselectedLabelColor:
                    darkMode ? Colors.grey[600] : Colors.grey[400],
                controller: tabController,
                tabs: <Widget>[
                  Tab(
                    child: RotationTransition(
                      turns: timerRotate,
                      child: AnimatedCrossFade(
                        crossFadeState: index == 0
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration:
                            Duration(milliseconds: index == 0 ? 160 : 240),
                        firstChild: const Icon(Icons.hourglass_full),
                        secondChild: const Icon(Icons.hourglass_empty),
                      ),
                    ),
                  ),
                  Tab(
                    child: RotationTransition(
                      turns: stopwatchRotate,
                      child: AnimatedCrossFade(
                        crossFadeState: index == 1
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration:
                            Duration(milliseconds: index == 1 ? 140 : 240),
                        firstChild: const Icon(Icons.timer),
                        secondChild: const Icon(Icons.timer_off),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: disableTouch,
          child: Container(
            padding: const EdgeInsets.only(top: 16.0),
            height: portrait
                ? MediaQuery.of(context).size.width - 72.0
                : MediaQuery.of(context).size.height,
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                TimerWidget(
                  name: widget.name,
                  index: widget.index,
                  isPackage: widget.isPackage,
                  timerController: timerController,
                  timerFadeController: timerFadeController,
                ),
                StopwatchWidget(
                  name: widget.name,
                  index: widget.index,
                  stopwatch: stopwatch,
                  stopwatchController: stopwatchController,
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: darkMode ? Colors.lightBlue : Colors.blue,
              colorBrightness: Brightness.dark,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              child: Text(index == 0 ? timerButtonText : stopwatchButtonText),
              onPressed: () {
                disableTouch = true;
                if (index == 0) {
                  if (timerController.isAnimating) {
                    setState(() {
                      timerController.stop();
                      timerButtonText = 'RESUME';
                    });
                  } else {
                    setState(() {
                      timerAnimationStarted = true;
                      timerFadeController.forward();
                      timerButtonText = 'PAUSE';
                      dynamic content =
                          App.of(context).exerciseContents[widget.name];
                      if (content.length == 4)
                        content.add([timerController.duration.inSeconds]);
                      else
                        content[4][widget.index] =
                            timerController.duration.inSeconds;
                      FileManager
                          .writeToFile('exercise.json', widget.name, content)
                          .then((contents) {
                        App.of(context).changeExercises(contents);
                      });
                    });
                    timerController.reverse(
                      from: timerController.value == 0.0
                          ? 1.0
                          : timerController.value,
                    );
                  }
                } else {
                  setState(() {
                    if (stopwatch.isRunning) {
                      stopwatch.stop();
                      stopwatchButtonText = 'RESUME';
                    } else {
                      stopwatch.start();
                      stopwatchController.forward();
                      stopwatchButtonText = 'PAUSE';
                    }
                  });
                }
              },
            ),
            const SizedBox(
              width: 16.0,
            ),
            RaisedButton(
              color: darkMode ? Colors.grey[850] : Colors.white,
              disabledColor: darkMode ? Colors.grey[850] : Colors.white,
              textColor: darkMode ? Colors.lightBlue : Colors.blue,
              disabledTextColor: darkMode ? Colors.grey[600] : Colors.grey[400],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              child: const Text('RESET'),
              onPressed: (index == 0 && timerAnimationStarted) ||
                      (index == 1 && stopwatch.elapsedMilliseconds != 0)
                  ? () {
                      disableTouch = false;
                      if (index == 0) {
                        setState(() {
                          timerAnimationStarted = false;
                          timerButtonText = 'START';
                        });
                        timerFadeController.reverse();
                        timerController.value = 1.0;
                      } else {
                        stopwatch.stop();
                        stopwatch.reset();
                        setState(() {
                          stopwatchButtonText = 'START';
                        });
                      }
                    }
                  : null,
            ),
          ],
        ),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}

class TimerWidget extends StatefulWidget {
  TimerWidget({
    @required this.name,
    @required this.index,
    @required this.isPackage,
    @required this.timerController,
    @required this.timerFadeController,
    Key key,
  }) : super(key: key);
  final String name;
  final int index;
  final bool isPackage;
  final AnimationController timerController;
  final AnimationController timerFadeController;
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  AnimationController timerController;
  AnimationController timerFadeController;
  Animation<double> fadeOut;
  Animation<double> fadeIn;
  bool animationStarted = false;

  @override
  void initState() {
    super.initState();
    timerController = widget.timerController;
    timerFadeController = widget.timerFadeController;
    fadeOut = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: timerFadeController,
        curve: Interval(
          0.0,
          0.55,
          curve: Curves.easeIn,
        ),
      ),
    );
    fadeIn = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: timerFadeController,
        curve: Interval(
          0.45,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }

  void changeDuration(Duration newDuration) {
    setState(() {
      timerController.duration = newDuration;
    });
  }

  String timerMinutesString(int index) {
    Duration duration = timerController.duration * timerController.value;
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    if (index == 0) return minutes[0];
    return minutes[1];
  }

  String timerSecondsString(int index) {
    Duration duration = timerController.duration * timerController.value;
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    if (index == 0) return seconds[0];
    return seconds[1];
  }

  String timerMillisecondsString(int index) {
    Duration duration = timerController.duration * timerController.value;
    String milliseconds =
        (duration.inMilliseconds % 1000).toString().padLeft(3, '0');
    if (index == 0) return milliseconds[0];
    return milliseconds[1];
  }

  Container timerText(String text) {
    return Container(
      width: text == ':' || text == '.' ? 18.0 : 29.0,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          height: 1.2,
          fontFamily: 'Renner*',
          fontSize: 48.0,
        ),
      ),
    );
  }

  Widget text(int index) {
    return Center(
      child: Text(
        index.toString().padLeft(2, '0'),
        style: const TextStyle(
          height: 1.2,
          fontSize: 36.0,
          fontFamily: 'Renner*',
        ),
      ),
    );
  }

  List<Widget> get numList {
    List<Widget> list = [];
    for (int i = 0; i < 60; i++) {
      list.add(text(i));
    }
    return list;
  }

  Widget selectTime(int number) {
    if (timerController.duration.inSeconds == 0) {
      final Map<String, dynamic> contents = App.of(context).exerciseContents;
      if (contents[widget.name].length == 5)
        timerController.duration =
            Duration(seconds: contents[widget.name][4][widget.index]);
      assert(timerController.duration.inMinutes < 60);
    }
    int minutes = timerController.duration.inMinutes;
    int seconds = timerController.duration.inSeconds % 60;
    return Container(
      height: 200.0,
      width: 72.0,
      child: CupertinoPicker(
        notSoDark: widget.isPackage ?? false,
        scrollController: FixedExtentScrollController(
          initialItem: number == 0 ? minutes : seconds,
        ),
        backgroundColor: Colors.transparent,
        itemExtent: 56.0,
        children: numList,
        onSelectedItemChanged: (index) {
          if (number == 0) {
            changeDuration(
              Duration(
                minutes: index,
                seconds: timerController.duration.inSeconds % 60,
              ),
            );
          } else {
            changeDuration(
              Duration(
                minutes: timerController.duration.inMinutes,
                seconds: index,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 64.0),
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: <Widget>[
                Center(
                  child: FadeTransition(
                    opacity: fadeIn,
                    child: AnimatedBuilder(
                      animation: timerController,
                      builder: (context, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            timerText(timerMinutesString(0)),
                            timerText(timerMinutesString(1)),
                            timerText(':'),
                            timerText(timerSecondsString(0)),
                            timerText(timerSecondsString(1)),
                            timerText('.'),
                            timerText(timerMillisecondsString(0)),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: animationStarted ? true : false,
                  child: Center(
                    child: FadeTransition(
                      opacity: fadeOut,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          selectTime(0),
                          selectTime(1),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: timerController,
                      builder: (context, _) {
                        return CustomPaint(
                          painter: TimerPainter(
                            animation: timerController,
                            backgroundColor:
                                darkMode ? Colors.white12 : Colors.black12,
                            color: darkMode ? Colors.lightBlue : Colors.blue,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;

  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

class StopwatchWidget extends StatelessWidget {
  StopwatchWidget({
    this.name,
    this.index,
    this.stopwatch,
    this.stopwatchController,
    Key key,
    this.isPackage,
  }) : super(key: key);

  final String name;
  final int index;
  final Stopwatch stopwatch;
  final AnimationController stopwatchController;
  final bool isPackage;

  Container stopwatchText(String text) {
    return Container(
      width: 18.0,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          height: 1.2,
          fontFamily: 'Renner*',
          fontSize: 48.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StopwatchMinutes(
          stopwatch: stopwatch,
          stopwatchController: stopwatchController,
        ),
        stopwatchText(':'),
        StopwatchSeconds(
          stopwatch: stopwatch,
          stopwatchController: stopwatchController,
        ),
        stopwatchText('.'),
        StopwatchMilliseconds(
          stopwatch: stopwatch,
          stopwatchController: stopwatchController,
        ),
      ],
    );
  }
}

class StopwatchMinutes extends StatefulWidget {
  StopwatchMinutes({
    this.stopwatch,
    this.stopwatchController,
    Key key,
  }) : super(key: key);
  final Stopwatch stopwatch;
  final AnimationController stopwatchController;
  @override
  _StopwatchMinutesState createState() => _StopwatchMinutesState();
}

class _StopwatchMinutesState extends State<StopwatchMinutes> {
  int minutes = 0;

  @override
  void initState() {
    super.initState();
    widget.stopwatchController.addListener(minuteListener);
    minutes = widget.stopwatch.elapsed.inMinutes % 100;
  }

  @override
  void dispose() {
    widget.stopwatchController.removeListener(minuteListener);
    super.dispose();
  }

  void minuteListener() {
    if (minutes != widget.stopwatch.elapsed.inMinutes % 100) {
      setState(() {
        minutes = widget.stopwatch.elapsed.inMinutes % 100;
      });
    }
  }

  Widget stopwatchMinutesString(int index) {
    String minuteString = minutes.toString().padLeft(2, '0');
    return Container(
      width: 29.0,
      alignment: Alignment.center,
      child: Text(
        minuteString[index],
        style: const TextStyle(
          height: 1.2,
          fontFamily: 'Renner*',
          fontSize: 48.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        stopwatchMinutesString(0),
        stopwatchMinutesString(1),
      ],
    );
  }
}

class StopwatchSeconds extends StatefulWidget {
  StopwatchSeconds({
    this.stopwatch,
    this.stopwatchController,
    Key key,
  }) : super(key: key);
  final Stopwatch stopwatch;
  final AnimationController stopwatchController;
  @override
  _StopwatchSecondsState createState() => _StopwatchSecondsState();
}

class _StopwatchSecondsState extends State<StopwatchSeconds> {
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    widget.stopwatchController.addListener(secondListener);
    seconds = widget.stopwatch.elapsed.inSeconds % 60;
  }

  @override
  void dispose() {
    widget.stopwatchController.removeListener(secondListener);
    super.dispose();
  }

  void secondListener() {
    if (seconds != widget.stopwatch.elapsed.inSeconds % 60) {
      setState(() {
        seconds = widget.stopwatch.elapsed.inSeconds % 60;
      });
    }
  }

  Widget stopwatchSecondsString(int index) {
    String secondString = seconds.toString().padLeft(2, '0');
    return Container(
      width: 29.0,
      alignment: Alignment.center,
      child: Text(
        secondString[index],
        style: const TextStyle(
          height: 1.2,
          fontFamily: 'Renner*',
          fontSize: 48.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        stopwatchSecondsString(0),
        stopwatchSecondsString(1),
      ],
    );
  }
}

class StopwatchMilliseconds extends StatefulWidget {
  StopwatchMilliseconds({
    this.stopwatch,
    this.stopwatchController,
    Key key,
  }) : super(key: key);
  final Stopwatch stopwatch;
  final AnimationController stopwatchController;
  @override
  _StopwatchMillisecondsState createState() => _StopwatchMillisecondsState();
}

class _StopwatchMillisecondsState extends State<StopwatchMilliseconds> {
  int milliseconds = 0;

  @override
  void initState() {
    super.initState();
    widget.stopwatchController.addListener(millisecondListener);
    milliseconds = widget.stopwatch.elapsed.inMilliseconds % 1000;
  }

  @override
  void dispose() {
    widget.stopwatchController.removeListener(millisecondListener);
    super.dispose();
  }

  void millisecondListener() {
    if (milliseconds != widget.stopwatch.elapsed.inMilliseconds % 1000) {
      setState(() {
        milliseconds = widget.stopwatch.elapsed.inMilliseconds % 1000;
      });
    }
  }

  Widget stopwatchMillisecondsString(int index) {
    String millisecondString = milliseconds.toString().padLeft(3, '0');
    return Container(
      width: 29.0,
      alignment: Alignment.center,
      child: Text(
        millisecondString[index],
        style: const TextStyle(
          height: 1.2,
          fontFamily: 'Renner*',
          fontSize: 48.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        stopwatchMillisecondsString(0),
        stopwatchMillisecondsString(1),
      ],
    );
  }
}
