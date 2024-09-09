// ignore_for_file: must_be_immutable
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/widgets/custom_textfield.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';


class CancelJobPopup extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  const CancelJobPopup({Key? key,required this.controller,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        elevation: 10,
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: whiteColor,
        child:Container(
          width: MediaQuery.of(context).size.width*0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xffdfe0eb), width: 1, ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x192f80ed),
                blurRadius: 40,
                offset: Offset(5, 5),
              ),
            ],
            color: Colors.white,
          ),
          padding:const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                myText(text: "Are You Sure You Want To Cancel This Job?", fontFamily: "Poppins", fontWeight: FontWeight.w600,size: 18.sp, color: redColor,textAlign: TextAlign.center,),
                SizedBox(height: 10.h),
                myText(text: "The will be shown to your service provider.", fontFamily: "Poppins",size: 14.sp, color: greyDark,textAlign: TextAlign.center),
                SizedBox(height: 20.h),
                CustomTextField(borderColor: greyDark,controller: controller, hint: "Reason for cancellation.......",maxLines: 5,),
                SizedBox(height: 20.h),
                MyFancyButton(
                    width: MediaQuery.of(context).size.width*0.7,
                    height: 50.h,
                    borderRadius:22.r,
                    isIconButton: false,
                    isGradient: true,
                    gradient:const  LinearGradient(
                      colors: [
                        Color(0xFF38EF7D),
                        Color(0xFF11998E),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    fontSize: 16.sp,
                    family: "Poppins",
                    fontColor:whiteColor,
                    text: "Confirm", tap:onTap,
                    buttonColor: greyDark,
                    hasShadow: false),
                SizedBox(height: 10.h),
                MyFancyButton(
                    width: MediaQuery.of(context).size.width*0.7,
                    height: 50.h,
                    borderRadius:22.r,
                    isIconButton: false,
                    fontSize: 16.sp,
                    family: "Poppins",
                    fontColor:redColor,
                    text: "Cancel", tap: (){
                      AppRoutes.pop(context);
                    },
                    buttonColor: whiteColor,
                    hasShadow: false),
              ],
            ),
          ),
        )
    );
  }

}
