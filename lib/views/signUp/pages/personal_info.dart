import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../enums/color_constants.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/text_widget.dart';
import '../controller/signUp_provider.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            myText(text: "createAccount", fontFamily: "Poppins", size: 24.sp, color: lightBlue,fontWeight: FontWeight.w600,),
            SizedBox(height: 10.h),
            myText(text: "esDC", fontFamily: "Poppins", fontWeight: FontWeight.w500,size: 16.sp, color: whiteColor,textAlign: TextAlign.center,),
            SizedBox(height: 30.h),
            CustomTextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(20)
              ],
                validator: (value) {
                  if(value ==null || value.isEmpty){
                    return "validName".tr();

                  }
                  return null;
                },controller: context.read<SignUpProvider>().nameController, hint: "enterName"),
            SizedBox(height: 20.h),
            CustomTextField( inputFormatters: [
              LengthLimitingTextInputFormatter(20)
            ],controller: context.read<SignUpProvider>().middleNameController, hint: "middleName"),
            SizedBox(height: 20.h),
            CustomTextField( inputFormatters: [
              LengthLimitingTextInputFormatter(20)
            ],validator: (value) {
              if(value ==null || value.isEmpty){
                return "validSur".tr();
              }
              return null;
            },controller: context.read<SignUpProvider>().surNameController, hint: "enterSur"),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myText(text: "sGender", fontFamily: "Poppins", size: 16.sp, color: whiteColor,fontWeight: FontWeight.w400,),
                CustomDropDown(hint: "selectG", item: context.read<SignUpProvider>().genderItems, value: context.watch<SignUpProvider>().gender,
                    onChanged: (value){
                      context.read<SignUpProvider>().setGender(value);
                    })
              ],
            ),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myText(text: "sDOB", fontFamily: "Poppins", size: 16.sp, color: whiteColor,fontWeight: FontWeight.w400,),
                SizedBox(height: 5.h),
                GestureDetector(
                  onTap: (){
                    context.read<SignUpProvider>().selectDate(context);
                  },
                  child: CustomTextField(validator: (value) {
                    if(value ==null || value.isEmpty){
                      return "pDOB".tr();

                    }
                    return null;
                  },controller: context.watch<SignUpProvider>().dobController, hint: "dob",absorbing: true,suffixIcon: Icon(Icons.calendar_month,color: greyDark,size: 25.sp)),
                ),
              ],
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
