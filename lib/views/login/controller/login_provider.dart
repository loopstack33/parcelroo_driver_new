import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';

import '../../../utils/app_routes.dart';
import '../../../utils/shared_pref.dart';
import '../../../utils/toasts.dart';
import '../../../widgets/simple_dialog.dart';
import '../../dashboard/dashboard.dart';
import '../../signUp/email_verification.dart';

class LoginProvider extends ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  bool _passwordVisible = true;
  bool get passwordVisible => _passwordVisible;
  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  togglePassword(){
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void handleRememberMe(bool? value) async {
    SharedPref.saveRememberMe(value!);

    if(value==true){
       SharedPref.saveEmail(emailController.text);
       SharedPref.saveUserPassword(passController.text);
    }
    _rememberMe = value;
    notifyListeners();
  }

  //DRIVER SIGN IN
  void signIn(BuildContext context, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final auth = FirebaseAuth.instance;

    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) {
        SharedPref.saveUserID(auth.currentUser!.uid.toString());
        SharedPref.saveEmail(email.toString());
        SharedPref.saveUserPassword(password.toString());
        SharedPref.saveIsLoggedIn(true);
        Globals.uid = auth.currentUser!.uid.toString();
        Globals.email = email.toString();
        Globals.pass = password.toString();

        if(auth.currentUser?.emailVerified==true){
          checkUserActive(context,auth.currentUser!.uid.toString());
        }
        else{
          sendEmailVerification(context,auth);
        }

      });
    } on FirebaseAuthException catch (error) {
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: error.message.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
      _isLoading = false;
      notifyListeners();
    }

  }

  Future checkUserActive(BuildContext context,uid) async {
    _isLoading=true;
    notifyListeners();
    await firebaseFireStore.collection('drivers').where("uid",isEqualTo: uid.toString()).limit(1)
        .get().then((value) {
      if(value.size>0){
        log("THIS USER IS ACTIVATED");
        ToastUtils.successToast("Login Successful!!" , context);
        AppRoutes.pushAndRemoveUntil(context, const Dashboard());
        _isLoading = false;
        notifyListeners();
      }
      else{
        checkActive(context,uid);
      }
    });
  }

  Future checkActive(BuildContext context,uid) async {

    await firebaseFireStore.collection('offBoard_drivers').where("uid",isEqualTo: uid.toString()).limit(1)
        .get().then((value) {
      if(value.size>0){
        log("THIS USER IS NOT ACTIVE");
        showDialog(context: context, builder: (context){
          return const MySimpleDialog(title: "Error", msg: "You Are Temporarily Banned By Super Admin. Contact support@parcelroo.co.uk For Further Details.",
            icon:FeatherIcons.alertTriangle,);
        });

        _isLoading = false;
        notifyListeners();
      }
      else{
        showDialog(context: context, builder: (context){
          return  const MySimpleDialog(
              title: "Alert",icon: FeatherIcons.alertTriangle,msg: "You Are Permanently Banned By Super Admin. Contact support@parcelroo.co.uk For Further Details.");
        });
        _isLoading = false;
        notifyListeners();
      }
    });
  }


  Future<void> sendEmailVerification(context,FirebaseAuth auth) async{
    try{
      _isLoading = false;
      notifyListeners();
      await auth.currentUser?.sendEmailVerification();
      ToastUtils.successToast("Verification Mail Sent To Given Email", context);
      AppRoutes.push(context, PageTransitionType.fade, const EmailVerification(from: false,));
    }
    on FirebaseAuthException catch (e){
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: e.message.toString(),
          icon:FeatherIcons.alertTriangle,);
      });
      _isLoading=false;
      notifyListeners();
    }
  }

  void loadUserEmailPassword(context) async {
    try {
      var username = await SharedPref.getEmail();
      var password = await SharedPref.getUserPassword();
      var rememberMe = await SharedPref.getRememberMe();

      if (rememberMe) {
        _rememberMe = true;
        emailController.text = username.toString();
        passController.text = password.toString();
        notifyListeners();
      } else {
        _rememberMe = false;
        emailController.text = username.toString();
        passController.text = password.toString();
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }

}