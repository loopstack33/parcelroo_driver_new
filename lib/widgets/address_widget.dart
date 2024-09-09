import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';

class AddressWidget extends StatelessWidget {
   final Color color;
   final String type;
   final String date;
   final String time;
   final String? email;
   final String? contact;
   final String? name;
   final String address;
   final bool isOther;
   final bool hasNavigation;
   const AddressWidget({Key? key,required this.hasNavigation,required this.color,required this.time,required this.date,
   required this.type,required this.address,required this.isOther,this.email,this.name,this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: myText(text: type, fontFamily: "Poppins", fontWeight: FontWeight.w600,size: 18.sp, color: Colors.black)),
          SizedBox(height: 10.h),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Row(
               children: [
                 Icon(FeatherIcons.calendar,color: Colors.black,size: 25.sp),
                 SizedBox(width: 10.w),
                 myText(text: date, fontFamily: "Poppins", fontWeight: FontWeight.w500,size: 14.sp, color: whiteColor),
               ],
             ),
             Row(
               children: [
                 Icon(FeatherIcons.clock,color: Colors.black,size: 25.sp),
                 SizedBox(width: 10.w),
                 myText(text: time, fontFamily: "Poppins", fontWeight: FontWeight.w500,size: 14.sp, color: whiteColor),
               ],
             ),
           ],
         ),
          if(isOther)...[
            SizedBox(height: 10.h),
            Row(
              children: [
                myText(text: "Customer Name:", fontFamily: "Poppins", fontWeight: FontWeight.w600,size: 14.sp, color: Colors.black),
                SizedBox(width: 10.w),
                myText(text: name??"", fontFamily: "Poppins",size: 14.sp, color: whiteColor),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                myText(text: "Customer Contact:", fontFamily: "Poppins", fontWeight: FontWeight.w600,size: 14.sp, color: Colors.black),
                SizedBox(width: 10.w),
                myText(text: contact??"", fontFamily: "Poppins", size: 14.sp, color: whiteColor),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                myText(text: "Customer Email:", fontFamily: "Poppins", fontWeight: FontWeight.w600,size: 14.sp, color: Colors.black),
                SizedBox(width: 10.w),
                myText(text: email??"", fontFamily: "Poppins", size: 14.sp, color: whiteColor),
              ],
            ),
            SizedBox(height: 10.h),
            myText(text: "Customer Address:", fontFamily: "Poppins", fontWeight: FontWeight.w600,size: 14.sp, color: Colors.black),
            myText(text: address, fontFamily: "Poppins",size: 14.sp, color: whiteColor),
            SizedBox(height: 10.h),
          ]
          else...[
            SizedBox(height: 10.h),
            myText(text: "Customer Address:", fontFamily: "Poppins", fontWeight: FontWeight.w600,size: 14.sp, color: Colors.black),
            myText(text: address, fontFamily: "Poppins",size: 14.sp, color: whiteColor),
            SizedBox(height: 10.h),
          ],
          if(hasNavigation)...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                myText(text: "Navigate", fontFamily: "Poppins", fontWeight: FontWeight.w500,size: 14.sp, color: whiteColor),
                SizedBox(width: 10.w),
                Icon(FeatherIcons.mapPin,color: Colors.black,size: 25.sp),
                SizedBox(height: 10.h),
              ],
            ),
            SizedBox(height: 10.h),
          ]
        ],
      ),
    );
  }
}
