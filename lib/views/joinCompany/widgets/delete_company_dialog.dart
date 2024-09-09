
// ignore_for_file: must_be_immutable
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/widgets/close_widget.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';


class DeleteCompanyPopup extends StatelessWidget {
  final VoidCallback onTap;
  const DeleteCompanyPopup({Key? key,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        elevation: 10,
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: whiteColor,
        child:Container(
          width: MediaQuery.of(context).size.width*0.9,
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
                const Align(
                  alignment: Alignment.centerRight,
                  child: CloseWidget(),
                ),
                myText(text: "WARNING! \nAre You Sure You Want To DELETE this company?", fontFamily: "Poppins", fontWeight: FontWeight.w600,size: 18.sp, color: redColor,textAlign: TextAlign.center,),
                SizedBox(height: 20.h),
                myText(text: "ACTION CANNOT BE UNDONE YOU MUST RE-APPLY TO JOIN COMPANY.", fontFamily: "Poppins",size: 14.sp, color: greyDark,textAlign: TextAlign.center),
                SizedBox(height: 40.h),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   MyFancyButton(
                       width: MediaQuery.of(context).size.width*0.3,
                       height: 50.h,
                       borderRadius:22.r,
                       isIconButton: false,
                       isGradient: true,
                       gradient:close,
                       fontSize: 16.sp,
                       family: "Poppins",
                       fontColor:whiteColor,
                       text: "No", tap:(){
                         AppRoutes.pop(context);
                   },
                       buttonColor: greyDark,
                       hasShadow: false),
                   MyFancyButton(
                       width: MediaQuery.of(context).size.width*0.3,
                       height: 50.h,
                       borderRadius:22.r,
                       isIconButton: false,
                       isGradient: true,
                       gradient:confirm,
                       fontSize: 16.sp,
                       family: "Poppins",
                       fontColor:whiteColor,
                       text: "Yes", tap:onTap,
                       buttonColor: greyDark,
                       hasShadow: false),
                 ],
               )
              ],
            ),
          ),
        )
    );
  }

}
