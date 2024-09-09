import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/controller/jobs_todo_controller.dart';
import 'package:provider/provider.dart';

import '../../../enums/color_constants.dart';
import '../../../enums/image_constants.dart';
import '../../../models/advertise_model.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/simple_dialog.dart';
import '../../../widgets/text_widget.dart';
import '../widgets/reason_widget.dart';

class PTodoReason extends StatelessWidget {
  final AdvertiseModel advertiseModel;
  const PTodoReason({Key? key,required this.advertiseModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashColor,
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(
            FeatherIcons.chevronLeft,
            color: whiteColor,
            size: 28.sp, // Changing Drawer Icon Size
          ),
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        backgroundColor:Colors.transparent,
        elevation: 0,
        title: myText(text: "Waiting Reason", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 20.sp, color: whiteColor),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r)),
            border: Border.all(color: textFieldColor,width: 1.w)
        ),
        child:Center(
          child:  SingleChildScrollView(
              padding:const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Image.asset(thumbs,height: 150.h),
                  SizedBox(height: 40.h),
                  ReasonWidget(controller: context.read<JobsTodoProvider>().waitingPH,controller2: context.read<JobsTodoProvider>().waitingPM,
                   value: context.watch<JobsTodoProvider>().selectedPReason==""?null:context.watch<JobsTodoProvider>().selectedPReason,
                    onChanged: (value){
                      context.read<JobsTodoProvider>().pOnChanged(value);
                    },data: context.read<JobsTodoProvider>().pReason,),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 18.w,
                        height:18.h,
                        decoration: BoxDecoration(
                            color: lightGrey, borderRadius: BorderRadius.circular(3.r)),
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: lightGrey),
                          child: Transform.scale(
                            scale:1.0,
                            child: Checkbox(
                                value: context.watch<JobsTodoProvider>().agreeP,
                                activeColor: darkPurple,
                                onChanged: context.read<JobsTodoProvider>().agreeCheck),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      myText(text: "Confirm Parcel's Picked Up", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 18.sp, color: dashColor),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  MyFancyButton(
                      width: MediaQuery.of(context).size.width*0.5,
                      height: 50.h,
                      borderRadius:10.r,
                      isIconButton: false,
                      isGradient: true,
                      gradient:  LinearGradient(
                        colors: [
                          context.watch<JobsTodoProvider>().agreeP==false? greyDark: const Color(0xFF1E90FF),
                          context.watch<JobsTodoProvider>().agreeP==false? greyDark:  const Color(0xFF1560BD),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      fontSize: 14.sp,
                      family: "Poppins",
                      text: "Continue", tap:context.watch<JobsTodoProvider>().agreeP==false?(){}: (){
                        if(context.read<JobsTodoProvider>().waitingPH.text.isNotEmpty || context.read<JobsTodoProvider>().waitingPM.text.isNotEmpty){
                          if(context.read<JobsTodoProvider>().waitingPH.text.isEmpty ){
                            showDialog(context: context, builder: (context){
                              return const MySimpleDialog(title: "Error", msg: "Please Enter Waiting Hours.",
                                icon:FeatherIcons.alertTriangle,);
                            });
                          }
                          else if(context.read<JobsTodoProvider>().waitingPM.text.isEmpty ){
                            showDialog(context: context, builder: (context){
                              return const MySimpleDialog(title: "Error", msg: "Please Enter Waiting Minutes.",
                                icon:FeatherIcons.alertTriangle,);
                            });
                          }
                          else if(context.read<JobsTodoProvider>().selectedPReason == null){
                            showDialog(context: context, builder: (context){
                              return const MySimpleDialog(title: "Error", msg: "Please Select Reason For Waiting",
                                icon:FeatherIcons.alertTriangle,);
                            });
                          }
                          else {
                            context.read<JobsTodoProvider>().updatePickReason(advertiseModel.jobId, context,advertiseModel);
                          }
                        }
                        else{
                          context.read<JobsTodoProvider>().updatePickReason(advertiseModel.jobId, context,advertiseModel);
                        }


                      },
                      buttonColor: darkPurple,
                      hasShadow: true),
                ],
              )
          ),
        )
      ),
    );
  }
}
