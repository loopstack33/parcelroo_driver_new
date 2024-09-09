/*
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import '../enums/gobals.dart';
import '../models/chatModels/chat_room_model.dart';
import '../models/chatModels/userModel.dart';
import '../views/chat/chatDetail.dart';
import 'app_routes.dart';

class FirebaseHelper{
  static Future checkRoomExists(DriverModel driverModel,context) async {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
    await firebaseFireStore.collection('chatrooms').where("targetId",isEqualTo: driverModel.uid)
        .get().then((value)  async {
      log(value.size.toString());
      if(value.size>0) {
        log("Room Already Created");

        await firebaseFireStore
            .collection('chatrooms')
            .doc(driverModel.chatroomID.toString())
            .get()
            .then((value) {
          log(value.toString());

          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(value.data()!);
          log(chatRoomModel.toMap().toString());

          AppRoutes.push(
              context,
              PageTransitionType.rightToLeft,
              ChatDetailPage(
                status: "online",
                targetUser: UsersModel(
                  userId: driverModel.uid.toString(),
                  status: "online",
                  userToken: "",
                  name: driverModel.name.toString(),
                  image: driverModel.image.toString(),
                ),
                userModel: UsersModel(
                    userId: Globals.uid.toString(),
                    status: "online",
                    userToken: "",
                    name: ""
                ),
                chatRoom: chatRoomModel,
              ));

        }).catchError((e)  {
          log(e.toString());
        });
      }
      else{
        createChatroom(driverModel,context);
      }
    });

  }

  static void createChatroom(DriverModel driverModel,context) async {
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
    String id = const Uuid().v1();
    await firebaseFireStore.collection("chatrooms").doc(id.toString()).set({
      "chatroomid": id.toString(),
      "count":0,
      "idFrom":Globals.uid.toString(),
      "idTo":driverModel.uid.toString(),
      "lastmessage":"",
      "participants":{
        Globals.uid.toString():Globals.uid.toString(),
        driverModel.uid.toString():driverModel.uid.toString(),
      },
      "read":false,
      "targetId":driverModel.uid.toString(),
      "time":DateTime.now().millisecondsSinceEpoch.toString()
    }).then((value) {
      log("Room Created");
      updateRoomID(driverModel,id);
      firebaseFireStore
          .collection('chatrooms')
          .doc(id.toString())
          .get()
          .then((value) {

        ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(value.data()!);

        AppRoutes.push(
            context,
            PageTransitionType.rightToLeft,
            ChatDetailPage(
              status: "online",
              targetUser: UsersModel(
                userId: driverModel.uid.toString(),
                status: "online",
                userToken: "",
                name: driverModel.name.toString(),
                image: driverModel.image.toString(),
              ),
              userModel: UsersModel(
                  userId: Globals.uid.toString(),
                  status: "online",
                  userToken: "",
                  name: Globals.companyName.toString()
              ),
              chatRoom: chatRoomModel,
            ));

      }).catchError((e) async {
        log(e.toString());
      });

    });
  }


}

*/
