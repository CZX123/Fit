import 'package:flutter/material.dart'
    show
        AnimatedContainer,
        AnimatedCrossFade,
        Animation,
        AnimationController,
        BorderRadius,
        Brightness,
        BuildContext,
        Colors,
        Column,
        Container,
        CrossFadeState,
        CurvedAnimation,
        Curves,
        EdgeInsets,
        ExpansionPanel,
        ExpansionPanelCallback,
        ExpansionPanelList,
        ExpansionPanelRadio,
        Icon,
        Icons,
        Interval,
        Key,
        ListBody,
        LocalKey,
        MergeSemantics,
        RotationTransition,
        SingleTickerProviderStateMixin,
        State,
        StatefulWidget,
        Theme,
        Tween,
        Widget,
        hashValues,
        kThemeAnimationDuration;
import 'mergeableMaterial.dart'
    show MaterialGap, MaterialSlice, MergeableMaterial, MergeableMaterialItem;
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

class CustomExpansionPanelList extends StatefulWidget {
  /// Creates an expansion panel list widget. The [expansionCallback] is
  /// triggered when an expansion panel expand/collapse button is pushed.
  ///
  /// The [children] and [animationDuration] arguments must not be null.
  const CustomExpansionPanelList({
    Key key,
    this.children = const <ExpansionPanel>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.borderRadius,
  })  : assert(children != null),
        assert(animationDuration != null),
        _allowOnlyOnePanelOpen = false,
        this.initialOpenPanelValue = null,
        super(key: key);

  /// Creates a radio expansion panel list widget.
  ///
  /// This widget allows for at most one panel in the list to be open.
  /// The expansion panel callback is triggered when an expansion panel
  /// expand/collapse button is pushed. The [children] and [animationDuration]
  /// arguments must not be null. The [children] objects must be instances
  /// of [ExpansionPanelRadio].
  const CustomExpansionPanelList.radio({
    Key key,
    List<ExpansionPanelRadio> children = const <ExpansionPanelRadio>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.initialOpenPanelValue,
    this.borderRadius,
  })  : children = children, // ignore: prefer_initializing_formals
        assert(children != null),
        assert(animationDuration != null),
        _allowOnlyOnePanelOpen = true,
        super(key: key);

  /// The children of the expansion panel list. They are laid out in a similar
  /// fashion to [ListBody].
  final List<ExpansionPanel> children;

  /// The callback that gets called whenever one of the expand/collapse buttons
  /// is pressed. The arguments passed to the callback are the index of the
  /// to-be-expanded panel in the list and whether the panel is currently
  /// expanded or not.
  ///
  /// This callback is useful in order to keep track of the expanded/collapsed
  /// panels in a parent widget that may need to react to these changes.
  final ExpansionPanelCallback expansionCallback;

  /// The duration of the expansion animation.
  final Duration animationDuration;

  // Whether multiple panels can be open simultaneously
  final bool _allowOnlyOnePanelOpen;

  /// The value of the panel that initially begins open. (This value is
  /// only used when initializing with the [ExpansionPanelList.radio]
  /// constructor.)
  final Object initialOpenPanelValue;

  final double borderRadius;

  @override
  State<StatefulWidget> createState() => _ExpansionPanelListState();
}

class _ExpansionPanelListState extends State<CustomExpansionPanelList> {
  ExpansionPanelRadio _currentOpenPanel;

  @override
  void initState() {
    super.initState();
    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All object identifiers are not unique!');
      for (ExpansionPanelRadio child in widget.children) {
        if (widget.initialOpenPanelValue != null &&
            child.value == widget.initialOpenPanelValue)
          _currentOpenPanel = child;
      }
    }
  }

  @override
  void didUpdateWidget(CustomExpansionPanelList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All object identifiers are not unique!');
      for (ExpansionPanelRadio newChild in widget.children) {
        if (widget.initialOpenPanelValue != null &&
            newChild.value == widget.initialOpenPanelValue)
          _currentOpenPanel = newChild;
      }
    } else if (oldWidget._allowOnlyOnePanelOpen) {
      _currentOpenPanel = null;
    }
  }

  bool _allIdentifiersUnique() {
    final Map<Object, bool> identifierMap = <Object, bool>{};
    for (ExpansionPanelRadio child in widget.children) {
      identifierMap[child.value] = true;
    }
    return identifierMap.length == widget.children.length;
  }

  bool _isChildExpanded(int index) {
    if (widget._allowOnlyOnePanelOpen) {
      final ExpansionPanelRadio radioWidget = widget.children[index];
      return _currentOpenPanel?.value == radioWidget.value;
    }
    return widget.children[index].isExpanded;
  }

  void _handlePressed(bool isExpanded, int index) {
    if (widget.expansionCallback != null)
      widget.expansionCallback(index, isExpanded);

    if (widget._allowOnlyOnePanelOpen) {
      final ExpansionPanelRadio pressedChild = widget.children[index];

      for (int childIndex = 0;
          childIndex < widget.children.length;
          childIndex += 1) {
        final ExpansionPanelRadio child = widget.children[childIndex];
        if (widget.expansionCallback != null &&
            childIndex != index &&
            child.value == _currentOpenPanel?.value)
          widget.expansionCallback(childIndex, false);
      }
      _currentOpenPanel = isExpanded ? null : pressedChild;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];
    const EdgeInsets kExpandedEdgeInsets = EdgeInsets.symmetric(
        vertical: _kPanelHeaderExpandedHeight - _kPanelHeaderCollapsedHeight);

    for (int index = 0; index < widget.children.length; index += 1) {
      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1))
        items.add(MaterialGap(
            key: _SaltedKey<BuildContext, int>(context, index * 2 - 1)));

      final ExpansionPanel child = widget.children[index];
      final AnimatedContainer header = AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.fastOutSlowIn,
        height: _isChildExpanded(index)
            ? _kPanelHeaderExpandedHeight
            : _kPanelHeaderCollapsedHeight,
        child: child.headerBuilder(
          context,
          _isChildExpanded(index),
        ),
      );

      items.add(
        MaterialSlice(
          key: _SaltedKey<BuildContext, int>(context, index * 2),
          child: Column(
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
            children: <Widget>[
              MergeSemantics(child: header),
              AnimatedCrossFade(
                firstChild: Container(height: 0.0),
                secondChild: child.body,
                firstCurve:
                    const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve:
                    const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState: _isChildExpanded(index)
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: widget.animationDuration,
              ),
            ],
          ),
        ),
      );

      if (_isChildExpanded(index) && index != widget.children.length - 1)
        items.add(MaterialGap(
            key: _SaltedKey<BuildContext, int>(context, index * 2 + 1)));
    }

    return MergeableMaterial(
      borderRadius: widget.borderRadius != null
          ? BorderRadius.circular(widget.borderRadius)
          : BorderRadius.zero,
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
        color: darkMode ? Colors.white : Colors.black54,
      ),
    );
  }
}
