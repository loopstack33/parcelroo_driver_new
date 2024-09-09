import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:provider/provider.dart';
import '../../../../enums/color_constants.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/custom_textfield.dart';
import '../../../../widgets/text_widget.dart';
import '../../widgets/drawerWidget.dart';
import 'controller/update_bank_controller.dart';


class UpdateBank extends StatefulWidget {
  const UpdateBank({Key? key}) : super(key: key);


  @override
  State<UpdateBank> createState() => _UpdateBankState();
}

class _UpdateBankState extends State<UpdateBank> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UpdateBankProvider>(context, listen: false)
          .getBankingInfo(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashColor,
      drawer:const DrawerMobileWidget(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon:  Icon(
                Icons.menu,
                color: whiteColor,
                size: 28.sp, // Changing Drawer Icon Size
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor:Colors.transparent,
        elevation: 0,
        title: myText(text: "Update Banking Info", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
        centerTitle: true,
      ),
      body: LoadingAnimation(
        inAsyncCall: context.watch<UpdateBankProvider>().isLoading,
        child: Padding(
          padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 10.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                myText(text: "Please enter Banking information or skip and fill In-app. (optional)", fontFamily: "Poppins", size: 15.sp, color: whiteColor,textAlign: TextAlign.center,),
                SizedBox(height: 30.h),
                CustomTextField(controller: context.read<UpdateBankProvider>().accountHolderController, hint: "Account Holders Full Name"),
                SizedBox(height: 20.h),
                CustomTextField(controller: context.read<UpdateBankProvider>().accountNoController, hint: "Account Number"),
                SizedBox(height: 20.h),
                CustomTextField(controller: context.read<UpdateBankProvider>().accountCodeController, hint: "Account Sort Code"),
                SizedBox(height: 20.h),
                CustomTextField(controller: context.read<UpdateBankProvider>().rollNoController, hint: "Building Society Roll Number"),
                SizedBox(height: 20.h),
                CustomTextField(controller: context.read<UpdateBankProvider>().ibanController, hint: "IBAN Number"),
                SizedBox(height: 10.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myText(text: "Please Choose Payment type", fontFamily: "Poppins", size: 16.sp, color: whiteColor,fontWeight: FontWeight.w400,),
                    SizedBox(height: 5.h),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("payment_methods").where("enabled",isEqualTo: true).snapshots(),
                        builder: (context,snapshot) {
                          if(snapshot.hasData){
                            return CustomDropDown(hint: "Select Payment Method",
                                item: snapshot.data!.docs,
                                value: context.watch<UpdateBankProvider>().bank,
                                onChanged: (value){
                                  context.read<UpdateBankProvider>().setBank(value);
                                },
                                items: snapshot.data!.docs.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.get('name'),
                                    child:Text(
                                      value.get('name').toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontFamily: 'Poppins'),
                                    ),
                                  );
                                }).toList());
                          }
                          else {
                            return const Center(
                              child: CircularProgressIndicator(color: lightPurple,),
                            );
                          }
                        }
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomTextField(controller: context.read<UpdateBankProvider>().internalEmailController, hint: "Internet Linked Email Address"),
                SizedBox(height: 20.h),
                CustomTextField(controller: context.read<UpdateBankProvider>().reTypeInternalEmailController, hint: "Re-Type Internet Linked Email Address"),
                SizedBox(height: 30.h),
                MyFancyButton(
                    margin: EdgeInsets.only(bottom: 30.h),
                    width: MediaQuery.of(context).size.width*0.5,
                    borderRadius:40.r,
                    isIconButton: false,
                    isGradient: true,
                    gradient:
                    const LinearGradient(
                      colors: [
                        darkPurple,
                        Color(0xFF6610F2),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    fontSize: 22.sp,
                    family: "Poppins",
                    text: "Submit", tap: (){
                      context.read<UpdateBankProvider>().updateBankingInfo(context,
                          context.read<UpdateBankProvider>().ibanController.text,
                          context.read<UpdateBankProvider>().accountHolderController.text,
                          context.read<UpdateBankProvider>().accountNoController.text,
                          context.read<UpdateBankProvider>().internalEmailController.text,
                          context.read<UpdateBankProvider>().bank.toString(),
                          context.read<UpdateBankProvider>().rollNoController.text,
                          context.read<UpdateBankProvider>().accountCodeController.text);
                },
                    buttonColor: darkPurple,
                    hasShadow: true),
              ],
            ),
          ),
        ),
      )
    );
  }
}
