// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';


class MySimpleDialog extends StatelessWidget {
  final String title;
  final String msg;
  final IconData icon;
  final VoidCallback? onTap;
  const MySimpleDialog({Key? key,this.onTap,required this.title,required this.msg,required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        elevation: 10,
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: dialogColor,
        child:Container(

          width: MediaQuery.of(context).size.width*0.8,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10),

            boxShadow: const [
              BoxShadow(
                color: Color(0x192f80ed),
                blurRadius: 40,
                offset: Offset(5, 5),
              ),
            ],
            color: dialogColor
          ),
          padding:const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap:onTap?? (){
                    AppRoutes.pop(context);
                  },
                  child:const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(FeatherIcons.x,color: whiteColor,)
                  ),
                ),
                Icon(icon,color: whiteColor,size: 30.sp,),
                SizedBox(height: 10.h),
                myText(text: title.tr(), fontFamily: "Poppins", fontWeight: FontWeight.w700,size: 24.sp, color: whiteColor,textAlign: TextAlign.center,),
                SizedBox(height: 20.h),
                myText(text: msg, fontFamily: "Poppins", fontWeight: FontWeight.w400,size: 16.sp, color: whiteColor,textAlign: TextAlign.center,),

              ],
            ),
          ),
        )
    );
  }

}
