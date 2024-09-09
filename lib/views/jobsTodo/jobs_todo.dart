import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/widgets/todo_job_widget.dart';
import 'package:provider/provider.dart';
import '../../enums/color_constants.dart';
import '../../enums/gobals.dart';
import '../../enums/image_constants.dart';
import '../../models/advertise_model.dart';
import '../../utils/app_routes.dart';
import '../../widgets/text_widget.dart';
import '../dashboard/controller/dash_provider.dart';

class JobsTodo extends StatelessWidget {

  const JobsTodo({Key? key}) : super(key: key);

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
          title: myText(text: "Jobs To Do", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.only(bottom: 20.h,left: 10.w,right: 10.w),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('jobs').where("assignedTo",isEqualTo: Globals.uid.toString()).where("isPicked",isEqualTo: false).where("companyId",isEqualTo: context.read<DashProvider>().activeCompany).snapshots(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {
                  return snapshot.data!.docs.length.toString()!="0"?
                  ListView.builder(itemBuilder: (context,index){
                    AdvertiseModel advertiseModel = AdvertiseModel.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                    return  Padding(padding:const EdgeInsets.all(10),
                        child: JobsTodoWidget(
                            advertiseModel:advertiseModel
                        ));
                  },
                    itemCount: snapshot.data!.docs.length,shrinkWrap: true,):
                  Center(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(logo,height: 150.h,),
                        SizedBox(height: 10.h),
                        myText(text: "No Jobs Todo Found", fontFamily: "Poppins", size: 25.sp, color:Colors.white),
                      ],
                    ),
                  );
                }
                else if (snapshot.hasError) {
                  return Center(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(logo,height: 150.h,),
                        SizedBox(height: 10.h),
                        myText(text: "No Jobs Todo Found", fontFamily: "Poppins", size: 25.sp, color:Colors.white),
                      ],
                    ),
                  );
                }
                else {
                  return const Center(
                    child:CircularProgressIndicator(color: dashColor),
                  );
                }
              },
            )
        )


    );
  }
}
