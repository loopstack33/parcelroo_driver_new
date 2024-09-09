// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';

import '../../../utils/utilities.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/text_widget.dart';

class ReasonWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController controller2;
  var value;
  final List data;
  final Function(String?) onChanged;
  ReasonWidget({Key? key,required this.controller,required this.controller2,required this.value,
  required this.onChanged,required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.9,
      padding:const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: dashColor.withOpacity(0.25),
            blurRadius: 5.r
          )
        ]
      ),
      child: Column(
        children: [
          myText(text: "Waiting Time", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 20.sp, color: dashColor),
          SizedBox(height: 10.h),

          Wrap(
            spacing: 20,
            children: [
              SizedBox(
                width: 100,
                child: CustomTextField(
                  controller: controller,
                  hint: "Hours",
                  type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      NumberRangeInputFormatter()
                    ]
                ),
              ),
              SizedBox(
                width: 100,
                child: CustomTextField(
                  controller: controller2,
                  hint: "Minutes",
                  type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      NumberRangeInputFormatter2()
                    ]
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),
          CustomDropDown(hint: "Select Reason",
              item: data,
              value: value,
              onChanged: onChanged,
              items: data.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child:SizedBox(
                    width: MediaQuery.of(context).size.width*0.6,
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontFamily: 'Poppins'),
                    ),
                  )
                );
              }).toList()),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
