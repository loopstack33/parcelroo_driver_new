// ignore_for_file: file_names


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:parcelroo_driver_app/views/signUp/controller/signUp_provider.dart';
import 'package:parcelroo_driver_app/views/signUp/pages/widgets/vehicle_widget.dart';
import 'package:provider/provider.dart';
import '../../../enums/color_constants.dart';
import '../../../widgets/text_widget.dart';

class VehicleInfo extends StatelessWidget {
  const VehicleInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            myText(text: "createAccount", fontFamily: "Poppins", size: 24.sp, color: lightBlue,fontWeight: FontWeight.w600,),
            SizedBox(height: 10.h),
            myText(text: "sVehicles", fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 16.sp, color: whiteColor),
            SizedBox(height: 10.h),
            myText(text: "maxV", fontFamily: "Poppins",textAlign: TextAlign.center, size: 14.sp, color: whiteColor),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("vehicles").orderBy("timestamp",descending: false).snapshots(),
                builder: (context,snapshot) {
                  if(snapshot.hasData){
                    return  AnimationLimiter(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot  snap =  snapshot.data!.docs[index];
                          context.read<SignUpProvider>().controllers.add(TextEditingController());
                          context.read<SignUpProvider>().selected.add(snap["selected"]);

                          return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 600),
                              child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: VehicleWidget(
                                      onChanged: (checkbox){
                                        context.read<SignUpProvider>().addVehicle(index, snap["cc"].toString(), snap["name"].toString(), snap["image"].toString(), snap["id"].toString(),snap["info"].toString(),context.read<SignUpProvider>().controllers[index].text.toString());
                                      },
                                      index:index,
                                      value:context.watch<SignUpProvider>().selected[index],
                                      name:snap["name"].toString(),
                                      hasReg:snap["hasReg"],
                                      info:snap["info"],
                                      hasInfo:snap["hasInfo"],
                                      image:snap["image"].toString(),
                                      cc:snap["cc"].toString(),
                                      controllers: context.read<SignUpProvider>().controllers,
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
            ),

          ],
        ),
      ),
    );
  }
}

