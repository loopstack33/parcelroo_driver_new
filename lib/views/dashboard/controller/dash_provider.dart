// ignore_for_file: invalid_use_of_visible_for_testing_member, prefer_typing_uninitialized_variables, prefer_final_fields

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/utils/shared_pref.dart';
import 'package:parcelroo_driver_app/views/login/login_screen.dart';

import '../../../enums/color_constants.dart';
import '../../../utils/toasts.dart';
import '../../../widgets/simple_dialog.dart';
import '../widgets/vehicle_sheet.dart';

class DashProvider extends ChangeNotifier{
  bool _isSwitched = false;
  bool get isSwitched => _isSwitched;
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  void toggleSwitch(bool value,context) {

    if(value==true){
      selectedIndex = null;
      _activeVehicle = "";
      selectedIndex2=null;
      _activeCompany= "";
      _companyID.clear();
      _selected.clear();
      _selectedVehicle = "";
      notifyListeners();
      Sheets.showVehicleSheet(context);
    }
    else{
      resetDriverStatus(Globals.uid,"offline",context);
    }

  }

  Future getData(context) async{
    var id = await SharedPref.getUserID();
    Globals.uid=id;
    notifyListeners();
  }

  var selectedIndex;
  String _activeVehicle = "";
  String get activeVehicle => _activeVehicle;
  String _selectedVehicle = "";
  String get selectedVehicle => _selectedVehicle;

  changeIndex(index,vehicle,name){
    selectedIndex= index;
    _activeVehicle = vehicle;
    _selectedVehicle = name;
    notifyListeners();
    log(_activeVehicle);
    log(_selectedVehicle);
  }

  var selectedIndex2;
  String _activeCompany = "";
  String get activeCompany => _activeCompany;

  switchCompany(value){
    _activeCompany = value;
    notifyListeners();
  }

  List<bool> _selected = [];
  List<bool> get selected => _selected;

  List<String> _companyID = [];
  List<String> get companyID => _companyID;

  void addCompanies(index,company){
    _selected[index] = !_selected[index];
    notifyListeners();
    if(_selected[index]){
      _companyID.add(company);
    }
    else{
      _companyID.removeAt(index);
    }

  }

  changeIndex2(index,company,context){
    selectedIndex2= index;
    _activeCompany = company;
    log(_activeCompany);
    notifyListeners();
  }

  void setDriverStatus(context) async {
    _isLoading=true;
    notifyListeners();
    for (int i = 0; i < _companyID.length; i++) {
      await firebaseFireStore.collection("companies").doc(_companyID[i].toString()).collection("myDrivers").doc(Globals.uid).update({
        "status": "online",
        "activeVehicle": _activeVehicle.toString(),
        "selectedVehicle": _selectedVehicle.toString(),
        "onlineFor": DateTime.now().millisecondsSinceEpoch.toString(),
      });


      if(i==_companyID.length-1){
        await firebaseFireStore.collection("drivers").doc(Globals.uid).update({
          "status": "online",
          "activeVehicle": _activeVehicle.toString(),
          "selectedVehicle": _selectedVehicle.toString(),
          "onlineFor": _companyID.map((e) => e).toList(),
          'lastOnline':DateTime.now().millisecondsSinceEpoch.toString()
        });
        print("Last");
        _isLoading=false;
        _isSwitched = true;
        _activeCompany = _companyID[0].toString();
        _companyID.clear();
        _selected.clear();
        notifyListeners();
        getUserData();
        log("Status Update Done");

        showDialog(context: context, builder: (context){
          return  MySimpleDialog(title: "Success", msg: "You are now online.",
            icon: FeatherIcons.checkCircle,
            onTap:(){
              AppRoutes.pop(context);
              AppRoutes.pop(context);
            },);
        });
      }

    }

  }

  void setDriverStatus2(context) async {
    _isLoading=true;
    notifyListeners();
    await firebaseFireStore.collection("companies").doc(_activeCompany.toString()).collection("myDrivers").doc(Globals.uid).update({
      "status": "online",
      "activeVehicle": _activeVehicle.toString(),
      "selectedVehicle": _selectedVehicle.toString(),
      "onlineFor": DateTime.now().millisecondsSinceEpoch.toString(),
    }).then((value) async{
      await firebaseFireStore.collection("drivers").doc(Globals.uid).update({
        "status": "online",
        "activeVehicle": _activeVehicle.toString(),
        "selectedVehicle": _selectedVehicle.toString(),
        "onlineFor": _activeCompany.toString(),
        'lastOnline':DateTime.now().millisecondsSinceEpoch.toString()
      }).then((value) async{
        _isLoading=false;
        _isSwitched = true;
        notifyListeners();
        getUserData();
        log("Status Update Done");

        showDialog(context: context, builder: (context){
          return  MySimpleDialog(title: "Success", msg: "You are now online.",
            icon: FeatherIcons.checkCircle,
            onTap:(){
              AppRoutes.pop(context);
              AppRoutes.pop(context);
            },);
        });

      });
    });
  }

