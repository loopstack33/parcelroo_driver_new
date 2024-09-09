
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';
import 'package:parcelroo_driver_app/views/updateVehicles/widgets/delete_vehicle_dialog.dart';
import 'package:parcelroo_driver_app/views/updateVehicles/widgets/u_v_widget.dart';
import 'package:provider/provider.dart';

import '../../enums/color_constants.dart';
import '../../utils/loading_animation.dart';
import '../../widgets/drawerWidget.dart';
import '../../widgets/text_widget.dart';
import '../signUp/pages/widgets/vehicle_widget.dart';
import 'controller/update_vehicle_controller.dart';

class UpdateVehicles extends StatefulWidget {
  const UpdateVehicles({Key? key}) : super(key: key);

  @override
  State<UpdateVehicles> createState() => _UpdateVehiclesState();
}

class _UpdateVehiclesState extends State<UpdateVehicles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: dashColor,
        drawer:const DrawerMobileWidget(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon:  Icon(
                  Icons.menu,
                  color: whiteColor,
                  size: 28.sp, // Changing Drawer Icon Size
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          backgroundColor:Colors.transparent,
          elevation: 0,
          title: myText(text: "Change Vehicle", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
          centerTitle: true,
        ),
        body: LoadingAnimation(
            inAsyncCall: context.watch<UpdateVehicleProvider>().isLoading,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myText(text: "Please select one or more vehicle types you will use. You can add and remove vehicles In-app.", fontFamily: "Poppins",textAlign: TextAlign.center, size: 14.sp, color: whiteColor),
                    SizedBox(height: 10.h),
                    myText(text: "Current Vehicle Details.", fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 16.sp, color: whiteColor),
                    SizedBox(height: 10.h),
                    StreamBuilder<QuerySnapshot>(
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

                                            child: UpdateVehicleWidget(
                                              onChanged: (){
                                                showDialog(context: context, builder: (context){
                                                  return  DeleteVehiclePopup(onTap: (){
                                                    context.read<UpdateVehicleProvider>().deleteVehicle(context,  snap[index]["id"].toString());
                                                  });
                                                });
                                              },
                                              index:index,
                                              value:false,
                                              name:snap[index]["name"].toString(),
                                              reg:snap[index]["reg"].toString(),
                                              image:snap[index]["image"].toString(),
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
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.9,
                      child: const Divider(color: greyLight),
                    ),
                    SizedBox(height: 10.h),
                    myText(text: "Add Additional Vehicles", fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 16.sp, color: whiteColor),
                    SizedBox(height: 10.h),
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
                                  context.read<UpdateVehicleProvider>().controllers.add(TextEditingController());
                                  context.read<UpdateVehicleProvider>().selected.add(snap["selected"]);

                                  return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(milliseconds: 600),
                                      child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                              child: VehicleWidget(
                                                onChanged: (checkbox){
                                                  context.read<UpdateVehicleProvider>().checkLength(context,index, snap["cc"].toString(), snap["name"].toString(), snap["image"].toString(), snap["id"].toString(),snap["info"].toString(),context.read<UpdateVehicleProvider>().controllers[index].text.toString());
                                                },
                                                index:index,
                                                value:context.watch<UpdateVehicleProvider>().selected[index],
                                                name:snap["name"].toString(),
                                                hasReg:snap["hasReg"],
                                                info:snap["info"],
                                                hasInfo:snap["hasInfo"],
                                                image:snap["image"].toString(),
                                                cc:snap["cc"].toString(),
                                                controllers: context.read<UpdateVehicleProvider>().controllers,
                                              )
                                          )));
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
                    )
                  ],
                ),
              ),
            )
        )
    );
  }
}