import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';
import 'package:parcelroo_driver_app/enums/image_constants.dart';
import 'package:parcelroo_driver_app/views/completedJobs/controller/completed_job_controller.dart';
import 'package:parcelroo_driver_app/views/completedJobs/widgets/completedJobs_widget.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../enums/color_constants.dart';
import '../../models/advertise_model.dart';
import '../../utils/app_routes.dart';
import '../../widgets/text_widget.dart';

class CompletedJobs extends StatelessWidget {
  const CompletedJobs({Key? key}) : super(key: key);

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
          title: myText(text: "Completed Jobs", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20.h,left: 10.w,right: 10.w),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2023, 3, 14),
                lastDay: DateTime.now(),
                focusedDay: DateTime.now(),
                calendarFormat: CalendarFormat.week,
                pageJumpingEnabled: false,
                headerStyle: HeaderStyle(
                    leftChevronIcon : const Icon(Icons.chevron_left,color: whiteColor),
                    rightChevronIcon : const Icon(Icons.chevron_right,color: whiteColor),
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: whiteColor)),
                calendarStyle: CalendarStyle(
                    selectedTextStyle: TextStyle(
                        color: dashColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins'),
                    todayTextStyle: TextStyle(
                        color: dashColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins'),
                    selectedDecoration: const BoxDecoration(
                        color: whiteColor, shape: BoxShape.circle),
                    todayDecoration: const BoxDecoration(
                        color: bGrey, shape: BoxShape.circle),
                    markersAlignment: Alignment.topCenter,
                    defaultTextStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: whiteColor)),
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12.sp,
                        color: whiteColor),
                    weekendStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12.sp,
                        color: whiteColor)),
                selectedDayPredicate: (day) {
                  return isSameDay(context.read<CompletedJobController>().selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  context.read<CompletedJobController>().changeDay(selectedDay,focusedDay);
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('drivers').doc(Globals.uid).collection("completedJobs").where("pickDate",isEqualTo: DateFormat("dd-MM-yyyy").format(context.watch<CompletedJobController>().focusedDay)).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.docs.length.toString()!="0"?
                    ListView.builder(
                      physics:const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                      AdvertiseModel advertiseModel = AdvertiseModel.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                      return  Padding(padding:const EdgeInsets.all(10),
                          child: CompletedJobsWidget(
                              advertiseModel:advertiseModel
                          ));
                    },
                      itemCount: snapshot.data!.docs.length,shrinkWrap: true,):
                    Center(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          Image.asset(logo,height: 150.h,),
                          SizedBox(height: 10.h),
                          myText(text: "No Completed Jobs Found", fontFamily: "Poppins", size: 25.sp, color:Colors.white),
                        ],
                      ),
                    );
                  }
                  else if (snapshot.hasError) {
                    return Center(
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10.h),
                          Image.asset(logo,height: 150.h,),
                          SizedBox(height: 10.h),
                          myText(text: "No Completed Jobs Found", fontFamily: "Poppins", size: 25.sp, color:Colors.white),
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
            ],
          )
        )
    );
  }
}
