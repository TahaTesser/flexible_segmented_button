import 'package:flutter/material.dart';

const double _kItemSize = 80.0;
// const PageScrollPhysics _kPagePhysics = PageScrollPhysics();

class FlexibleSegment<T> {
  const FlexibleSegment({
    this.top,
    this.center,
    this.bottom,
    this.tooltip,
  }) : assert(top != null || center != null || bottom != null);

  final Widget? top;
  final Widget? center;
  final Widget? bottom;
  final String? tooltip;
}

class FlexibleSegmentedButton<T> extends StatelessWidget {
  const FlexibleSegmentedButton({
    super.key,
    required this.segments,
    required this.activeIndex,
    this.visibleItems = 4,
    this.constraints,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius,
    this.onSegmentTap,
  });

  final List<FlexibleSegment<T>> segments;
  final int activeIndex;
  final int visibleItems;
  final BoxConstraints? constraints;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final ValueChanged<int>? onSegmentTap;

  @override
  Widget build(BuildContext context) {
    final BoxConstraints constraints = this.constraints ??
      BoxConstraints(
        maxHeight: _kItemSize + padding.vertical + 8.0,
        maxWidth: (_kItemSize + padding.horizontal) * visibleItems,
      );
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: constraints,
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        // physics: SnappingScrollPhysics(itemExtent: _kItemSize + padding.horizontal, parent: const ClampingScrollPhysics()),
        scrollDirection: Axis.horizontal,
        itemCount: segments.length,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (BuildContext context, int index) {
          final Color backgroundColor = index < activeIndex
              ? colorScheme.primary
              : colorScheme.primaryContainer;
          final Color textColor = index < activeIndex
              ? colorScheme.onPrimary
              : colorScheme.onPrimaryContainer;
          final TextStyle topTextStyle = TextStyle(color: textColor);
          final TextStyle centerTextStyle = theme.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: textColor);
          final TextStyle bottomTextStyle = TextStyle(color: textColor);

          BorderRadius borderRadius = BorderRadius.zero;
          if (index == 0) {
            borderRadius = const BorderRadius.horizontal(left: Radius.circular(_kItemSize / 4));
          } else if (index == segments.length - 1) {
            borderRadius = const BorderRadius.horizontal(right: Radius.circular(_kItemSize / 4));
          }

          if (activeIndex == index) {
            return CustomPaint(
              painter: _ActivSegmentBackground(
                activeColor: colorScheme.primary,
                inactiveColor: backgroundColor,
                childSize: const Size.square(_kItemSize),
              ),
              child: Material(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kItemSize / 4)),
                elevation: 2.0,
                child: _SegmentWidget(
                  top: segments[index].top,
                  center: segments[index].center,
                  bottom: segments[index].bottom,
                  topTextStyle: topTextStyle,
                  centerTextStyle: centerTextStyle,
                  bottomTextStyle: bottomTextStyle,
                  padding: padding,
                ),
              ),
            );
          }

          return _SegmentWidget(
            top: segments[index].top,
            center: segments[index].center,
            bottom: segments[index].bottom,
            topTextStyle: topTextStyle,
            centerTextStyle: centerTextStyle,
            bottomTextStyle: bottomTextStyle,
            padding: padding,
            borderRadius: borderRadius,
            backgroundColor: backgroundColor,
            onTap: () {
              onSegmentTap?.call(index);
            },
          );
        },
      ),
      // child: CustomPaint(
      // painter: _ActivSegmentBackground(
      //   backgroundColor: colorScheme.primaryContainer,
      //   backgroundRadius: const Radius.circular(_SegmentSize / 4),
      //   childSize: const Size.square(_SegmentSize),
      // ),
      // child: ListView.builder(
      //   physics: const SnappingScrollPhysics(
      //       itemExtent: _SegmentItemExtent,
      //       parent: ClampingScrollPhysics()),
      //   scrollDirection: Axis.horizontal,
      //   itemCount: segments.length,
      //   padding: const EdgeInsets.symmetric(vertical: 8.0),
      //   itemBuilder: (BuildContext context, int index) {
      //     final Color textColor = index < activeIndex
      //         ? colorScheme.onPrimary
      //         : colorScheme.onPrimaryContainer;
      //     if (index == activeIndex) {
      //       return CustomPaint(
      //         painter: _SegmentBackgroundPainter(
      //           activeIndex: activeIndex,
      //           index: index,
      //           childSize: const Size.square(_SegmentSize),
      //           backgroundRadius: const Radius.circular(_SegmentSize / 4),
      //           completedColor: colorScheme.onPrimaryContainer,
      //         ),
      //         child: Card(
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(_SegmentSize / 4)),
      //           margin: EdgeInsets.zero,
      //           elevation: 4.0,
      //           child: _SegmentWidget(
      //             size: const Size.square(_SegmentSize),
      //             top: segments[index].top,
      //             center: segments[index].center,
      //             bottom: segments[index].bottom,
      //             textColor: textColor,
      //           ),
      //         ),
      //       );
      //     }
      //     return CustomPaint(
      //       painter: _SegmentBackgroundPainter(
      //         activeIndex: activeIndex,
      //         index: index,
      //         childSize: const Size.square(_SegmentSize),
      //         backgroundRadius: const Radius.circular(_SegmentSize / 4),
      //         completedColor: colorScheme.onPrimaryContainer,
      //       ),
      //       child: _SegmentWidget(
      //         size: const Size.square(_SegmentSize),
      //         top: segments[index].top,
      //         center: segments[index].center,
      //         bottom: segments[index].bottom,
      //         textColor: textColor,
      //       ),
      //     );
      //   },
      // ),
      // ),
    );
    // return ScrollConfiguration(
    //   behavior: const ScrollBehavior().copyWith(dragDevices: {
    //     PointerDeviceKind.touch,
    //     PointerDeviceKind.mouse,
    //   }, scrollbars: false),
    //   child: ConstrainedBox(
    //     constraints: const BoxConstraints(
    //         maxHeight: _SegmentSize, maxWidth: _SegmentSize * 5),
    //     child: CustomPaint(
    //       painter: _ActivSegmentBackground(
    //         backgroundColor: colorScheme.primaryContainer,
    //         backgroundRadius: const Radius.circular(_SegmentSize / 4),
    //         childSize: const Size.square(_SegmentSize),
    //       ),
    //       child: ListView.builder(
    //         physics: const SnappingScrollPhysics(
    //             itemExtent: _SegmentItemExtent,
    //             parent: ClampingScrollPhysics()),
    //         scrollDirection: Axis.horizontal,
    //         itemCount: segments.length,
    //         padding: const EdgeInsets.symmetric(vertical: 8.0),
    //         itemBuilder: (BuildContext context, int index) {
    //           final Color textColor = index < activeIndex
    //               ? colorScheme.onPrimary
    //               : colorScheme.onPrimaryContainer;
    //           if (index == activeIndex) {
    //             return CustomPaint(
    //               painter: _SegmentBackgroundPainter(
    //                 activeIndex: activeIndex,
    //                 index: index,
    //                 childSize: const Size.square(_SegmentSize),
    //                 backgroundRadius: const Radius.circular(_SegmentSize / 4),
    //                 completedColor: colorScheme.onPrimaryContainer,
    //               ),
    //               child: Card(
    //                 shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(_SegmentSize / 4)),
    //                 margin: EdgeInsets.zero,
    //                 elevation: 4.0,
    //                 child: _SegmentWidget(
    //                   size: const Size.square(_SegmentSize),
    //                   top: segments[index].top,
    //                   center: segments[index].center,
    //                   bottom: segments[index].bottom,
    //                   textColor: textColor,
    //                 ),
    //               ),
    //             );
    //           }
    //           return CustomPaint(
    //             painter: _SegmentBackgroundPainter(
    //               activeIndex: activeIndex,
    //               index: index,
    //               childSize: const Size.square(_SegmentSize),
    //               backgroundRadius: const Radius.circular(_SegmentSize / 4),
    //               completedColor: colorScheme.onPrimaryContainer,
    //             ),
    //             child: _SegmentWidget(
    //               size: const Size.square(_SegmentSize),
    //               top: segments[index].top,
    //               center: segments[index].center,
    //               bottom: segments[index].bottom,
    //               textColor: textColor,
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}

