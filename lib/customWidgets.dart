import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Grid Widget using columns and rows. Only supports vertical layout, and does not have any values regarding widget size and spacing between grid items
class Grid extends StatelessWidget {
  const Grid({
    @required this.children,
    this.columnCount: 2,
  });

  final List<Widget> children;
  final int columnCount;

  List<Widget> _buildGrid() {
    List<Widget> rows = [];
    List<Widget> columns = [];
    int _columnCount = columnCount;
    int _rowCount = (children.length / columnCount).ceil();
    int _lastRowColumnCount = children.length % columnCount;

    for (int i = 0; i < _rowCount; i++) {
      columns = [];
      if (i == _rowCount - 1 && _lastRowColumnCount != 0)
        _columnCount = _lastRowColumnCount;

      for (int j = 0; j < _columnCount; j++) {
        int index = i * columnCount + j;
        columns.add(children[index]);
      }

      rows.add(
        new Row(
          children: columns,
        ),
      );
    }

    return rows;
  }

  Widget build(BuildContext context) {
    return new Column(
      children: _buildGrid(),
    );
  }
}

class FadingPageRoute<T> extends MaterialPageRoute<T> {
  FadingPageRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;

    return new FadeTransition(opacity: animation, child: child);
  }
}
