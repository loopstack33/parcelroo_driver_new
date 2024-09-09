import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';
import 'package:parcelroo_driver_app/models/advertise_model.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/widgets/box_widget.dart';
import 'package:parcelroo_driver_app/widgets/my_company_widget.dart';
import 'package:provider/provider.dart';
import '../../../widgets/address_widget.dart';
import '../../../widgets/simple_dialog.dart';
import '../controller/available_job_provider.dart';
import 'accept_job_dialog.dart';

class AvailableJobWidget extends StatelessWidget {
  final AdvertiseModel advertiseModel;
  final VoidCallback tap;
  const AvailableJobWidget({Key? key,required this.tap,required this.advertiseModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: textFieldColor,width: 1.w)
      ),
      child: Column(
        children:  [
          Padding(padding: const EdgeInsets.all(10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BoxWidget(isImage: true,text: "Required Vehicle",image: advertiseModel.vehicleRequired.toString()),
                BoxWidget(isImage: false,text: "Payment Terms",detail: advertiseModel.paymentType.toString()),
                BoxWidget(isImage: false,text: "Payment Amount",detail: "${advertiseModel.currency.toString()} ${advertiseModel.price.toString()}"),
              ]
          )),
          Padding(padding:const EdgeInsets.all(10),
              child: MyCompanyWidget(name: advertiseModel.companyName.toString(),isDelete: false,address: advertiseModel.companyAddress.toString(),image: advertiseModel.companyLogo.toString(),)),
          AddressWidget(hasNavigation: false,isOther: false,color: pickUpColor,time: advertiseModel.pickTime.toString(),date:advertiseModel.pickDate.toString(),address: advertiseModel.pickAddress.toString(),type: "Pick Up Details",name:advertiseModel.pickCustomer.toString(),email:advertiseModel.pickEmail.toString(),contact: advertiseModel.pickContact.toString()),
          AddressWidget(hasNavigation: false,isOther: false,color: dropOffColor,time: advertiseModel.dropTime.toString(),date: advertiseModel.dropDate.toString(),address: advertiseModel.dropAddress.toString(),type: "Drop Off Details",name:advertiseModel.dropCustomer.toString(),email: advertiseModel.dropEmail.toString(),contact: advertiseModel.dropContact.toString()),SizedBox(height: 30.h),
          MyFancyButton(
              width: MediaQuery.of(context).size.width*0.5,
              height: 50.h,
              borderRadius:20.r,
              isIconButton: false,
              isGradient: true,
              gradient: advertiseModel.assignedTo.toString()==Globals.uid.toString()?
              confirm
                  :const LinearGradient(
                colors: [
                  darkPurple,
                  Color(0xFF6610F2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              fontSize: 18.sp,
              family: "Poppins",
              text:advertiseModel.assignedTo.toString()==Globals.uid.toString()? "Job Accepted":"Accept Job", tap: (){
                if(advertiseModel.assignedTo.toString()==Globals.uid.toString()){
                  showDialog(context: context, builder: (context){
                    return  const MySimpleDialog(title: "Info", msg: "This Job is Already Assigned To You",
                      icon: FeatherIcons.info,);
                  });
                }
                else{
                  showDialog(context: context, builder: (ctx){
                    return AcceptJobPopup(onTap: tap);
                  });
                }

          },
              buttonColor: darkPurple,
              hasShadow: true),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
