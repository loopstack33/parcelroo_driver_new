
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../enums/color_constants.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/text_widget.dart';
import '../controller/signUp_provider.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [

            myText(text: "createAccount", fontFamily: "Poppins", size: 24.sp, color: lightBlue,fontWeight: FontWeight.w600,),
            SizedBox(height: 10.h),
            myText(text: "cDetails", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 16.sp, color: whiteColor),
            SizedBox(height: 30.h),
            CustomTextField(validator: (value) {
              if(value ==null || value.isEmpty){
                return "enterEmail2".tr();
              }
              else if((RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value) ==
                  false) ){
                return "validEmail".tr();

              }
              return null;
            },controller: context.read<SignUpProvider>().emailController, hint: "eEmail2",suffixIcon: Icon(Icons.email,color: greyDark,size: 25.sp),
            type: TextInputType.emailAddress,),
            SizedBox(height: 20.h),
            CustomTextField(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: GestureDetector(
                    onTap: (){
                      showCountryPicker(
                        context: context,
                        favorite: <String>['GB'],
                        showPhoneCode: false,
                        onSelect: (Country country) {
                          context.read<SignUpProvider>().changeCountry2(country);
                        },
                        countryListTheme: CountryListThemeData(
                          // Optional. Sets the border radius for the bottomsheet.
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          ),
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontFamily: "Poppins"
                          ),
                          // Optional. Styles the search field.
                          inputDecoration: InputDecoration(
                            labelText: 'search'.tr(),
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontFamily: "Poppins"
                            ),
                            hintText: 'startType'.tr(),
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: const Color(0xFF8C98A8).withOpacity(0.2),
                              ),
                            ),
                          ),
                          // Optional. Styles the text in the search field
                          searchTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontFamily: "Poppins"
                          ),
                        ),
                      );
                    },
                    child: AbsorbPointer(
                        absorbing: true,
                        child:SizedBox(
                          width: 80.w,
                          child: CustomTextField(
                            noBorder: true,controller: context.read<SignUpProvider>().countryController2, hint: context.read<SignUpProvider>().country2.name.toString(),
                            prefixIcon: IconButton(
                              icon: Row(
                                children: [
                                  Text(context.watch<SignUpProvider>().country2.flagEmoji,style: TextStyle(fontSize: 16.sp),),
                                  Text(" +${context.watch<SignUpProvider>().country2.phoneCode}",style: TextStyle(fontSize: 16.sp,color: Colors.black),),
                                ],
                              ), onPressed: () {  },
                            ),
                          ),
                        )
                    ),
                  ),
                ),
                validator: (value) {
                  if(value ==null || value.isEmpty){
                    return "validPhone".tr();
                  }
                  return null;
                },
                controller: context.read<SignUpProvider>().phoneController, hint: "phoneNo", type: TextInputType.number,
                inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
              FilteringTextInputFormatter.deny(RegExp(r'^0+')),
            ]),

            SizedBox(height: 20.h),
            CustomTextField(validator: (value) {
              if(value ==null || value.isEmpty){
                return "cantEmpty".tr();
              }
              else if(value.length<8){
                return "validLength".tr();
              }
              else if(context.read<SignUpProvider>().isPasswordValid(value.toString())==false){
                return "must".tr();
              }
              return null;
            },
                controller: context.read<SignUpProvider>().passController, hint: "enterPass2",obscure:  context.watch<SignUpProvider>().passwordVisible,
                suffixIcon: InkWell(
                    onTap: () {
                      context
                          .read<SignUpProvider>()
                          .togglePassword();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        context.watch<SignUpProvider>().passwordVisible
                            ? FeatherIcons.eye
                            : FeatherIcons.eyeOff,
                        size: 25.sp,
                      ),
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ]),
            SizedBox(height: 20.h),
            CustomTextField(
                validator: (value) {
                  if(value ==null || value.isEmpty){
                    return "cEmpty".tr();
                  }

                  else if(value.toString()!=context.read<SignUpProvider>().passController.text.toString()){
                    return "notMatch".tr();
                  }
                  return null;
                },
                controller: context.read<SignUpProvider>().confirmPassController, hint: "reType",obscure:  context.watch<SignUpProvider>().cnfrmPasswordVisible,
                suffixIcon: InkWell(
                    onTap: () {
                      context
                          .read<SignUpProvider>()
                          .toggleConfirmPassword();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        context.watch<SignUpProvider>().cnfrmPasswordVisible
                            ? FeatherIcons.eye
                            : FeatherIcons.eyeOff,
                        size: 25.sp,
                      ),
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ]),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
