import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'newActivity.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({
    Key key,
    this.icon: Icons.help,
    this.image,
    @required this.name,
    @required this.description,
    this.packageTasks,
  }) : super(key: key);

  final IconData icon;
  final String image;
  final String name;
  final String description;
  final List<Task> packageTasks;

  @override
  _AddActivityScreenState createState() => new _AddActivityScreenState();
}

enum Answer { THRICE, TWICE, DAILY, TWODAYS, THREEDAYS, FIVEDAYS, WEEKLY }

class _AddActivityScreenState extends State<AddActivityScreen> {
  List<TimeOfDay> _fromTime = [const TimeOfDay(hour: 12, minute: 00)];
  List<TimeOfDay> _toTime = [const TimeOfDay(hour: 13, minute: 00)];
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
      if (!validate) _validate = false;
      listTimings.add(new Row(
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
            validate: validate,
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
            validate: validate,
          ),
        ],
      ));
    }

    final IconData icon = widget.icon;
    final String image = widget.image;
    final String name = widget.name;
    final String description = widget.description;
    final List<Task> packageTasks = widget.packageTasks;
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final String packageOrTask = packageTasks != null ? 'Package' : 'Task';
    final double height = MediaQuery.of(context).size.height;
    final double windowTopPadding = MediaQuery.of(context).padding.top;

    return new Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: new AppBar(
        backgroundColor: darkMode ? Colors.grey[800] : Colors.blue,
        title: new Text(
          'New $name $packageOrTask',
          style: new TextStyle(
            height: 1.2,
            fontFamily: 'Renner*',
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: new SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 72.0, vertical: 32.0),
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
                  tag: name,
                  child: (image != null)
                      ? new Image.asset(
                          image,
                          fit: BoxFit.contain,
                        )
                      : new FittedBox(
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
                  //textAlign: TextAlign.center,
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
                  //textAlign: TextAlign.center,
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
      ),
      floatingActionButton: _validate
          ? new FloatingActionButton(
              tooltip: 'Add Activity',
              child: new Icon(Icons.check),
              onPressed: () {
                print(_fromTime);
                print(_toTime);
                print(_selectedFrequency);
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
