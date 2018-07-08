import 'dart:math';
import 'package:flutter/material.dart';
import 'fileManager.dart' show FileManager;
import 'addActivity.dart' show AddActivityScreen;
import 'customWidgets.dart' show FadingPageRoute;
import 'newActivity.dart' show Package;

class StartActivityScreen extends StatelessWidget {
  StartActivityScreen({
    this.icon: Icons.help,
    @required this.name,
    this.description,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              child: Timer(Duration(seconds: 20)),
            )
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
  bool animationStarted = false;

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
    if (status == AnimationStatus.dismissed) {
      animationStarted = false;
      controller.value = 1.0;
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
                              darkMode ? Colors.white12 : Colors.black12,
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
                          timerText(timerMillisecondsString(1)),
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
                animationStarted = true;
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
