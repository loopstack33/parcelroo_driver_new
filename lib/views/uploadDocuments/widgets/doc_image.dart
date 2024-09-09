import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../enums/color_constants.dart';
import '../../../enums/image_constants.dart';
import '../../../widgets/text_widget.dart';

class DocImageWidget extends StatelessWidget {
  final String url;
  final String text;
  final bool uploaded;
  const DocImageWidget({Key? key,required this.url,required this.text,required this.uploaded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       uploaded? Icon(FeatherIcons.checkCircle,color:Colors.greenAccent,size: 25.sp):
       ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: CachedNetworkImage(
            imageUrl: url,
            height: 120.h,
            width: 120.w,
            imageBuilder:
                (context, imageProvider) =>
                Container(
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
                Container(
                  decoration:const BoxDecoration(
                      color: Colors.white
                  ),
                  child: const Icon(
                    Icons.error,
                    color: redColor,
                  ),
                ),
          ),
        ),
        SizedBox(height: 10.h),
        myText(text: text, fontFamily: "Poppins", size: 16.sp, color: whiteColor),

      ],
    );
  }
}
