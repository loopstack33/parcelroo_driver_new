import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:parcelroo_driver_app/views/uploadDocuments/controller/upload_doc_controller.dart';
import 'package:parcelroo_driver_app/views/uploadDocuments/widgets/doc_image.dart';
import 'package:parcelroo_driver_app/views/uploadDocuments/widgets/doc_widget.dart';
import 'package:provider/provider.dart';
import '../../../../enums/color_constants.dart';
import '../../../../widgets/text_widget.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/drawerWidget.dart';
import '../../widgets/simple_dialog.dart';


class UploadDocument extends StatefulWidget {
  const UploadDocument({Key? key}) : super(key: key);

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<UploadDocumentProvider>().getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashColor,
      drawer:const DrawerMobileWidget(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon:  Icon(
                Icons.menu,
                color: whiteColor,
                size: 28.sp, // Changing Drawer Icon Size
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor:Colors.transparent,
        elevation: 0,
        title: myText(text: "Upload Documents", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
        centerTitle: true,
      ),
      body: LoadingAnimation(
        inAsyncCall: context.watch<UploadDocumentProvider>().isLoading,
        child: Padding(
          padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 10.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                myText(text: "Step One.", fontFamily: "Poppins", size: 18.sp,fontWeight: FontWeight.w600, color: lightBlue,textAlign: TextAlign.center,),
                SizedBox(height: 10.h),
                myText(text: "Select Documents You Want To Upload.",fontWeight: FontWeight.w600,  fontFamily: "Poppins", size: 15.sp, color: whiteColor,textAlign: TextAlign.center,),
                SizedBox(height: 20.h),

                CustomDropDown(hint: "Select Image Type",
                    item: context.read<UploadDocumentProvider>().types,
                    value: context.watch<UploadDocumentProvider>().selectedType==""?null:context.watch<UploadDocumentProvider>().selectedType,
                    onChanged: (value){
                      context.read<UploadDocumentProvider>().changeType(value);
                    },
                    items:context.read<UploadDocumentProvider>().types.map((value) {
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
                SizedBox(height: 30.h),
                if(context.watch<UploadDocumentProvider>().selectedType=="Passport Page")...[
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      ///PASSPORT IMAGE
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          showModalBottomSheet(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (builder) => bottomSheet(context, "1"));
                        },
                        child:
                        context.read<UploadDocumentProvider>().downloadURL1==""?
                        DocWidget(text: "Passport Front Page",hasTwo: false,tap:(){},uploaded:context.watch<UploadDocumentProvider>().passport!=null?true: false,):
                        DocImageWidget(url: context.read<UploadDocumentProvider>().downloadURL1,text: "Passport Front Page",uploaded:context.watch<UploadDocumentProvider>().passport!=null?true: false,),
                      ),
                      ///PASSPORT IMAGE
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          showModalBottomSheet(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (builder) => bottomSheet(context, "11"));
                        },
                        child: context.read<UploadDocumentProvider>().downloadURL11==""?
                        DocWidget(text: "Passport Front Back",hasTwo: false,tap:(){},uploaded:context.watch<UploadDocumentProvider>().passportBack!=null?true: false,):
                        DocImageWidget(url: context.read<UploadDocumentProvider>().downloadURL11,text: "Passport Back Page",
                            uploaded:context.watch<UploadDocumentProvider>().passportBack!=null?true: false),
                      ),
                    ],
                  )
                ],

                if(context.watch<UploadDocumentProvider>().selectedType=="Full Driving license")...[
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      ////DRIVING LICENSE
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          showModalBottomSheet(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (builder) => bottomSheet(context, "2"));
                        },
                        child: context.read<UploadDocumentProvider>().downloadURL2==""?
                        DocWidget(text: " Full Driving license Front",hasTwo: false,tap:(){
                        },uploaded:context.watch<UploadDocumentProvider>().license!=null?true: false,):
                        DocImageWidget(url: context.read<UploadDocumentProvider>().downloadURL2,text: "Full Driving license Front",
                          uploaded:context.watch<UploadDocumentProvider>().license!=null?true: false,),
                      ),

