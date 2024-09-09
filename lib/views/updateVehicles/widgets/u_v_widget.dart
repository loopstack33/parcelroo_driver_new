
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';

import '../../../../enums/color_constants.dart';
import '../../../../enums/image_constants.dart';

class UpdateVehicleWidget extends StatelessWidget {
  final String name;
  final String image;
  final String cc;
  final String reg;
  final int index;
  final bool value;
  final VoidCallback onChanged;
  const UpdateVehicleWidget({Key? key,required this.value,required this.index,required this.onChanged,required this.name,required this.image,required this.reg,required this.cc}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: 100,
            child:  Column(
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
        Column(
          children: [
            TextButton(onPressed:onChanged, child: myText(text: "Delete", fontFamily: "Poppins", size: 14.sp, color: redColor)),
            myText(text: "Tag/Registration", fontFamily: "Poppins",fontWeight: FontWeight.w300, size: 14.sp, color: whiteColor),
            myText(text:reg, fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 16.sp, color: whiteColor),

          ],
        )
      ],
    );
  }
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
