import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:parcelroo_driver_app/views/dashboard/dashboard.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/controller/jobs_todo_controller.dart';
import 'package:provider/provider.dart';

import '../../../enums/color_constants.dart';
import '../../../models/advertise_model.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/toasts.dart';
import '../../../utils/utilities.dart';
import '../../../widgets/cancel_job_popup.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/simple_dialog.dart';
import '../../../widgets/text_widget.dart';

class AgeCalculator extends StatelessWidget {
  final AdvertiseModel advertiseModel;
  const AgeCalculator({Key? key, required this.advertiseModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async{
      AppRoutes.pushAndRemoveUntil(context, const Dashboard());
      return true;
    },
    child: Scaffold(
        backgroundColor: dashColor,
        appBar: AppBar(
          leading: IconButton(
            icon:  Icon(
              FeatherIcons.chevronLeft,
              color: whiteColor,
              size: 28.sp, // Changing Drawer Icon Size
            ),
            onPressed: () {
              AppRoutes.pushAndRemoveUntil(context, const Dashboard());
            },
          ),
          backgroundColor:Colors.transparent,
          elevation: 0,
          title: myText(text: "Age calculator", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 20.sp, color: whiteColor),
          centerTitle: true,
        ),
        body: LoadingAnimation(
          inAsyncCall: context.watch<JobsTodoProvider>().isUpdating,
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r)),
                  border: Border.all(color: textFieldColor,width: 1.w)
              ),
              child: Form(
                key: context.read<JobsTodoProvider>().formKey2,
                child: SingleChildScrollView(
                  padding:const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      myText(text: "Please Verify Customers Age", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 22.sp, color: dashColor),
                      SizedBox(height: 20.h),
                      myText(text: "WARNING !", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 25.sp, color: redColor),
                      SizedBox(height: 5.h),
                      myText(text: "YOU ARE SOLEY RESPONSIBLE FOR THE DELIVERY OF GOODS AND ANY PROHIBITED ITEMS SUCH AS ALCOHOL/KNIVES/TOBACCO ETC. DELIVERY TO MINORS WILL BE LIABLE FOR PROSECUTION ACCORDING TO YOUR COUNTRY/STATE LAWS", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 20.sp, color: redColor,textAlign: TextAlign.center,),
                      SizedBox(height:50.h),
                      myText(text: "CUSTOMERS DATE OF BIRTH", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 18.sp, color: dashColor),
                      SizedBox(height: 30.h),
                      Wrap(
                        spacing: 20,
                        children: [
                          SizedBox(
                            width: 100,
                            child: CustomTextField(
                                controller: context.read<JobsTodoProvider>().day,
                                hint: "Day",
                                type: TextInputType.number,
                                validator: (value) {
                                  if(value ==null || value.isEmpty){
                                    return "* Required";
                                  }

                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                  DayFormatter()
                                  /// NumberRangeInputFormatter()
                                ]
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: CustomTextField(
                                controller: context.read<JobsTodoProvider>().month,
                                hint: "Month",
                                type: TextInputType.number,
                                validator: (value) {
                                  if(value ==null || value.isEmpty){
                                    return "* Required";
                                  }

                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                  MonthFormatter()
                                  /// NumberRangeInputFormatter()
                                ]
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: CustomTextField(
                                controller: context.read<JobsTodoProvider>().year,
                                hint: "Year",
                                type: TextInputType.number,
                                validator: (value) {
                                  if(value ==null || value.isEmpty){
                                    return "* Required";
                                  }

                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                                  /// NumberRangeInputFormatter()
                                ]
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.87,
                        child: CustomTextField(
                          controller: context.read<JobsTodoProvider>().result,
                          hint: "Result",
                          absorbing: true,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      MyFancyButton(
                          width: MediaQuery.of(context).size.width*0.5,
                          height: 50.h,
                          borderRadius:10.r,
                          isIconButton: false,
                          isGradient: true,
                          gradient: confirm,
                          fontSize: 14.sp,
                          family: "Poppins",
                          text: "Calculate", tap: () async{
                        if (context.read<JobsTodoProvider>().formKey2.currentState!.validate()) {
                          if(int.parse(context.read<JobsTodoProvider>().year.text.toString())>DateTime.now().year){
                            showDialog(context: context, builder: (context){
                              return const MySimpleDialog(title: "Error", msg: "Year Cannot Be Greater Than Current Year",
                                icon:FeatherIcons.alertTriangle,);
                            });
                          }
                          else{
                            context.read<JobsTodoProvider>().calculateAge(context);
                          }

                        }

                      },
                          buttonColor: darkPurple,
                          hasShadow: true),
                         if(context.watch<JobsTodoProvider>().calculated)...[
                           SizedBox(height: 40.h),
                           MyFancyButton(
                               width: MediaQuery.of(context).size.width*0.5,
                               height: 50.h,
                               borderRadius:10.r,
                               isIconButton: false,
                               isGradient: true,
                               gradient:  LinearGradient(
                                 colors: [
                                   context.watch<JobsTodoProvider>().calculated==false? greyDark:const Color(0xFF1E90FF),
                                   context.watch<JobsTodoProvider>().calculated==false? greyDark:const Color(0xFF1560BD),
                                 ],
                                 begin: Alignment.topCenter,
                                 end: Alignment.bottomCenter,
                               ),
                               fontSize: 14.sp,
                               family: "Poppins",
                               text: "Continue", tap:context.watch<JobsTodoProvider>().calculated==false?(){}:
                               () async{
                             context.read<JobsTodoProvider>().updateAge(context,advertiseModel);
                           },
                               buttonColor: darkPurple,
                               hasShadow: true),
                      ]
                      // else if(context.watch<JobsTodoProvider>().showCancel)...[
                      //      SizedBox(height: 40.h),
                      //      MyFancyButton(
                      //          width: MediaQuery.of(context).size.width*0.5,
                      //          height: 50.h,
                      //          borderRadius:10.r,
                      //          isIconButton: false,
                      //          isGradient: true,
                      //          gradient: const LinearGradient(
                      //            colors: [
                      //              Color(0xFFF43030),
                      //              Color(0xFFFF0000),
                      //            ],
                      //            begin: Alignment.topCenter,
                      //            end: Alignment.bottomCenter,
                      //          ),
                      //          fontSize: 14.sp,
                      //          family: "Poppins",
                      //          text: "Cancel Job", tap: () async{
                      //        showDialog(context: context, builder: (context){
                      //          return CancelJobPopup(controller: context.read<JobsTodoProvider>().reasonController,onTap: (){
                      //            if(context.read<JobsTodoProvider>().reasonController.text.isEmpty){
                      //              ToastUtils.failureToast("Enter Reason", context);
                      //            }
                      //            else{
                      //              context.read<JobsTodoProvider>().cancelJob(context, advertiseModel);
                      //            }
                      //          },);
                      //        });
                      //      },
                      //          buttonColor: darkPurple,
                      //          hasShadow: true),
                      // ],


                    ],
                  ),
                ),
              )
          ),
        )
    )
    );
  }

}
