// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/enums/image_constants.dart';
import 'package:parcelroo_driver_app/views/chat/widgets/chatListWidget.dart';
import '../../enums/gobals.dart';
import '../../utils/app_routes.dart';
import '../../widgets/text_widget.dart';
import 'chat_helper.dart';

class UserChatList extends StatefulWidget {
  UserChatList({Key? key}) : super(key: key);

  @override
  State<UserChatList> createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {
  bool loading = true;
  bool dialogOpen = false;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // FirebaseHelper.updateUserStatus(
        //     Globals.uid, 'offline');
        //FirebaseHelper.deleteUserToken(Globals.uid);
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
                AppRoutes.pop(context);
              },
            ),
            backgroundColor:Colors.transparent,
            elevation: 0,
          title: myText(text: "Messages", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
          centerTitle: true,),
        body: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                )),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 10.h,
                    bottom: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10.h),
                    Image.asset(logo, height: 100.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              'Start your conversation with clients',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: 18.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    const ChatListWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
