// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';

import '../../../enums/color_constants.dart';
import '../../../models/chatModels/chat_room_model.dart';
import '../../../models/chatModels/userModel.dart';
import '../../../utils/app_routes.dart';
import '../chatDetail.dart';
import '../chat_helper.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({Key? key}) : super(key: key);

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget>
    with WidgetsBindingObserver {
  FirebaseAuth auth = FirebaseAuth.instance;
  var currentUser;

  @override
  void initState() {
    super.initState();
    getData();
    WidgetsBinding.instance.addObserver(this);
  }

  getData() async {

    // FirebaseHelper.updateUserStatus(Globals.uid, 'online');
    //FirebaseHelper.updateUserToken(Globals.uid, "");
    currentUser = await FirebaseHelper.getUserModelById(Globals.uid);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
    final isBackground = state == AppLifecycleState.paused;
    if (isBackground) {
      // FirebaseHelper.updateUserStatus(Globals.uid, 'offline');
    } else {
      // FirebaseHelper.updateUserStatus(Globals.uid, 'online');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chatrooms")
            .where("participants.${Globals.uid}", isEqualTo: Globals.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              log(snapshot.data!.size.toString());
              QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

              return chatRoomSnapshot.docs.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: chatRoomSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            chatRoomSnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        Map<dynamic, dynamic> participants =
                            chatRoomModel.participants!;
                        List<dynamic> participantKeys =
                            participants.keys.toList();

                        participantKeys.removeAt(1);
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                            int.parse(chatRoomModel.timeStamp!));
                        var format = DateFormat.jm();
                        var dateString = format.format(date);

                        return FutureBuilder(
                          future: FirebaseHelper.getFromAllDatabase(participantKeys[0]),
                          builder: (context, userData) {
                            if (userData.connectionState == ConnectionState.done) {
                              if (userData.data != null) {
                                var targetUser = userData.data as Map;
                                //log(targetUser.toString());

                                return GestureDetector(
                                  onTap: () {
                                    log(chatRoomModel.chatroomid.toString());
                                    if (chatRoomModel.toString() != "null") {
                                      //log(currentUser.toString());
                                      log(currentUser['name'].toString());
                                      AppRoutes.push(
                                          context,
                                          PageTransitionType.rightToLeft,
                                          ChatDetailPage(
                                            status:
                                                targetUser['status'].toString(),
                                            targetUser: UsersModel(
                                                userId: targetUser['docID'].toString(),
                                                status: targetUser['status'],
                                                userToken: "",
                                                name: targetUser['companyName'],
                                              image: targetUser['companyLogo'].toString(),
                                              ),
                                            userModel: UsersModel(
                                              userId:
                                                  currentUser['id'].toString(),
                                              status: currentUser['status'],
                                              userToken:
                                                  currentUser['deviceToken'],
                                                name: currentUser['name']
                                            ),
                                            chatRoom: chatRoomModel,
                                          ));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(10.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.18),
                                          blurRadius: 11.r
                                        )
                                      ]
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10,bottom: 10),
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 45,
                                              width: 45,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                fit: StackFit.expand,
                                                children: [
                                                 CircleAvatar(
                                                    backgroundImage: NetworkImage(targetUser['companyLogo'].toString()),
                                                    backgroundColor: Colors.grey,
                                                  ),
                                                  Positioned(
                                                      bottom: 0,
                                                      right: 5,
                                                      child:Container(
                                                        width: 10.w,
                                                        height: 10.h,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border:Border.all(color: Colors.white),
                                                            color:targetUser['status'].toString()=="online"? Colors.lightGreenAccent
                                                                : Colors.grey,

                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Container(
                                              color: Colors.transparent,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    targetUser["companyName"].toString(),
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontFamily:
                                                            'Poppins',
                                                        color: Colors.black),
                                                  ),
                                                  (chatRoomModel.lastMessage
                                                              .toString() !=
                                                          "")
                                                      ? chatRoomModel.lastMessage
                                                                  .toString() ==
                                                              "Image File"
                                                          ? Text(
                                                              "📷 Photo",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  color: Colors.black,
                                                                  fontFamily:
                                                                      'Poppins'),
                                                            )
                                                          : chatRoomModel.lastMessage
                                                                      .toString() ==
                                                                  "Audio"
                                                              ? Text(
                                                                  "🎵 Audio",
                                                                  style: TextStyle(
                                                                      fontSize: 14
                                                                          .sp,
                                                                      color: Colors.black,
                                                                      fontFamily:
                                                                          'Poppins'),
                                                                )
                                                              : chatRoomModel
                                                                          .lastMessage
                                                                          .toString() ==
                                                                      "Video"
                                                                  ? Text(
                                                                      "📸 Video",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14.sp,
                                                                          color: Colors.black,
                                                                          fontFamily: 'Poppins'),
                                                                    )
                                                                  : SizedBox(
                                                                    width:MediaQuery.of(context).size.width*0.45,
                                                                    child: Text(
                                                                        chatRoomModel
                                                                            .lastMessage
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14.sp,
                                                                            color: Colors.black,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            fontFamily: 'Poppins'),
                                                                      ),
                                                                  )
                                                      : Text(
                                                          "Say hi✋ to your new friend",
                                                          style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color: Colors.grey,
                                                              fontFamily:
                                                                  'Poppins'))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(dateString.toString(),
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontFamily: 'Poppins',
                                                    color: Colors.grey)),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text(""),
                                );
                              }
                            } else {
                              return const Center(
                                child: Text(""),
                              );
                            }
                          },
                        );
                      },
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            Icon(FeatherIcons.alertCircle,color: dashColor,size: 30.sp,),
                            Text(
                              "No Chats Found",
                              style: TextStyle(

                                  fontSize: 20.sp, fontFamily: 'Poppins'),
                            )
                          ],
                        ),
                      ),
                    );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString(),
                  style: TextStyle(

                      fontSize: 20.sp, fontFamily: 'Poppins'),),
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      Icon(FeatherIcons.alertCircle,color: dashColor,size: 30.sp,),
                      Text(
                        "No Chats Found",
                        style: TextStyle(

                            fontSize: 20.sp, fontFamily: 'Poppins'),
                      )
                    ],
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(color: dashColor),
            );
          }
        },
      ),
    );
  }
}
