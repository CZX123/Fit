import 'dart:async';
import 'package:flutter/material.dart';
import 'newActivity.dart';
import 'fileManager.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({
    Key key,
    this.icon: Icons.help,
    @required this.name,
    @required this.description,
    this.packageTasks,
    this.updateActivity,
  }) : super(key: key);

  final IconData icon;
  final String name;
  final String description;
  final List<Task> packageTasks;
  final bool updateActivity;

  @override
  _AddActivityScreenState createState() => new _AddActivityScreenState();
}

enum Answer { THRICE, TWICE, DAILY, TWODAYS, THREEDAYS, FIVEDAYS, WEEKLY }

class _AddActivityScreenState extends State<AddActivityScreen> {
  bool _snackbarShown = false;
  List<dynamic> _fromTime = [const TimeOfDay(hour: 12, minute: 00)];
  List<dynamic> _toTime = [const TimeOfDay(hour: 13, minute: 00)];
  bool _validate = false;
  List<String> _frequency = [
    'Three Times a Day',
    'Twice a Day',
    'Daily',
    'Every 2 Days',
    'Every 3 Days',
    'Every 5 Days',
    'Weekly'
  ];
  String _selectedFrequency = 'Daily';
  String fileName = 'exercise.json';
  Map<String, dynamic> fileContent;
  bool _updateActivity = false;

  @override
  void initState() {
    super.initState();
    getFileContents();
  }

  Future getFileContents() async {
    fileContent = await FileManager.readFile(fileName);
    if (fileContent.keys.contains(widget.name)) {
      setState(() {
        _updateActivity = true;
        _selectedFrequency = fileContent[widget.name][2];
        _fromTime = fileContent[widget.name][0].map((value) {
          return new TimeOfDay(
            hour: value[0],
            minute: value[1],
          );
        }).toList();
        _toTime = fileContent[widget.name][1].map((value) {
          return new TimeOfDay(
            hour: value[0],
            minute: value[1],
          );
        }).toList();
      });
    }
  }

  void showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      duration: new Duration(seconds: 5),
      content: Text(
          'This ${widget.name} exercise has already been added. New edits you make will overwrite the old values.'),
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

  Future writeToFile(String key, dynamic value) async {
    FileManager.writeToFile(fileName, key, value);
    fileContent = await FileManager.readFile(fileName);
  }

  Future removeFromFile(String key) async {
    FileManager.removeFromFile(fileName, key);
    fileContent = await FileManager.readFile(fileName);
  }

  void setFrequency(String newValue) {
    setState(() {
      _selectedFrequency = newValue;
    });
  }

