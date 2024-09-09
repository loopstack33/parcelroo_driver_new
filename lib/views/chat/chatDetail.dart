// ignore_for_file: file_names, must_be_immutable, library_private_types_in_public_api, use_build_context_synchronously, prefer_typing_uninitialized_variables
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcelroo_driver_app/enums/image_constants.dart';
import 'package:parcelroo_driver_app/views/chat/widgets/bottom_field_widget.dart';
import '../../enums/color_constants.dart';
import '../../models/chatModels/chat_room_model.dart';
import '../../models/chatModels/message_model.dart';
import '../../models/chatModels/userModel.dart';
import '../../utils/app_routes.dart';


class ChatDetailPage extends StatefulWidget {
  final UsersModel targetUser;
  final ChatRoomModel chatRoom;
  final UsersModel userModel;

  final status;
  const ChatDetailPage({
    Key? key,
    required this.targetUser,
    required this.chatRoom,
    required this.userModel,
    required this.status,
  }) : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> with WidgetsBindingObserver {

  final ScrollController controller = ScrollController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashColor,
      resizeToAvoidBottomInset: true,
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
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color:Colors.black,
                      blurRadius: 5.r,)
                  ],
                ),
                width: 40.w,
                height: 40.h,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.targetUser.image.toString()),
                  backgroundColor: Colors.grey,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.targetUser.name.toString(),
                      style: TextStyle(
                          fontFamily: 'Poppins',

                          fontSize: 14.sp),
                    ),
                    Row(children: [
                      Container(
                        width: 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                            color:  Colors.lightGreenAccent),
                      ),
                      SizedBox(width: 5.w),
                      Text("Active Now",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Poppins',
                              fontSize: 12.sp)),
                    ]),
                  ],
                ),
              ),
            ],
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            )),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 55.0, top: 10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoom.chatroomid)
                    .collection("messages")
                    .orderBy("createdon", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                      snapshot.data as QuerySnapshot;
                      return ListView.builder(
                        physics:const BouncingScrollPhysics(),
                        controller: controller,
                        reverse: true,
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage =
                          MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                              as Map<String, dynamic>);
                                  // Text
                          return currentMessage.type == "text"
                              ? Container(
                            padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 5,
                                bottom: 5),
                            child: Align(
                              alignment: ((currentMessage
                                  .sender ==
                                  widget.userModel.userId)
                                  ? Alignment.topRight
                                  : Alignment.topLeft),
                              child: Column(
                                crossAxisAlignment:
                                (currentMessage.sender ==
                                    widget.userModel
                                        .userId)
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment
                                    .start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4.r
                                        )
                                      ],
                                      borderRadius: (currentMessage
                                          .sender ==
                                          widget.userModel
                                              .userId)
                                          ? BorderRadius.only(
                                          topLeft: Radius.circular(
                                              10.r),
                                          topRight:
                                          Radius.circular(
                                              10.r),
                                          bottomLeft:
                                          Radius.circular(
                                              10.r))
                                          : BorderRadius.only(
                                          bottomLeft:
                                          Radius.circular(
                                              10.r),
                                          topRight: Radius.circular(15.r),
                                          bottomRight: Radius.circular(15.r)),
                                      color: ((currentMessage
                                          .sender ==
                                          widget.userModel
                                              .userId)
                                          ? Colors.black
                                          : whiteColor),
                                    ),
                                    padding:
                                    const EdgeInsets.all(
                                        8),
                                    child: Text(
                                      currentMessage.text!,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily:
                                          'Poppins',
                                          color:currentMessage
                                              .sender ==
                                              widget.userModel
                                                  .userId? whiteColor:Colors.black),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    mainAxisAlignment:
                                    (currentMessage
                                        .sender ==
                                        widget.userModel
                                            .userId)
                                        ? MainAxisAlignment
                                        .end
                                        : MainAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        DateFormat.jm().format(
                                            currentMessage
                                                .createdon!),
                                        style: TextStyle(
                                            fontFamily:
                                            'Poppins',
                                            fontSize: 12.sp,
                                            color:Colors.black.withOpacity(0.7)),
                                      ),

                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                              // Image
                              :currentMessage.type == "image"
                              ? Container(
                            padding:
                            const EdgeInsets.only(
                                left: 14,
                                right: 14,
                                top: 10,
                                bottom: 10),
                            child: Align(
                              alignment: (currentMessage
                                  .sender ==
                                  widget.userModel
                                      .userId)
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment:
                                (currentMessage
                                    .sender ==
                                    widget
                                        .userModel
                                        .userId)
                                    ? CrossAxisAlignment
                                    .end
                                    : CrossAxisAlignment
                                    .start,
                                children: [
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          15.r),
                                      child: /* currentMessage
                                                  .text !=
                                                  ""
                                                  ? */
                                      Image.network(
                                        currentMessage
                                            .text!,
                                        loadingBuilder:
                                            (BuildContext
                                        context,
                                            Widget
                                            child,
                                            ImageChunkEvent?
                                            loadingProgress) {
                                          if (loadingProgress ==
                                              null) {
                                            return child;
                                          }
                                          return Container(
                                            decoration:
                                            BoxDecoration(
                                              color:
                                              whiteColor,
                                              borderRadius:
                                              BorderRadius
                                                  .all(
                                                Radius.circular(
                                                    8.r),
                                              ),
                                            ),
                                            width: 200.w,
                                            height: 200.h,
                                            child: Center(
                                              child:
                                              CircularProgressIndicator(
                                                color: Colors.black,
                                                value: loadingProgress.expectedTotalBytes !=
                                                    null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context,
                                            object,
                                            stackTrace) {
                                          return Material(
                                            borderRadius:
                                            BorderRadius
                                                .all(
                                              Radius
                                                  .circular(
                                                  8.r),
                                            ),
                                            clipBehavior:
                                            Clip.hardEdge,
                                            child: Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: Image
                                                  .asset(
                                                logo,
                                                width: 180.w,
                                                height: 180.h,
                                              ),
                                            ),
                                          );
                                        },
                                        width: 200.w,
                                        height: 200.h,
                                        fit: BoxFit.cover,
                                      )
                                    /*: Center(
                                                child: StreamBuilder<
                                                    TaskSnapshot>(
                                                    stream: uploadTask
                                                        ?.snapshotEvents,
                                                    builder:
                                                        (context,
                                                        snapshot) {
                                                      if (snapshot
                                                          .hasData) {
                                                        final data =
                                                            snapshot.data;
                                                        double
                                                        progress =
                                                        (data!.bytesTransferred / data.totalBytes);
                                                        return SizedBox(
                                                          width: 200.w,
                                                          height: 200.h,
                                                          child: Stack(
                                                            fit: StackFit.expand,
                                                            children: [
                                                              SizedBox(
                                                                width: 60.w,
                                                                height: 60.h,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(70.0),
                                                                  child: CircularProgressIndicator(value: progress, color: AppColors.redcolor, backgroundColor: Colors.grey),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  '${(100 * progress).roundToDouble()} %',
                                                                  style: TextStyle(fontFamily: 'Poppins-Regular',fontWeight: FontWeight.bold, fontSize: 15.sp),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        return const SizedBox();
                                                      }
                                                    }),
                                              ),*/

                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    mainAxisAlignment: (currentMessage
                                        .sender ==
                                        widget
                                            .userModel
                                            .userId)
                                        ? MainAxisAlignment
                                        .end
                                        : MainAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        DateFormat.jm().format(
                                            currentMessage
                                                .createdon!),
                                        style: TextStyle(
                                            fontFamily:
                                            'Poppins',
                                            fontSize:
                                            12.sp,
                                            color: const Color(
                                                0xFF606060)
                                                .withOpacity(
                                                0.6)),
                                      ),

                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                              :const SizedBox.shrink();
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "An error occurred! Please check your internet connection."),
                      );
                    } else {
                      return const Center(
                          child: Text(
                            "Say hi to your new friend",
                          ));
                    }
                  } else {
                    return const Center();
                  }
                },
              ),
            ),
            IgnorePointer(
                child: Center(
                    child: Opacity(
                      opacity: 0.05,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Image.asset(logo)),
                    ))),
            Align(
              alignment: Alignment.bottomLeft,
              child: BottomField(
                  usersModel: widget.userModel,
                  chatRoom: widget.chatRoom,
                  targetUser: widget.targetUser),
            ),
          ],
        ),
      ),
    );
  }

}
