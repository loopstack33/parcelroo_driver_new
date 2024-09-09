// ignore_for_file: use_build_context_synchronously

import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:parcelroo_driver_app/views/dashboard/dashboard.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/controller/jobs_todo_controller.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import '../../enums/color_constants.dart';
import '../../models/advertise_model.dart';
import '../../utils/app_routes.dart';
import '../../widgets/text_widget.dart';

class CustomerSignature extends StatefulWidget {
  final AdvertiseModel advertiseModel;
  const CustomerSignature({Key? key,required this.advertiseModel}) : super(key: key);


  @override
  State<CustomerSignature> createState() => _CustomerSignatureState();
}

class _CustomerSignatureState extends State<CustomerSignature> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();
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
          title: myText(text: "Customer Signature", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 20.sp, color: whiteColor),
          centerTitle: true,
          actions: [
            Padding(padding: EdgeInsets.only(right: 10.w),child:  GestureDetector(
              onTap: (){
                context.read<JobsTodoProvider>().changeOrientation();
              },
              child: Icon(FeatherIcons.refreshCcw,color: whiteColor,size: 25.sp),
            ),)
          ],
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
            child: SingleChildScrollView(
              padding:const EdgeInsets.all(8),
              child: Column(
                children: [
                  context.watch<JobsTodoProvider>().change? const SizedBox():myText(text: "Customers Signature Required", fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 20.sp, color: dashColor),
                  SizedBox(height: 10.h),
                  myText(text: "Please Take Customers Signature", fontFamily: "Poppins",fontWeight: FontWeight.w400, size: 18.sp, color: dashColor),
                  SizedBox(height: 20.h),
                  Container(
                    margin: EdgeInsets.only(left: 10.w,right: 10.w),
                    padding: EdgeInsets.only(left: 10.w,right: 10.w),
                    height: context.watch<JobsTodoProvider>().change? 150: 300,
                    width: context.watch<JobsTodoProvider>().change?MediaQuery.of(context).size.width*0.8: MediaQuery.of(context).size.width*0.9,
                    child: SfSignaturePad(
                      key: signaturePadKey,
                      minimumStrokeWidth: 1,
                      maximumStrokeWidth: 3,
                      strokeColor: dashColor,
                      backgroundColor: whiteColor.withOpacity(0.25),
                    ),
                  ),
                  Container(
                    width: context.watch<JobsTodoProvider>().change?MediaQuery.of(context).size.width*0.8: MediaQuery.of(context).size.width*0.9,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border(
                        bottom: BorderSide(width: 2.w, color: dashColor),
                      ),

                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    width: context.watch<JobsTodoProvider>().change?MediaQuery.of(context).size.width*0.8: MediaQuery.of(context).size.width*0.9,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border(
                        bottom: BorderSide(width: 2.w, color: dashColor),
                      ),

                    ),
                  ),
                  SizedBox(height: 40.h),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      MyFancyButton(
                          width:context.watch<JobsTodoProvider>().change? MediaQuery.of(context).size.width*0.25:MediaQuery.of(context).size.width*0.5,
                          height: 50.h,
                          borderRadius:10.r,
                          isIconButton: false,
                          isGradient: true,
                          gradient: const LinearGradient(
                            colors: [
                              Colors.green,
                              Colors.green,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          fontSize: 14.sp,
                          family: "Poppins",
                          text: "Clear", tap: ()async{
                        signaturePadKey.currentState!.clear();
                      },
                          buttonColor: darkPurple,
                          hasShadow: true),
                      MyFancyButton(
                          width: context.watch<JobsTodoProvider>().change? MediaQuery.of(context).size.width*0.25:MediaQuery.of(context).size.width*0.5,
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
                          text: "Continue", tap: () async{
                        final data =
                        await signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
                        final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
                        context.read<JobsTodoProvider>().updateSignature(context,bytes!.buffer.asUint8List(),widget.advertiseModel);
                      },
                          buttonColor: darkPurple,
                          hasShadow: true),
                    ],
                  ),


                ],
              ),
            ),


          ),
        ),

    ));
  }
}