  Future<Null> _changeFrequency() async {
    switch (await showDialog(
      context: context,
      builder: (context) {
        return new SimpleDialog(
          title: new Text(
            'Change Frequency',
            style: new TextStyle(
              height: 1.2,
              fontFamily: 'Renner*',
            ),
          ),
          children: _frequency.map((String value) {
            return new SimpleDialogOption(
              onPressed: () {
                Navigator.pop(
                    context, Answer.values[_frequency.indexOf(value)]);
              },
              child: new Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: new Text(
                  value,
                  textAlign: TextAlign.left,
                ),
              ),
            );
          }).toList(),
        );
      },
    )) {
      case Answer.THRICE:
        setFrequency(_frequency[0]);
        break;
      case Answer.TWICE:
        setFrequency(_frequency[1]);
        break;
      case Answer.DAILY:
        setFrequency(_frequency[2]);
        break;
      case Answer.TWODAYS:
        setFrequency(_frequency[3]);
        break;
      case Answer.THREEDAYS:
        setFrequency(_frequency[4]);
        break;
      case Answer.FIVEDAYS:
        setFrequency(_frequency[5]);
        break;
      case Answer.WEEKLY:
        setFrequency(_frequency[6]);
        break;
    }
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
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            new _TimePicker(
              initialTime: _fromTime[i],
              selectTime: (TimeOfDay time) {
                setState(() {
                  _fromTime[i] = time;
                });
              },
              validate: validate && validate2,
            ),
            new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: new Text('to'),
            ),
            new _TimePicker(
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

    final IconData icon = widget.icon;
    final String name = widget.name;
    final String description = widget.description;
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final double height = MediaQuery.of(context).size.height;
    final double windowTopPadding = MediaQuery.of(context).padding.top;

    return new Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: new AppBar(
        backgroundColor: darkMode ? Colors.grey[800] : Colors.blue,
        title: new Text(
          (_updateActivity ? 'Edit' : 'New') + ' $name Exercise',
          style: new TextStyle(
            height: 1.2,
            fontFamily: 'Renner*',
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: new Builder(
        builder: (context) {
          if (_updateActivity &&
              !_snackbarShown &&
              (widget.updateActivity == null || !widget.updateActivity))
            WidgetsBinding.instance
                .addPostFrameCallback((_) => showSnackbar(context));
          return new SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 72.0, vertical: 32.0),
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: height - 120.0 - windowTopPadding,
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(),
                  new SizedBox(
                    height: 96.0,
                    width: 96.0,
                    child: new Hero(
                      tag: (widget.updateActivity != null &&
                              widget.updateActivity != false)
                          ? name + 'a'
                          : name,
                      child: new FittedBox(
                        child: new Icon(
                          icon,
                          color: darkMode ? Colors.lightBlue : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 8.0),
                    child: new Text(
                      name,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        height: 1.2,
                        fontFamily: 'Renner*',
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: new Text(description),
                  ),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 4.0),
                    child: new Text(
                      'Frequency',
                      style: new TextStyle(
                        height: 1.2,
                        fontFamily: 'Renner*',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.centerLeft,
                    child: new OutlineButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(4.0),
                        ),
                      ),
                      highlightElevation: 0.0,
                      highlightedBorderColor:
                          darkMode ? Colors.lightBlue : Colors.blue,
                      borderSide: new BorderSide(
                        color: darkMode ? Colors.grey[600] : Colors.grey[350],
                        width: 2.0,
                      ),
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(_selectedFrequency),
                          new Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: new Icon(
                              Icons.arrow_drop_down,
                              color: darkMode ? Colors.white : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _changeFrequency();
                      },
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 4.0),
                    child: new Text(
                      _fromTime.length == 1 ? 'Time' : 'Timings',
                      style: new TextStyle(
                        height: 1.2,
                        fontFamily: 'Renner*',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: new Column(
                      children: listTimings,
                    ),
                  ),
                  new Container(),
                  new Container(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _validate
          ? new FloatingActionButton(
              tooltip: _updateActivity ? 'Save Edits' : 'Add Activity',
              child: new Icon(_updateActivity ? Icons.save : Icons.check),
              onPressed: () {
                if (_validate) {
                  writeToFile(name, [
                    _fromTime.map((time) {
                      return [time.hour, time.minute];
                    }).toList(),
                    _toTime.map((time) {
                      return [time.hour, time.minute];
                    }).toList(),
                    _selectedFrequency,
                  ]).then((_) {
                    Navigator.pop(context);
                    Navigator.pop(context, name);
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
    return new OutlineButton(
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.all(
          const Radius.circular(4.0),
        ),
      ),
      highlightElevation: 0.0,
      highlightedBorderColor: validate ? highlightedBorderColor : red,
      borderSide: new BorderSide(
        color: validate ? outlineColor : red,
        width: 2.0,
      ),
      padding: const EdgeInsets.all(0.0),
      child: new Container(
        height: 36.0,
        alignment: Alignment.center,
        child: new Text(
          initialTime.format(context),
          style: new TextStyle(
            color: validate ? textColor : red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onPressed: () {
        _selectTime(context);
      },
    );
  }
}
