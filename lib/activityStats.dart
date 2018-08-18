import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'newActivity.dart';
import 'customExpansionPanel.dart';

class ExpansionPanelItem {
  ExpansionPanelItem(
      {this.isExpanded, this.header, this.body, this.icon, this.completed});
  bool isExpanded;
  final String header;
  final Widget body;
  final IconData icon;
  bool completed;
}

class ActivityStatsScreen extends StatefulWidget {
  ActivityStatsScreen({
    this.package,
    this.task,
    Key key,
  }) : super(key: key);
  final Package package;
  final Task task;
  _ActivityStatsScreenState createState() => _ActivityStatsScreenState();
}

class _ActivityStatsScreenState extends State<ActivityStatsScreen> {
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
              child: timer(packageTasks[i], name, i, true),
            ),
            completed: false,
          ),
        );
      }
    }
  }

  Widget timer(Task task, String name, int index, [bool isPackage]) {
    List<ExerciseData> data = [
      ExerciseData('15/8', 10.0, Colors.blue),
      ExerciseData('16/8', 7.0, Colors.blue),
      ExerciseData('17/8', 5.0, Colors.blue),
    ];
    List<charts.Series<ExerciseData, String>> series = [
      charts.Series<ExerciseData, String>(
        id: 'Stats',
        domainFn: (ExerciseData exerciseData, _) => exerciseData.date,
        measureFn: (ExerciseData exerciseData, _) => exerciseData.amount,
        colorFn: (ExerciseData exerciseData, _) => exerciseData.color,
        data: data,
      ),
    ];
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SizedBox(
      width: portrait
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.height,
      child: Container(
        height: 324.0,
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: charts.BarChart(
          series,
          animate: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
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
                      '$name Exercise Statistics',
                      style: const TextStyle(
                        height: 1.2,
                        fontFamily: 'Renner*',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                              backgroundColor: item.completed
                                  ? darkMode ? Colors.green[400] : Colors.green
                                  : darkMode
                                      ? Colors.blueGrey[700]
                                      : Colors.blue,
                              child: Icon(
                                item.completed ? Icons.check : item.icon,
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

class ExerciseData {
  final String date;
  final double amount;
  final charts.Color color;
  ExerciseData(this.date, this.amount, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
