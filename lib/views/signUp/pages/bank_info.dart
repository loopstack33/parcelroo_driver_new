
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../enums/color_constants.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/text_widget.dart';
import '../controller/signUp_provider.dart';

class BankInfo extends StatelessWidget {
  const BankInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 20.w,right: 20.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            myText(text: "createAccount", fontFamily: "Poppins", size: 24.sp, color: lightBlue,fontWeight: FontWeight.w600,),
            SizedBox(height: 10.h),
            myText(text: "bankDetailDesc", fontFamily: "Poppins", size: 15.sp, color: whiteColor,textAlign: TextAlign.center,),
            SizedBox(height: 10.h),
            myText(text: "bankDetails", fontFamily: "Poppins", size: 16.sp,fontWeight: FontWeight.w500, color: whiteColor,textAlign: TextAlign.center,),
            SizedBox(height: 30.h),
            CustomTextField(controller: context.read<SignUpProvider>().accountHolderController, hint: "accountName"),
            SizedBox(height: 20.h),
            CustomTextField(controller: context.read<SignUpProvider>().accountNoController, hint: "accountNo"),
            SizedBox(height: 20.h),
            CustomTextField(controller: context.read<SignUpProvider>().accountCodeController, hint: "sortCode"),
            SizedBox(height: 20.h),
            CustomTextField(controller: context.read<SignUpProvider>().rollNoController, hint: "rollNo"),
            SizedBox(height: 20.h),
            CustomTextField(controller: context.read<SignUpProvider>().ibanController, hint: "iban"),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myText(text: "paymentType", fontFamily: "Poppins", size: 16.sp, color: whiteColor,fontWeight: FontWeight.w400,),
                SizedBox(height: 5.h),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("payment_methods").where("enabled",isEqualTo: true).snapshots(),
                    builder: (context,snapshot) {
                      if(snapshot.hasData){
                        return CustomDropDown(hint: "paymentMethod", item: snapshot.data!.docs, value: context.watch<SignUpProvider>().bank,
                            onChanged: (value){
                              context.read<SignUpProvider>().setBank(value);
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
                            }).toList()
                        );
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
            CustomTextField(controller: context.read<SignUpProvider>().internalEmailController, hint: "internalEmail"),
            SizedBox(height: 20.h),
            CustomTextField(controller: context.read<SignUpProvider>().reTypeInternalEmailController, hint: "reEmail"),
            SizedBox(height: 20.h),
            Row(
              children: [
                Container(
                  width: 18.w,
                  height:18.h,
                  decoration: BoxDecoration(
                      color: lightGrey, borderRadius: BorderRadius.circular(3.r)),
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: lightGrey),
                    child: Transform.scale(
                      scale:1.0,
                      child: Checkbox(
                          value: context.watch<SignUpProvider>().agree,
                          activeColor: darkPurple,
                          onChanged: context.read<SignUpProvider>().agreeCheck),
                    ),
                  ),
                ),
                SizedBox(width: 10.h),
                Text.rich(TextSpan(children:[
                  TextSpan(
                      text: "${"bySign".tr()}\n ",
                      style: TextStyle(fontFamily: "Poppins",fontSize: 12.sp,color:Colors.white)
                  ),
                  TextSpan(
                      text: "termService".tr(),
                      style: TextStyle(fontFamily: "Poppins",fontSize: 12.sp,color:darkPurple)
                  ),
                  TextSpan(
                      text: "and".tr(),
                      style: TextStyle(fontFamily: "Poppins",fontSize: 12.sp,color:Colors.white)
                  ),
                  TextSpan(
                      text: "privacyPolicy".tr(),
                      style: TextStyle(fontFamily: "Poppins",fontSize: 12.sp,color:darkPurple)
                  )
                ])),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
