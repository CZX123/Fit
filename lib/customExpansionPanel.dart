import 'package:flutter/material.dart' show AnimatedContainer, AnimatedCrossFade, Animation, AnimationController, BorderRadius, Brightness, BuildContext, Colors, Column, Container, CrossFadeState, CurvedAnimation, Curves, ExpansionPanel, ExpansionPanelCallback, ExpansionPanelList, Icon, Icons, Interval, LocalKey, RotationTransition, SingleTickerProviderStateMixin, State, StatefulWidget, Theme, Tween, Widget, hashValues, kThemeAnimationDuration;
import 'mergeableMaterial.dart' show MaterialGap, MaterialSlice, MergeableMaterial, MergeableMaterialItem;
import 'dart:math' show pi;

const double _kPanelHeaderCollapsedHeight = 56.0;
const double _kPanelHeaderExpandedHeight = 72.0;

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _SaltedKey<S, V> typedOther = other;
    return salt == typedOther.salt && value == typedOther.value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}

class CustomExpansionPanelList extends ExpansionPanelList {
  CustomExpansionPanelList({
    List<ExpansionPanel> children,
    ExpansionPanelCallback expansionCallback,
    this.borderRadius,
  }) : super(children: children, expansionCallback: expansionCallback);

  final double borderRadius;

  bool _isChildExpanded(int index) {
    return children[index].isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];

    for (int index = 0; index < children.length; index += 1) {
      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1))
        items.add(new MaterialGap(
            key: new _SaltedKey<BuildContext, int>(context, index * 2 - 1)));

      final AnimatedContainer header = new AnimatedContainer(
        height: _isChildExpanded(index)
            ? _kPanelHeaderExpandedHeight
            : _kPanelHeaderCollapsedHeight,
        duration: animationDuration,
        curve: Curves.fastOutSlowIn,
        child: children[index].headerBuilder(
          context,
          children[index].isExpanded,
        ),
      );

      items.add(
        new MaterialSlice(
          key: new _SaltedKey<BuildContext, int>(context, index * 2),
          child: new Container(
            /*
            decoration: borderRadius != null
                ? _isChildExpanded(index)
                    ? BoxDecoration(
                        color: darkMode ? Colors.grey[850] : Colors.white,
                        borderRadius: BorderRadius.circular(borderRadius),
                      )
                    : index == 0
                        ? BoxDecoration(
                            color: darkMode ? Colors.grey[850] : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(borderRadius),
                              topRight: Radius.circular(borderRadius),
                            ),
                          )
                        : index == children.length - 1
                            ? BoxDecoration(
                                color:
                                    darkMode ? Colors.grey[850] : Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(borderRadius),
                                  bottomRight: Radius.circular(borderRadius),
                                ),
                              )
                            : BoxDecoration(
                                color:
                                    darkMode ? Colors.grey[850] : Colors.white,
                              )
                : BoxDecoration(
                    color: darkMode ? Colors.grey[850] : Colors.white,
                  ),
                  */
            child: new Column(
              children: <Widget>[
                header,
                new AnimatedCrossFade(
                  firstChild: new Container(height: 0.0),
                  secondChild: children[index].body,
                  firstCurve:
                      const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                  secondCurve:
                      const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                  sizeCurve: Curves.fastOutSlowIn,
                  crossFadeState: _isChildExpanded(index)
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: animationDuration,
                ),
              ],
            ),
          ),
        ),
      );

      if (_isChildExpanded(index) && index != children.length - 1)
        items.add(new MaterialGap(
            key: new _SaltedKey<BuildContext, int>(context, index * 2 + 1)));
    }

    return new MergeableMaterial(
      borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius) : BorderRadius.zero,
      elevation: darkMode ? 0 : 2,
      hasDividers: darkMode ? false : true,
      children: items,
    );
  }
}

class CustomExpandIcon extends StatefulWidget {
  const CustomExpandIcon(this.isExpanded);
  final bool isExpanded;

  @override
  _CustomExpandIconState createState() => new _CustomExpandIconState();
}

class _CustomExpandIconState extends State<CustomExpandIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _controller =
        new AnimationController(duration: kThemeAnimationDuration, vsync: this);
    _iconTurns = new Tween<double>(begin: 0.0, end: 0.5).animate(
        new CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    // If the widget is initially expanded, rotate the icon without animating it.
    if (widget.isExpanded) {
      _controller.value = pi;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomExpandIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return new RotationTransition(
      turns: _iconTurns,
      child: new Icon(
        Icons.expand_more,
        color: darkMode ? Colors.white : Colors.grey[700],
      ),
    );
  }
}
