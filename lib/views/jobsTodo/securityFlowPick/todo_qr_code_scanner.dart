
import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/enums/image_constants.dart';
import 'package:provider/provider.dart';
import '../../../enums/color_constants.dart';
import '../../../models/advertise_model.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/utilities.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/simple_dialog.dart';
import '../../../widgets/text_widget.dart';
import '../../chat/chat_list.dart';
import '../controller/jobs_todo_controller.dart';

class TodoPickQrScanner extends StatefulWidget {
  final AdvertiseModel advertiseModel;
  const TodoPickQrScanner({Key? key,required this.advertiseModel}) : super(key: key);

  @override
  State<TodoPickQrScanner> createState() => _TodoPickQrScannerState();
}

class _TodoPickQrScannerState extends State<TodoPickQrScanner> {


  String result = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<JobsTodoProvider>().addSelected(widget.advertiseModel.barCodes!.toList());
  }

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
        backgroundColor: Colors.transparent,
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
        child: SingleChildScrollView(
            padding:const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                myText(text: "Barcode Scan", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 22.sp, color: dashColor),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () async{
                    try{
                      final qrCode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true,widget.advertiseModel.pickScanType=="Barcode"? ScanMode.BARCODE:
                      ScanMode.QR);

                      if (!mounted) return;

                      setState(() {
                        result = qrCode;
                      });

                    } on PlatformException {
                      result = 'Failed to scan QR Code.';
                    }

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    height: 100,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: lGrey,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                              color: bGrey.withOpacity(0.25),
                              blurRadius: 4.r
                          )
                        ]
                    ),
                    child: Image.asset(camera),
                  )
                ),
                result==""? const SizedBox():myText(text: "Scanned Result: $result",
                  fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 20.sp, color: dashColor,textAlign: TextAlign.center),
                SizedBox(height: 20.h),
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: lGrey,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: bGrey.withOpacity(0.25),
                        blurRadius: 4.r
                      )
                    ]
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: bGrey,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                  color: bGrey.withOpacity(0.25),
                                  blurRadius: 4.r
                              )
                            ]
                        ),
                        child: myText(text: "Scan The Following Items", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 16.sp, color: dashColor),
                      ),
                      SizedBox(height: 20.h),
                      ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                myText(
                                  text: obscureString(widget.advertiseModel.barCodes![index].toString()),
                                  fontFamily: "Poppins",fontWeight: FontWeight.w400, size: 20.sp, color: dashColor,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    context.read<JobsTodoProvider>().check(index,widget.advertiseModel.barCodes![index].toString(),result,context);
                                  },
                                  child: Container(
                                    padding:const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: context.watch<JobsTodoProvider>().selected[index]==true? Colors.greenAccent:whiteColor,
                                        borderRadius: BorderRadius.circular(5.r),
                                        border: Border.all(color: dashColor)
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                      itemCount: widget.advertiseModel.barCodes!.length,),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding:const EdgeInsets.only(left: 10,right: 10,top: 10),
                  child: CustomTextField(
                      controller: context.read<JobsTodoProvider>().overrideController,
                      hint: "Override Password",
                  )),
                SizedBox(height: 10.h),
                myText(text: "Manual Override Passcode Request From Service Provider",
                  fontFamily: "Poppins",fontWeight: FontWeight.w400, size: 18.sp, color: dashColor,textAlign: TextAlign.center,),
                SizedBox(height: 20.h),
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
                  if(context.read<JobsTodoProvider>().overrideController.text.isNotEmpty){
                    context.read<JobsTodoProvider>().checkPickOverPass(context,widget.advertiseModel);
                  }
                  else{
                    if(context.read<JobsTodoProvider>().selected.where((element) => element==false).isNotEmpty){
                      showDialog(context: context, builder: (context){
                        return const MySimpleDialog(title: "Error", msg: "Scan All Codes",
                          icon:FeatherIcons.alertTriangle,);
                      });
                    }
                    else{
                      showDialog(context: context, builder: (context){
                        return const MySimpleDialog(title: "Success", msg: "All Codes Scanned",
                          icon:FeatherIcons.checkCircle,);
                      });
                      context.read<JobsTodoProvider>().completePickUp(widget.advertiseModel,context);
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
