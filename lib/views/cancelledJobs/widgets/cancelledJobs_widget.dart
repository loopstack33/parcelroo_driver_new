// ignore_for_file: file_names

import 'package:fancy_button_new/fancy_button_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/models/advertise_model.dart';
import 'package:parcelroo_driver_app/views/cancelledJobs/widgets/details_popup.dart';
import 'package:parcelroo_driver_app/widgets/box_widget.dart';
import 'package:parcelroo_driver_app/widgets/my_company_widget.dart';
import '../../../widgets/address_widget.dart';

class CancelledJobsWidget extends StatelessWidget {
  final AdvertiseModel advertiseModel;
  const CancelledJobsWidget({Key? key,required this.advertiseModel}) : super(key: key);

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
          AddressWidget(hasNavigation: false,isOther: true,color: pickUpColor,time: advertiseModel.pickTimeType.toString()=="" || advertiseModel.pickTimeType.toString()=="null"? advertiseModel.pickTime.toString():  "${advertiseModel.pickTimeType.toString()} ${advertiseModel.pickTime.toString()}",date:advertiseModel.pickDate.toString(),address: advertiseModel.pickAddress.toString(),type: "Pick Up Details",name:advertiseModel.pickCustomer.toString(),email:advertiseModel.pickEmail.toString(),contact: advertiseModel.pickContact.toString()),
          AddressWidget(hasNavigation: false,isOther: true,color: dropOffColor,time: advertiseModel.dropTimeType.toString()=="" || advertiseModel.dropTimeType.toString()=="null"? advertiseModel.dropTime.toString():  "${advertiseModel.dropTimeType.toString()} ${advertiseModel.dropTime.toString()}",date: advertiseModel.dropDate.toString(),address: advertiseModel.dropAddress.toString(),type: "Drop Off Details",name:advertiseModel.dropCustomer.toString(),email: advertiseModel.dropEmail.toString(),contact: advertiseModel.dropContact.toString()),
          SizedBox(height: 30.h),
          MyFancyButton(
              width: MediaQuery.of(context).size.width*0.5,
              height: 50.h,
              borderRadius:20.r,
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
              fontSize: 18.sp,
              family: "Poppins",
              text: "Details", tap: (){
            showDialog(context: context, builder: (context){
              return  DetailsPopup(
                reason: advertiseModel.cancellationReason.toString(),
              );
            });
          },
              buttonColor: darkPurple,
              hasShadow: true),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
