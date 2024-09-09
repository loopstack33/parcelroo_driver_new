import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../enums/color_constants.dart';

class LoadingAnimation extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;

  const LoadingAnimation({
    Key? key,
    required this.child,
    required this.inAsyncCall,
    this.opacity = 0.4,
    this.color = dashColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          Center(
            child: LoadingAnimationWidget.discreteCircle(
                color: lightBlue,
                size: 50.w,
                secondRingColor: lightPurple,
                thirdRingColor: darkPurple),
          )
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
