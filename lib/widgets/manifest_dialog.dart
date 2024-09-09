// ignore_for_file: must_be_immutable
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';


class ManifestDialog extends StatelessWidget {
  final String data;
  const ManifestDialog({Key? key,required this.data}) : super(key: key);

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
                myText(text: "Manifest", fontFamily: "Poppins", fontWeight: FontWeight.w600,size: 18.sp, color: Colors.black,textAlign: TextAlign.center,),
                SizedBox(height: 20.h),
                myText(text: data.toString(), fontFamily: "Poppins", size: 18.sp, color: drawerColor),
                SizedBox(height: 20.h),
                MyFancyButton(
                    width: MediaQuery.of(context).size.width*0.3,
                    height: 40.h,
                    borderRadius:22.r,
                    isIconButton: false,
                    isGradient: true,
                    gradient:close,
                    fontSize: 16.sp,
                    family: "Poppins",
                    fontColor:whiteColor,
                    text: "Close", tap:(){
                  AppRoutes.pop(context);
                },
                    buttonColor: greyDark,
                    hasShadow: false),
              ],
            ),
          ),
        )
    );
  }

}
