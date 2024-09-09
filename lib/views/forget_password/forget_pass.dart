import 'package:easy_localization/easy_localization.dart';
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:parcelroo_driver_app/views/forget_password/controller/forget_pass_provider.dart';
import 'package:provider/provider.dart';
import '../../enums/color_constants.dart';
import '../../utils/app_routes.dart';

import '../../widgets/custom_textfield.dart';
import '../../widgets/text_widget.dart';
import '../signUp/sign_up.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: bgGradient
          ),
          child: LoadingAnimation(
            inAsyncCall: context.watch<ForgetPassProvider>().isLoading,
            child: Form(
              key: context.read<ForgetPassProvider>().formKey,
              child: Padding(
                padding:  EdgeInsets.only(left: 20.w,right: 20.w,top: 30.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 60.h),
                      Text.rich(
                          TextSpan(
                              children:[
                                TextSpan(
                                    text: "Parcel",
                                    style: TextStyle(fontFamily: "Fredoka",fontSize: 40.sp,color:lightBlue)
                                ),
                                TextSpan(
                                    text: "roo",
                                    style: TextStyle(fontFamily: "Fredoka",fontSize: 40.sp,color:lightPurple)
                                )
                              ])),
                      SizedBox(height: 40.h),
                      myText(text: "forgetPass", fontFamily: "Poppins", size: 28.sp, color: whiteColor,fontWeight: FontWeight.w700,),
                      SizedBox(height: 20.h),
                      CustomTextField(
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'enterEmail'.tr();
                            }
                            else if((RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value) ==
                                false) ){

                              return 'validEmail'.tr();
                            }
                            return null;
                          },controller: context.read<ForgetPassProvider>().emailController, hint: "eEmail",suffixIcon: Icon(Icons.email,color: greyDark,size: 25.sp)),

                      SizedBox(height: 40.h),
                      myText(text: "fMsg",
                        fontFamily: "Poppins", size: 16.sp, color: whiteColor,textAlign: TextAlign.center,),
                      SizedBox(height: 40.h),
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
                          text: "submit".tr(), tap: (){
                        // Validate returns true if the form is valid, or false otherwise.
                        if (context.read<ForgetPassProvider>().formKey.currentState!.validate()) {
                          context.read<ForgetPassProvider>().sendResetLink(context);
                        }

                      },
                          buttonColor: darkPurple,
                          hasShadow: true),
                      SizedBox(height: 40.h),
                      InkWell(
                        onTap: (){
                          AppRoutes.push(context, PageTransitionType.fade, const SignUp());
                        },
                        child:   Text.rich(TextSpan(children:[
                          TextSpan(
                              text: "noAccount".tr(),
                              style: TextStyle(fontFamily: "Poppins",fontSize: 18.sp,color:greyLight)
                          ),
                          TextSpan(
                              text: " ${"signUp".tr()}",
                              style: TextStyle(fontFamily: "Poppins",fontWeight:FontWeight.w600,fontSize: 18.sp,color:darkPurple,decoration: TextDecoration.underline)
                          )
                        ])),
                      ),
                    ],
                  ),
                ),
              ),
            )
          )
      ),
    );
  }
}
