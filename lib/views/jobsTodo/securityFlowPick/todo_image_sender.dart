
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcelroo_driver_app/models/advertise_model.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:provider/provider.dart';

import '../../../enums/color_constants.dart';
import '../../../enums/image_constants.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/simple_dialog.dart';
import '../../../widgets/text_widget.dart';
import '../controller/jobs_todo_controller.dart';

class ImageSenderPick extends StatelessWidget {
  final AdvertiseModel advertiseModel;
  const ImageSenderPick({Key? key, required this.advertiseModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashColor,
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(
            FeatherIcons.chevronLeft,
            color: whiteColor,
            size: 28.sp, // Changing Drawer Icon Size
          ),
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        backgroundColor:Colors.transparent,
        elevation: 0,
        title: myText(text: "Customer Code Selected", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 20.sp, color: whiteColor),
        centerTitle: true,
      ),

      body: LoadingAnimation(
        inAsyncCall: context.watch<JobsTodoProvider>().isUpdating,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r)),
              border: Border.all(color: textFieldColor,width: 1.w)
          ),
          child: Padding(
              padding:const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  myText(text: "Photo Proof Of Pick Up", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 24.sp, color: dashColor),
                  SizedBox(height: 10.h),
                  myText(text: "Please Take Picture Of Parcel/s To Pick Up", fontFamily: "Poppins",fontWeight: FontWeight.w400, size: 18.sp, color: dashColor),
                  SizedBox(height: 20.h),
                  context.watch<JobsTodoProvider>().pickImage==null?Image.asset(imagePick,height: 250.h):
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(context.read<JobsTodoProvider>().pickImage!,height: 250.h),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (builder) => bottomSheet(context));
                      },
                      child: Container(
                        padding:const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF6C6A6A),width: 1.w),
                            borderRadius: BorderRadius.circular(10.r)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(FeatherIcons.uploadCloud,color: dashColor),
                            SizedBox(
                                width: 10.w
                            ),
                            myText(text: "Press To Take Pick Up Image", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 18.sp, color: dashColor),
                          ],
                        ),
                      )
                  ),
                  const Spacer(),
                  MyFancyButton(
                      width: MediaQuery.of(context).size.width*0.5,
                      height: 50.h,
                      borderRadius:10.r,
                      isIconButton: false,
                      isGradient: true,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1E90FF),
                          Color(0xFF1560BD),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      fontSize: 14.sp,
                      family: "Poppins",
                      text: "Continue", tap: (){
                    if(context.read<JobsTodoProvider>().pickImage==null){
                      showDialog(context: context, builder: (context){
                        return const MySimpleDialog(title: "Error", msg: "Please Select Pick Up Image",
                          icon:FeatherIcons.alertTriangle,);
                      });
                    }
                    else{
                      context.read<JobsTodoProvider>().updatePickImage(context, advertiseModel);
                    }
                  },
                      buttonColor: darkPurple,
                      hasShadow: true),
                  SizedBox(height: 20.h),
                ],
              )
          ),
        ),
      )
    );
  }

  Widget bottomSheet(BuildContext context) {
    return SizedBox(
      height: 180.h,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(18.0),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconCreation(
                  Icons.image, Colors.purple, "Image",(){
                context.read<JobsTodoProvider>().imagePickerMethodPick(context,ImageSource.gallery);
              }),
              SizedBox(
                width: 40.w,
              ),
              iconCreation(Icons.camera, Colors.pink, "Camera",
                      (){
                    context.read<JobsTodoProvider>().imagePickerMethodPick(context,ImageSource.camera);
                  }),

            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(
      IconData icons, Color color, String text, GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 30.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: 14.sp,
                fontFamily: "Poppins",
                color: dashColor
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

}
