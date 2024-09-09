
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../enums/color_constants.dart';
import '../../../utils/utilities.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/text_widget.dart';
import '../controller/signUp_provider.dart';

class HomeInfo extends StatelessWidget {
  const HomeInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 10.h),
      child: SingleChildScrollView(
        child: Column(

          children: [
            myText(text: "createAccount", fontFamily: "Poppins", size: 24.sp, color: lightBlue,fontWeight: FontWeight.w600,),
            SizedBox(height: 10.h),
            myText(text: "addressInfo", fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 16.sp, color: whiteColor),
            SizedBox(height: 30.h),
            GestureDetector(
              onTap: (){
                showCountryPicker(
                  context: context,
                  favorite: <String>['GB'],
                  showPhoneCode: false,
                  onSelect: (Country country) {
                    context.read<SignUpProvider>().changeCountry(country);
                  },
                  countryListTheme: CountryListThemeData(

                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontFamily: "Poppins"
                    ),

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
                child:CustomTextField(controller: context.read<SignUpProvider>().countryController, hint: context.read<SignUpProvider>().country.name.toString(),
                  prefixIcon: IconButton(
                    icon: Text(context.watch<SignUpProvider>().country.flagEmoji,style: TextStyle(fontSize: 20.sp),), onPressed: () {  },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            CustomTextField(validator: (value) {
              if(value ==null || value.isEmpty){
                return "validAddress".tr();

              }
              return null;
            },
              controller: context.read<SignUpProvider>().address1Controller, hint: "line1",suffixIcon: Icon(Icons.home,color: greyDark,size: 25.sp),
              inputFormatters: [
                LengthLimitingTextInputFormatter(70),
              ],),
            SizedBox(height: 20.h),
            CustomTextField( inputFormatters: [

              LengthLimitingTextInputFormatter(70),
            ],controller: context.read<SignUpProvider>().address2Controller, hint: "line2",suffixIcon: Icon(Icons.home,color: greyDark,size: 25.sp)),
            SizedBox(height: 20.h),
            CustomTextField( inputFormatters: [

              LengthLimitingTextInputFormatter(70),
            ],controller: context.read<SignUpProvider>().address3Controller, hint: "line3",suffixIcon: Icon(Icons.home,color: greyDark,size: 25.sp)),
            SizedBox(height: 20.h),

            CustomTextField(
                validator: (value) {
                  if(value ==null || value.isEmpty){
                    return "validCity".tr();
                  }
                  return null;
                },
                controller: context.read<SignUpProvider>().cityController, hint: "city",suffixIcon: Icon(Icons.location_city,color: greyDark,size: 25.sp)),
            SizedBox(height: 20.h),
            CustomTextField(inputFormatters: [
              UpperCaseTextFormatter(),
              LengthLimitingTextInputFormatter(10),
            ],validator: (value) {
              if(value ==null || value.isEmpty){
                return "zipCode".tr();

              }
              return null;
            },controller: context.read<SignUpProvider>().zipController, hint: "zP",
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
