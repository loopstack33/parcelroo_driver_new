import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/utils/toasts.dart';
import 'package:parcelroo_driver_app/views/joinCompany/join_company.dart';
import 'package:provider/provider.dart';

import '../../../enums/color_constants.dart';
import '../../../enums/gobals.dart';
import '../../../enums/image_constants.dart';
import '../../../widgets/my_company_widget.dart';
import '../../../widgets/text_widget.dart';
import '../../updateVehicles/widgets/vehicleWidget_dash.dart';
import '../controller/dash_provider.dart';

class Sheets {
  static void showVehicleSheet(context){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r),topRight: Radius.circular(30.r))
        ),
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  myText(text: "Please Select Vehicle You Want To Go Online With? ",
                      fontFamily: "Poppins", size: 16.sp,fontWeight: FontWeight.w600,color: Colors.black),
                  SizedBox(height: 10.h),
                  SizedBox(height: 300.h,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("drivers").where("uid",isEqualTo: Globals.uid.toString()).snapshots(),
                        builder: (context,snapshot) {
                          if(snapshot.hasData){
                            return  AnimationLimiter(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs[0]["vehicles"].length,
                                itemBuilder: (BuildContext context, int index) {

                                  var  snap =  snapshot.data!.docs[0]["vehicles"];
                                  return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(milliseconds: 600),
                                      child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(

                                            child: VehicleWidgetD(
                                              onChanged: (){
                                                context.read<DashProvider>().changeIndex(index,snap[index]["image"].toString(),snap[index]["name"].toString());
                                              },
                                              index:index,
                                              value:false,
                                              name:snap[index]["name"].toString(),
                                              reg:snap[index]["reg"].toString(),
                                              image:snap[index]["image"].toString(),
                                              info:snap[index]["info"].toString(),
                                              cc:snap[index]["cc"].toString(),
                                            ),)));
                                },
                              ),
                            );
                          }
                          else {
                            return Center(
                              child: LoadingAnimationWidget.flickr(leftDotColor: lightBlue, rightDotColor: lightPurple, size: 50),
                            );
                          }
                        }
                    ),),
                  MyFancyButton(
                      margin: EdgeInsets.only(bottom: 30.h),
                      width: MediaQuery.of(context).size.width*0.4,
                      borderRadius:40.r,
                      isIconButton: false,
                      isGradient: true,
                      gradient:confirm,
                      fontSize: 20.sp,
                      family: "Poppins",
                      text: "Next", tap: () async{
                        if(context.read<DashProvider>().activeVehicle==""){
                          ToastUtils.failureToast("Select A Vehicle", context);
                        }
                        else{
                          AppRoutes.pop(context);
                          showCompanySheet(context);
                        }
                  },
                      buttonColor: darkPurple,
                      hasShadow: true),
                ],
              ),
            )
        ),
      );
    });
  }

  static void showCompanySheet(context){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r),topRight: Radius.circular(30.r))
        ),
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 20,left: 20,top: 20),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  myText(text: "Choose Companies You Want To Show Your ONLINE/OFFLINE Status too.",
                      fontFamily: "Poppins", size: 16.sp,fontWeight: FontWeight.w600,color: Colors.black),
                  SizedBox(height: 10.h),
                  SizedBox(height: 300.h,
                    child:  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('drivers').doc(Globals.uid).collection("partneredCompany").snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return  snapshot.data!.docs.length.toString()!="0"?
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 220.h,
                                  child: ListView.builder(
                                    itemBuilder: (context,index){
                                    DocumentSnapshot doc = snapshot.data!.docs[index];
                                    context.read<DashProvider>().selected.add(false);
                                    return Padding(padding:const EdgeInsets.all(10),
                                        child: MyCompanyWidget2(
                                            index:index,
                                            isActive:doc["isActive"],
                                            name: doc["companyName"],
                                            image: doc["companyLogo"],
                                            value:context.watch<DashProvider>().selected[index],
                                            address: doc["companyAddress"],
                                            onTap2:doc["isActive"]==false?(checkbox){}: (checkbox){
                                              // context.read<DashProvider>().changeIndex2(index,doc["companyID"].toString(),context);
                                              context.read<DashProvider>().addCompanies(index,doc["companyID"].toString());
                                            },));
                                  },
                                    itemCount: snapshot.data!.docs.length,
                                    shrinkWrap: true,)
                                ),
                                SizedBox(height: 10.h),
                                MyFancyButton(
                                    margin: EdgeInsets.only(bottom: 20.h),
                                    width: MediaQuery.of(context).size.width*0.4,
                                    borderRadius:40.r,
                                    isIconButton: false,
                                    isGradient: true,
                                    gradient:purpleGradient,
                                    fontSize: 20.sp,
                                    family: "Poppins",
                                    text: "Submit", tap: () async{
                                      if(context.read<DashProvider>().companyID.isEmpty){
                                        ToastUtils.failureToast("Select At Least One Company", context);
                                      }
                                      else{
                                        context.read<DashProvider>().setDriverStatus(context);
                                      }

                                },
                                    buttonColor: darkPurple,
                                    hasShadow: true),
                              ],
                            ),
                          )
                          :Center(
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                myText(text: "No Companies Found", fontFamily: "Poppins", size: 18.sp, fontWeight: FontWeight.w600,color:Colors.black),
                                myText(text: "Please Register by Joining A company in App.", fontFamily: "Poppins", size: 16.sp,fontWeight: FontWeight.w400, color:Colors.black,textAlign: TextAlign.center,),
                                SizedBox(height: 10.h),
                                MyFancyButton(
                                    margin: EdgeInsets.only(bottom: 30.h),
                                    width: MediaQuery.of(context).size.width*0.5,
                                    borderRadius:40.r,
                                    isIconButton: true,
                                    image: addIcon,
                                    //isGradient: true,
                                    fontSize: 16.sp,
                                    imageHeight: 22.h,
                                    imageWidth: 22.w,
                                    family: "Poppins",
                                    fontColor: whiteColor,
                                    text: "Join A Company", tap: () async{
                                      AppRoutes.pop(context);
                                      AppRoutes.push(context, PageTransitionType.fade, const JoinCompany());
                                },
                                    buttonColor: joinCompany,

                                    hasShadow: false),
                              ],
                            )
                          );
                        }
                        else if (snapshot.hasError) {
                          return Center(
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  myText(text: "No Companies Found", fontFamily: "Poppins", size: 18.sp, fontWeight: FontWeight.w600,color:Colors.black),
                                  myText(text: "Please Register by Joining A company in App.", fontFamily: "Poppins", size: 16.sp,fontWeight: FontWeight.w400, color:Colors.black,textAlign: TextAlign.center,),
                                  SizedBox(height: 10.h),
                                  MyFancyButton(
                                      margin: EdgeInsets.only(bottom: 30.h),
                                      width: MediaQuery.of(context).size.width*0.5,
                                      borderRadius:40.r,
                                      isIconButton: true,
                                      image: addIcon,
                                      fontSize: 16.sp,
                                      imageHeight: 22.h,
                                      imageWidth: 22.w,
                                      family: "Poppins",
                                      fontColor: whiteColor,
                                      text: "Join A Company", tap: () async{
                                    AppRoutes.pop(context);
                                    AppRoutes.push(context, PageTransitionType.fade, const JoinCompany());
                                  },
                                      buttonColor: joinCompany,

                                      hasShadow: false),
                                ],
                              )
                          );
                        }
                        else {
                          return const Center(
                            child:CircularProgressIndicator(color: dashColor),
                          );
                        }
                      },
                    ),),
                ],
              ),
            )
        ),
      );
    });
  }
}