                      ////DRIVING LICENSE
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          showModalBottomSheet(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (builder) => bottomSheet(context, "22"));
                        },
                        child:context.read<UploadDocumentProvider>().downloadURL22==""?
                        DocWidget(text: " Full Driving license Back",hasTwo: false,tap:(){
                        },uploaded:context.watch<UploadDocumentProvider>().licenseBack!=null?true: false,):
                        DocImageWidget(url: context.read<UploadDocumentProvider>().downloadURL22,text: "Full Driving license Back",
                          uploaded:context.watch<UploadDocumentProvider>().licenseBack!=null?true: false,),
                      ),

                    ],
                  )
                ],

                if(context.watch<UploadDocumentProvider>().selectedType=="Updated Bank Statements")...[
                  ///BANKS STATEMENTS
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      showModalBottomSheet(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (builder) => bottomSheet(context, "3"));
                    },
                    child:context.read<UploadDocumentProvider>().downloadURL3==""?
                    DocWidget(text: "Updated Bank Statements",hasTwo: false,tap:(){

                    },uploaded:context.watch<UploadDocumentProvider>().statement!=null?true: false,):
                    DocImageWidget(url: context.read<UploadDocumentProvider>().downloadURL3,text: "Updated Bank Statements",
                        uploaded:context.watch<UploadDocumentProvider>().statement!=null?true: false),
                  ),
                ],

                if(context.watch<UploadDocumentProvider>().selectedType=="Vehicle Insurance")...[
                  ///VEHICLE INSURANCE
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      showModalBottomSheet(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (builder) => bottomSheet(context, "4"));
                    },
                    child:context.read<UploadDocumentProvider>().downloadURL4==""?
                    DocWidget(text: "Vehicle Insurance",hasTwo: false,tap:(){

                    },uploaded:context.watch<UploadDocumentProvider>().insurance!=null?true: false,):
                    DocImageWidget(url: context.read<UploadDocumentProvider>().downloadURL4,text: "Vehicle Insurance",
                        uploaded:context.watch<UploadDocumentProvider>().insurance!=null?true: false),
                  ),
                ],

                if(context.watch<UploadDocumentProvider>().selectedType=="Goods In Transit Insurance")...[
                  ///TRANSIT INSURANCE
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      showModalBottomSheet(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (builder) => bottomSheet(context, "5"));
                    },
                    child: context.read<UploadDocumentProvider>().downloadURL5==""?
                    DocWidget(text: "Goods In Transit Insurance",hasTwo: false,tap:(){

                    },uploaded:context.watch<UploadDocumentProvider>().transit!=null?true: false,):
                    DocImageWidget(url: context.read<UploadDocumentProvider>().downloadURL5,text: "Goods In Transit Insurance",uploaded:context.watch<UploadDocumentProvider>().transit!=null?true: false),
                  ),
                ],

                if(context.watch<UploadDocumentProvider>().selectedType=="Liability Insurance")...[
                  ///LIABILITY INSURANCE
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      showModalBottomSheet(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (builder) => bottomSheet(context, "6"));
                    },
                    child:  context.read<UploadDocumentProvider>().downloadURL6==""?
                    DocWidget(text: "Liability Insurance",hasTwo: false,tap:(){

                    },uploaded:context.watch<UploadDocumentProvider>().liability!=null?true: false,):
                    DocImageWidget(url: context.read<UploadDocumentProvider>().downloadURL6,text: "Liability Insurance",
                      uploaded:context.watch<UploadDocumentProvider>().liability!=null?true: false,),
                  ),
                ],
                if(context.watch<UploadDocumentProvider>().selectedType=="National Identity card \n/ Citizen Card")...[
                  ///NIC
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      showModalBottomSheet(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (builder) => bottomSheet(context, "7"));
                    },
                    child:  context.read<UploadDocumentProvider>().downloadURL7==""?
                    DocWidget(text: "National Identity card / Citizen Card",hasTwo: false,tap:(){},uploaded:context.watch<UploadDocumentProvider>().nic!=null?true: false,):
                    DocImageWidget(url: context.read<UploadDocumentProvider>().downloadURL7,text: "National Identity card \n/ Citizen Card",
                      uploaded:context.watch<UploadDocumentProvider>().nic!=null?true: false,),
                  ),
                ],

               SizedBox(height: 30.h),
                myText(text: "Step Two.", fontFamily: "Poppins", size: 18.sp,fontWeight: FontWeight.w600, color: lightBlue,textAlign: TextAlign.center,),
                SizedBox(height: 20.h),
                MyFancyButton(
                    margin: EdgeInsets.only(bottom: 30.h),
                    width: MediaQuery.of(context).size.width*0.5,
                    borderRadius:40.r,
                    isIconButton: false,
                    isGradient: true,
                    gradient:
                    const LinearGradient(
                      colors: [
                        darkPurple,
                        Color(0xFF6610F2),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    fontSize: 22.sp,
                    family: "Poppins",
                    text: "Submit", tap: (){
                        if(context.read<UploadDocumentProvider>().imageSelected==false){
                        showDialog(context: context, builder: (context){
                          return  const MySimpleDialog(title: "Error", msg: "Select At Least One Document",
                            icon:FeatherIcons.alertTriangle,);
                        });
                      }
                      else{
                      context.read<UploadDocumentProvider>().checkDocsExists(context, Globals.uid.toString());
                      }
                },
                    buttonColor: darkPurple,
                    hasShadow: true),
              ],
            ),
          ),
        ),
      )
    );
  }


  Widget bottomSheet(BuildContext context, no) {
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
                context.read<UploadDocumentProvider>().imagePickerMethod(context, no,ImageSource.gallery);
              }),
              SizedBox(
                width: 40.w,
              ),
              iconCreation(Icons.camera, Colors.pink, "Camera",
                      (){
                        context.read<UploadDocumentProvider>().imagePickerMethod(context, no,ImageSource.camera);
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
