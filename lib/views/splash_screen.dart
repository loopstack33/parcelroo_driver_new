// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:parcelroo_driver_app/enums/image_constants.dart';
import 'package:parcelroo_driver_app/views/dashboard/dashboard.dart';
import 'package:parcelroo_driver_app/views/login/login_screen.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/color_constants.dart';
import '../utils/app_routes.dart';
import 'dashboard/controller/dash_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
   checkIfUserLoggedIn();
  }

  checkIfUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool('remember_me');
    var isLoggedIn = prefs.getBool("isLoggedIn");


    if (loggedIn == false && isLoggedIn == false) {
      Future.delayed(const Duration(seconds: 3),
              () => AppRoutes.pushAndRemoveUntil(context, const LoginScreen(from: false,)));
    }

    else if (loggedIn == true && isLoggedIn == true ) {
      Provider.of<DashProvider>(context, listen: false)
          .getData(context);
      Future.delayed(const Duration(seconds: 3),
              () => AppRoutes.pushAndRemoveUntil(context, const Dashboard()));

    }
    else{
      Future.delayed(const Duration(seconds: 3),
              () => AppRoutes.pushAndRemoveUntil(context, const LoginScreen(from: false)));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Center(
         child:Padding(
           padding: EdgeInsets.only(left: 10.w,right: 10.w),
           child:  Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Spacer(),
               Text.rich(TextSpan(children:[
                 TextSpan(
                     text: "Parcel",
                     style: TextStyle(fontFamily: "Fredoka",fontSize: 40.sp,color:dashColor)
                 ),
                 TextSpan(
                     text: "roo",
                     style: TextStyle(fontFamily: "Fredoka",fontSize: 40.sp,color:dashColor)
                 )
               ])),
               myText(text: "version", fontFamily: "Poppins",fontWeight: FontWeight.w400, size: 14.sp, textAlign: TextAlign.center,color: dashColor),

               const Spacer(),
               Lottie.asset(delivery),
               SizedBox(height: 30.h),
               myText(text: "address", fontFamily: "Poppins",fontWeight: FontWeight.w400, size: 14.sp, textAlign: TextAlign.center,color: dashColor),
               SizedBox(height: 10.h),
               Text.rich(TextSpan(children: [
                 TextSpan(
                     text: "companyNo".tr(),
                     style: TextStyle(fontSize: 14.sp,fontFamily: "Poppins",color: dashColor)
                 ),
                 TextSpan(
                     text: "13340898",
                     style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,fontFamily: "Poppins",color: dashColor)
                 ),
               ])),
               SizedBox(height: 30.h),
             ],)
         )
     ));
  }

}