  String _image = "";
  String _firstName = "";
  String _middleName = "";
  String _lastName = "";
  String get image => _image;
  String get firstName => _firstName;
  String get middleName => _middleName;
  String get lastName => _lastName;

  Future checkUserActive(BuildContext context) async {
    _isLoading=true;
    notifyListeners();
    await firebaseFireStore.collection('drivers').where("uid",isEqualTo: Globals.uid.toString()).limit(1)
        .get().then((value) {
      if(value.size>0){
        getUserData();
      }
      else{
        checkActive(context);
      }
    });
  }

  Future checkActive(BuildContext context) async {

    await firebaseFireStore.collection('offBoard_drivers').where("uid",isEqualTo: Globals.uid.toString()).limit(1)
        .get().then((value) {
      if(value.size>0){

        log("THIS USER IS NOT ACTIVE");
        _isLoading = false;
        notifyListeners();
        AppRoutes.pushAndRemoveUntil(context, const LoginScreen(from:true));
      }
      else{
        _isLoading = false;
        notifyListeners();
        AppRoutes.pushAndRemoveUntil(context, const LoginScreen(from:true));
      }
    });
  }

  Future getUserData() async{
    print(Globals.uid);

    await firebaseFireStore.collection('drivers').doc(Globals.uid)
        .get().then((value) {
    _image =value.data()!["image"].toString();
    _firstName =value.data()!["name"].toString();
    _middleName =value.data()!["middleName"].toString();
    _lastName =value.data()!["surName"].toString();
    _isSwitched = value.data()!["status"].toString()=="online"?true:false;
    _activeCompany =value.data()!["onlineFor"].toString()!="[]" && value.data()!["onlineFor"].toString()!=""? value.data()!["onlineFor"][0].toString():"";
    if(value.data()!["onlineFor"].toString()!="[]" && value.data()!["onlineFor"].toString()!=""){
      _companyID.clear();
      for (int i = 0; i < value.data()!["onlineFor"].length; i++){
        _companyID.add(value.data()!["onlineFor"][i].toString());
      }
    }

    log("COMPANY IDS  $_companyID");

    _selectedVehicle = value.data()!["selectedVehicle"].toString();
    _isLoading=false;
    notifyListeners();
    });
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void resetDriverStatus(uid, String status,context) async {
    _isLoading=true;
    notifyListeners();

    getUserData().then((value) async{

      for (int i = 0; i < _companyID.length; i++) {
        await firebaseFireStore.collection("companies").doc(_companyID[i].toString()).collection("myDrivers").doc(Globals.uid).update({
          "status": "offline",
          "activeVehicle": "",
          "selectedVehicle": "",
          'lastOnline':""
        });

        if(i==_companyID.length-1){
          await firebaseFireStore.collection("drivers").doc(uid).update({
            'status': status.toString(),
            "activeVehicle": "",
            "selectedVehicle": "",
            "onlineFor":[],
          });
          print("Last");
          _isLoading=false;
          _isSwitched = true;
          _activeCompany = "";
          _companyID.clear();
          _selected.clear();
          notifyListeners();
          getUserData();
          log("Status Update Done");
          showDialog(context: context, builder: (context){
            return const MySimpleDialog(title: "Success", msg: "You are now offline.",
              icon: FeatherIcons.checkCircle,);
          });
        }

      }
    });

  }

  String downloadURL1= "";
  File? imageUrl;

  bool _updatingImage= false;
  bool get updatingImage=> _updatingImage;
  Future imagePickerMethod(context) async {
    final pick = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
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
         checkFileSize(croppedFile.path,context);
      }
    } else {}
  }

  Future getCameraImage(context) async {
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.camera,
      imageQuality: 30,).then((xFile) async {
        if (xFile != null) {
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: xFile.path,
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
            checkFileSize(xFile.path,context);
          }
        } else {}

    });
  }

  checkFileSize(path,context) {
    var fileSizeLimit = 1024;
    File f = File(path);
    var s = f.lengthSync();
    var fileSizeInKB = s / 1024;
    if (fileSizeInKB > fileSizeLimit) {
      ToastUtils.warningToast("Image size should be less than 1 MB", context);
      return false;
    } else {
      _updatingImage= true;
      imageUrl = File(path);
      notifyListeners();
      updateLogo(Globals.uid,context);
      return true;
    }
  }

  void updateLogo(uid,context) async {
    if (imageUrl != null) {
      final path = 'driverImages/${Globals.uid}/${imageUrl!.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(imageUrl!);
      downloadURL1 = await ref.getDownloadURL();
    }

    await firebaseFireStore.collection("drivers").doc(uid).update({
      'image': downloadURL1.toString(),
    }).then((value) {
      getUserData();
      _updatingImage= false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Profile Image Updated Successfully!!",
          icon: FeatherIcons.checkCircle,);
      });
    });
  }

  bool _clearing = false;
  bool get  clearing=> _clearing;

  clearCache(context){
    _clearing = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2),(){
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Cache Cleared!!",
          icon: FeatherIcons.checkCircle,);
      });
      _clearing = false;
      notifyListeners();
    });
  }

}