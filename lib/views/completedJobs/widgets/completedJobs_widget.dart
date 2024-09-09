// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/widgets/box_widget.dart';
import 'package:parcelroo_driver_app/widgets/my_company_widget.dart';
import '../../../models/advertise_model.dart';
import '../../../widgets/address_widget.dart';

class CompletedJobsWidget extends StatelessWidget {
  final AdvertiseModel advertiseModel;

  const CompletedJobsWidget({Key? key,required this.advertiseModel}) : super(key: key);

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
        ],
      ),
    );
  }
}
