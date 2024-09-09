
import 'package:easy_localization/easy_localization.dart';
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:parcelroo_driver_app/utils/toasts.dart';
import 'package:parcelroo_driver_app/views/signUp/controller/signUp_provider.dart';
import 'package:parcelroo_driver_app/views/signUp/pages/bank_info.dart';
import 'package:parcelroo_driver_app/views/signUp/pages/contact_info.dart';
import 'package:parcelroo_driver_app/views/signUp/pages/home_info.dart';
import 'package:parcelroo_driver_app/views/signUp/pages/personal_info.dart';
import 'package:parcelroo_driver_app/views/signUp/pages/vehicleInfo.dart';
import 'package:provider/provider.dart';
import '../../enums/color_constants.dart';
import '../../widgets/text_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  late SignUpProvider signUpProvider;
  @override
  void initState() {
    super.initState();
    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    context.read<SignUpProvider>().pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    signUpProvider.pageController.dispose();
    signUpProvider.nameController.text = "";
    signUpProvider.surNameController.text = "";
    signUpProvider.middleNameController.text = "";
    signUpProvider.cityController.text = "";
    signUpProvider.confirmPassController.text = "";
    signUpProvider.passController.text = "";
    signUpProvider.phoneController.text = "";
    signUpProvider.accountCodeController.text = "";
    signUpProvider.accountHolderController.text = "";
    signUpProvider.accountNoController.text = "";
    signUpProvider.address1Controller.text = "";
    signUpProvider.address2Controller.text = "";
    signUpProvider.address3Controller.text = "";
    signUpProvider.zipController.text = "";
    signUpProvider.emailController.text = "";
    signUpProvider.dobController.text = "";
    signUpProvider.rollNoController.text = "";
    signUpProvider.ibanController.text = "";
    signUpProvider.internalEmailController.text = "";
    signUpProvider.reTypeInternalEmailController.text = "";
    for (TextEditingController c in signUpProvider.controllers) {
      c.clear();
      c.text='';
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return WillPopScope(onWillPop: () async {
      if(context.read<SignUpProvider>().currentStep==0){
        AppRoutes.pop(context);
      }
      else if(context.read<SignUpProvider>().currentStep==1){
        signUpProvider.pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }
      else if(context.read<SignUpProvider>().currentStep==2){
        signUpProvider.pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }
      else if(context.read<SignUpProvider>().currentStep==3){
        signUpProvider.pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }
      else if(context.read<SignUpProvider>().currentStep==4){
        signUpProvider.pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }
      else{
        AppRoutes.pop(context);
      }
      return false;
    }, child: Scaffold(

      body: LoadingAnimation(
        inAsyncCall: context.watch<SignUpProvider>().loading,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: bgGradient
          ),
          child:Form(
            key: context.read<SignUpProvider>().formKey,
            child: SingleChildScrollView(
                child:Column(children: [
                  SizedBox(height: 50.h),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: (){
                          if(context.read<SignUpProvider>().currentStep==0){
                            AppRoutes.pop(context);
                          }
                          else if(context.read<SignUpProvider>().currentStep==1){
                            signUpProvider.pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut);
                          }
                          else if(context.read<SignUpProvider>().currentStep==2){
                            signUpProvider.pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut);
                          }
                          else if(context.read<SignUpProvider>().currentStep==3){
                            signUpProvider.pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut);
                          }
                          else if(context.read<SignUpProvider>().currentStep==4){
                            signUpProvider.pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut);
                          }
                          else{
                            AppRoutes.pop(context);
                          }
                        },
                        child: Row(
                          children: [
                            Icon(FeatherIcons.chevronLeft,color: whiteColor,size: 30.sp),
                            SizedBox(width: 10.w),
                            myText(text: "back", fontFamily: "Poppins", size: 24.sp, color: whiteColor,fontWeight: FontWeight.w400,),
                          ],
                        ),
                      )
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height*0.8,
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        pageSnapping: true,
                        reverse: false,
                        controller: signUpProvider.pageController,
                        onPageChanged: (int index) => context.read<SignUpProvider>().changeIndex(index),
                        children: const [
                          //FIRST PAGE
                          PersonalInfo(),
                          //SECOND PAGE
                          HomeInfo(),
                          //THIRD PAGE
                          ContactInfo(),
                          //FOURTH PAGE
                          VehicleInfo(),
                          //FOURTH PAGE
                          BankInfo(),
                        ],
                      )),
                  MyFancyButton(
                      margin: EdgeInsets.only(bottom: 30.h),
                      width: MediaQuery.of(context).size.width*0.5,

                      borderRadius:40.r,
                      isIconButton: false,
                      isGradient: true,
                      gradient: context.watch<SignUpProvider>().currentStep==4?context.watch<SignUpProvider>().agree==false? const LinearGradient(
                        colors: [
                          greyDark,
                          greyDark,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ):const LinearGradient(
                        colors: [
                          darkPurple,
                          Color(0xFF6610F2),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ):
                      const LinearGradient(
                        colors: [
                          darkPurple,
                          Color(0xFF6610F2),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      fontSize: 22.sp,
                      family: "Poppins",
                      text: context.watch<SignUpProvider>().currentStep==4?"submit".tr():"next".tr(), tap: () async{
                    if(context.read<SignUpProvider>().currentStep==0){
                      if (context.read<SignUpProvider>().formKey.currentState!.validate()) {
                        signUpProvider.pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);

                      }

                    }
                    else if(context.read<SignUpProvider>().currentStep==1){
                      if (context.read<SignUpProvider>().formKey.currentState!.validate()) {
                        signUpProvider.pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      }
                    }
                    else if(context.read<SignUpProvider>().currentStep==2){
                      if (context.read<SignUpProvider>().formKey.currentState!.validate()) {
                        signUpProvider.pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      }
                    }
                    else if(context.read<SignUpProvider>().currentStep==3){
                      if(context.read<SignUpProvider>().vehicleData.isEmpty){
                        ToastUtils.failureToast("selectOne", context);
                      }
                      else{
                        signUpProvider.pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      }
                    }
                    else {
                      if(context.read<SignUpProvider>().currentStep==4){
                        if(context.read<SignUpProvider>().agree){
                          context.read<SignUpProvider>().signUp(context);

                        }
                      }
                      else{
                        signUpProvider.pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      }
                    }

                  },
                      buttonColor: darkPurple,
                      hasShadow: true),
                ])
            ),
          )
        ),
      )
    ));
  }
}

