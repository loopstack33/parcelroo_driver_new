
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/tracking.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:parcelroo_driver_app/utils/toasts.dart';
import 'package:parcelroo_driver_app/views/dashboard/dashboard.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/securityFlowDrop/age_calculator.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/securityFlowDrop/job_todo_reasond.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/securityFlowDrop/todo_image_sender.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/securityFlowDrop/todo_password_screen.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/securityFlowDrop/todo_qr_code_scanner.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/securityFlowPick/job_todo_reason.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/securityFlowPick/todo_image_sender.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/securityFlowPick/todo_password_screen.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/securityFlowPick/todo_qr_code_scanner.dart';
import 'package:parcelroo_driver_app/widgets/cancel_job_popup.dart';
import 'package:parcelroo_driver_app/widgets/manifest_dialog.dart';
import 'package:parcelroo_driver_app/widgets/special_instructions.dart';
import 'package:provider/provider.dart';
import '../../enums/color_constants.dart';
import '../../models/advertise_model.dart';
import '../../utils/app_routes.dart';
import '../../widgets/address_widget.dart';
import '../../widgets/box_widget.dart';
import '../../widgets/my_company_widget.dart';
import '../../widgets/text_widget.dart';
import 'controller/jobs_todo_controller.dart';


class JobFullDetails extends StatelessWidget {
  final AdvertiseModel advertiseModel;
  final bool from;
  const JobFullDetails({Key? key,required this.advertiseModel,required this.from}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async{
      if(from){
        AppRoutes.pushAndRemoveUntil(context,const Dashboard());
      }
      else{
        AppRoutes.pop(context);
      }
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
                if(from){
                  AppRoutes.pushAndRemoveUntil(context,const Dashboard());
                }
                else{
                  AppRoutes.pop(context);
                }

              },
            ),
            backgroundColor:Colors.transparent,
            elevation: 0,
            title: myText(text: "Jobs To Do ${context.watch<JobsTodoProvider>().showPick?"(Pickup)":"(DropOff)"}", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
            centerTitle: true,
          ),
          body: LoadingAnimation(
              inAsyncCall:context.watch<JobsTodoProvider>().isCancel,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r)),
                    border: Border.all(color: textFieldColor,width: 1.w)
                ),
                child:  Padding(
                  padding:const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Column(
                      children:  [
                        Padding(padding: const EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BoxWidget(isImage: true,text: "Required Vehicle",image: advertiseModel.vehicleRequired.toString()),
                                  BoxWidget(isImage: false,text: "Payment Terms",detail: advertiseModel.paymentType.toString()),
                                  BoxWidget(isImage: false,text: "Payment Amount",detail: "${advertiseModel.currency.toString()} ${advertiseModel.price.toString()}"),
                                ]
                            )),
                        Padding(padding:const EdgeInsets.all(10),
                            child: MyCompanyWidget(name: advertiseModel.companyName.toString(),isDelete: false,address: advertiseModel.companyAddress.toString(),image: advertiseModel.companyLogo.toString(),)),Padding(padding:const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyFancyButton(
                                    width: MediaQuery.of(context).size.width*0.25,
                                    height: 50.h,
                                    borderRadius:10.r,
                                    isIconButton: false,
                                    isGradient: true,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1E90FF),
                                        Color(0xFF1560BD),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    fontSize: 14.sp,
                                    family: "Poppins",
                                    text: "Manifest \nOf Goods", tap: (){
                                  showDialog(context: context, builder: (context){
                                    return  ManifestDialog(data:advertiseModel.isPicked==true? advertiseModel.dropManifest.toString():advertiseModel.pickManifest.toString());
                                  });
                                },
                                    buttonColor: darkPurple,
                                    hasShadow: true),
                                MyFancyButton(
                                    borderColor: Colors.black,
                                    borderWidth: 1.w,
                                    width: MediaQuery.of(context).size.width*0.25,
                                    height: 50.h,
                                    borderRadius:10.r,
                                    isIconButton: false,
                                    isGradient: true,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    fontSize: 14.sp,
                                    fontColor: Colors.black,
                                    family: "Poppins",
                                    text: advertiseModel.jobNo.toString(), tap: (){},
                                    buttonColor: darkPurple,
                                    hasShadow: false),
                                MyFancyButton(
                                    width: MediaQuery.of(context).size.width*0.3,
                                    height: 50.h,
                                    borderRadius:10.r,
                                    isIconButton: false,
                                    isGradient: true,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFFD200),
                                        Color(0xFFF7971E),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    fontSize: 12.sp,
                                    family: "Poppins",
                                    fontColor: Colors.black,
                                    text: "Special Instructions On ${context.watch<JobsTodoProvider>().showDrop==false? "Pick Up":"Drop Off"}", tap: (){
                                  showDialog(context: context, builder: (context){
                                    return  SpecialInstructions(data:advertiseModel.isPicked==true? advertiseModel.dropInstructions.toString() :advertiseModel.pickInstructions.toString(),on:context.watch<JobsTodoProvider>().showDrop==false?  "Pick Up":"Drop Off",);
                                  });
                                },
                                    buttonColor: darkPurple,
                                    hasShadow: true),
                              ],
                            )),
                        if(context.watch<JobsTodoProvider>().showPick)...[
                          GestureDetector(
                            onTap: (){
                              AppRoutes.push(context, PageTransitionType.fade,  MapSample(location: advertiseModel.pickAddress.toString(),title: advertiseModel.jobNo.toString(),lat:advertiseModel.pickLatitude! ,lng: advertiseModel.pickLongitude!,));
                            },
                            child:  AddressWidget(hasNavigation: true,isOther: true,color: pickUpColor,time:advertiseModel.pickTimeType.toString()=="" || advertiseModel.pickTimeType.toString()=="null"? advertiseModel.pickTime.toString():  "${advertiseModel.pickTimeType.toString()} ${advertiseModel.pickTime.toString()}",date:advertiseModel.pickDate.toString(),address: advertiseModel.pickAddress.toString(),type: "Pick Up Details",name:advertiseModel.pickCustomer.toString(),email:advertiseModel.pickEmail.toString(),contact: advertiseModel.pickContact.toString()),
                          )
                        ],
                        if(context.watch<JobsTodoProvider>().showDrop)...[
                          GestureDetector(
                            onTap: (){
                              AppRoutes.push(context, PageTransitionType.fade,  MapSample(location: advertiseModel.dropAddress.toString(),title: advertiseModel.jobNo.toString(),lat:advertiseModel.dropLatitude! ,lng: advertiseModel.dropLongitude!,));
                            },
                            child:  AddressWidget(hasNavigation: true,isOther: true,color: dropOffColor,time: advertiseModel.dropTimeType.toString()=="" || advertiseModel.dropTimeType.toString()=="null"? advertiseModel.dropTime.toString():  "${advertiseModel.dropTimeType.toString()} ${advertiseModel.dropTime.toString()}",date: advertiseModel.dropDate.toString(),address: advertiseModel.dropAddress.toString(),type: "Drop Off Details",name:advertiseModel.dropCustomer.toString(),email: advertiseModel.dropEmail.toString(),contact: advertiseModel.dropContact.toString()),
                          )
                        ],
                        Padding(
                            padding:const EdgeInsets.all(10),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyFancyButton(
                                    width: MediaQuery.of(context).size.width*0.25,
                                    height: 50.h,
                                    borderRadius:10.r,
                                    isIconButton: false,
                                    isGradient: true,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF38EF7D),
                                        Color(0xFF11998E),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    fontSize: 14.sp,
                                    family: "Poppins",
                                    text:context.watch<JobsTodoProvider>().showDrop==false? "Start Pick Up":"Start Drop Off",
                                    tap: (){
                                      context.read<JobsTodoProvider>().setArrived(true);
                                      context.watch<JobsTodoProvider>().showDrop==false?  AppRoutes.push(context, PageTransitionType.fade,  MapSample(location: advertiseModel.pickAddress.toString(),title: advertiseModel.jobNo.toString(),lat:advertiseModel.pickLatitude! ,lng: advertiseModel.pickLongitude!,)):
                                      AppRoutes.push(context, PageTransitionType.fade,  MapSample(location: advertiseModel.dropAddress.toString(),title: advertiseModel.jobNo.toString(),lat:advertiseModel.dropLatitude! ,lng: advertiseModel.dropLongitude!,));
                                    },
                                    buttonColor: darkPurple,
                                    hasShadow: true),
                                MyFancyButton(
                                    width: MediaQuery.of(context).size.width*0.25,
                                    height: 50.h,
                                    borderRadius:10.r,
                                    isIconButton: false,
                                    isGradient: true,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF885DF1),
                                        Color(0xFF6610F2),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    fontSize: 14.sp,
                                    family: "Poppins",
                                    text: "Arrived", tap: (){
                                  context.read<JobsTodoProvider>().setArrived(true);
                                },
                                    buttonColor: darkPurple,
                                    hasShadow: false),
                                MyFancyButton(
                                    width: MediaQuery.of(context).size.width*0.3,
                                    height: 50.h,
                                    borderRadius:10.r,
                                    isIconButton: false,
                                    isGradient: true,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFF43030),
                                        Color(0xFFFF0000),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    fontSize: 14.sp,
                                    family: "Poppins",
                                    text: "Cancel Job", tap: (){
                                  showDialog(context: context, builder: (context){
                                    return CancelJobPopup(controller: context.read<JobsTodoProvider>().reasonController,onTap: (){
                                      if(context.read<JobsTodoProvider>().reasonController.text.isEmpty){
                                        ToastUtils.failureToast("Enter Reason", context);
                                      }
                                      else{
                                        context.read<JobsTodoProvider>().cancelJob(context, advertiseModel);
                                      }
                                    },);
                                  });
                                },
                                    buttonColor: darkPurple,
                                    hasShadow: true),
                              ],
                            )),
                        SizedBox(height: 10.h),
                        Center(
                          child:MyFancyButton(
                              width: MediaQuery.of(context).size.width*0.7,
                              height: 50.h,
                              borderRadius:22.r,
                              isIconButton: false,
                              isGradient: true,
                              gradient:  LinearGradient(
                                colors: [
                                  context.watch<JobsTodoProvider>().isArrived==false? greyDark:customerCode,
                                  context.watch<JobsTodoProvider>().isArrived==false? greyDark:customerCode2
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              fontSize: 16.sp,
                              family: "Poppins",
                              fontColor:whiteColor,
                              text: "Press For Customers Code",
                              tap: context.watch<JobsTodoProvider>().isArrived==false?(){}: (){
                                if(context.read<JobsTodoProvider>().showPick){
                                  if(advertiseModel.pickSecurity.toString()=="Password"){
                                    context.read<JobsTodoProvider>().clearOne();
                                    AppRoutes.push(context, PageTransitionType.fade,
                                        TodoPickPasswordScreen(advertiseModel: advertiseModel));
                                  }
                                  else if(advertiseModel.pickSecurity.toString()=="Qr code & bar code"){
                                    context.read<JobsTodoProvider>().setPQr();
                                    AppRoutes.push(context, PageTransitionType.fade,
                                        TodoPickQrScanner(advertiseModel: advertiseModel));
                                  }
                                  else if(advertiseModel.pickSecurity.toString()=="Pick Up Image"){
                                    AppRoutes.push(context, PageTransitionType.fade,
                                        ImageSenderPick(advertiseModel: advertiseModel,));
                                  }
                                  else{
                                    AppRoutes.push(context, PageTransitionType.fade,
                                        PTodoReason(advertiseModel: advertiseModel));
                                  }
                                }
                                else{
                                    if(advertiseModel.isAdult==true){
                                      context.read<JobsTodoProvider>().resetAge();
                                      AppRoutes.push(context, PageTransitionType.fade,
                                          AgeCalculator(advertiseModel: advertiseModel));
                                    }
                                    else{
                                      if(advertiseModel.dropSecurity.toString()=="Password"){
                                        context.read<JobsTodoProvider>().clearTwo();
                                        AppRoutes.push(context, PageTransitionType.fade,
                                            TodoDropPasswordScreen(advertiseModel: advertiseModel));

                                      }
                                      else if(advertiseModel.dropSecurity.toString()=="Qr code & bar code"){
                                        AppRoutes.push(context, PageTransitionType.fade,
                                            TodoDropQrScanner(advertiseModel: advertiseModel));
                                      }
                                      else if(advertiseModel.dropSecurity.toString()=="Drop Off Image"){
                                        AppRoutes.push(context, PageTransitionType.fade,
                                            ImageSenderDrop(advertiseModel: advertiseModel,));
                                      }
                                      else{
                                        AppRoutes.push(context, PageTransitionType.fade,
                                            DTodoReason(advertiseModel: advertiseModel));
                                      }

                                    }

                                }
                              },
                              buttonColor: greyDark,
                              hasShadow: false),
                        ),
                        /* SizedBox(height: 10.h),
                Padding(padding:const EdgeInsets.all(10),
                  child:SlideAction(
                    key: context.read<JobsTodoProvider>().key,
                    sliderButtonIconPadding: 5,
                    height: 50.h,
                    borderRadius: 10.r,
                    elevation: 0,
                    innerColor:context.watch<JobsTodoProvider>().showDrop==false? dropOffColor:pickUpColor,
                    outerColor: context.watch<JobsTodoProvider>().showDrop==false? dropOffColor.withOpacity(0.6):pickUpColor.withOpacity(0.6),
                    sliderButtonIcon: const Icon(FeatherIcons.chevronRight,color: whiteColor),
                    text: context.watch<JobsTodoProvider>().showDrop==false?'Drop Off Details':'Pick Up Details',
                    textStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: dashColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600
                    ),
                    sliderRotate: true,
                    onSubmit: (){
                      if( context.read<JobsTodoProvider>().showDrop==false){
                        if(context.read<JobsTodoProvider>().unblock!=true){
                          showDialog(context: context, builder: (context){
                            return const MySimpleDialog(title: "Error", msg: "Please Complete the Customer Code",
                              icon:FeatherIcons.alertTriangle,);
                          });
                        }
                        else{
                          context.read<JobsTodoProvider>().setDrop(true);
                        }

                      }
                      else{
                        if(context.read<JobsTodoProvider>().unblock!=true){
                          showDialog(context: context, builder: (context){
                            return const MySimpleDialog(title: "Error", msg: "Please Complete the Customer Code",
                              icon:FeatherIcons.alertTriangle,);
                          });
                        }
                        else{

                        }
                      }

                    },
                  )),*/
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              )
          )
      )
    );
  }
}
