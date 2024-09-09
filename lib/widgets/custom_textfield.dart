// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';


class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String hint;
  bool? noBorder;
  bool? align;
  int? maxLines;
  bool? absorbing;
  bool? obscure;
  Widget? suffixIcon;
  Widget? prefixIcon;
  Color? borderColor;
  EdgeInsetsGeometry? contentPadding;
  TextInputType? type;
  String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  Function(String)? onChanged;
  CustomTextField(
      {Key? key,
        this.noBorder,
        this.contentPadding,
        this.validator,
        this.borderColor,
        this.obscure,
        this.align,
        this.onChanged,
        this.absorbing,
        this.maxLines,
        this.suffixIcon,
        this.prefixIcon,
        this.type,
        required this.controller,
        this.inputFormatters,
        required this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: absorbing ?? false,
      child: TextFormField(
        validator: validator,
        textAlignVertical: align == null ? null : TextAlignVertical.center,
        onChanged: onChanged,
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Poppins",
          fontSize: 16.sp,
        ),

        obscureText: obscure?? false,
        controller: controller,
        textInputAction: TextInputAction.done,
        inputFormatters: inputFormatters,
        maxLines: maxLines ?? 1,
        keyboardType: type ?? TextInputType.text,

        decoration: InputDecoration(

          errorStyle: TextStyle(
            color:redColor,
            fontFamily: "Poppins",
            fontSize: 14.sp,
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          isDense: true,
          fillColor: whiteColor,
          filled: true,
          hintText: hint.tr(),
          hintStyle: TextStyle(
            color: greyDark,
            fontFamily: "Poppins",
            fontSize: 16.sp,
          ),
          contentPadding: contentPadding,
          errorBorder:noBorder!=null?OutlineInputBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),bottomLeft: Radius.circular(10.r)),
              borderSide: BorderSide(color: redColor, width: 1.w)
          ): OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: redColor, width: 1.w)
          ),
          focusedErrorBorder:noBorder!=null? OutlineInputBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),bottomLeft: Radius.circular(10.r)),
              borderSide: BorderSide(color: redColor, width: 1.w)
          ):  OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: redColor, width: 1.w)
          ),
          enabledBorder:noBorder!=null?OutlineInputBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),bottomLeft: Radius.circular(10.r)),
              borderSide: BorderSide(color: textFieldColor, width: 1.w)):  OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: textFieldColor, width: 1.w)),
          focusedBorder:noBorder!=null?OutlineInputBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),bottomLeft: Radius.circular(10.r)),
              borderSide: BorderSide(color: textFieldColor, width: 1.w)):  OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: textFieldColor, width: 1.w)),
        ),
      ),
    );
  }
}

