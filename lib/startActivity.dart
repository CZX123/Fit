import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'picker.dart' show CupertinoPicker;
import 'fileManager.dart' show FileManager;
import 'addActivity.dart' show AddActivityScreen;
import 'customWidgets.dart' show FadingPageRoute;
import 'newActivity.dart' show Package;

class StartActivityScreen extends StatelessWidget {
  StartActivityScreen({
    @required this.icon,
    @required this.name,
    @required this.description,
    this.packageTasks,
  });

  final IconData icon;
  final String name;
  final String description;
  final List<Package> packageTasks;

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
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
                          icon,
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
                          FadingPageRoute(
                            builder: (context) => AddActivityScreen(
                                  icon: icon,
                                  name: name,
                                  description: description,
                                  packageTasks: packageTasks ?? [],
                                  updateActivity: true,
                                ),
                          ),
                        );
                      } else if (value == 'Remove') {
                        FileManager
                            .removeFromFile('exercise.json', name)
                            .then((_) {
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
                                color: darkMode ? Colors.white : Colors.black87,
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
                                color: darkMode ? Colors.white : Colors.black87,
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
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.height,
              ),
              child: Timer(
                name: name,
                key: Key('timer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Timer extends StatefulWidget {
  Timer({this.name, Key key}) : super(key: key);
  final String name;
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController fadeController;
  Animation<double> fadeOut;
  Animation<double> fadeIn;
  bool animationStarted = false;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(),
    );
    fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    fadeOut = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: fadeController,
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
        parent: fadeController,
        curve: Interval(
          0.45,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    controller.value = 1.0;
    controller.addStatusListener(animationEnd);
  }

  @override
  void dispose() {
    controller.removeStatusListener(animationEnd);
    controller.dispose();
    fadeController.dispose();
    super.dispose();
  }

  Future<int> get getDuration async {
    if (!loaded) {
      Map<String, dynamic> contents =
          await FileManager.readFile('exercise.json');
      loaded = true;
      if (contents[widget.name].length == 4) {
        controller.duration = Duration(seconds: contents[widget.name][3]);
        return contents[widget.name][3];
      }
    }
    return 0;
  }

  void animationEnd(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      setState(() {
        animationStarted = false;
        fadeController.reverse();
      });
    }
  }

  void changeDuration(Duration newDuration) {
    setState(() {
      controller.duration = newDuration;
    });
  }

  String timerMinutesString(int index) {
    Duration duration = controller.duration * controller.value;
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    if (index == 0) return minutes[0];
    return minutes[1];
  }

  String timerSecondsString(int index) {
    Duration duration = controller.duration * controller.value;
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    if (index == 0) return seconds[0];
    return seconds[1];
  }

  String timerMillisecondsString(int index) {
    Duration duration = controller.duration * controller.value;
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

  Widget selectTime(int number, int duration) {
    int minutes = (duration / 60).floor();
    int seconds = duration % 60;
    return Container(
      height: 200.0,
      width: 72.0,
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: number == 0 ? minutes : seconds,
        ),
        backgroundColor: Colors.transparent,
        itemExtent: 56.0,
        children: numList,
        onSelectedItemChanged: (index) {
          if (number == 0) {
            changeDuration(Duration(
                minutes: index, seconds: controller.duration.inSeconds % 60));
          } else {
            changeDuration(Duration(
                minutes: controller.duration.inMinutes, seconds: index));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 64.0),
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
                      animation: controller,
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
                      child: FutureBuilder(
                        future: getDuration,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                selectTime(0, snapshot.data),
                                selectTime(1, snapshot.data),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) {
                        return CustomPaint(
                          painter: TimerPainter(
                            animation: controller,
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
          const SizedBox(
            height: 24.0,
          ),
          RaisedButton(
            color: darkMode ? Colors.lightBlue : Colors.blue,
            colorBrightness: Brightness.dark,
            shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(4.0),
              ),
            ),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) => Text(controller.isAnimating
                  ? 'STOP'
                  : animationStarted ? 'RESUME' : 'START'),
            ),
            onPressed: () {
              if (controller.isAnimating) {
                setState(() {
                  controller.stop();
                });
              } else {
                setState(() {
                  animationStarted = true;
                  fadeController.forward();
                  FileManager.readFile('exercise.json').then((contents) {
                    dynamic content = contents[widget.name];
                    if (content.length == 3)
                      content.add(controller.duration.inSeconds);
                    else
                      content[3] = controller.duration.inSeconds;
                    FileManager.writeToFile(
                        'exercise.json', widget.name, content);
                  });
                });
                controller.reverse(
                  from: controller.value == 0.0 ? 1.0 : controller.value,
                );
              }
            },
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
