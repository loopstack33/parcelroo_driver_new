
// ignore_for_file: use_build_context_synchronously


import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcelroo_driver_app/enums/image_constants.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:provider/provider.dart';
import '../../enums/color_constants.dart';
import '../../models/advertise_model.dart';
import '../../utils/app_routes.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/simple_dialog.dart';
import '../../widgets/text_widget.dart';
import '../dashboard/dashboard.dart';
import 'controller/jobs_todo_controller.dart';

class PODScreen extends StatelessWidget {
  final AdvertiseModel advertiseModel;
  const PODScreen({Key? key,required this.advertiseModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
      AppRoutes.pushAndRemoveUntil(context, const Dashboard());
      return true;
    },
    child: Scaffold(
      backgroundColor: dashColor,
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(
            FeatherIcons.chevronLeft,
            color: whiteColor,
            size: 28.sp, // Changing Drawer Icon Size
          ),
          onPressed: () {
            AppRoutes.pushAndRemoveUntil(context, const Dashboard());
          },
        ),
        backgroundColor:Colors.transparent,
        elevation: 0,
        title: myText(text: "POD", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 20.sp, color: whiteColor),
        centerTitle: true,
      ),
      body: LoadingAnimation(
        inAsyncCall: context.watch<JobsTodoProvider>().isComplete,
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r),topRight: Radius.circular(15.r)),
                border: Border.all(color: textFieldColor,width: 1.w)
            ),
            child: Form(
              key: context.read<JobsTodoProvider>().formKey,
              child: SingleChildScrollView(
                padding:const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myText(text: "POD (Proof Of Delivery).", fontFamily: "Poppins",fontWeight: FontWeight.w400, size: 18.sp, color: dashColor),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      controller: context.read<JobsTodoProvider>().recipientController,
                      hint: "Name Of Recipient",
                      validator: (value) {
                        if(value ==null || value.isEmpty){
                          return "Please Enter Your Name Of Recipient";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomDropDown(hint: "Select Location",
                        item: context.read<JobsTodoProvider>().items,
                        value: context.watch<JobsTodoProvider>().selectedLocation,
                        onChanged: (value){
                          context.read<JobsTodoProvider>().changeLocation(value);
                        },
                        items: context.read<JobsTodoProvider>().items.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child:Text(
                              value.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontFamily: 'Poppins'),
                            ),
                          );
                        }).toList()),
                    if(context.watch<JobsTodoProvider>().selectedLocation.toString().trim()=="Other (Please Specify)")...[
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: context.read<JobsTodoProvider>().locationController,
                        hint: "Special Location: Other (Please Specify)",
                      ),
                      SizedBox(height: 20.h),
                      context.read<JobsTodoProvider>().customerPic==null?
                      Center(
                          child: Image.asset(imagePick,height: 250.h)
                      ):
                      Center(
                        child: Image.file(context.read<JobsTodoProvider>().customerPic!,height: 250.h),
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
                                myText(text: "Press To Take Customer Picture", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 18.sp, color: dashColor),
                              ],
                            ),
                          )
                      )
                    ],
                    SizedBox(height: 20.h),
                    Center(
                      child: MyFancyButton(
                          width: MediaQuery.of(context).size.width*0.55,
                          height: 50.h,
                          borderRadius:10.r,
                          isIconButton: false,
                          isGradient: true,
                          gradient: const LinearGradient(
                            colors: [
                              darkPurple,
                              Color(0xFF6610F2),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          fontSize: 16.sp,
                          family: "Poppins",
                          text: "Finish", tap: () async{
                        if (context.read<JobsTodoProvider>().formKey.currentState!.validate()) {
                          if(context.read<JobsTodoProvider>().selectedLocation==null){
                            showDialog(context: context, builder: (context){
                              return const MySimpleDialog(title: "Error", msg: "Select Location",
                                icon:FeatherIcons.alertTriangle,);
                            });
                          }
                          else if(context.read<JobsTodoProvider>().selectedLocation.toString().trim()=="Other (Please Specify)" && context.read<JobsTodoProvider>().locationController.text.isEmpty){
                            showDialog(context: context, builder: (context){
                              return const MySimpleDialog(title: "Error", msg: "Enter Specific Location",
                                icon:FeatherIcons.alertTriangle,);
                            });
                          }
                          else if(context.read<JobsTodoProvider>().selectedLocation.toString().trim()=="Other (Please Specify)" && context.read<JobsTodoProvider>().customerPic==null){
                            showDialog(context: context, builder: (context){
                              return const MySimpleDialog(title: "Error", msg: "Please Take Picture",
                                icon:FeatherIcons.alertTriangle,);
                            });
                          }
                          else{
                            context.read<JobsTodoProvider>().getDataOfJob(context, advertiseModel);
                          }
                        }
                      },
                          buttonColor: darkPurple,
                          hasShadow: true),
                    ),

                  ],
                ),
              ),
            )
        ),
      )
    ));
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
                context.read<JobsTodoProvider>().imagePickerMethod(context,ImageSource.gallery);
              }),
              SizedBox(
                width: 40.w,
              ),
              iconCreation(Icons.camera, Colors.pink, "Camera",
                      (){
                    context.read<JobsTodoProvider>().imagePickerMethod(context,ImageSource.camera);
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


