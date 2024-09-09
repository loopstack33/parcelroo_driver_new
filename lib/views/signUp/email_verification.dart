import 'package:easy_localization/easy_localization.dart';
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/image_constants.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/views/login/login_screen.dart';
import 'package:parcelroo_driver_app/views/signUp/controller/signUp_provider.dart';
import 'package:provider/provider.dart';
import '../../enums/color_constants.dart';
import '../../widgets/text_widget.dart';

class EmailVerification extends StatefulWidget {
  final bool from;
  const EmailVerification({Key? key,required this.from}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SignUpProvider>().setTimerForAutoRedirect(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: bgGradient
        ),
        child: SingleChildScrollView(
          padding:  EdgeInsets.only(left: 20.w,right: 20.w,top: 60.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(email),
              SizedBox(height: 20.h),
              myText(text: "verifyEmail", fontFamily: "Poppins", size: 24.sp, color: whiteColor,fontWeight: FontWeight.w500,),
              SizedBox(height: 30.h),
              myText(text: "sentUEmail", fontFamily: "Poppins", size: 18.sp, color: whiteColor,fontWeight: FontWeight.w300,textAlign: TextAlign.center,),
              SizedBox(height: 10.h),
              myText(text: "reDirection", fontFamily: "Poppins", size: 18.sp, color: whiteColor,fontWeight: FontWeight.w300,textAlign: TextAlign.center,),
              SizedBox(height: 50.h),
              MyFancyButton(
                  width: MediaQuery.of(context).size.width*0.5,
                  borderRadius:40.r,
                  isIconButton: false,
                  isGradient: true,
                  gradient: const LinearGradient(
                    colors: [
                      darkPurple,
                      Color(0xFF6610F2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  fontSize: 22.sp,
                  family: "Poppins",
                  text: "continue".tr(), tap: (){
                   context.read<SignUpProvider>().manualCheckEmailVerificationStatus(context);
                  },
                  buttonColor: darkPurple,
                  hasShadow: true),
              SizedBox(height: 50.h),
              GestureDetector(
                onTap: (){
                  context.read<SignUpProvider>().sendEmailVerification(context);
                },
                child: myText(text: "resendEmailL", fontFamily: "Poppins", size: 20.sp, color: help,fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 30.h),
              GestureDetector(
                onTap: (){
                  if(widget.from){
                    AppRoutes.pushAndRemoveUntil(context, const LoginScreen(from: false,));
                  }
                  else{
                    AppRoutes.pop(context);
                  }

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FeatherIcons.arrowLeft,color:whiteColor,size: 25.sp,),
                    SizedBox(width: 10.w),
                    myText(text: "goBack", fontFamily: "Poppins", size: 20.sp, color: whiteColor,fontWeight: FontWeight.w500),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
