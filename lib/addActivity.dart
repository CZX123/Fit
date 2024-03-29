import 'dart:async';
import 'package:flutter/material.dart'
    show
        Alignment,
        AppBar,
        BorderRadius,
        BorderSide,
        BoxConstraints,
        Brightness,
        BuildContext,
        Builder,
        ButtonThemeData,
        Color,
        Colors,
        Column,
        ConstrainedBox,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        FittedBox,
        FloatingActionButton,
        FontWeight,
        Hero,
        Icon,
        IconData,
        Icons,
        Key,
        MainAxisAlignment,
        MediaQuery,
        Navigator,
        OutlineButton,
        Padding,
        Radius,
        RoundedRectangleBorder,
        Row,
        Scaffold,
        SingleChildScrollView,
        SizedBox,
        SnackBar,
        SnackBarAction,
        State,
        StatefulWidget,
        StatelessWidget,
        TargetPlatform,
        Text,
        TextAlign,
        TextBaseline,
        TextStyle,
        Theme,
        ThemeData,
        TimeOfDay,
        ValueChanged,
        Widget,
        WidgetsBinding,
        showTimePicker;
import 'newActivity.dart';
import 'fileManager.dart';
import 'main.dart';
import 'customDropdown.dart'
    show DropdownButton, DropdownButtonHideUnderline, DropdownMenuItem;

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({
    Key key,
    this.task,
    this.package,
    this.updateActivity,
  }) : super(key: key);

  final Task task;
  final Package package;
  final bool updateActivity;

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

enum Answer { THRICE, TWICE, DAILY, WEEKLY }

class _AddActivityScreenState extends State<AddActivityScreen> {
  bool _snackbarShown = false;
  List<dynamic> _fromTime = [const TimeOfDay(hour: 12, minute: 00)];
  List<dynamic> _toTime = [const TimeOfDay(hour: 13, minute: 00)];
  bool _validate = false;
  final List<String> _frequency = [
    'Thrice a Day',
    'Twice a Day',
    'Daily',
    'Weekly'
  ];
  String _selectedFrequency = 'Daily';
  final String fileName = 'exercise.json';
  bool _updateActivity = false;

