import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'newActivity.dart';

class ExerciseData {
  final String date;
  final double amount;
  final charts.Color color;
  ExerciseData(this.date, this.amount, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class ActivityStatsScreen extends StatelessWidget {
  ActivityStatsScreen(this.package, this.task);

  final Package package;
  final Task task;

  @override
  Widget build(BuildContext context) {
    final double windowTopPadding = MediaQuery.of(context).padding.top;
    List<ExerciseData> data = [
      ExerciseData('2016', 12.0, Colors.red),
      ExerciseData('2017', 42.0, Colors.yellow),
      ExerciseData('2018', 30.0, Colors.green),
    ];
    var series = [
      charts.Series(
        id: 'Clicks',
        domainFn: (ExerciseData exerciseData, _) => exerciseData.date,
        measureFn: (ExerciseData exerciseData, _) => exerciseData.amount,
        colorFn: (ExerciseData exerciseData, _) => exerciseData.color,
        data: data,
      ),
    ];
    return Container(
      padding: EdgeInsets.only(top: windowTopPadding),
      child: Column(
        children: <Widget>[
          charts.BarChart(
            series,
            animate: true,
          ),
        ],
      ),
    );
  }
}
