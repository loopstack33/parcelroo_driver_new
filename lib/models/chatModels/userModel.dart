// ignore_for_file: empty_catches, file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  String userId;
  String userToken;
  String status;
  String name;
  String? image;


  UsersModel(
      {
      required this.status,
      required this.userId,
      required this.userToken,
        required this.name,
        this.image,
});

  Map<String, dynamic> toJson() => {
        'uid': userId,
        'deviceToken': userToken,
        'status': status,
        'name':name,
        'image':image
      };

  factory UsersModel.fromDocument(DocumentSnapshot doc) {
    String uid = "";
    String deviceToken = "";
    String status = "";
    String name="";
    String image="";

    try {
      uid = doc.get("uid");
    } catch (e) {}

    try {
      deviceToken = doc.get("deviceToken");
    } catch (e) {}

    try {
      status = doc.get("status");
    } catch (e) {}

    try {
      name = doc.get("name");
    } catch (e) {}
    try {
      image = doc.get("image");
    } catch (e) {}

    return UsersModel(
        userId: uid,
        userToken: deviceToken,
        status: status,
        name: name,
        image:image
    );
  }
}