  IconData iconData;
  String name, description;
  List<Task> packageTasks;
  bool updateActivity;
  List<int> timings;
  String _dayDropdownValue;
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _dayDropdownValue = _days[DateTime.now().weekday - 1];
    FileManager.readFile(fileName).then((contents) {
      if (contents != null && contents.keys.contains(name)) {
        setState(() {
          _updateActivity = true;
          _selectedFrequency = contents[name][2];
          _fromTime = contents[name][0].map((value) {
            return TimeOfDay(
              hour: value[0],
              minute: value[1],
            );
          }).toList();
          _toTime = contents[name][1].map((value) {
            return TimeOfDay(
              hour: value[0],
              minute: value[1],
            );
          }).toList();
        });
      }
    });
    updateActivity = widget.updateActivity;
    if (widget.task != null) {
      iconData = widget.task.icon;
      name = widget.task.name;
      description = widget.task.description;
    } else {
      iconData = widget.package.icon;
      name = widget.package.name;
      description = widget.package.description;
      packageTasks = widget.package.packageTasks;
      timings = widget.package.timings;
    }
  }

  void showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(
          'This $name exercise has already been added. New edits you make will overwrite the old values.'),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
    setState(() {
      _snackbarShown = true;
    });
  }

  void setFrequency(String newValue) {
    setState(() {
      _selectedFrequency = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    _validate = true;
    if (_selectedFrequency == _frequency[0] && _fromTime.length != 3) {
      _fromTime = [
        const TimeOfDay(hour: 7, minute: 00),
        const TimeOfDay(hour: 12, minute: 00),
        const TimeOfDay(hour: 17, minute: 00),
      ];
      _toTime = [
        const TimeOfDay(hour: 8, minute: 00),
        const TimeOfDay(hour: 13, minute: 00),
        const TimeOfDay(hour: 18, minute: 00),
      ];
    } else if (_selectedFrequency == _frequency[1] && _fromTime.length != 2) {
      if (_fromTime.length == 3) {
        _fromTime.removeLast();
        _toTime.removeLast();
      } else {
        _fromTime = [
          const TimeOfDay(hour: 8, minute: 00),
          const TimeOfDay(hour: 15, minute: 00),
        ];
        _toTime = [
          const TimeOfDay(hour: 9, minute: 00),
          const TimeOfDay(hour: 16, minute: 00),
        ];
      }
    } else if (_selectedFrequency != _frequency[0] &&
        _selectedFrequency != _frequency[1] &&
        _fromTime.length != 1) {
      if (_fromTime.length == 3) {
        _fromTime.removeRange(1, 3);
        _toTime.removeRange(1, 3);
      } else {
        _fromTime.removeLast();
        _toTime.removeLast();
      }
    }

    final List<Row> listTimings = [];

    for (int i = 0; i < _fromTime.length; i++) {
      bool validate = _fromTime[i].hour < _toTime[i].hour ||
          _fromTime[i].hour == _toTime[i].hour &&
              _fromTime[i].minute < _toTime[i].minute;
      bool validate2 = true;
      bool validate3 = true;
      for (int j = 0; j < _fromTime.length; j++) {
        if (i != j &&
            (_fromTime[i].hour > _fromTime[j].hour ||
                _fromTime[i].hour == _fromTime[j].hour &&
                    _fromTime[i].minute >= _fromTime[j].minute) &&
            (_fromTime[i].hour < _toTime[j].hour ||
                _fromTime[i].hour == _toTime[j].hour &&
                    _fromTime[j].minute <= _toTime[j].minute))
          validate2 = false;
        if (i != j &&
            (_toTime[i].hour > _fromTime[j].hour ||
                _toTime[i].hour == _fromTime[j].hour &&
                    _toTime[i].minute >= _fromTime[j].minute) &&
            (_toTime[i].hour < _toTime[j].hour ||
                _toTime[i].hour == _toTime[j].hour &&
                    _toTime[j].minute <= _toTime[j].minute)) validate3 = false;
      }
      if (!validate || !validate2 || !validate3) _validate = false;
      listTimings.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            _TimePicker(
              initialTime: _fromTime[i],
              selectTime: (TimeOfDay time) {
                setState(() {
                  _fromTime[i] = time;
                });
              },
              validate: validate && validate2,
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Text('to'),
            ),
            _TimePicker(
              initialTime: _toTime[i],
              selectTime: (TimeOfDay time) {
                setState(() {
                  _toTime[i] = time;
                });
              },
              validate: validate && validate3,
            ),
          ],
        ),
      );
    }
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final double height = MediaQuery.of(context).size.height;
    final double windowTopPadding = MediaQuery.of(context).padding.top;
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: darkMode ? Colors.grey[800] : Colors.blue,
        title: Text(
          (_updateActivity ? 'Edit' : 'New') + ' $name Exercise',
          style: const TextStyle(
            height: 1.2,
            fontFamily: 'Renner*',
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Theme(
        data: ThemeData(
          brightness: darkMode ? Brightness.dark : Brightness.light,
          primaryColor: Colors.blue,
          accentColor: darkMode ? Colors.limeAccent : Colors.deepOrangeAccent,
          buttonTheme: ButtonThemeData(
            alignedDropdown: true,
          ),
        ),
        child: Builder(
          builder: (context) {
            if (_updateActivity &&
                !_snackbarShown &&
                (widget.updateActivity == null || !widget.updateActivity))
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => showSnackbar(context));
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 72.0, vertical: 32.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height - 120.0 - windowTopPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(),
                    SizedBox(
                      height: 96.0,
                      width: 96.0,
                      child: Hero(
                        tag: isIos
                            ? name + 'iosSucks3'
                            : (widget.updateActivity != null &&
                                    widget.updateActivity != false)
                                ? name + 'a'
                                : name,
                        child: FittedBox(
                          child: Icon(
                            iconData,
                            color: darkMode ? Colors.lightBlue : Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 8.0),
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          height: 1.2,
                          fontFamily: 'Renner*',
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(description),
                    ),
                    const Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 4.0),
                      child: const Text(
                        'Frequency',
                        style: const TextStyle(
                          height: 1.2,
                          fontFamily: 'Renner*',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      alignment: Alignment.centerLeft,
                      child: DropdownButtonHideUnderline(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            DropdownButton<String>(
                              isDense: true,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: darkMode ? Colors.white : Colors.black87,
                              ),
                              value: _selectedFrequency,
                              onChanged: (String newValue) {
                                setState(() {
                                  _selectedFrequency = newValue;
                                });
                              },
                              items: _frequency.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                            ),
                            _selectedFrequency == 'Weekly'
                                ? const Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: const Text('on'),
                                  )
                                : const SizedBox(),
                            _selectedFrequency == 'Weekly'
                                ? DropdownButton<String>(
                                    isDense: true,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: darkMode
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    value: _dayDropdownValue,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _dayDropdownValue = newValue;
                                      });
                                    },
                                    items: _days.map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 4.0),
                      child: Text(
                        _fromTime.length == 1 ? 'Time' : 'Timings',
                        style: const TextStyle(
                          height: 1.2,
                          fontFamily: 'Renner*',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: listTimings,
                      ),
                    ),
                    const SizedBox(),
                    const SizedBox(),
                    const SizedBox(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: _validate
          ? FloatingActionButton(
              backgroundColor:
                  darkMode ? Colors.grey[800] : Colors.deepOrangeAccent,
              tooltip: _updateActivity ? 'Save Edits' : 'Add Activity',
              child: Icon(
                _updateActivity ? Icons.save : Icons.check,
                color: darkMode ? Colors.limeAccent : Colors.white,
              ),
              onPressed: () {
                if (_validate) {
                  dynamic value = [
                    _fromTime.map((time) {
                      return [time.hour, time.minute];
                    }).toList(),
                    _toTime.map((time) {
                      return [time.hour, time.minute];
                    }).toList(),
                    _selectedFrequency,
                    _selectedFrequency == 'Weekly' ? _dayDropdownValue : 'Not Weekly',
                    [0], // timings
                    [false], // stopwatch
                    [false], // activity completion
                    // activityStats,
                  ];
                  if (timings != null && timings.length != 0) {
                    value[4] = timings;
                    List<bool> list = [];
                    for (int i = 0; i < timings.length; i++) {
                      list.add(false);
                    }
                    value[5] = list;
                    value[6] = list;
                  }
                  FileManager
                      .writeToFile(fileName, name, value)
                      .then((contents) {
                    App.of(context).changeExercises(contents);
                    Navigator.pop(context);
                    dynamic returnValue = [
                      name,
                      _selectedFrequency,
                      _fromTime.map((time) {
                        return [time.hour, time.minute];
                      }).toList(),
                      _toTime.map((time) {
                        return [time.hour, time.minute];
                      }).toList(),
                    ];
                    if (_selectedFrequency == 'Weekly')
                      returnValue.add(_dayDropdownValue);
                    Navigator.pop(context, returnValue);
                    if (Navigator.canPop(context))
                      Navigator.pop(context, returnValue);
                    if (Navigator.canPop(context))
                      Navigator.pop(context, returnValue);
                  });
                }
              },
            )
          : null,
    );
  }
}

class _TimePicker extends StatelessWidget {
  const _TimePicker({Key key, this.initialTime, this.selectTime, this.validate})
      : super(key: key);

  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> selectTime;
  final bool validate;

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null && picked != initialTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Color red = darkMode ? Colors.redAccent[200] : Colors.red;
    final Color textColor = darkMode ? Colors.white : Colors.black87;
    final Color outlineColor = darkMode ? Colors.grey[600] : Colors.grey[350];
    final Color highlightedBorderColor =
        darkMode ? Colors.lightBlue : Colors.blue;
    return OutlineButton(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(4.0),
        ),
      ),
      highlightElevation: 0.0,
      highlightedBorderColor: validate ? highlightedBorderColor : red,
      borderSide: BorderSide(
        color: validate ? outlineColor : red,
        width: 1.0,
      ),
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 36.0,
        alignment: Alignment.center,
        child: Text(
          initialTime.format(context),
          style: TextStyle(
            color: validate ? textColor : red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onPressed: () => _selectTime(context),
    );
  }
}
