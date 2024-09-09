import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ApiService{

  Future sendCompanyNotification(type,message,docID) async{
    FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
    String id = const Uuid().v1();
    firebaseFireStore.collection("companies").doc(docID).collection("notifications").doc(id).set({
      "dateTime": DateTime.now().millisecondsSinceEpoch.toString(),
      "id":id,
      "message":message,
      "type":type,
    });

  }
}