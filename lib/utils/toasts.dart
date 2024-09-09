import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';


class ToastUtils{

  static successToast(String msg, BuildContext context){
    return showToast(msg.tr(),
      context: context,
      textStyle: TextStyle(fontSize: 14.sp,fontFamily: 'Poppins',color: whiteColor),
      backgroundColor: Colors.green,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      animDuration:const Duration(seconds: 1),
      duration:const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }

  static failureToast(String msg,BuildContext context){
    return showToast(msg.tr(),
      context: context,
      textStyle: TextStyle(fontSize: 14.sp,fontFamily: 'Poppins',color: whiteColor),
      backgroundColor: Colors.red,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      animDuration:const Duration(seconds: 1),
      duration:const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }

  static warningToast(String msg,BuildContext context){
    return showToast(msg.tr(),
      context: context,
      textStyle: TextStyle(fontSize: 14.sp,fontFamily: 'Poppins',color: Colors.black),
      backgroundColor: Colors.yellowAccent,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      animDuration:const Duration(seconds: 1),
      duration:const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }

  static infoToast(String msg,BuildContext context){
    return showToast(msg.tr(),
      context: context,
      textStyle: TextStyle(fontSize: 12.sp,fontFamily: 'Poppins',color: whiteColor),
      backgroundColor: Colors.blueAccent,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      animDuration:const Duration(seconds: 1),
      duration:const Duration(seconds: 3),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
  }

}

