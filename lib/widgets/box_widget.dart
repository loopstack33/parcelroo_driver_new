import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';

import '../enums/color_constants.dart';
import '../enums/image_constants.dart';

class BoxWidget extends StatelessWidget {
  final bool isImage;
  final String text;
  final String? detail;
  final String? image;
  const BoxWidget({Key? key,required this.text,required this.isImage,this.detail,this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(width: 80.w,
        child: myText(text: text, fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 14.sp, color: Colors.black,textAlign: TextAlign.center,)),
        SizedBox(height: 10.h),
        Container(

          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.r)
          ),
          width: 100.w,
          height: 100.h,
          child:isImage? CachedNetworkImage(
            imageUrl: image!,

            imageBuilder:
                (context, imageProvider) =>
                Container(
                  margin:const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
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
          ):
          Center(
            child: myText(text: detail!, fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 16.sp, color: Colors.black,textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}
