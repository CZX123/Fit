import 'package:Fit/exercise.dart';
import 'package:Fit/sportsIcons.dart';

List<Activity> activeActivityList = [
  new Activity(
    icon: SportsIcons.push_up,
    name: 'Push Ups',
    completionState: 'Completed',
    onPressed: () {},
  ),
  new Activity(
    icon: SportsIcons.cycling,
    name: 'Cycling',
    completionState: 'Pending',
    onPressed: () {},
  ),
  new Activity(
    icon: SportsIcons.running,
    name: 'Running',
    completionState: 'Incomplete',
    onPressed: () {},
  ),
];
