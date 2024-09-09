// ignore_for_file: must_be_immutable

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';

class DocWidget extends StatelessWidget {
  bool hasTwo;
  String text;
  VoidCallback tap;
  bool uploaded;
  DocWidget({Key? key,required this.text,required this.hasTwo,required this.tap,required this.uploaded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        myText(text: text, fontFamily: "Poppins", size: 16.sp, color: whiteColor),

        Icon(uploaded?FeatherIcons.checkCircle:FeatherIcons.upload,color:uploaded? Colors.greenAccent:whiteColor,size: 25.sp),

      ],
    );
  }
}
