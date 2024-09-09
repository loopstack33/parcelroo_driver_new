import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';
import '../../../models/driver_model.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/toasts.dart';
import '../../../widgets/simple_dialog.dart';

class JoinProvider extends ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  TextEditingController companyEmail = TextEditingController();
  TextEditingController companyConfirmEmail = TextEditingController();

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  void deleteCompany(BuildContext context,id,companyID) async {
    _isLoading=true;
    notifyListeners();
    await firebaseFireStore.collection("drivers").doc(Globals.uid).collection("partneredCompany").doc(id).delete().then((value) async{

      await firebaseFireStore.collection("companies").doc(companyID).collection("myDrivers").doc(Globals.uid).delete().then((value) {
        AppRoutes.pop(context);
        showDialog(context: context, builder: (context){
          return const MySimpleDialog(title: "Success", msg: "Company Deleted Successfully",
            icon: FeatherIcons.checkCircle,);
        });
        _isLoading=false;
        notifyListeners();

      }).catchError((e){
        ToastUtils.failureToast(e.toString() , context);
      });

    }).catchError((e){
      ToastUtils.failureToast(e.toString() , context);
    });
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future checkCompanyExists(BuildContext context,email) async {
    _isLoading=true;
    notifyListeners();
    await firebaseFireStore.collection('companies').where("email",isEqualTo: email.toString()).limit(1)
    .get().then((value) {
     if(value.size>0){
       checkRequestAlreadyExists(context,value.docs[0]["companyId"].toString());
     }
     else{
       _isLoading=false;
       notifyListeners();
       showDialog(context: context, builder: (context){
         return const MySimpleDialog(title: "Error", msg: "Company does not exists with given email",
           icon:FeatherIcons.alertTriangle,);
       });
     }
    });
  }

  Future checkRequestAlreadyExists(BuildContext context,id) async {

    await firebaseFireStore.collection('companies').doc(id).collection("driverRequests").where("uid",isEqualTo: Globals.uid).limit(1)
        .get().then((value) {

      if(value.size>0){
        _isLoading=false;
        companyEmail.text="";
        companyConfirmEmail.text="";
        notifyListeners();
        showDialog(context: context, builder: (context){
          return const MySimpleDialog(title: "Error", msg: "Joining Request Already Submitted.",
            icon:FeatherIcons.alertTriangle,);
        });
      }
      else{
        getDriver(context,id.toString());

      }
    });
  }

  getDriver(context,id) async{
    await firebaseFireStore.collection('drivers').doc(Globals.uid)
        .get().then((value) {
      DriverModel driverModel = DriverModel.fromMap(value.data()!);
      submitRequest(context,id.toString(),driverModel);
    });
  }


  Future submitRequest(BuildContext context, id, DriverModel driverModel) async{
    DriverModel driverModel2 = DriverModel(
        address1: driverModel.address1,
        address2: driverModel.address2,
        address3: driverModel.address3,
        city: driverModel.city,
        contact: driverModel.contact,
        country: driverModel.country,
        courierID: driverModel.courierID,
        zip: driverModel.zip,
        email: driverModel.email,
        gender: driverModel.gender,
        image: driverModel.image,
        uid: driverModel.uid,
        dob: driverModel.dob,
        name: driverModel.name,
        middleName: driverModel.middleName,
        surName: driverModel.surName,
        isActive: driverModel.isActive,
        isBan: driverModel.isBan,
        deviceToken:  driverModel.deviceToken,
        emailVerified: driverModel.emailVerified,
        status: driverModel.status,
        password: "",
        onlineFor: "",
        activeVehicle: driverModel.activeVehicle,
        selectedVehicle: driverModel.selectedVehicle,
        chatroomID: driverModel.chatroomID.toString()=="null"?"":driverModel.chatroomID.toString(),
        reasonForBan: "",
        lat: driverModel.lat,
        lng: driverModel.lng);

    await firebaseFireStore.collection("companies").doc(id).collection("driverRequests").doc(driverModel.uid.toString()).set(driverModel2.toMap()).then((value){
      _isLoading=false;
      companyEmail.text="";
      companyConfirmEmail.text="";
      notifyListeners();
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Thank You For Reaching Out Your Company Will Be In Touch With You Soon Please Check Your Email online.",
          icon: FeatherIcons.checkCircle,);
      });
    }).catchError((e){
      _isLoading=false;
      notifyListeners();
      ToastUtils.failureToast(e.toString() , context);
    });

  }

}