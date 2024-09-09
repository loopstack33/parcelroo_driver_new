// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parcelroo_driver_app/widgets/simple_dialog.dart';


class ForgetPassProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();

  final auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  reset(){
    emailController.text="";
    notifyListeners();
  }

  final formKey = GlobalKey<FormState>();
  static var errorMessage;

  Future<void> sendResetLink(context) async{
    _isLoading = true;
    notifyListeners();
    try {
     await auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
        showDialog(context: context, builder: (context){
          return const MySimpleDialog(title: "Success", msg: "A Password Reset Link Has Been Sent To  Your Email Please Check This Can Take A Few Minutes.",
            icon: FeatherIcons.checkCircle,);
        });
        _isLoading = false;
        notifyListeners();
      });
    }  on FirebaseAuthException catch (error) {
      _isLoading = false;
      notifyListeners();
        showDialog(context: context, builder: (context){
          return MySimpleDialog(title: "Error", msg: error.message.toString(),
            icon: FeatherIcons.alertTriangle,);
        });


    }

  }
}
