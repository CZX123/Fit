import 'dart:math';
import 'package:flutter/material.dart';
import 'fileManager.dart' show FileManager;
import 'addActivity.dart' show AddActivityScreen;
import 'customWidgets.dart' show FadingPageRoute;
import 'newActivity.dart' show Package;

class StartActivityScreen extends StatelessWidget {
  StartActivityScreen({
    this.icon: Icons.help,
    this.color,
    @required this.name,
    this.description,
    this.packageTasks,
  });

  final IconData icon;
  final Color color;
  final String name;
  final String description;
  final List<Package> packageTasks;

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Color actualColor =
        color ?? (darkMode ? Colors.lightBlue : Colors.blue);
    return new Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.white,
      body: new SingleChildScrollView(
        padding: new EdgeInsets.fromLTRB(
            0.0, MediaQuery.of(context).padding.top + 4.0, 0.0, 16.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: new BackButton(),
                ),
                new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 16.0),
                  child: new SizedBox(
                    height: 96.0,
                    width: 96.0,
                    child: new Hero(
                      tag: name + 'a',
                      child: new FittedBox(
                        child: new Icon(
                          icon,
                          color: actualColor,
                        ),
                      ),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: new PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Edit') {
                        Navigator.push(
                          context,
                          new FadingPageRoute(
                            builder: (context) => new AddActivityScreen(
                                  icon: icon,
                                  name: name,
                                  description: description ??
                                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
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
                        new PopupMenuItem<String>(
                          value: 'Edit',
                          child: new Row(
                            children: <Widget>[
                              new Icon(
                                Icons.edit,
                                color: darkMode ? Colors.white : Colors.black87,
                              ),
                              new SizedBox(
                                width: 16.0,
                              ),
                              const Text('Edit'),
                            ],
                          ),
                        ),
                        new PopupMenuItem<String>(
                          value: 'Remove',
                          child: new Row(
                            children: <Widget>[
                              new Icon(
                                Icons.delete,
                                color: darkMode ? Colors.white : Colors.black87,
                              ),
                              new SizedBox(
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
            new Text(
              name,
              textAlign: TextAlign.center,
              style: new TextStyle(
                height: 1.2,
                fontFamily: 'Renner*',
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            new Timer(Duration(seconds: 20)),
          ],
        ),
      ),
    );
  }
}

class Timer extends StatefulWidget {
  Timer(this.duration, {Key key}) : super(key: key);
  final Duration duration;
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    controller.value = 1.0;
    controller.addStatusListener(animationEnd);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeStatusListener(animationEnd);
  }

  void animationEnd(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) controller.value = 1.0;
  }

  void changeDuration(Duration newDuration) {
    setState(() {
      controller.duration = newDuration;
    });
  }

  String get timerMinutesString {
    Duration duration = controller.duration * controller.value;
    return duration.inMinutes.toString().padLeft(2, '0');
  }

  String get timerSecondsString {
    Duration duration = controller.duration * controller.value;
    return (duration.inSeconds % 60).toString().padLeft(2, '0');
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
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: TimerPainter(
                          animation: controller,
                          backgroundColor:
                              darkMode ? Colors.white30 : Colors.black38,
                          color: darkMode ? Colors.lightBlue : Colors.blue,
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      final TextStyle textStyle = const TextStyle(
                        height: 1.2,
                        fontFamily: 'Renner*',
                        fontSize: 64.0,
                      );
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 96.0,
                            alignment: Alignment.centerRight,
                            child: new Text(
                              timerMinutesString,
                              style: textStyle,
                            ),
                          ),
                          new Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              ':',
                              style: textStyle,
                            ),
                          ),
                          Container(
                            width: 96.0,
                            alignment: Alignment.centerLeft,
                            child: new Text(
                              timerSecondsString,
                              style: textStyle,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          RaisedButton(
            color: darkMode ? Colors.lightBlue : Colors.blue,
            colorBrightness: Brightness.dark,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(
                const Radius.circular(4.0),
              ),
            ),
            child: new AnimatedBuilder(
              animation: controller,
              builder: (context, _) =>
                  Text(controller.isAnimating ? 'STOP' : 'START'),
            ),
            onPressed: () {
              if (controller.isAnimating) {
                setState(() {
                  controller.stop();
                });
              } else {
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
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
