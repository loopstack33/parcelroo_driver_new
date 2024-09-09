
// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/views/dashboard/controller/dash_provider.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../../../enums/color_constants.dart';
import '../../../../enums/image_constants.dart';
import '../../../widgets/info_view_dialog.dart';

class VehicleWidgetD extends StatelessWidget {
  final String name;
  final String image;
  final String cc;
  final String reg;
  final int index;
  final bool value;
  final String info;
  final VoidCallback onChanged;
  const VehicleWidgetD({Key? key,required this.info,required this.value,required this.index,required this.onChanged,required this.name,required this.image,required this.reg,required this.cc}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: image,
                height: 100.h,
                width: 100.w,
                imageBuilder:
                    (context, imageProvider) =>
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitHeight,
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
            myText(text: name.toString(), fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 14.sp, color: Colors.black,textAlign: TextAlign.center),
            SizedBox(
              width: 100,
              child: myText(text: cc.toString(), fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 14.sp, color: Colors.black,textAlign: TextAlign.center),
            )
          ],),
        Column(
          children: [
           myText(text: "Tag/Registration", fontFamily: "Poppins",fontWeight: FontWeight.w300, size: 14.sp, color: Colors.black),
            myText(text:reg, fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 16.sp, color: Colors.black),
          ],
        ),
        Column(
          children: [
            if(info.toString()!="")...[
              GestureDetector(
                onTap: (){
                  showDialog(context: context, builder: (context){
                    return InfoViewDialog(image:info.toString());
                  });
                },
                child: Icon(FeatherIcons.info,color: dashColor,size: 25.sp),
              )
            ],
            SizedBox(height: 10.h),
            GestureDetector(
                onTap: onChanged,
                child: Container(
                  width: 22.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color:context.watch<DashProvider>().selectedIndex==index? dashColor:lightGrey
                  ),
                  child:context.watch<DashProvider>().selectedIndex==index? Icon( Icons.check,color: whiteColor,size: 15.sp,):null,
                )
            ),
            SizedBox(height: 40.h),
          ],
        )
      ],
    );
  }
}
