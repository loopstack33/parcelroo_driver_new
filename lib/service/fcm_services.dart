// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

const firebaseKey = "AAAA_raebm0:APA91bHfoC028NDLt5tM57voQjQCFXcyKq_VCBjW6MrpQepYX6qwC42M1bvBdxH8qOM_lrjUCmnUTNyI_ac_ELQL5hMpY5QsF35LhnkS4qXHpanE8T09F3Z4-Lj1f9DUhFun1pCBHWcm";

class FCMServices {
  static fcmGetTokenandSubscribe(topic) {
    FirebaseMessaging.instance.getToken().then((value) {
      FirebaseMessaging.instance.subscribeToTopic("$topic");
    });
  }

  static Future<http.Response> sendFCM(topic, id, title, description) {

    return http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "key=$firebaseKey",
      },
      body: jsonEncode({
         "to": "/topics/$topic",
        "notification": {
          "title": title,
          "body": description,
        },
        "mutable_content": true,
        "content_available": true,
        "priority": "high",
        "data": {
           "android_channel_id": "parcelroo",
          "id": id,
          "userName": title,
        }
      }),
    );
  }

  static Future<http.Response> sendFCM2(topic, id, title, description) {

    return http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "key=$firebaseKey",
      },
      body: jsonEncode({
        //  "to": "/topics/$topic",
        'to': topic,
        "notification": {
          "title": title,
          "body": description,
        },
        "mutable_content": true,
        "content_available": true,
        "priority": "high",
        "data": {
          "android_channel_id": "parcelroo",
          "id": id,
          "userName": title,
        }
      }),
    );
  }
}
