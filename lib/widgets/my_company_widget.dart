import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/image_constants.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../enums/color_constants.dart';
import '../views/dashboard/controller/dash_provider.dart';

class MyCompanyWidget extends StatelessWidget {
  final String name;
  final String address;
  final bool isDelete;
  final VoidCallback? onTap;
  final String? image;
  final bool? fromDash;
  final VoidCallback? onTap2;


  const MyCompanyWidget({Key? key,this.onTap2,this.fromDash,this.onTap,required this.name,required this.address,required this.isDelete,this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: joinCompany.withOpacity(0.52),
        borderRadius: BorderRadius.circular(10.r)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*0.5,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myText(text: name, fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 18.sp, color: darkPurple),
                myText(text: "Full Address", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 16.sp, color: Colors.black),
                myText(text: address, fontFamily: "Poppins", size: 14.sp, color: Colors.black)
              ],
            ),
          ),
          Column(
            children: [
              if(image.toString()!="null")...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    imageUrl: image!,
                    width: 50.w,
                    height: 50.h,
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
                    const Icon(
                      Icons.error,
                      color: redColor,
                    ),
                  ),
                ),
              ]
              else ...[
                CircleAvatar(
                  radius: 25.r,
                  backgroundColor: whiteColor,
                  child: Image.asset(logo),
                ),
              ],

              if(isDelete && fromDash==null)...[
                TextButton(onPressed: onTap, child: myText(text: "Delete", fontFamily: "Poppins",fontWeight: FontWeight.w600, size: 15.sp, color: Colors.red))
              ]
              else...[
                // GestureDetector(
                //     onTap: onTap2,
                //     child: Container(
                //       margin: EdgeInsets.only(top: 10.h),
                //       width: 22.w,
                //       height: 25.h,
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(4.r),
                //           color:lightGrey
                //       ),
                //
                //
                //     )
                // ),
               ]

            ],
          )
        ],
      )
    );
  }
}


class MyCompanyWidget2 extends StatelessWidget {
  final String name;
  final String address;
  final Function(bool?) onTap2;
  final String? image;
  final int index;
  final bool isActive;
  final bool value;

  const MyCompanyWidget2({Key? key,required this.onTap2,required this.index,required this.name,required this.address,this.image,required this.isActive,
  required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color:isActive? joinCompany.withOpacity(0.52):dashColor.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10.r)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.5,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myText(text: name, fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 18.sp, color: darkPurple),
                  myText(text: "Full Address", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 16.sp, color: Colors.black),
                  myText(text: address, fontFamily: "Poppins", size: 14.sp, color: Colors.black)
                ],
              ),
            ),
            Column(
              children: [
                if(image.toString()!="null")...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      imageUrl: image!,
                      width: 50.w,
                      height: 50.h,
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
                      const Icon(
                        Icons.error,
                        color: redColor,
                      ),
                    ),
                  ),
                ]
                else ...[
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: whiteColor,
                    child: Image.asset(logo),
                  ),
                ],
                if(isActive)...[
                  Checkbox(
                    value: value,
                    onChanged: onTap2,
                  ),
                  // GestureDetector(
                  //     onTap: onTap2,
                  //     child: Container(
                  //       margin: EdgeInsets.only(top: 10.h),
                  //       width: 22.w,
                  //       height: 25.h,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(4.r),
                  //           color:context.watch<DashProvider>().selectedIndex2==index? dashColor:lightGrey
                  //       ),
                  //       child:context.watch<DashProvider>().selectedIndex2==index? Icon( Icons.check,color: whiteColor,size: 15.sp,):null,
                  //     )
                  // ),
                ],


              ],
            )
          ],
        )
    );
  }
}