class _SegmentWidget extends StatelessWidget {
  const _SegmentWidget({
    required this.top,
    required this.center,
    required this.bottom,
    this.topTextStyle,
    this.centerTextStyle,
    this.bottomTextStyle,
    required this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
  });

  final Widget? top;
  final Widget? center;
  final Widget? bottom;
  final TextStyle? topTextStyle;
  final TextStyle? centerTextStyle;
  final TextStyle? bottomTextStyle;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints:  BoxConstraints(
          minWidth: _kItemSize + padding.horizontal,
          maxWidth: _kItemSize + padding.horizontal,
          minHeight: _kItemSize + padding.vertical,
          maxHeight: _kItemSize + padding.vertical,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: backgroundColor,
          ),
          child: Padding(
            padding: padding,
            child: Column(
              children: <Widget>[
                if (top != null)
                  DefaultTextStyle(
                    style: textTheme.bodyMedium!.merge(topTextStyle),
                    child: top!,
                  ),
                if (center != null)
                  DefaultTextStyle(
                    style: textTheme.bodyMedium!.merge(centerTextStyle),
                    child: Expanded(child: Center(child: center!)),
                  ),
                if (bottom != null)
                  DefaultTextStyle(
                    style: textTheme.bodyMedium!.merge(bottomTextStyle),
                    child: bottom!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SnappingScrollPhysics extends ScrollPhysics {
  final double itemExtent;

  const SnappingScrollPhysics({required this.itemExtent, super.parent});

  @override
  SnappingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnappingScrollPhysics(
        itemExtent: itemExtent, parent: buildParent(ancestor));
  }

  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance) {
    var itemIndex = (position.pixels / itemExtent).round();
    return itemIndex * itemExtent;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (position.pixels <= position.minScrollExtent ||
        position.pixels >= position.maxScrollExtent) {
      return super.createBallisticSimulation(position, velocity);
    }

    Tolerance tolerance = this.tolerance;
    double target = _getTargetPixels(position, tolerance);

    if (velocity.abs() < tolerance.velocity ||
        (velocity > 0 && target <= position.pixels) ||
        (velocity < 0 && target >= position.pixels)) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }

    return null;
  }
}

// class _SegmentBackgroundPainter extends CustomPainter {
//   _SegmentBackgroundPainter({
//     required this.activeIndex,
//     required this.index,
//     required this.childSize,
//     required this.backgroundRadius,
//     required this.completedColor,
//   });

//   final int activeIndex;
//   final int index;
//   final Size childSize;
//   final Radius backgroundRadius;
//   final Color completedColor;

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Paint backgroundPaint = Paint()..color = backgroundColor;
//     // canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), backgroundRadius), backgroundPaint); // Example: Blue rectangle for the first 100 pixels in height
//     Paint completedPaint = Paint()..color = completedColor;

//     if (index == 0) {
//       canvas.drawRRect(
//           RRect.fromRectAndCorners(
//             Rect.fromLTWH(0, 0, childSize.width, size.height),
//             topLeft: backgroundRadius,
//             bottomLeft: backgroundRadius,
//           ),
//           completedPaint); // Example: Blue rectangle for the first 100 pixels in height
//     } else if (index < activeIndex) {
//       canvas.drawRect(Rect.fromLTWH(0, 0, childSize.width, size.height),
//           completedPaint); // Example: Blue rectangle for the first 100 pixels in height
//     } else if (index == activeIndex) {
//       canvas.drawRect(Rect.fromLTWH(0, 0, childSize.width / 2, size.height),
//           completedPaint); // Example: Blue rectangle for the first 100 pixels in height
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

class _ActivSegmentBackground extends CustomPainter {
  _ActivSegmentBackground({
    required this.activeColor,
    required this.inactiveColor,
    required this.childSize,
  });
  final Color activeColor;
  final Color inactiveColor;
  final Size childSize;

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()..color = activeColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width / 2, size.height), backgroundPaint);
    backgroundPaint = Paint()..color = inactiveColor;
    canvas.drawRect(Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height), backgroundPaint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
