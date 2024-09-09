
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/views/forget_password/controller/forget_pass_provider.dart';
import 'package:parcelroo_driver_app/views/forget_password/forget_pass.dart';
import 'package:parcelroo_driver_app/views/login/controller/login_provider.dart';
import 'package:parcelroo_driver_app/views/login/widgets/remember_me.dart';
import 'package:parcelroo_driver_app/views/signUp/controller/signUp_provider.dart';
import 'package:parcelroo_driver_app/views/signUp/sign_up.dart';
import 'package:parcelroo_driver_app/widgets/custom_textfield.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../enums/color_constants.dart';
import 'package:fancy_button_new/fancy_button_new.dart';

import '../../widgets/simple_dialog.dart';


class LoginScreen extends StatefulWidget {
  final bool from;
  const LoginScreen({Key? key,required this.from}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
    if(widget.from){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showDialog(context: context, builder: (context){
          return MySimpleDialog(title: "error", msg: "banned".tr(),
            icon:FeatherIcons.alertTriangle,);
        });
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginProvider>().loadUserEmailPassword(context);
    });
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
          child: Form(
            key: context.read<LoginProvider>().formKey,
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
                    myText(text: "login", fontFamily: "Poppins", size: 28.sp, color: whiteColor,fontWeight: FontWeight.w700,),
                    SizedBox(height: 20.h),
                    CustomTextField(controller: context.read<LoginProvider>().emailController, hint: "eEmail",suffixIcon: Icon(Icons.email,color: greyDark,size: 25.sp),
                      validator: (value) {
                        if(value ==null || value.isEmpty){
                        return "enterEmail".tr();

                        }
                        else if((RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value) ==
                            false) ){
                          return "validEmail".tr();
                        }

                        return null;
                      }),
                    SizedBox(height: 20.h),
                    CustomTextField(
                        validator: (value) {

                          if(value ==null || value.isEmpty){
                            return "enterPassword".tr();
                          }

                          return null;
                        },
                        controller: context.read<LoginProvider>().passController,
                        hint: "ePassword",
                        obscure:  context.watch<LoginProvider>().passwordVisible,
                        suffixIcon: InkWell(
                            onTap: () {
                              context
                                  .read<LoginProvider>()
                                  .togglePassword();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                context.watch<LoginProvider>().passwordVisible
                                    ? FeatherIcons.eye
                                    : FeatherIcons.eyeOff,
                                size: 25.sp,
                              ),
                            )),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ]),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        rememberMeCheckbox(context.read<LoginProvider>().rememberMe,
                            context.read<LoginProvider>().handleRememberMe, context),
                        InkWell(
                          onTap: (){ context.read<ForgetPassProvider>().reset();

                          AppRoutes.push(context, PageTransitionType.fade, const ForgetPassword());
                          },
                          child: Text( "${"forgetPass".tr()}?", style: TextStyle(fontFamily: "Poppins", fontSize: 16.sp, color: darkPurple,fontWeight: FontWeight.w400),),
                        )
                      ],
                    ),
                    SizedBox(height: 40.h),
                    context.watch<LoginProvider>().isLoading? const Center(
                      child: CircularProgressIndicator(color: darkPurple),
                    ): MyFancyButton(
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
                        text: "login".tr(), tap: (){
                      if (context.read<LoginProvider>().formKey.currentState!.validate()) {

                        context.read<LoginProvider>().signIn(context, context.read<LoginProvider>().emailController.text,
                            context.read<LoginProvider>().passController.text);
                      }
                    },
                        buttonColor: darkPurple,
                        hasShadow: true),
                    SizedBox(height: 40.h),
                    InkWell(
                      onTap: (){
                        context.read<SignUpProvider>().resetValues();
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
            )
          )
      ),
    );
  }

}
