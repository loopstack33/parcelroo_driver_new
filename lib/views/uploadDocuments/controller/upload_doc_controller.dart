// ignore_for_file: invalid_use_of_visible_for_testing_member, prefer_typing_uninitialized_variables

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import '../../../enums/color_constants.dart';
import '../../../enums/gobals.dart';
import '../../../utils/toasts.dart';
import '../../../widgets/simple_dialog.dart';

class UploadDocumentProvider extends ChangeNotifier{

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;



  Future getDocuments() async{
    await firebaseFireStore.collection("drivers").doc(Globals.uid).collection("documents").doc(Globals.uid).get().then((value){
      _downloadURL1 = value.data()!["passportFront"].toString();
      _downloadURL11 = value.data()!["passportBack"].toString();
      _downloadURL2 = value.data()!["drivingLicenseFront"].toString();
      _downloadURL22 = value.data()!["drivingLicenseBack"].toString();
      _downloadURL3 = value.data()!["bankStatement"].toString();
      _downloadURL4 = value.data()!["vehicleInsurance"].toString();
      _downloadURL5 = value.data()!["transitInsurance"].toString();
      _downloadURL6 = value.data()!["liabilityInsurance"].toString();
      _downloadURL7 = value.data()!["nic"].toString();

      notifyListeners();
    });
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  var selectedType;
  List types = ["Passport Page","Full Driving license","Updated Bank Statements","Vehicle Insurance","Goods In Transit Insurance","Liability Insurance","National Identity card \n/ Citizen Card"];

  changeType(value){
    selectedType = value;
    notifyListeners();
  }

  Future checkDocsExists(BuildContext context,docID) async {
    _isLoading=true;
    notifyListeners();
    await firebaseFireStore.collection("drivers").doc(Globals.uid).collection("documents").doc(docID)
        .get().then((value) {
      if(value.exists){
        log("Exists");
        updateDocuments(context,docID);
      }
      else{
        _isLoading=false;
        notifyListeners();
        log("Not Exists");
        uploadDocuments(context,docID);
      }
    });
  }

  String _downloadURL1= "";
  String _downloadURL11= "";
  String _downloadURL2= "";
  String _downloadURL22= "";
  String _downloadURL3= "";
  String _downloadURL4= "";
  String _downloadURL5= "";
  String _downloadURL6= "";
  String _downloadURL7= "";

  String get downloadURL1=> _downloadURL1;
  String get downloadURL11=> _downloadURL11;
  String get downloadURL2=> _downloadURL2;
  String get downloadURL22=> _downloadURL22;
  String get downloadURL3=> _downloadURL3;
  String get downloadURL4=> _downloadURL4;
  String get downloadURL5=> _downloadURL5;
  String get downloadURL6=> _downloadURL6;
  String get downloadURL7=> _downloadURL7;

  File? passport, passportBack, license, licenseBack, statement, insurance, transit, liability, nic;

  bool _imageSelected = false;
  bool get imageSelected => _imageSelected;

  reset(){
    selectedType = null;
    _downloadURL1= "";
    _downloadURL2= "";
    _downloadURL11= "";
    _downloadURL22= "";
    _downloadURL3= "";
    _downloadURL4= "";
    _downloadURL5= "";
    _downloadURL6= "";
    _downloadURL7= "";
    passport=null;
    passportBack = null;
    license=null;
    licenseBack = null;
    statement=null;
    insurance=null;
    transit=null;
    liability=null;
    nic=null;
    _imageSelected=false;
    _isLoading=false;
    notifyListeners();
  }

  void uploadDocuments(context,docID) async {
    _isLoading=true;
    notifyListeners();

    ////PASSPORT
    if (passport != null) {
      final path = 'driverDocuments/${Globals.uid}/${passport!.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(passport!);
      _downloadURL1 = await ref.getDownloadURL();
      notifyListeners();
    }

    ////PASSPORT BACK
    if (passportBack != null) {
      final path = 'driverDocuments/${Globals.uid}/${passportBack!.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(passportBack!);
      _downloadURL11 = await ref.getDownloadURL();
      notifyListeners();
    }

    ////LICENSE
    if (license != null) {
      final path = 'driverDocuments/${Globals.uid}/${license!.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(license!);
      _downloadURL2 = await ref.getDownloadURL();
      notifyListeners();
    }

    ////LICENSE BACK
    if (licenseBack != null) {
      final path = 'driverDocuments/${Globals.uid}/${licenseBack!.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(licenseBack!);
      _downloadURL22 = await ref.getDownloadURL();
      notifyListeners();
    }

    ////STATEMENT
    if (statement != null) {
      final path = 'driverDocuments/${Globals.uid}/${statement!.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(statement!);
      _downloadURL3 = await ref.getDownloadURL();
      notifyListeners();
    }

    ////INSURANCE
    if (insurance != null) {
      final path = 'driverDocuments/${Globals.uid}/${insurance!.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(insurance!);
      _downloadURL4 = await ref.getDownloadURL();
      notifyListeners();
    }

    ////TRANSIT
    if (transit != null) {
      final path = 'driverDocuments/${Globals.uid}/${transit!.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(transit!);
      _downloadURL5 = await ref.getDownloadURL();
      notifyListeners();
    }

    ////LIABILITY
    if (liability != null) {
      final path = 'driverDocuments/${Globals.uid}/${liability!.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(liability!);
      _downloadURL6 = await ref.getDownloadURL();
      notifyListeners();
    }

    ////NIC
    if (nic != null) {
      final path = 'driverDocuments/${Globals.uid}/${nic!.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(nic!);
      _downloadURL7 = await ref.getDownloadURL();
      notifyListeners();
    }

    await firebaseFireStore.collection("drivers").doc(Globals.uid.toString()).collection("documents").doc(docID).set({
      "passportFront":_downloadURL1,
      "passportBack":_downloadURL11,
      "drivingLicenseFront":_downloadURL2,
      "drivingLicenseBack":_downloadURL22,
      "bankStatement":_downloadURL3,
      "vehicleInsurance":_downloadURL4,
      "transitInsurance":_downloadURL5,
      "liabilityInsurance":_downloadURL6,
      "nic":_downloadURL7,
      "time": DateTime.now().millisecondsSinceEpoch.toString(),
    }).then((value) {
      getDocuments();
      _isLoading=false;
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Your Documents Have Been Uploaded Successfully.",
          icon: FeatherIcons.checkCircle,);
      });
      reset();
      notifyListeners();
    }).catchError((e){
      _isLoading=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return  MySimpleDialog(title: "Error", msg: e.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
    });
  }

  void updateDocuments(context,docID) async {

    ////PASSPORT
    if (passport != null) {
      if(_downloadURL1!=""){
        Reference ref = FirebaseStorage.instance.refFromURL(_downloadURL1);
        ///VEHICLE IMAGE
        await ref.putFile(passport!);
        _downloadURL1 = await ref.getDownloadURL();
        notifyListeners();
      }
      else{
        final path = 'driverDocuments/${Globals.uid}/${passport!.path.split('/').last}';
        Reference ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(passport!);
        _downloadURL1 = await ref.getDownloadURL();
        notifyListeners();
      }

    }

    ////PASSPORT BACK
    if (passportBack != null) {
      if(_downloadURL11!=""){
        Reference ref = FirebaseStorage.instance.refFromURL(_downloadURL11);
        await ref.putFile(passportBack!);
        _downloadURL11 = await ref.getDownloadURL();
        notifyListeners();
      }
      else{
        final path = 'driverDocuments/${Globals.uid}/${passportBack!.path.split('/').last}';
        Reference ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(passportBack!);
        _downloadURL11 = await ref.getDownloadURL();
        notifyListeners();
      }

    }

    ////LICENSE
    if (license != null) {
      if(_downloadURL2!=""){
        Reference ref = FirebaseStorage.instance.refFromURL(_downloadURL2);
        await ref.putFile(license!);
        _downloadURL2 = await ref.getDownloadURL();
        notifyListeners();
      }
      else{
        final path = 'driverDocuments/${Globals.uid}/${license!.path.split('/').last}';
        Reference ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(license!);
        _downloadURL2 = await ref.getDownloadURL();
        notifyListeners();
      }
    }

    ////LICENSE BACK
    if (licenseBack != null) {
      if(_downloadURL22!=""){
        Reference ref = FirebaseStorage.instance.refFromURL(_downloadURL22);
        await ref.putFile(licenseBack!);
        _downloadURL22 = await ref.getDownloadURL();
        notifyListeners();
      }
      else{
        final path = 'driverDocuments/${Globals.uid}/${licenseBack!.path.split('/').last}';
        Reference ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(licenseBack!);
        _downloadURL22 = await ref.getDownloadURL();
        notifyListeners();
      }
    }

    ////STATEMENT
    if (statement != null) {
      if(_downloadURL3!=""){
        Reference ref = FirebaseStorage.instance.refFromURL(_downloadURL3);
        await ref.putFile(statement!);
        _downloadURL3 = await ref.getDownloadURL();
        notifyListeners();
      }
      else{
        final path = 'driverDocuments/${Globals.uid}/${statement!.path.split('/').last}';
        Reference ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(statement!);
        _downloadURL3 = await ref.getDownloadURL();
        notifyListeners();
      }
    }

    ////INSURANCE
    if (insurance != null) {
      if(_downloadURL4!=""){
        Reference ref = FirebaseStorage.instance.refFromURL(_downloadURL4);
        await ref.putFile(insurance!);
        _downloadURL4 = await ref.getDownloadURL();
        notifyListeners();
      }
      else{
        final path = 'driverDocuments/${Globals.uid}/${insurance!.path.split('/').last}';
        Reference ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(insurance!);
        _downloadURL4 = await ref.getDownloadURL();
        notifyListeners();
      }
    }

    ////TRANSIT
    if (transit != null) {
      if(_downloadURL5!=""){
        Reference ref = FirebaseStorage.instance.refFromURL(_downloadURL5);
        await ref.putFile(transit!);
        _downloadURL5 = await ref.getDownloadURL();
        notifyListeners();
      }
      else{
        final path = 'driverDocuments/${Globals.uid}/${transit!.path.split('/').last}';
        Reference ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(transit!);
        _downloadURL5 = await ref.getDownloadURL();
        notifyListeners();
      }

    }

    ////LIABILITY
    if (liability != null) {
      if(_downloadURL6!=""){
        Reference ref = FirebaseStorage.instance.refFromURL(_downloadURL6);
        await ref.putFile(liability!);
        _downloadURL6 = await ref.getDownloadURL();
        notifyListeners();
      }
      else{
        final path = 'driverDocuments/${Globals.uid}/${liability!.path.split('/').last}';
        Reference ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(liability!);
        _downloadURL6 = await ref.getDownloadURL();
        notifyListeners();
      }

    }

    ////NIC
    if (nic != null) {
      if(_downloadURL7!=""){
        Reference ref = FirebaseStorage.instance.refFromURL(_downloadURL7);
        await ref.putFile(nic!);
        _downloadURL7 = await ref.getDownloadURL();
        notifyListeners();
      }
      else{
        final path = 'driverDocuments/${Globals.uid}/${nic!.path.split('/').last}';
        Reference ref = FirebaseStorage.instance.ref().child(path);
        await ref.putFile(nic!);
        _downloadURL7 = await ref.getDownloadURL();
        notifyListeners();
      }

    }

    await firebaseFireStore.collection("drivers").doc(Globals.uid.toString()).collection("documents").doc(docID).update({
      "passportFront":_downloadURL1,
      "passportBack":_downloadURL11,
      "drivingLicenseFront":_downloadURL2,
      "drivingLicenseBack":_downloadURL22,
      "bankStatement":_downloadURL3,
      "vehicleInsurance":_downloadURL4,
      "transitInsurance":_downloadURL5,
      "liabilityInsurance":_downloadURL6,
      "nic":_downloadURL7,
      "time": DateTime.now().millisecondsSinceEpoch.toString(),
    }).then((value) {
      getDocuments();
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Your Documents Have Been Uploaded Successfully.",
          icon: FeatherIcons.checkCircle,);
      });
      _isLoading=false;
      reset();
      notifyListeners();
    }).catchError((e){
      _isLoading=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return  MySimpleDialog(title: "Error", msg: e.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
    });
  }

  Future imagePickerMethod(context,type,ImageSource source) async {
    final pick = await ImagePicker.platform.pickImage(
      source: source,
      imageQuality: 30,
    );

    if (pick != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pick.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );
      if (croppedFile != null) {
        checkFileSize(croppedFile.path,context,type);
      }
    } else {}
  }

  checkFileSize(path,context,type) {
    var fileSizeLimit = 1024;
    File f = File(path);
    var s = f.lengthSync();
    var fileSizeInKB = s / 1024;
    if (fileSizeInKB > fileSizeLimit) {
      ToastUtils.warningToast("Image size should be less than 1 MB", context);
      return false;
    } else {
      _imageSelected=true;
      notifyListeners();
      if(type=="1"){
        passport = File(path);
        notifyListeners();
      }
      else if(type=="11"){
        passportBack = File(path);
        notifyListeners();
      }
      else if(type=="2"){
        license = File(path);
        notifyListeners();
      }
      else if(type=="22"){
        licenseBack = File(path);
        notifyListeners();
      }
      else if(type=="3"){
        statement = File(path);
        notifyListeners();
      }
      else if(type=="4"){
        insurance = File(path);
        notifyListeners();
      }
      else if(type=="5"){
        transit = File(path);
        notifyListeners();
      }
      else if(type=="6"){
        liability = File(path);
        notifyListeners();
      }
      else{
        nic = File(path);
        notifyListeners();
      }
      AppRoutes.pop(context);
        return true;
      }
    }

}