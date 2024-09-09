// ignore_for_file: prefer_typing_uninitialized_variables, invalid_use_of_visible_for_testing_member, prefer_final_fields

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';
import 'package:parcelroo_driver_app/models/advertise_model.dart';
import 'package:parcelroo_driver_app/service/api_service.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/views/dashboard/dashboard.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/pod_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../../../enums/color_constants.dart';
import '../../../utils/toasts.dart';
import '../../../utils/utilities.dart';
import '../../../widgets/simple_dialog.dart';
import '../../dashboard/controller/dash_provider.dart';
import '../customer_signature.dart';
import '../job_full_details.dart';
import '../securityFlowDrop/age_calculator.dart';
import '../securityFlowDrop/job_todo_reasond.dart';
import '../securityFlowDrop/todo_image_sender.dart';
import '../securityFlowDrop/todo_password_screen.dart';
import '../securityFlowDrop/todo_qr_code_scanner.dart';
import '../securityFlowPick/job_todo_reason.dart';
import 'package:pdf/widgets.dart' as pw;

class JobsTodoProvider extends ChangeNotifier{
  final GlobalKey<SlideActionState> key = GlobalKey();
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  TextEditingController reasonController = TextEditingController();
  final pdf = pw.Document();

  TextEditingController day = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController result = TextEditingController();

  TextEditingController waitingPH = TextEditingController();
  TextEditingController waitingPM = TextEditingController();
  List pReason = ["None","Customer Not Ready","Wrong Details Given e.g. Name, Address, Contact Details."];
  var selectedPReason;

  List<bool> _selected = [];
  List<bool> get selected => _selected;

  setPQr(){
    _selected.clear();
    overrideController.text="";
    notifyListeners();
  }
  
  addSelected(List itemLength){
    for (int i = 0; i < itemLength.length; i++) {
      _selected.add(false);
    }
  }

