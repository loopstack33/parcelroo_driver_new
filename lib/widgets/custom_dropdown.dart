// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';


class CustomDropDown extends StatelessWidget {
  List item;
  var value;
  String hint;
  Function(String?) onChanged;
  List<DropdownMenuItem<String>>? items;
  CustomDropDown(
      {Key? key, required this.hint,required this.onChanged, required this.item, required this.value,this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.h,
      padding: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: textFieldColor,width: 1.w),
          boxShadow: [
            BoxShadow(color: darkPurple.withOpacity(0.25), blurRadius: 5.r)
          ]),
      child: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              menuMaxHeight: 250,
              dropdownColor: whiteColor,
              borderRadius: BorderRadius.circular(10),
              icon: Icon(
                FeatherIcons.chevronDown,
                size: 20.sp,
                color: Colors.black,
              ),
              hint: myText(
              text: hint,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              size: 16.sp,
              color: Colors.black),
              isExpanded: false,
              style: TextStyle(
                  color: Colors.black, fontSize: 16.sp, fontFamily: 'Poppins'),
              onChanged: onChanged,
              value: value,
              items:items ?? item.map((val) {
                return DropdownMenuItem(
                  value: val.toString(),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      val.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                );
          }).toList(),
        )),
      ),
    );
  }
}
