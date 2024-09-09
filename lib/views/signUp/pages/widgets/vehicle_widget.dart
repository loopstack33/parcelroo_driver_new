
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/widgets/custom_textfield.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';

import '../../../../enums/color_constants.dart';
import '../../../../enums/image_constants.dart';
import '../../../../utils/utilities.dart';
import '../../../../widgets/info_view_dialog.dart';

class VehicleWidget extends StatelessWidget {
  final String name;
  final String image;
  final String cc;
  final bool hasReg;
  final bool hasInfo;
  final int index;
  final bool value;
  final String info;
  final List<TextEditingController> controllers;
  final Function(bool?)? onChanged;
  const VehicleWidget({Key? key,required this.info, required this.controllers,required this.value,required this.index,required this.onChanged,required this.name,required this.image,required this.hasReg,required this.hasInfo,required this.cc}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       SizedBox(
         width: 100,
         child:  Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             ClipRRect(
               borderRadius: BorderRadius.circular(10.r),
               child: CachedNetworkImage(
                 imageUrl: image,
                 height: 100.h,

                 imageBuilder:
                     (context, imageProvider) =>
                     Container(
                       decoration: BoxDecoration(
                         image: DecorationImage(
                           image: imageProvider,
                           fit: BoxFit.fitWidth,
                         ),
                       ),
                     ),
                 placeholder: (context, url) =>
                     Image.asset(
                         loader),
                 errorWidget: (context, url, error) =>
                 const Icon(
                   Icons.error,
                   color: redColor,
                 ),
               ),
             ),
             myText(text: name, fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 14.sp, color: whiteColor,textAlign: TextAlign.center),
             myText(text: cc, fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 14.sp, color: whiteColor,textAlign: TextAlign.center)
           ],)
       ),
        if(hasReg)...[
          Column(
            children: [
              myText(text: "tag", fontFamily: "Poppins",fontWeight: FontWeight.w300, size: 14.sp, color: whiteColor),
              SizedBox(height: 10.h),
              SizedBox(width: 100.w,
              child: CustomTextField(controller:controllers[index], hint: "",
                inputFormatters: [
                  UpperCaseTextFormatter(),
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],))
            ],
          ),
        ],
        if(hasInfo)...[
          Column(
            children: [
              GestureDetector(
                onTap: (){
                  showDialog(context: context, builder: (context){
                    return InfoViewDialog(image:info.toString());
                  });
                },
                child: Icon(FeatherIcons.info,color: whiteColor,size: 25.sp,),
              ),
              SizedBox(height: 10.h),

              Checkbox(
                value: value,
                onChanged:onChanged,
                activeColor: darkPurple,
                side: const BorderSide(color: whiteColor),

              ),
            ],

          ),
        ]
        else...[
          Checkbox(
            value: value,
            onChanged:onChanged,
            activeColor: darkPurple,
            side: const BorderSide(color: whiteColor),
          ),
          ]

      ],
    );
  }
}

