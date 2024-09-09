
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:parcelroo_driver_app/views/joinCompany/controller/join_company_provider.dart';
import 'package:parcelroo_driver_app/views/joinCompany/widgets/delete_company_dialog.dart';
import 'package:parcelroo_driver_app/widgets/my_company_widget.dart';
import 'package:provider/provider.dart';

import '../../enums/color_constants.dart';
import '../../enums/gobals.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/text_widget.dart';

class JoinCompany extends StatelessWidget {
  const JoinCompany({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: dashColor,
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(
            FeatherIcons.chevronLeft,
            color: whiteColor,
            size: 28.sp, // Changing Drawer Icon Size
          ),
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        backgroundColor:Colors.transparent,
        elevation: 0,
        title: myText(text: "Join A Company", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
        centerTitle: true,
      ),
      body: LoadingAnimation(
        inAsyncCall:context.watch<JoinProvider>().isLoading,
        child: Form(
          key: context.read<JoinProvider>().formKey,
          child: Padding(
            padding:const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: myText(text: "My Companies", fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 16.sp, color: whiteColor),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    height: MediaQuery.of(context).size.height*0.4,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(10.r)
                    ),
                    child:  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('drivers').doc(Globals.uid).collection("partneredCompany").snapshots(),
                      builder: (context, snapshot) {

                        if (snapshot.hasData) {
                          return  snapshot.data!.docs.length.toString()!="0"?Scrollbar(
                            thickness: 8,
                            radius: Radius.circular(10.r),
                            thumbVisibility: true,
                            trackVisibility: true,
                            child:
                            ListView.builder(itemBuilder: (context,index){
                              DocumentSnapshot doc = snapshot.data!.docs[index];
                              return Padding(padding:const EdgeInsets.all(10),
                                  child:  MyCompanyWidget(name: doc["companyName"],
                                    image:  doc["companyLogo"],
                                    isDelete: true,address: doc["companyAddress"],
                                    onTap: (){
                                      showDialog(context: context, builder: (context){
                                        return  DeleteCompanyPopup(onTap: (){
                                          context.read<JoinProvider>().deleteCompany(context,  doc["id"].toString(),doc["companyID"].toString());
                                        });
                                      });
                                    },));
                            },itemCount: snapshot.data!.docs.length,shrinkWrap: true,),
                          ):Center(
                            child:myText(text: "No Companies Data Found", fontFamily: "Poppins", size: 20.sp, color:Colors.black),
                          );
                        }
                        else if (snapshot.hasError) {
                          return Center(
                            child:myText(text: "No Companies Data Found", fontFamily: "Poppins", size: 20.sp, color:Colors.black),
                          );
                        }
                        else {
                          return const Center(
                            child:CircularProgressIndicator(color: dashColor),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  myText(text: "Join A New Company", fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 16.sp, color: whiteColor),
                  SizedBox(height: 10.h),
                  myText(text: "Enter Email Of Company Registered With Premium Subscription", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 14.sp, color: whiteColor,textAlign: TextAlign.center,),
                  SizedBox(height: 20.h),
                  CustomTextField(validator: (value) {
                    if(value ==null || value.isEmpty){
                      return "Please Enter Company Email";

                    }
                    else if((RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value) ==
                        false) ){
                      return "Please Enter Valid Email";
                    }

                    return null;
                  },controller: context.read<JoinProvider>().companyEmail, hint: "Enter Company Email",suffixIcon: Icon(Icons.email,color: greyDark,size: 25.sp)),
                  SizedBox(height: 20.h),
                  CustomTextField(validator: (value) {
                    if(value ==null || value.isEmpty){
                      return "Please Confirm Company Email";

                    }
                    else if((RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value) ==
                        false) ){
                      return "Please Enter Valid Email";
                    }
                    else if(value.toString()!=context.read<JoinProvider>().companyEmail.text.toString()){
                      return "Email did not matched!";
                    }

                    return null;
                  },controller: context.read<JoinProvider>().companyConfirmEmail, hint: "Confirm Company Email",suffixIcon: Icon(Icons.email,color: greyDark,size: 25.sp)),
                  SizedBox(height: 40.h),
                  MyFancyButton(
                      width: MediaQuery.of(context).size.width*0.5,
                      borderRadius:40.r,
                      isIconButton: false,
                      isGradient: true,
                      gradient: purpleGradient,
                      fontSize: 22.sp,
                      family: "Poppins",
                      text: "Submit", tap: (){
                    if (context.read<JoinProvider>().formKey.currentState!.validate()) {
                      context.read<JoinProvider>().checkCompanyExists(
                          context, context
                          .read<JoinProvider>()
                          .companyEmail
                          .text
                          .toString());
                    }

                  },
                      buttonColor: darkPurple,
                      hasShadow: true),

                ],
              ),
            ),
          ),
        )
      )
    );
  }
}
