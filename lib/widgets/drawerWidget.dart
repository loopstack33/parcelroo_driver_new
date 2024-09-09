// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';
import 'package:parcelroo_driver_app/enums/image_constants.dart';
import 'package:parcelroo_driver_app/views/clear_cache.dart';
import 'package:parcelroo_driver_app/views/dashboard/controller/dash_provider.dart';
import 'package:parcelroo_driver_app/views/dashboard/dashboard.dart';
import 'package:parcelroo_driver_app/views/languages.dart';
import 'package:parcelroo_driver_app/views/login/login_screen.dart';
import 'package:parcelroo_driver_app/views/updateVehicles/update_vehicles.dart';
import 'package:parcelroo_driver_app/views/uploadDocuments/controller/upload_doc_controller.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_routes.dart';
import '../utils/shared_pref.dart';
import '../views/about_us.dart';
import '../views/help.dart';
import '../views/settings.dart';
import '../views/updateBank/update_bank.dart';
import '../views/uploadDocuments/upload_docs.dart';

class DrawerMobileWidget extends StatefulWidget {
  const DrawerMobileWidget({Key? key}) : super(key: key);

  @override
  State<DrawerMobileWidget> createState() => _DrawerMobileWidgetState();
}

class _DrawerMobileWidgetState extends State<DrawerMobileWidget> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: drawerColor,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child:Column(
          children: [
            Expanded(child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 50.h,bottom: 20.h),
                    child: Column(
                      children: [
                       context.watch<DashProvider>().updatingImage? const Center(
                         child: CircularProgressIndicator(color: lightGrey),
                       ):GestureDetector(
                          onTap: (){

                            showModalBottomSheet(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (builder) => bottomSheet());
                          },
                          child: CircleAvatar(
                              radius: 40.r,
                              backgroundColor: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.r),
                                child: CachedNetworkImage(
                                  imageUrl: context.read<DashProvider>().image,
                                  height: 80.h,
                                  width: 80.w,
                                  imageBuilder:
                                      (context, imageProvider) =>
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                  placeholder: (context, url) =>
                                      Image.asset(
                                          loader),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        decoration:const BoxDecoration(
                                            color: Colors.white
                                        ),
                                        child: const Icon(
                                          Icons.error,
                                          color: redColor,
                                        ),
                                      ),
                                ),
                              )
                          ),
                        ),
                        SizedBox(height: 10.h),
                        myText(text: "Update Profile", fontFamily: "Poppins", size: 14.sp, color: whiteColor,textAlign: TextAlign.center,),
                        SizedBox(height: 10.h),
                        myText(text:context.read<DashProvider>().middleName.toString()==""? "${context.read<DashProvider>().firstName} \n${context.read<DashProvider>().lastName}":
                        "${context.read<DashProvider>().firstName} \n ${context.read<DashProvider>().middleName} ${context.read<DashProvider>().lastName}", fontFamily: "Poppins", size: 16.sp, fontWeight: FontWeight.w600,color: whiteColor,textAlign: TextAlign.center,)
                      ],
                    )
                ),
                ListTile(
                  hoverColor: whiteColor.withOpacity(0.25),
                  title: myText(text: "Dashboard", fontFamily: "Poppins", size: 16.sp, color: whiteColor),
                  leading: Icon(FeatherIcons.home,color: whiteColor,size: 25.sp),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const Dashboard()),
                            (Route<dynamic> route) => false);
                  },
                ),
                ListTile(
                  hoverColor: whiteColor.withOpacity(0.25),
                  title: myText(text: "Upload Documents", fontFamily: "Poppins", size: 16.sp, color: whiteColor),
                  leading: Icon(FeatherIcons.upload,color: whiteColor,size: 25.sp),
                  onTap: () {
                    context.read<UploadDocumentProvider>().reset();
                    AppRoutes.pop(context);
                    AppRoutes.push(context, PageTransitionType.fade, const UploadDocument());
                  },
                ),
                ListTile(
                  hoverColor: whiteColor.withOpacity(0.25),
                  title: myText(text: "Update Banking Info", fontFamily: "Poppins", size: 16.sp, color: whiteColor),
                  leading: Icon(FeatherIcons.dollarSign,color: whiteColor,size: 25.sp),
                  onTap: () {
                    AppRoutes.pop(context);
                    AppRoutes.push(context, PageTransitionType.fade, const UpdateBank());
                  },
                ),
                ListTile(
                  hoverColor: whiteColor.withOpacity(0.25),
                  title: myText(text: "Change Vehicle", fontFamily: "Poppins", size: 16.sp, color: whiteColor),
                  leading: Icon(FeatherIcons.truck,color: whiteColor,size: 25.sp),
                  onTap: () {
                    AppRoutes.pop(context);
                    AppRoutes.push(context, PageTransitionType.fade, const UpdateVehicles());
                  },
                ),
                ListTile(
                  hoverColor: whiteColor.withOpacity(0.25),
                  title: myText(text: "Languages", fontFamily: "Poppins", size: 16.sp, color: whiteColor),
                  leading: Icon(FeatherIcons.globe,color: whiteColor,size: 25.sp),
                  onTap: () {
                    AppRoutes.pop(context);
                    AppRoutes.push(context, PageTransitionType.fade, const Languages());
                  },
                ),
                ListTile(
                  hoverColor: whiteColor.withOpacity(0.25),
                  title:  myText(text: "Settings", fontFamily: "Poppins", size: 16.sp, color: whiteColor),
                  leading: Icon(FeatherIcons.settings,color: whiteColor,size: 25.sp),
                  onTap: () {
                    AppRoutes.pop(context);
                    AppRoutes.push(context, PageTransitionType.fade, const Settings());
                  },
                ),
                ListTile(
                  hoverColor: whiteColor.withOpacity(0.25),
                  title:  myText(text: "Help Using The App", fontFamily: "Poppins", size: 16.sp, color: whiteColor),
                  leading: Icon(FeatherIcons.info,color: whiteColor,size: 25.sp),
                  onTap: () {
                    AppRoutes.pop(context);
                    AppRoutes.push(context, PageTransitionType.fade, const Help());
                  },
                ),
                ListTile(
                  hoverColor: whiteColor.withOpacity(0.25),
                  title:  myText(text: "Clear Cache", fontFamily: "Poppins", size: 16.sp, color: whiteColor),
                  leading: Icon(FeatherIcons.refreshCw,color: whiteColor,size: 25.sp),
                  onTap: () {
                    AppRoutes.pop(context);
                    AppRoutes.push(context, PageTransitionType.fade, const ClearCache());
                  },
                ),
                ListTile(
                  hoverColor: whiteColor.withOpacity(0.25),
                  title:  myText(text: "Logout", fontFamily: "Poppins", size: 16.sp, color: whiteColor),
                  leading: Icon(FeatherIcons.logOut,color: whiteColor,size: 25.sp),
                  onTap: () {

                    // Create button
                    Widget okButton = ElevatedButton(
                      child:myText(text: "Yes", fontFamily: "Poppins", fontWeight: FontWeight.w400,size: 14.sp, color: whiteColor),
                      onPressed: () {
                        logOut();
                      },
                    );

                    // Create button
                    Widget noButton = TextButton(
                      child:myText(text: "No", fontFamily: "Poppins",  fontWeight: FontWeight.w400,size: 14.sp, color: dashColor),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    );

                    // Create AlertDialog
                    AlertDialog alert = AlertDialog(
                      title: myText(text: "Alert!", fontFamily: "Poppins", fontWeight: FontWeight.w600,size: 16.sp, color: dashColor),
                      content:myText(text: "Do you want to logout?", fontFamily: "Poppins", size: 16.sp, color: dashColor),
                      actions: [
                        noButton,
                        okButton,

                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                ),
              ],
            )),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: GestureDetector(
                  onTap: (){
                    AppRoutes.pop(context);
                    AppRoutes.push(context, PageTransitionType.fade, const AboutUs());
                  },
                  child: Column(
                    children: [
                      Text.rich(TextSpan(children:[
                        TextSpan(
                            text: "Parcel",
                            style: TextStyle(fontFamily: "Fredoka",fontSize: 20.sp,color:lightBlue)
                        ),
                        TextSpan(
                            text: "roo",
                            style: TextStyle(fontFamily: "Fredoka",fontSize: 20.sp,color:lightPurple)
                        )
                      ])),
                      SizedBox(height: 10.h,),
                      myText(text: "About Us & Version", fontFamily: "Poppins", size: 16.sp, color: whiteColor),
                      SizedBox(height: 20.h,),
                    ],
                  ),
                )
            )

          ],
        )
    );
  }

  Widget bottomSheet() {
    return SizedBox(
      height: 180.h,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(18.0),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconCreation(
                  Icons.image, Colors.purple, "Image",(){
                context.read<DashProvider>().imagePickerMethod(context);
              }),
              SizedBox(
                width: 40.w,
              ),
              iconCreation(Icons.camera, Colors.pink, "Camera",
                  (){
        context.read<DashProvider>().getCameraImage(context);
        }),

            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(
      IconData icons, Color color, String text, GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 30.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: 14.sp,
                fontFamily: "Poppins",
                color: dashColor
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? rememberMe = prefs.getBool("remember_me");
    prefs.setBool("isLoggedIn", false);

    if (rememberMe == false) {
      prefs.clear();
    } else {
      SharedPref.saveUserID("null");
    }
    if (mounted) {
      setState(() {
        SharedPref.saveIsLoggedIn(false);
        Globals.uid = "null";
        Globals.email ="null";
        Globals.pass = "null";
      });
    }
    FirebaseMessaging.instance.deleteToken();
    AppRoutes.pushAndRemoveUntil(context, const LoginScreen(from: false,));
  }

}


