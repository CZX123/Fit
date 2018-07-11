// Imported from Flutter official code to add support for dark mode

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

const Color _kHighlighterBorder = const Color(0xFF7F7F7F);
const Color _kDefaultBackground = const Color(0xFFD2D4DB);
const double _kDefaultDiameterRatio = 1.1;
const double _kForegroundScreenOpacityFraction = 0.7;

/// An iOS-styled picker.
///
/// Displays the provided [children] widgets on a wheel for selection and
/// calls back when the currently selected item changes.
///
/// Can be used with [showModalBottomSheet] to display the picker modally at the
/// bottom of the screen.
///
/// See also:
///
///  * [ListWheelScrollView], the generic widget backing this picker without
///    the iOS design specific chrome.
///  * <https://developer.apple.com/ios/human-interface-guidelines/controls/pickers/>
class CupertinoPicker extends StatefulWidget {
  /// Creates a control used for selecting values.
  ///
  /// The [diameterRatio] and [itemExtent] arguments must not be null. The
  /// [itemExtent] must be greater than zero.
  ///
  /// The [backgroundColor] defaults to light gray. It can be set to null to
  /// disable the background painting entirely; this is mildly more efficient
  /// than using [Colors.transparent].
  const CupertinoPicker({
    Key key,
    this.notSoDark,
    this.diameterRatio = _kDefaultDiameterRatio,
    this.backgroundColor = _kDefaultBackground,
    this.scrollController,
    @required this.itemExtent,
    @required this.onSelectedItemChanged,
    @required this.children,
  })  : assert(diameterRatio != null),
        assert(diameterRatio > 0.0,
            RenderListWheelViewport.diameterRatioZeroMessage),
        assert(itemExtent != null),
        assert(itemExtent > 0),
        super(key: key);

  final bool notSoDark;

  /// Relative ratio between this picker's height and the simulated cylinder's diameter.
  ///
  /// Smaller values creates more pronounced curvatures in the scrollable wheel.
  ///
  /// For more details, see [ListWheelScrollView.diameterRatio].
  ///
  /// Must not be null and defaults to `1.1` to visually mimic iOS.
  final double diameterRatio;

  /// Background color behind the children.
  ///
  /// Defaults to a gray color in the iOS color palette.
  ///
  /// This can be set to null to disable the background painting entirely; this
  /// is mildly more efficient than using [Colors.transparent].
  final Color backgroundColor;

  /// A [FixedExtentScrollController] to read and control the current item.
  ///
  /// If null, an implicit one will be created internally.
  final FixedExtentScrollController scrollController;

  /// The uniform height of all children.
  ///
  /// All children will be given the [BoxConstraints] to match this exact
  /// height. Must not be null and must be positive.
  final double itemExtent;

  /// An option callback when the currently centered item changes.
  ///
  /// Value changes when the item closest to the center changes.
  ///
  /// This can be called during scrolls and during ballistic flings. To get the
  /// value only when the scrolling settles, use a [NotificationListener],
  /// listen for [ScrollEndNotification] and read its [FixedExtentMetrics].
  final ValueChanged<int> onSelectedItemChanged;

  /// [Widget]s in the picker's scroll wheel.
  final List<Widget> children;

  @override
  State<StatefulWidget> createState() => new _CupertinoPickerState();
}

class _CupertinoPickerState extends State<CupertinoPicker> {
  int _lastHapticIndex;

  void _handleSelectedItemChanged(int index) {
    // Only the haptic engine hardware on iOS devices would produce the
    // intended effects.
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        index != _lastHapticIndex) {
      _lastHapticIndex = index;
      HapticFeedback.selectionClick();
    }

    if (widget.onSelectedItemChanged != null) {
      widget.onSelectedItemChanged(index);
    }
  }

  /// Makes the fade to white edge gradients.
  Widget _buildGradientScreen() {
    return new Positioned.fill(
      child: new IgnorePointer(
        child: new Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.light
                  ? const <Color>[
                      const Color(0xFFFFFFFF),
                      const Color(0xF2FFFFFF),
                      const Color(0xDDFFFFFF),
                      const Color(0x00FFFFFF),
                      const Color(0x00FFFFFF),
                      const Color(0xDDFFFFFF),
                      const Color(0xF2FFFFFF),
                      const Color(0xFFFFFFFF),
                    ]
                  : widget.notSoDark
                      ? const <Color>[
                          const Color(0xFF303030),
                          const Color(0xF2303030),
                          const Color(0xDD303030),
                          const Color(0x00303030),
                          const Color(0x00303030),
                          const Color(0xDD303030),
                          const Color(0xF2303030),
                          const Color(0xFF303030),
                        ]
                      : const <Color>[
                          const Color(0xFF212121),
                          const Color(0xF2212121),
                          const Color(0xDD212121),
                          const Color(0x00212121),
                          const Color(0x00212121),
                          const Color(0xDD212121),
                          const Color(0xF2212121),
                          const Color(0xFF212121),
                        ],
              stops: const <double>[
                0.0,
                0.05,
                0.09,
                0.22,
                0.78,
                0.91,
                0.95,
                1.0,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  /// Makes the magnifier lens look so that the colors are normal through
  /// the lens and partially grayed out around it.
  Widget _buildMagnifierScreen() {
    final Color foreground = widget.backgroundColor?.withAlpha(
        (widget.backgroundColor.alpha * _kForegroundScreenOpacityFraction)
            .toInt());

    return new IgnorePointer(
      child: new Column(
        children: <Widget>[
          new Expanded(
            child: new Container(
              color: foreground,
            ),
          ),
          new Container(
            decoration: const BoxDecoration(
                border: const Border(
              top: const BorderSide(width: 0.0, color: _kHighlighterBorder),
              bottom: const BorderSide(width: 0.0, color: _kHighlighterBorder),
            )),
            constraints: new BoxConstraints.expand(height: widget.itemExtent),
          ),
          new Expanded(
            child: new Container(
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget result = new Stack(
      children: <Widget>[
        new Positioned.fill(
          child: new ListWheelScrollView(
            controller: widget.scrollController,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: widget.diameterRatio,
            itemExtent: widget.itemExtent,
            onSelectedItemChanged: _handleSelectedItemChanged,
            children: widget.children,
          ),
        ),
        _buildGradientScreen(),
        _buildMagnifierScreen(),
      ],
    );
    if (widget.backgroundColor != null) {
      result = new DecoratedBox(
        decoration: new BoxDecoration(
          color: widget.backgroundColor,
        ),
        child: result,
      );
    }
    return result;
  }
}
