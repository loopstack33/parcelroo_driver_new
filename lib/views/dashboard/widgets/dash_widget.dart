import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';

class DashWidget extends StatelessWidget {
  final Color color;
  final String? count;
  final String text;
  final IconData iconData;
  final bool? isLarge;
  final VoidCallback onTap;
  const DashWidget({Key? key,required this.onTap,this.isLarge,required this.color, required this.iconData,this.count,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLarge!=null?
   GestureDetector(
     onTap: onTap,
     child:  Container(
       height:80.h,
       width:isLarge!=null?MediaQuery.of(context).size.width : 160.w,
       decoration: BoxDecoration(
         color: color,
         borderRadius: BorderRadius.circular(17.r),
       ),
       padding: const EdgeInsets.all(10),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Icon(iconData,color: whiteColor,size: 25.sp,),
           myText(text: text, fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 16.sp, color: whiteColor),
           myText(text: count!, fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 22.sp, color: whiteColor),
         ],
       ),
     ),
   ) :
    GestureDetector(
      onTap: onTap,
      child: Container(
        height:120.h,
        width: 160.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(17.r),
        ),
        padding: const EdgeInsets.all(10),
        child: count==null?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData,color: whiteColor,size: 25.sp,),
            SizedBox(height: 20.h),
            myText(text: text, fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 16.sp, color: whiteColor)

          ],
        ):Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(iconData,color: whiteColor,size: 25.sp,),
            Center(
              child: Column(
                children: [
                  myText(text: count!, fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 22.sp, color: whiteColor),
                  myText(text: text, fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 16.sp, color: whiteColor,textAlign: TextAlign.center,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
