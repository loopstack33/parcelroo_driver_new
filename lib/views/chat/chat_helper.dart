import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  
  static Future getUserModelById(String uid) async {
    log(uid.toString());
    log(' getUserModelById uid: $uid');
    Object? data;
    DocumentSnapshot docSnap =
    await FirebaseFirestore.instance.collection("drivers").doc(uid).get();

    if (docSnap.data() != null) {
      data = docSnap.data();
      log('Userdata: $data');
    } else {
      log("users null");
    }

    return data;
  }

  static Future getFromAllDatabase(String uid) async {
    Object? data;
    DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection("companies").doc(uid).get();

    if (docSnap.data() != null) {
      data = docSnap.data();
    //  log('Userdata: $data');
    } else {
      log("users null");

    }

    return data;
  }

  static void updateUserStatus(uid, String status) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore.collection("drivers").doc(uid).update({
      'status': status.toString(),
    }).then((value) {
      log("Status Update Done");
    });

  }

  static void updateUserToken(uid, String token) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore.collection("drivers").doc(uid).update({
      'deviceToken': token,
    }).then((value) {
      log("Token Update Done");
    });
  }

  static void deleteUserToken(uid) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore.collection("drivers").doc(uid).update({
      'deviceToken': "",
    }).then((value) {
      log("Token Update Done");
    });
  }
}
