// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';

Widget rememberMeCheckbox(bool _rememberMe,
    void Function(bool?) handleRememberMe, BuildContext context) {
  return Row(
    children: <Widget>[
      Container(
        width: 18.w,
        height:18.h,
        decoration: BoxDecoration(
            color: lightGrey, borderRadius: BorderRadius.circular(3.r)),
        child: Theme(
          data: ThemeData(unselectedWidgetColor: lightGrey),
          child: Transform.scale(
            scale:1.0,
            child: Checkbox(
                value: _rememberMe,
                activeColor: darkPurple,
                onChanged: handleRememberMe),
          ),
        ),
      ),
      SizedBox(width: 10.w),
      Text(
        'remember'.tr(),
        style: TextStyle(fontSize: 16.sp,fontFamily: "Poppins", color: greyLight),
      ),
    ],
  );
}
