
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:parcelroo_driver_app/models/advertise_model.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/views/dashboard/dashboard.dart';
import '../../../enums/gobals.dart';
import '../../../service/api_service.dart';
import '../../../widgets/simple_dialog.dart';

class AvailableJobProvider extends ChangeNotifier{

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

 void acceptJob(AdvertiseModel advertiseModel,BuildContext context,uid,courierID,image,name) async{

  await firebaseFireStore.collection("jobs").doc(advertiseModel.jobId.toString()).update({
      "assignedTo" : uid,
      "driverName": name,
      "driverImage": image,
      "driverCourierID":courierID.toString(),
    }).then((value) async{
     _isLoading = false;
     notifyListeners();
     ApiService().sendCompanyNotification("jobAccepted", "Job No# ${advertiseModel.jobNo} Has Been Accepted By Driver CourierID# $courierID", advertiseModel.companyId.toString());
     showDialog(
         barrierDismissible: false,
         context: context, builder: (_){
       return  MySimpleDialog(title: "Success", msg: "Please Check Jobs To Do Your Job Is Now Ready.",
         icon: FeatherIcons.checkCircle,
         onTap: (){
           AppRoutes.pushAndRemoveUntil(context, const Dashboard());
         },);
     });


   }).catchError((e){
    _isLoading = false;
    notifyListeners();
    showDialog(context: context, builder: (context){
      return  MySimpleDialog(title: "Error", msg: e.toString(),
        icon:FeatherIcons.alertTriangle,);
    });
  });
  }

  void getDriverStatus(AdvertiseModel advertiseModel,BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    await firebaseFireStore.collection("drivers").doc(Globals.uid).get().then((value) {
      if(value.data()!["status"].toString()=="online"){
        acceptJob(advertiseModel,context,value.data()!["uid"].toString(),value.data()!["courierID"].toString(),value.data()!["image"].toString(),"${value.data()!["name"]} ${value.data()!["surName"]}");
      }
      else{
        _isLoading = false;
        notifyListeners();
        showDialog(context: context, builder: (context){
          return  const MySimpleDialog(title: "Error", msg: "Go Online First To Accept Job",
            icon:FeatherIcons.alertTriangle,);
        });
      }
     notifyListeners();
    });
  }

}