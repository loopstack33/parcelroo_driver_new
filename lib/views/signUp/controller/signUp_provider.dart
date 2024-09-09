// ignore_for_file: file_names, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_final_fields, prefer_const_constructors, body_might_complete_normally_catch_error

import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/models/driverVehicleModel.dart';
import 'package:parcelroo_driver_app/utils/toasts.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/utilities.dart';
import '../../../widgets/simple_dialog.dart';
import '../../login/login_screen.dart';
import '../email_verification.dart';

class SignUpProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController countryController2 = TextEditingController();
  TextEditingController zipController = TextEditingController();

  String _gender = "Male";
  String get gender => _gender;
  List genderItems = ["Male","Female","Other"];

  resetValues(){
    _loading = false;
    _gender = "Male";
    _country = Country.parse("GB");
    _country2 = Country.parse("GB");
    _currentStep = 0;
    bank = null;
    _agree = false;
    _selectedDate=DateTime.now();
    _confirmPasswordVisible = true;
    _passwordVisible = true;
    _vehicleData.clear();
    _selected =[];
    for (TextEditingController c in controllers) {
      c.clear();
      c.text='';

    }
    notifyListeners();
  }

  setGender(value){
    _gender = value;

    notifyListeners();
  }

  Country _country = Country.parse("GB");
  Country get country => _country;

  Country _country2 = Country.parse("GB");
  Country get country2 => _country2;

  int _currentStep = 0;
  int get currentStep => _currentStep;

  PageController pageController = PageController();
  changeIndex(value){
    _currentStep = value;
    log(_currentStep.toString());
    notifyListeners();
  }

  changeCountry(value){
    _country = value;
    notifyListeners();
  }
  changeCountry2(value){
    _country2 = value;
    notifyListeners();
  }

  bool _passwordVisible = true;
  bool get passwordVisible => _passwordVisible;

  togglePassword(){
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }


  bool _confirmPasswordVisible = true;
  bool get cnfrmPasswordVisible => _confirmPasswordVisible;

  toggleConfirmPassword(){
    _confirmPasswordVisible = !_confirmPasswordVisible;
    notifyListeners();
  }

  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController address3Controller = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

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

  bool _agree = false;
  bool get agree => _agree;

  void agreeCheck(bool? value) async {
    _agree = value!;
    notifyListeners();
  }

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      helpText: "SELECT TO DATE",
      fieldHintText: "YEAR/MONTH/DATE",
      fieldLabelText: "TO DATE",
      errorFormatText: "Enter a Valid Date",
      errorInvalidText: "Date Out of Range",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:  ColorScheme.light(
              primary: dashColor,
              onPrimary: whiteColor,
              onSurface: dashColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: whiteColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null && selected != selectedDate) {

        _selectedDate = selected;
        var diff = DateTime.now().difference(selectedDate).inDays;
        if (diff <= 6574.5) {
          showDialog(context: context, builder: (context){
            return const MySimpleDialog(title: "Error", msg: "You MUST be aged 18+ years and above to use this app",
              icon:FeatherIcons.alertTriangle,);
          });
        }  else {
          dobController.text =
              DateFormat('MM-dd-yyyy').format(selectedDate).toString();
        }
      notifyListeners();
    } else if (selected != null && selected == selectedDate) {

        _selectedDate = selected;
        var diff = DateTime.now().difference(selectedDate).inDays;

        if (diff <= 6574.5) {
          showDialog(context: context, builder: (context){
            return const MySimpleDialog(title: "Error", msg: "You MUST be aged 18+ years and above to use this app",
              icon:FeatherIcons.alertTriangle,);
          });}else {
          dobController.text =
              DateFormat('MM-dd-yyyy').format(selectedDate).toString();
        }
        notifyListeners();
    }
  }


  /// Password is valid if it has an uppercase, lowercase, number, symbol and has at least 8 characters
  bool isPasswordValid(String password) {
    final containsUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final containsLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final containsNumber = RegExp(r'\d').hasMatch(password);
    final containsSymbols = RegExp(r'[`~!@#$%\^&*\(\)_+\\\-={}\[\]\/.,<>;]').hasMatch(password);
  //  final hasManyCharacters = RegExp(r'^.{8,128}$', dotAll: true).hasMatch(password); // This is variable

    return containsUpperCase && containsLowerCase && containsNumber && containsSymbols;
  }

  bool _loading = false;
  bool get loading => _loading;
  final _auth = FirebaseAuth.instance;

  List<DriverVehicle> _vehicleData = [];
  List<DriverVehicle> get vehicleData => _vehicleData;

  List<TextEditingController> controllers = [];
  List<bool> _selected = [];
  List<bool> get selected => _selected;

  void addVehicle(index,cc,name,image,id,info,reg){
    _selected[index] = !_selected[index];
    notifyListeners();
    if(_selected[index]){
      _vehicleData.add(DriverVehicle(
          cc:cc ,
          image:image,
          name: name,
          reg:reg,
          id: id,
          info:info
      ));
    }
    else{
      _vehicleData.removeAt(index);
    }

  }

  void signUp(BuildContext context) async {

    _loading=true;
    notifyListeners();
    try {
      await _auth
          .createUserWithEmailAndPassword(email: emailController.text.toString(), password: passController.text.toString())
          .then((value) => {
           postDetailsToFireStore(context, _auth.currentUser!.uid),
      });
    } on FirebaseAuthException catch (error) {
      _loading=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: error.message.toString(),
          icon:FeatherIcons.alertTriangle,);
      });

    }
  }

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  final UniqueNumberGenerator generator = UniqueNumberGenerator();

  void postDetailsToFireStore(BuildContext context, id) async {
    log("IN POST");
    //var token = await FirebaseMessaging.instance.getToken();

    final int uniqueNumber = generator.generateUniqueNumber();
    await firebaseFireStore.collection("drivers").doc(id).set({
      'address1': address1Controller.text.toString(),
      'address2': address2Controller.text.toString(),
      'address3': address3Controller.text.toString(),
      'city': cityController.text.toString(),
      'contact': phoneController.text.toString(),
      'country': _country.name.toString(),
      'courierID': uniqueNumber.toString(),
      'zip/postal':zipController.text.toUpperCase().toString(),
      'deviceToken': "",
      'email': emailController.text.toString(),
      'gender': _gender.toString(),
      'image': "",
      "isBan":false,
      'uid':id.toString(),
      'dob':dobController.text.toString(),
      'name': nameController.text.toUpperCase().toString(),
      'middleName': middleNameController.text.toUpperCase().toString(),
      'surName': surNameController.text.toUpperCase().toString(),
      'password': passController.text.toString(),
      'isActive': false,
      'role': "driver",
      'status': "offline",
      "activeVehicle":"",
      "vehicles":_vehicleData.map((e) => e.toMap()).toList(),
      "requestSentTime": DateTime.now().millisecondsSinceEpoch.toString(),
      "selectedVehicle":"",
      "onlineFor":"",
      "emailVerified":false,
      "lastOnline":"",
      "lat":0.0,
      "lng":0.0,
    }).then((value) async{
        await firebaseFireStore.collection("drivers").doc(id).collection("bankInformation").doc(id).set({
            'IBAN': ibanController.text.toString(),
            'accountHolderName': accountHolderController.text.toString(),
            'accountNumber': accountNoController.text.toString(),
            'id': id.toString(),
            'paymentEmail': internalEmailController.text.toString(),
            'paymentSystem': bank.toString()=="null"?"":bank.toString(),
            'societyRollNo': rollNoController.text.toString(),
            'sortCode': accountCodeController.text.toString(),

          }).then((value) async{

          sendEmailVerification(context);
          }).catchError((e) {
          _loading=false;
          notifyListeners();
          ToastUtils.failureToast(e.toString(), context);

        });

    }).catchError((e) {
      _loading=false;
      notifyListeners();
      ToastUtils.failureToast(e.toString(), context);

    });
  }

  Timer? timer;

  Future<void> sendEmailVerification(context) async{
  try{
    _loading=false;
    notifyListeners();
    await _auth.currentUser?.sendEmailVerification().then((value) {
    ToastUtils.successToast("Verification Mail Sent To Given Email", context);
        AppRoutes.push(context, PageTransitionType.fade, const EmailVerification(from: true));
    }).catchError((e) {
    _loading=false;
    notifyListeners();
    ToastUtils.failureToast(e.toString(), context);

    });

  }
  on FirebaseAuthException catch (e){
    _loading=false;
    notifyListeners();
    showDialog(context: context, builder: (context){
      return MySimpleDialog(title: "Error", msg: e.message.toString(),
        icon:FeatherIcons.alertTriangle,);
    });

  }
  }

  void setTimerForAutoRedirect(context){
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if(user!.emailVerified){
        timer.cancel();
        firebaseFireStore.collection("drivers").doc(user.uid.toString()).update({
          "emailVerified":true
        }).then((value) {
          ToastUtils.successToast("Email Verified", context);
          ToastUtils.successToast("Account Created Successfully!! Login Now", context);

          Future.delayed(const Duration(seconds: 1),
                  () => AppRoutes.pushAndRemoveUntil(context, const LoginScreen(from: false,)));

        }).catchError((e) {

          ToastUtils.failureToast(e.toString(), context);

        });

      }
      else{

      }
    });
  }

  void manualCheckEmailVerificationStatus(context) {
    FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if(user!.emailVerified){
      firebaseFireStore.collection("drivers").doc(user.uid.toString()).update({
        "emailVerified": true
      }).then((value) {
        ToastUtils.successToast("Email Verified", context);
        ToastUtils.successToast("Account Created Successfully!! Login Now", context);

        Future.delayed(const Duration(seconds: 1),
                () => AppRoutes.pushAndRemoveUntil(context, const LoginScreen(from: false,)));

      }).catchError((e) {

        ToastUtils.failureToast(e.toString(), context);

      });

    }
    else{
      _loading=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return MySimpleDialog(title: "Error", msg: "Email Not Verified",
          icon:FeatherIcons.alertTriangle,);
      });
    }
  }

}