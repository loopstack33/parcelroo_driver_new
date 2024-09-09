import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/models/advertise_model.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/controller/jobs_todo_controller.dart';
import 'package:provider/provider.dart';
import '../../../enums/color_constants.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/simple_dialog.dart';
import '../../../widgets/text_widget.dart';
import '../../chat/chat_list.dart';

class TodoDropPasswordScreen extends StatelessWidget {
  final AdvertiseModel advertiseModel;
  const TodoDropPasswordScreen({Key? key,required this.advertiseModel}) : super(key: key);


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
      body: Container(
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
                myText(text: "Password", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 24.sp, color: dashColor),
                SizedBox(height: 20.h),
                myText(text: "Please Type In Password From Customer", fontFamily: "Poppins",fontWeight: FontWeight.w400, size: 18.sp, color: dashColor),
                SizedBox(height: 10.h),
                Padding(
                  padding:const EdgeInsets.only(left: 10,right: 10),
                  child: CustomTextField(
                      controller: context.read<JobsTodoProvider>().dropPassController,
                      hint: "Customer Password",
                      )),
                const Spacer(),
                Padding(
                  padding:const EdgeInsets.only(left: 10,right: 10),
                  child: CustomTextField(
                      controller: context.read<JobsTodoProvider>().dropOverrideController,
                      hint: "Override Password",
                     )),
                SizedBox(height: 10.h),
                myText(text: "Manual Override Passcode Request From Service Provider", fontFamily: "Poppins",fontWeight: FontWeight.w400, size: 18.sp, color: dashColor,textAlign: TextAlign.center,),
                SizedBox(height: 20.h),
                MyFancyButton(
                    width: MediaQuery.of(context).size.width*0.5,
                    height: 50.h,
                    borderRadius:10.r,
                    isIconButton: false,
                    isGradient: true,
                    gradient:const LinearGradient(
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
                  if(context.read<JobsTodoProvider>().dropPassController.text.isEmpty && context.read<JobsTodoProvider>().dropOverrideController.text.isEmpty){
                    showDialog(context: context, builder: (context){
                      return const MySimpleDialog(title: "Error", msg: "Please Enter Customer Password",
                        icon:FeatherIcons.alertTriangle,);
                    });
                  }
                  else {
                  if(context.read<JobsTodoProvider>().dropOverrideController.text.isNotEmpty){
                        context.read<JobsTodoProvider>().checkDropOverPass(context,advertiseModel);
                      }
                      else{
                        context.read<JobsTodoProvider>().checkDropPass(context,advertiseModel);
                      }
                    }
                      },
                    buttonColor: darkPurple,
                    hasShadow: true),
                SizedBox(height: 20.h),
              ],
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: dashColor,
        onPressed: (){
          AppRoutes.push(context, PageTransitionType.fade, UserChatList());
        },
        child: Icon(FeatherIcons.messageCircle,size: 30.sp,),
      ),
    );
  }
}
