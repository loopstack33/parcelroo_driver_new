// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import '../../../enums/gobals.dart';
import '../../../utils/toasts.dart';
import '../../../widgets/simple_dialog.dart';

class UpdateBankProvider extends ChangeNotifier {
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  // String _bank = "Stripe";
  // String get bank => _bank;
  var bank;
  setBank(value){
    bank = value;
    notifyListeners();
  }

  TextEditingController accountHolderController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController accountCodeController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController internalEmailController = TextEditingController();
  TextEditingController reTypeInternalEmailController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void updateBankingInfo(context,iban,holderName,accNo,payEmail,paySystem,rollNo,sortCode) async{
    _isLoading=true;
    notifyListeners();
    await firebaseFireStore.collection("drivers").doc(Globals.uid).collection("bankInformation").doc(Globals.uid).update({
      "IBAN":iban.toString(),
      "accountHolderName":holderName.toString(),
      "accountNumber":accNo.toString(),
      "paymentEmail":payEmail.toString(),
      "societyRollNo":rollNo.toString(),
      "sortCode":sortCode.toString(),
      "paymentSystem":paySystem.toString()=="null"?"":paySystem.toString(),
    }).then((value) {
      accountHolderController.text=holderName;
      accountNoController.text=accNo;
      accountCodeController.text=iban;
      rollNoController.text=rollNo;
      ibanController.text=iban;
      internalEmailController.text=payEmail;
      reTypeInternalEmailController.text=payEmail;
      _isLoading=false;
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Your Banking Details Have Been Updated Successfully.",
          icon: FeatherIcons.checkCircle,);
      });

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

  void getBankingInfo(context) async{
    _isLoading=true;
    notifyListeners();
    await firebaseFireStore.collection("drivers").doc(Globals.uid).collection("bankInformation").doc(Globals.uid).get().then((value) {
      accountHolderController.text=value.data()!["accountHolderName"].toString();
      accountNoController.text=value.data()!["accountNumber"].toString();
      accountCodeController.text=value.data()!["sortCode"].toString();
      rollNoController.text=value.data()!["societyRollNo"].toString();
      ibanController.text=value.data()!["IBAN"].toString();
      internalEmailController.text=value.data()!["paymentEmail"].toString();
      reTypeInternalEmailController.text=value.data()!["paymentEmail"].toString();
      _isLoading=false;
      notifyListeners();
    }).catchError((e){
      _isLoading=false;
      notifyListeners();
      ToastUtils.failureToast(e.toString() , context);
    });
  }

}