  void check(index, code, result,context){

     if(code.toString()==result.toString() && _selected[index]==false){
    _selected[index] = true;
    notifyListeners();
    showDialog(context: context, builder: (context){
    return const MySimpleDialog(title: "Success", msg: "Item Scanned.",
    icon:FeatherIcons.checkCircle,);
    });
    }
     else if(_selected[index]==true){
       showDialog(context: context, builder: (context){
         return const MySimpleDialog(title: "Error", msg: "Item Already Scanned",
           icon:FeatherIcons.alertTriangle,);
       });
     }
     else if(code.toString()!=result.toString()){
      _selected[index] = false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Error", msg: "Incorrect Scan Code.",
          icon:FeatherIcons.alertTriangle,);
      });
    }

    else {
      _selected[index] = false;
      notifyListeners();
    }
  }

  List<bool> _selected2 = [];
  List<bool> get selected2 => _selected2;

  setDQr(){
    _selected2.clear();
    dropOverrideController.text="";
    notifyListeners();
  }

  addSelected2(List itemLength){
    for (int i = 0; i < itemLength.length; i++) {
      _selected2.add(false);
    }
  }

  void check2(index, code, result,context){

    if(code.toString()==result.toString() && _selected2[index]==false){
      _selected2[index] = true;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Item Scanned.",
          icon:FeatherIcons.checkCircle,);
      });
    }
    else if(_selected2[index]==true){
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Error", msg: "Item Already Scanned",
          icon:FeatherIcons.alertTriangle,);
      });
    }
    else if(code.toString()!=result.toString()){
      _selected2[index] = false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Error", msg: "Incorrect Scan Code.",
          icon:FeatherIcons.alertTriangle,);
      });
    }

    else {
      _selected2[index] = false;
      notifyListeners();
    }
  }


  pOnChanged(value){
    selectedPReason = value;
    notifyListeners();
  }

  bool _change = false;
  bool get change => _change;
  changeOrientation(){
    _change = !_change;
    notifyListeners();
    if(_change){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
    else{
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

  }

  bool _agreeP = false;
  bool get agreeP => _agreeP;

  void agreeCheck(bool? value) async {
    _agreeP = value!;
    notifyListeners();
  }

  TextEditingController waitingDH = TextEditingController();
  TextEditingController waitingDM = TextEditingController();
  List dReason = ["None","Customer Not Ready","Wrong Details Given e.g. Name, Address, Contact Details."];
  var selectedDReason;

  dOnChanged(value){
    selectedDReason = value;
    notifyListeners();
  }

  bool _agreeD = false;
  bool get agreeD => _agreeD;

  void agreeCheckD(bool? value) async {
    _agreeD = value!;
    notifyListeners();
  }

  TextEditingController passController = TextEditingController();
  TextEditingController overrideController = TextEditingController();
  bool _unblock = false;
  bool get unblock => _unblock;

  clearOne(){
    passController.text="";
    overrideController.text="";
    _unblock = false;
    notifyListeners();
  }

  checkPickPass(context,AdvertiseModel advertiseModel){
    overrideController.text="";
    notifyListeners();
    if(passController.text.toString()!=advertiseModel.pickPassword.toString()){
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Incorrect Password", msg: "Please Try Again Or Contact Your Service Provider For An Override Code.",
          icon:FeatherIcons.alertTriangle,);
      });

    }
    else{
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Password Correct",
          icon:FeatherIcons.checkCircle,);
      });
      completePickUp(advertiseModel,context);
    }
  }

  checkPickOverPass(context,AdvertiseModel advertiseModel){
    passController.text="";
    notifyListeners();
    if(overrideController.text.toString()!=advertiseModel.pickOverride.toString()){
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Incorrect Password", msg: "Please Try Again Or Contact Your Service Provider For Correct Password.",
          icon:FeatherIcons.alertTriangle,);
      });
    }
    else{
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Password Correct",
          icon:FeatherIcons.checkCircle,);
      });
      completePickUp(advertiseModel,context);
    }
  }

  completePickUp(AdvertiseModel advertiseModel,context) async{
    Future.delayed(const Duration(seconds: 1),(){
      AppRoutes.push(context, PageTransitionType.fade,
          PTodoReason(advertiseModel: advertiseModel));
    });
  }

  void updatePickReason(id,BuildContext context,advertiseModel) async{
    await firebaseFireStore.collection("jobs").doc(id).update({
      "waitingReason" : selectedPReason.toString()=="null"?"":selectedPReason.toString(),
      "waitingTime":waitingPH.text==""? "":"${waitingPH.text.toString()} h:${waitingPM.text.toString()} min",
      "isPicked":true,
      "actualPickDate":DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
      "actualPickTime":TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute).format(context).toString(),
    }).then((value) {
      _showPick = false;
      _showDrop = true;
      _isArrived=false;
      notifyListeners();
      ApiService().sendCompanyNotification("pickUp", "Job No# ${advertiseModel.jobNo} Picked Up Has Been Successful", advertiseModel.companyId.toString());
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Picked Up Has Been Successful",
          icon:FeatherIcons.checkCircle,);
      });
      Future.delayed(const Duration(seconds: 1),(){
        AppRoutes.push(context, PageTransitionType.rightToLeft, JobFullDetails(advertiseModel: advertiseModel,from: true));
      });
    });
  }

  void updateDropReason(id,BuildContext context,AdvertiseModel advertiseModel) async{
    await firebaseFireStore.collection("jobs").doc(id).update({
      "waitingReasonDrop" : selectedDReason.toString()=="null"?"":selectedDReason.toString(),
      "waitingTimeDrop":waitingDH.text==""? "":"${waitingDH.text.toString()} h:${waitingDM.text.toString()} min",
      "isDropped":true,
      "actualDropDate":DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
      "actualDropTime":TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute).format(context).toString(),
    }).then((value) {
      _showPick = false;
      _showDrop = false;
      _isArrived=false;
      notifyListeners();
      ApiService().sendCompanyNotification("dropOff", "Job No# ${advertiseModel.jobNo} Drop Off Has Been Successful", advertiseModel.companyId.toString());
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Drop Off Has Been Successful",
          icon:FeatherIcons.checkCircle,);
      });
      Future.delayed(const Duration(seconds: 1),(){
        AppRoutes.push(context, PageTransitionType.fade, CustomerSignature(advertiseModel:advertiseModel));
      });

    });
  }

  TextEditingController dropPassController = TextEditingController();
  TextEditingController dropOverrideController = TextEditingController();

  bool _unblock2 = false;
  bool get unblock2 => _unblock2;

  clearTwo(){
    dropPassController.text="";
    dropOverrideController.text="";
    _unblock2 = false;
    notifyListeners();
  }

  checkDropPass(context,AdvertiseModel advertiseModel){
    dropOverrideController.text="";
    notifyListeners();

    if(dropPassController.text.toString()!=advertiseModel.dropPassword.toString()){
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Incorrect Password", msg: "Please Try Again Or Contact Your Service Provider For An Override Code.",
          icon:FeatherIcons.alertTriangle,);
      });

    }
    else{
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Password Correct",
          icon:FeatherIcons.checkCircle,);
      });
      completeDropOff(advertiseModel,context);
    }
  }

  checkDropOverPass(context,AdvertiseModel advertiseModel){
    dropPassController.text="";
    notifyListeners();
    if(dropOverrideController.text.toString()!=advertiseModel.dropOverride.toString()){
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Incorrect Password", msg: "Please Try Again Or Contact Your Service Provider For Correct Password.",
          icon:FeatherIcons.alertTriangle,);
      });
    }
    else{
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Password Correct",
          icon:FeatherIcons.checkCircle,);
      });
      completeDropOff(advertiseModel,context);
    }
  }

  completeDropOff(AdvertiseModel advertiseModel,context) async{
    Future.delayed(const Duration(seconds: 1),(){
      AppRoutes.push(context, PageTransitionType.fade,
          DTodoReason(advertiseModel: advertiseModel));
    });

  }

  bool _showPick = true;
  bool get showPick => _showPick;

  bool _showDrop = false;
  bool get showDrop => _showDrop;

  bool _isArrived = false;
  bool get isArrived => _isArrived;

  setArrived(bool value){
    _isArrived=value;
    notifyListeners();
  }

  setPick(bool value){
    _showPick = value;
    _showDrop = false;
    _isArrived=false;
    Future.delayed(
      const Duration(seconds: 1),
          () => key.currentState!.reset(),
    );
    notifyListeners();
  }

  setDrop(bool value){
    _showDrop = value;
    _showPick = false;
    _isArrived=false;
    Future.delayed(
      const Duration(seconds: 1),
          () => key.currentState!.reset(),
    );
    notifyListeners();
  }

  resetValues(showDrop,showPick,isArrived){
    log("HERE");
    _showDrop = showDrop;
    _showPick = showPick;
    _isArrived=isArrived;

    notifyListeners();
  }

  removeValues(){
    log("HERE");
    customerPic = null;
    selectedLocation = null;
    recipientController.text="";
    locationController.text="";
    selectedDReason = null;
    reasonController.text="";
    selectedPReason = null;
    waitingDH.text="";
    waitingDM.text="";
    waitingPH.text="";
    waitingPM.text="";
    pickImage = null;
    dropImage = null;
    _agreeD = false;
    _agreeP = false;
    notifyListeners();
  }

  File? pickImage;


  Future imagePickerMethodPick(context,ImageSource src) async {
    final pick = await ImagePicker.platform.pickImage(
      source: src,
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
        checkFileSizePick(croppedFile.path,context);
      }
    } else {}
  }

  checkFileSizePick(path,context) {
    var fileSizeLimit = 1024;
    File f = File(path);
    var s = f.lengthSync();
    var fileSizeInKB = s / 1024;
    if (fileSizeInKB > fileSizeLimit) {
      ToastUtils.warningToast("Image size should be less than 1 MB", context);
      return false;
    } else {
      pickImage = File(path);
      notifyListeners();
      AppRoutes.pop(context);
      return true;
    }
  }

  Future<String> uploadFilePick(jobID) async {
    String imageUrl = '';
    try {
      UploadTask uploadTask;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('jobs')
          .child('/$jobID/pickImage');
      uploadTask = ref.putFile(pickImage!);
      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      log(e.toString());
    }
    return imageUrl;
  }

  Future updatePickImage(context,AdvertiseModel advertiseModel) async {
    _isUpdating = true;
    notifyListeners();

    uploadFilePick(advertiseModel.jobId.toString()).then((imageUrl) async{
      await firebaseFireStore.collection("jobs").doc(advertiseModel.jobId.toString()).update({
        "pickImage":imageUrl.toString()
      }).then((value) {
        showDialog(context: context, builder: (context){
          return const MySimpleDialog(title: "Success", msg: "Photo Proof Uploaded",
            icon:FeatherIcons.checkCircle,);
        });
        _isUpdating=false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 1),(){
          AppRoutes.push(context, PageTransitionType.fade,
              PTodoReason(advertiseModel: advertiseModel));
        });
      }).catchError((e){
        _isUpdating=false;
        notifyListeners();
        showDialog(context: context, builder: (context){
          return MySimpleDialog(title: "Error", msg: e.toString(),
            icon:FeatherIcons.alertTriangle,);
        });
      });
    }).catchError((e) {
      _isUpdating=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: e.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
    });
  }

  File? dropImage;

  Future imagePickerMethodDrop(context,ImageSource src) async {
    final pick = await ImagePicker.platform.pickImage(
      source: src,
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
        checkFileSizeDrop(croppedFile.path,context);
      }
    } else {}
  }

  checkFileSizeDrop(path,context) {
    var fileSizeLimit = 1024;
    File f = File(path);
    var s = f.lengthSync();
    var fileSizeInKB = s / 1024;
    if (fileSizeInKB > fileSizeLimit) {
      ToastUtils.warningToast("Image size should be less than 1 MB", context);
      return false;
    } else {
      dropImage = File(path);
      notifyListeners();
      AppRoutes.pop(context);
      return true;
    }
  }

  Future<String> uploadFileDrop(jobID) async {
    String imageUrl = '';
    try {
      UploadTask uploadTask;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('jobs')
          .child('/$jobID/dropImage');
      uploadTask = ref.putFile(dropImage!);
      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      log(e.toString());
    }
    return imageUrl;
  }

  Future updateDropImage(context,AdvertiseModel advertiseModel) async {
    _isUpdating = true;
    notifyListeners();

    uploadFileDrop(advertiseModel.jobId.toString()).then((imageUrl) async{
      await firebaseFireStore.collection("jobs").doc(advertiseModel.jobId.toString()).update({
        "dropImage":imageUrl.toString()
      }).then((value) {
        showDialog(context: context, builder: (context){
          return const MySimpleDialog(title: "Success", msg: "Photo Proof Uploaded",
            icon:FeatherIcons.checkCircle,);
        });
        _isUpdating=false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 1),(){
          AppRoutes.push(context, PageTransitionType.fade,
              DTodoReason(advertiseModel: advertiseModel));

        });
      }).catchError((e){
        _isUpdating=false;
        notifyListeners();
        showDialog(context: context, builder: (context){
          return MySimpleDialog(title: "Error", msg: e.toString(),
            icon:FeatherIcons.alertTriangle,);
        });
      });
    }).catchError((e) {
      _isUpdating=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: e.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
    });
  }

  bool _isCancel = false;
  bool get isCancel => _isCancel;

  cancelJob(BuildContext context, AdvertiseModel model) async{
    _isCancel=true;
    notifyListeners();
    AdvertiseModel advertiseModel = AdvertiseModel(
        currency: model.currency,
        price: model.price,
        jobId: model.jobId,
        dropAddress: model.dropAddress,
        dropDate: model.dropDate,
        dropTime: model.dropTime,
        pickAddress: model.pickAddress,
        pickTime: model.pickTime,
        pickDate: model.pickDate,
        dropContact: model.dropContact,
        dropCustomer: model.dropCustomer,
        dropInstructions: model.dropInstructions,
        dropManifest: model.dropManifest,
        dropOverride: model.dropOverride,
        dropPassword: model.dropPassword,
        dropSecurity: model.dropSecurity,
        isAdult: model.isAdult,
        paymentType: model.paymentType,
        pickContact: model.pickContact,
        pickCustomer: model.pickCustomer,
        pickInstructions: model.pickInstructions,
        pickManifest: model.pickManifest,
        pickOverride: model.pickOverride,
        pickPassword: model.pickPassword,
        pickSecurity: model.pickSecurity,
        vehicleID: model.vehicleID,
        vehicleRequired: model.vehicleRequired,
        pickLatitude: model.pickLatitude,
        pickLongitude: model.pickLongitude,
        companyName: model.companyName,
        companyLogo: model.companyLogo,
        companyId: model.companyId,
        companyAddress: model.companyAddress,
        dropEmail: model.dropEmail,
        pickEmail: model.pickEmail,
        assignedTo: "",
        cancelledBy: Globals.uid.toString(),
        completedBy: model.completedBy,
        customerSignature: model.customerSignature,
        isCancel: true,
        isComplete: model.isComplete,
        jobNo: model.jobNo,
        rejectedBy: model.rejectedBy,
        vehicleType: model.vehicleType,
        waitingReason: model.waitingReason,
        waitingTime: model.waitingReason,
        dropLatitude: model.dropLatitude,
        dropLongitude: model.dropLongitude,
        barCodes: model.barCodes,
        barCodes2: model.barCodes2,
        driverName: model.driverName,
        driverCourier: model.driverCourier,
        driverImage: model.driverImage,
        cancellationReason: reasonController.text.toString(),
        cancelledTime: DateTime.now().millisecondsSinceEpoch.toString(),
        isDropped: model.isDropped,
        isPicked: model.isPicked,
        isAdvertised: false,
        actualPickTime: model.actualPickTime,
        actualPickDate: model.actualPickDate,
        actualDropTime: model.actualDropTime,
        actualDropDate: model.actualDropDate
    );

    await firebaseFireStore.collection("drivers").doc(Globals.uid).collection("cancelledJobs").doc().set(advertiseModel.toMap()).then((value) {

       firebaseFireStore.collection("jobs").doc(advertiseModel.jobId).update({
         "isCancel":true,
         "cancellationReason":reasonController.text.toString(),
         "cancelledBy":Globals.uid.toString(),
         "assignedTo":"",
         "cancelledTime":DateTime.now().millisecondsSinceEpoch.toString(),
         "isAdvertised":false
       });
      ApiService().sendCompanyNotification("jobCancelled", "Job No# ${advertiseModel.jobNo} Has Been Cancelled By ${advertiseModel.driverCourier}", advertiseModel.companyId.toString());
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Your Job Has Been Cancelled.",
          icon:FeatherIcons.checkCircle,);
      });
       _isCancel=false;
       notifyListeners();
      AppRoutes.pushAndRemoveUntil(context,const Dashboard());
    }).catchError((e){
      _isCancel=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: e.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
    });
  }

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  Future<String> uploadFile(jobID, Uint8List image) async {
    String imageUrl = '';
    try {
      UploadTask uploadTask;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('customerSignatures')
          .child('/$jobID');
      uploadTask = ref.putData(image);
      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      log(e.toString());
    }
    return imageUrl;
  }

  Future updateSignature(context,Uint8List bytes,AdvertiseModel advertiseModel) async {
    _isUpdating = true;
    notifyListeners();

    uploadFile(advertiseModel.jobId.toString(),bytes).then((imageUrl) async{
      await firebaseFireStore.collection("jobs").doc(advertiseModel.jobId.toString()).update({
        "customerSignature":imageUrl.toString()
      }).then((value) {
        showDialog(context: context, builder: (context){
          return const MySimpleDialog(title: "Success", msg: "Customer Signature Updated",
            icon:FeatherIcons.checkCircle,);
        });
        _isUpdating=false;
        notifyListeners();
        Future.delayed(const Duration(seconds: 1),(){
          AppRoutes.push(context, PageTransitionType.fade,PODScreen(advertiseModel: advertiseModel));
        });
      }).catchError((e){
        _isUpdating=false;
        notifyListeners();
        showDialog(context: context, builder: (context){
          return MySimpleDialog(title: "Error", msg: e.toString(),
            icon:FeatherIcons.alertTriangle,);
        });
      });
    }).catchError((e) {
      _isUpdating=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: e.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
    });
  }

  TextEditingController recipientController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  File? customerPic;

  List<String> items = ["Recipient / Receiver","Front Door","Goods In"," Reception Desk"," Other (Please Specify)"];
  var selectedLocation;
  final formKey = GlobalKey<FormState>();

  changeLocation(value){
    selectedLocation = value;

    notifyListeners();
  }

  Future imagePickerMethod(context,ImageSource src) async {
    final pick = await ImagePicker.platform.pickImage(
      source: src,
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

  checkFileSize(path,context) {
    var fileSizeLimit = 1024;
    File f = File(path);
    var s = f.lengthSync();
    var fileSizeInKB = s / 1024;
    if (fileSizeInKB > fileSizeLimit) {
      ToastUtils.warningToast("Image size should be less than 1 MB", context);
      return false;
    } else {
      customerPic = File(path);
      notifyListeners();
      AppRoutes.pop(context);
      return true;
    }
  }

  bool _calculated = false;
  bool get calculated => _calculated;

  bool _showCancel = false;
  bool get showCancel => _showCancel;

  final formKey2 = GlobalKey<FormState>();
  calculateAge(context){
   result.text= userAge(DateTime.now(),DateTime(int.parse(year.text), int.parse(month.text), int.parse(day.text)));


   // if(int.parse(result.text.toString().replaceAll(" Years", "").toString())<18){
   //   showDialog(context: context, builder: (context){
   //     return const MySimpleDialog(title: "Error", msg: "Customer Is Not An Adult, Cannot Complete Job.",
   //       icon:FeatherIcons.alertTriangle,);
   //   });
   //   _calculated = false;
   //   _showCancel = true;
   // }
   // else{
   //   _calculated = true;
   //   _showCancel = false;
   // }
   _calculated = true;
   notifyListeners();
  }

  resetAge(){
    result.text="";
    day.text="";
    month.text="";
    year.text="";
    _calculated = false;
    notifyListeners();
  }

  updateAge(context, AdvertiseModel advertiseModel) async{
    _isUpdating = true;
    notifyListeners();

    await firebaseFireStore.collection("jobs").doc(advertiseModel.jobId.toString()).update({
      "customerAge":result.text.toString()
    }).then((value) {
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Customer Age Has Been Recorded",
          icon:FeatherIcons.checkCircle,);
      });
      _isUpdating=false;
      result.text="";
      day.text="";
      month.text="";
      year.text="";
      _calculated = false;
      notifyListeners();

      Future.delayed(const Duration(seconds: 1),(){
        if(advertiseModel.dropSecurity.toString()=="Password"){
          context.read<JobsTodoProvider>().clearTwo();
          AppRoutes.push(context, PageTransitionType.fade,
              TodoDropPasswordScreen(advertiseModel: advertiseModel));

        }
        else if(advertiseModel.dropSecurity.toString()=="Qr code & bar code"){
          AppRoutes.push(context, PageTransitionType.fade,
              TodoDropQrScanner(advertiseModel: advertiseModel));
        }
        else if(advertiseModel.dropSecurity.toString()=="Drop Off Image"){
          AppRoutes.push(context, PageTransitionType.fade,
              ImageSenderDrop(advertiseModel: advertiseModel,));
        }
        else{
          AppRoutes.push(context, PageTransitionType.fade,
              DTodoReason(advertiseModel: advertiseModel));
        }
      });
    }).catchError((e){
      _isUpdating=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: e.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
    });

  }

  bool _isComplete = false;
  bool get isComplete => _isComplete;

  getDataOfJob(context,AdvertiseModel model) async{
    _isComplete=true;
    notifyListeners();
    await firebaseFireStore.collection('jobs').where("jobId",isEqualTo: model.jobId.toString())
        .get().then((value) {
      for (var element in value.docs) {
        AdvertiseModel advertiseModel =AdvertiseModel.fromMap(element.data());
        notifyListeners();
        savePDF(context,advertiseModel);
      }
    });
  }

  void savePDF(context,AdvertiseModel advertiseModel) async {
    final bytes = await generatePdf(advertiseModel);
    Future.delayed(const Duration(seconds: 1),(){
      upload(bytes,advertiseModel,context);
    });
  }

  Future<String> uploadFile2(Uint8List pdfFile) async {
    String imageUrl = '';
    try {
      UploadTask uploadTask;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('companies')
          .child('pods')
          .child('/${DateTime.now().millisecondsSinceEpoch}');
      uploadTask = ref.putData(pdfFile,SettableMetadata(contentType: 'pdf'));
      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      log(e.toString());
    }
    return imageUrl;
  }

  void upload(invoiceFile,AdvertiseModel advertiseModel,context) async{
    uploadFile2(invoiceFile).then((value) {
      firebaseFireStore.collection("uploadedPODs").doc(advertiseModel.jobId.toString()).set({
        "path":value.toString(),
        "companyID": advertiseModel.companyId.toString(),
        "podId":advertiseModel.jobId.toString(),
        "podDate":DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
        "podTime":DateFormat("hh:mm a").format(DateTime.now()).toString(),
        "jobID":advertiseModel.jobNo.toString()});
    }).then((value) {
      completeJob(context,advertiseModel);
    }).catchError((e){
      _isComplete=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: e.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
    });
  }

  Future<Uint8List> generatePdf(AdvertiseModel advertiseModel) async {
    var pickedImage;
    var droppedImage;
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.poppinsMedium();
    final font2 = await PdfGoogleFonts.poppinsBold();
    final font3 = await PdfGoogleFonts.poppinsSemiBold();
    if(advertiseModel.pickImage.toString()!=""){
      pickedImage = await networkImage(advertiseModel.pickImage.toString());
    }
    if(advertiseModel.dropImage.toString()!=""){
      droppedImage = await networkImage(advertiseModel.dropImage.toString());
    }
    final customerSignature = await networkImage(advertiseModel.customerSignature.toString());

    pdf.addPage(
      pw.Page(
        margin:const pw.EdgeInsets.only(top: 20,left: 30,right: 30),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text("E-POD",
                style: pw.TextStyle(
                    fontSize: 12,
                    font: font2,
                    fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                ),
              ),
              pw.Text("Electronic Proof Of Delivery".toUpperCase(),
                style: pw.TextStyle(
                    fontSize: 12,
                    font: font2,
                    fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("JOB NO#:",
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font3,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        width: 100,
                        decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(5),
                            color: PdfColor.fromHex("#FFFFFF"),
                            border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                        ),
                        child: pw.Center(
                          child:pw.Text(advertiseModel.jobNo.toString(),
                            style: pw.TextStyle(
                                fontSize: 8.5,
                                font: font,
                                fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Courier ID:".toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font3,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        width: 100,
                        decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(5),
                            color: PdfColor.fromHex("#FFFFFF"),
                            border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                        ),
                        child: pw.Center(
                          child:pw.Text(advertiseModel.driverCourier.toString(),
                            style: pw.TextStyle(
                                fontSize: 8.5,
                                font: font,
                                fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Courier Name:".toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font3,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        width: 100,
                        decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(5),
                            color: PdfColor.fromHex("#FFFFFF"),
                            border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                        ),
                        child: pw.Center(
                          child:pw.Text(advertiseModel.driverName.toString(),
                            style: pw.TextStyle(
                                fontSize: 8.5,
                                font: font,
                                fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Column(
                children: [
                  pw.Text("service provider full address: ".toUpperCase(),
                    style: pw.TextStyle(
                        fontSize: 8.5,
                        font: font3,
                        fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Container(
                    height: 60,
                    padding: const pw.EdgeInsets.only(left: 5,top: 5),
                    decoration: pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.circular(5),
                        color: PdfColor.fromHex("#FFFFFF"),
                        border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                    ),
                    child: pw.Text(advertiseModel.companyAddress.toString(),
                      style: pw.TextStyle(
                          fontSize: 8.5,
                          font: font,
                          fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                      ),

                    ),
                  )

                ],
              ),
              pw.SizedBox(height: 10),
              pw.Column(
                children: [
                  pw.Text("service provider contact no# ".toUpperCase(),
                    style: pw.TextStyle(
                        fontSize: 8.5,
                        font: font3,
                        fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Container(
                    height: 25,
                    width: 150,
                    padding:const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                        borderRadius: pw.BorderRadius.circular(5),
                        color: PdfColor.fromHex("#FFFFFF"),
                        border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                    ),
                    child: pw.Text(advertiseModel.companyContact.toString(),
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                        textAlign: pw.TextAlign.center

                    ),
                  )

                ],
              ),
              pw.SizedBox(height: 5),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 5),
              //// ------- PICK UP DETAILS -------  ////
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("actual pick up date: ".toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font3,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        width: 100,
                        decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(5),
                            color: PdfColor.fromHex("#FFFFFF"),
                            border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                        ),
                        child: pw.Center(
                          child:pw.Text(advertiseModel.actualPickDate.toString(),
                            style: pw.TextStyle(
                                fontSize: 8.5,
                                font: font,
                                fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("actual picked up time: ".toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font3,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        width: 100,
                        decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(5),
                            color: PdfColor.fromHex("#FFFFFF"),
                            border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                        ),
                        child: pw.Center(
                          child:pw.Text(advertiseModel.actualPickTime.toString(),
                            style: pw.TextStyle(
                                fontSize: 8.5,
                                font: font,
                                fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Waiting time: ".toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font3,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        width: 100,
                        decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(5),
                            color: PdfColor.fromHex("#FFFFFF"),
                            border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                        ),
                        child: pw.Center(
                          child:pw.Text(advertiseModel.waitingTime.toString(),
                            style: pw.TextStyle(
                                fontSize: 8.5,
                                font: font,
                                fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Reason on Pickup: ".toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font3,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        width: 100,
                        decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(5),
                            color: PdfColor.fromHex("#FFFFFF"),
                            border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                        ),
                        child: pw.Center(
                          child:pw.Text(advertiseModel.waitingReason.toString(),
                            style: pw.TextStyle(
                                fontSize: 8.5,
                                font: font,
                                fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Pick up customer full name:".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              height: 25,
                              width: 150,
                              decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(5),
                                  color: PdfColor.fromHex("#FFFFFF"),
                                  border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                              ),
                              child: pw.Center(
                                child:pw.Text(advertiseModel.pickCustomer.toString(),
                                  style: pw.TextStyle(
                                      fontSize: 8.5,
                                      font: font,
                                      fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("pick up customer contact no# ".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              height: 25,
                              width: 150,
                              decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(5),
                                  color: PdfColor.fromHex("#FFFFFF"),
                                  border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                              ),
                              child: pw.Center(
                                child:pw.Text(advertiseModel.pickContact.toString(),
                                  style: pw.TextStyle(
                                      fontSize: 8.5,
                                      font: font,
                                      fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Pick up full business / home address:".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              height: 50,
                              width: 150,
                              padding: const pw.EdgeInsets.only(left: 5,top: 5),
                              decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(5),
                                  color: PdfColor.fromHex("#FFFFFF"),
                                  border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                              ),
                              child:pw.Text(advertiseModel.pickAddress.toString(),
                                style: pw.TextStyle(
                                    fontSize: 8.5,
                                    font: font,
                                    fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                                ),
                              ),
                            )

                          ],
                        ),
                      ]
                  ),
                  pw.SizedBox(width: 20),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text("photo proof of pick up if applicable :".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                                width: 180,
                                height: 80,
                                padding: const pw.EdgeInsets.all(5),
                                decoration: pw.BoxDecoration(
                                    borderRadius: pw.BorderRadius.circular(5),
                                    color: PdfColor.fromHex("#FFFFFF"),
                                    border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                                ),
                                child: advertiseModel.pickImage.toString()!=""?
                                pw.Center(child: pw.Image(pickedImage)
                                ):pw.SizedBox()
                            )

                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("manifest: ".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              height: 50,
                              width: 260,
                              decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(5),
                                  color: PdfColor.fromHex("#FFFFFF"),
                                  border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                              ),
                              child: pw.Center(
                                child:pw.Text(advertiseModel.pickManifest.toString(),
                                  style: pw.TextStyle(
                                      fontSize: 8.5,
                                      font: font,
                                      fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ]
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 5),
              //// ------- DROP OFF DETAILS -------  ////
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("actual drop off date: ".toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font3,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        width: 100,
                        decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(5),
                            color: PdfColor.fromHex("#FFFFFF"),
                            border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                        ),
                        child: pw.Center(
                          child:pw.Text(advertiseModel.actualDropDate.toString(),
                            style: pw.TextStyle(
                                fontSize: 8.5,
                                font: font,
                                fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("actual drop off time: ".toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font3,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        width: 100,
                        decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(5),
                            color: PdfColor.fromHex("#FFFFFF"),
                            border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                        ),
                        child: pw.Center(
                          child:pw.Text(advertiseModel.actualDropTime.toString(),
                            style: pw.TextStyle(
                                fontSize: 8.5,
                                font: font,
                                fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Waiting time: ".toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font3,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        width: 100,
                        decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(5),
                            color: PdfColor.fromHex("#FFFFFF"),
                            border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                        ),
                        child: pw.Center(
                          child:pw.Text(advertiseModel.waitingTimeDrop.toString(),
                            style: pw.TextStyle(
                                fontSize: 8.5,
                                font: font,
                                fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Reason on Drop-off: ".toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 8.5,
                            font: font3,
                            fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        height: 25,
                        width: 100,
                        decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(5),
                            color: PdfColor.fromHex("#FFFFFF"),
                            border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                        ),
                        child: pw.Center(
                          child:pw.Text(advertiseModel.waitingReasonDrop.toString(),
                            style: pw.TextStyle(
                                fontSize: 8.5,
                                font: font,
                                fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Drop off customer full name:".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              height: 25,
                              width: 150,
                              decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(5),
                                  color: PdfColor.fromHex("#FFFFFF"),
                                  border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                              ),
                              child: pw.Center(
                                child:pw.Text(advertiseModel.dropCustomer.toString(),
                                  style: pw.TextStyle(
                                      fontSize: 8.5,
                                      font: font,
                                      fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Drop off customer contact no# ".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              height: 25,
                              width: 150,
                              decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(5),
                                  color: PdfColor.fromHex("#FFFFFF"),
                                  border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                              ),
                              child: pw.Center(
                                child:pw.Text(advertiseModel.dropContact.toString(),
                                  style: pw.TextStyle(
                                      fontSize: 8.5,
                                      font: font,
                                      fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Drop Off full business / home address:".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              height: 50,
                              width: 150,
                              padding: const pw.EdgeInsets.only(left: 5,top: 5),
                              decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(5),
                                  color: PdfColor.fromHex("#FFFFFF"),
                                  border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                              ),
                              child:pw.Text(advertiseModel.dropAddress.toString(),
                                style: pw.TextStyle(
                                    fontSize: 8.5,
                                    font: font,
                                    fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                                ),
                              ),
                            )

                          ],
                        ),
                      ]
                  ),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("delivered to recipient name : ".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              height: 25,
                              width: 150,
                              decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(5),
                                  color: PdfColor.fromHex("#FFFFFF"),
                                  border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                              ),
                              child: pw.Center(
                                child:pw.Text(recipientController.text.toString(),
                                  style: pw.TextStyle(
                                      fontSize: 8.5,
                                      font: font,
                                      fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("photo proof of Drop Off if applicable :".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                                width: 150,
                                height: 80,
                                padding: const pw.EdgeInsets.all(5),
                                decoration: pw.BoxDecoration(
                                    borderRadius: pw.BorderRadius.circular(5),
                                    color: PdfColor.fromHex("#FFFFFF"),
                                    border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                                ),
                                child:advertiseModel.dropImage.toString()!=""?
                                pw.Center(child:  pw.Image(droppedImage)
                                ):pw.SizedBox()
                            )

                          ],
                        ),


                      ]
                  ),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("signature of drop off: ".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                                height: 70,
                                width: 150,
                                decoration: pw.BoxDecoration(
                                    borderRadius: pw.BorderRadius.circular(5),
                                    color: PdfColor.fromHex("#FFFFFF"),
                                    border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                                ),
                                child:pw.Center(
                                    child: pw.Image(customerSignature)
                                )
                            )

                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("delivery location :".toUpperCase(),
                              style: pw.TextStyle(
                                  fontSize: 8.5,
                                  font: font3,
                                  fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Container(
                              height: 25,
                              width: 150,
                              decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(5),
                                  color: PdfColor.fromHex("#FFFFFF"),
                                  border: pw.Border.all(color: PdfColor.fromHex("#6C6A6A"))
                              ),
                              child: pw.Center(
                                child:pw.Text(selectedLocation.toString().trim()=="Other (Please Specify)"?locationController.text.toString():selectedLocation.toString(),
                                  style: pw.TextStyle(
                                      fontSize: 8.5,
                                      font: font,
                                      fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ]
                  ),

                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text("the e -pod (electronic proof of delivery) is confirmation to confirm your delivery was successfully carried out, according to your instructions provided.".toUpperCase(),
                  style: pw.TextStyle(
                      fontSize: 8.5,
                      font: font2,
                      fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#2A2A2A")
                  ),
                  textAlign: pw.TextAlign.center
              ),

            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  completeJob(BuildContext context,AdvertiseModel advertiseModel) async{
    await firebaseFireStore.collection("jobs").doc(advertiseModel.jobId.toString()).update({
      "isComplete": true,
      "completedBy": Globals.uid.toString(),
      "assignedTo":"",
      "isAdvertised":false
    }).then((value) {
      addToDriverComplete(context,advertiseModel);
    }).catchError((e){
      _isComplete=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: e.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
    });
  }

  addToDriverComplete(BuildContext context,AdvertiseModel advertiseModel) async{
    await firebaseFireStore.collection('drivers').doc(Globals.uid).collection("completedJobs").doc(advertiseModel.jobId.toString()).set(advertiseModel.toMap()).then((value) {
      ApiService().sendCompanyNotification("delivered", "Job No# ${advertiseModel.jobNo} Delivery Is Completed.", advertiseModel.companyId.toString());
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Delivery Is Complete. Please Handover Goods Successfully.",
          icon:FeatherIcons.checkCircle,);
      });
      _isComplete=false;
      notifyListeners();
      Future.delayed(const Duration(seconds: 1),(){
        AppRoutes.pushAndRemoveUntil(context, const Dashboard());
      });
    }).catchError((e){
      _isComplete=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: e.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
    });
  }


}