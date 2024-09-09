import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parcelroo_driver_app/enums/gobals.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:parcelroo_driver_app/views/activeJobs/active_jobs.dart';
import 'package:parcelroo_driver_app/views/availableJobs/available_jobs.dart';
import 'package:parcelroo_driver_app/views/cancelledJobs/cancelled_jobs.dart';
import 'package:parcelroo_driver_app/views/completedJobs/completed_jobs.dart';
import 'package:parcelroo_driver_app/views/dashboard/controller/dash_provider.dart';
import 'package:parcelroo_driver_app/views/dashboard/widgets/dash_widget.dart';
import 'package:parcelroo_driver_app/views/jobsTodo/jobs_todo.dart';
import 'package:parcelroo_driver_app/views/joinCompany/join_company.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import '../../enums/color_constants.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/drawerWidget.dart';
import '../../widgets/my_company_widget.dart';
import '../chat/chat_list.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);


  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DashProvider>(context, listen: false)
          .checkUserActive(context);
    });
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
        title: myText(text: "Driver Dashboard", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 20.sp, color: whiteColor),
      centerTitle: true,
      ),
      body: LoadingAnimation(
        inAsyncCall: context.watch<DashProvider>().isLoading,
        child: Padding(
          padding:const EdgeInsets.all(20),
          child:  SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('drivers').where("uid",isEqualTo: Globals.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            return  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                myText(text: "Your Status is ${doc["status"]}", fontFamily: "Poppins", size: 18.sp, color: whiteColor),
                                Transform.scale(
                                    scale:0.8,
                                    child: CupertinoSwitch(
                                        onChanged: (value){
                                          context.read<DashProvider>().toggleSwitch(value,context);
                                        },
                                        value: context.watch<DashProvider>().isSwitched,
                                        activeColor: switchColor,
                                        trackColor: greyDark,
                                        thumbColor:whiteColor
                                    )
                                ),
                              ],
                            );
                          });
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          myText(text: "Your Status is offline", fontFamily: "Poppins", size: 18.sp, color: whiteColor),
                          Transform.scale(
                              scale:0.8,
                              child: CupertinoSwitch(
                                  onChanged: (val){},
                                  value: false,
                                  activeColor: switchColor,
                                  trackColor: greyDark,
                                  thumbColor:whiteColor
                              )
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(height: 10.h),
                if(context.watch<DashProvider>().companyID.length>1 && context.watch<DashProvider>().isSwitched)...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myText(text: "Switch Company", fontFamily: "Poppins", size: 16.sp, color: whiteColor,fontWeight: FontWeight.w400,),
                      SizedBox(height: 5.h),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection("drivers").doc(Globals.uid).collection("partneredCompany").where("companyID",whereIn: context.read<DashProvider>().companyID).snapshots(),
                          builder: (context,snapshot) {
                            if(snapshot.hasData){
                              return CustomDropDown(hint: "Switch Company",
                                  item: snapshot.data!.docs,
                                  value: context.watch<DashProvider>().activeCompany,
                                  onChanged: (value){
                                    context.read<DashProvider>().switchCompany(value);
                                  },
                                  items: snapshot.data!.docs.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value.get("companyID"),
                                      child:Text(
                                        value.get("companyName"),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.sp,
                                            fontFamily: 'Poppins'),
                                      ),
                                    );
                                  }).toList());
                            }
                            else {
                              return const Center(
                                child: CircularProgressIndicator(color: lightPurple,),
                              );
                            }
                          }
                      ),
                      SizedBox(height: 20.h),
                    ],
                  )
               ],
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //////JOIN A COMPANY
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('drivers').doc(Globals.uid).collection("partneredCompany").snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DashWidget(color: joinCompany, count: snapshot.data!.size.toString(),text: "Join A Company",iconData: FeatherIcons.userPlus,onTap: (){
                                  AppRoutes.push(context, PageTransitionType.fade, const JoinCompany());
                                },);
                              } else {
                                return DashWidget(color: joinCompany, count: "0",text: "Join A Company",iconData: FeatherIcons.userPlus,onTap: (){
                                  AppRoutes.push(context, PageTransitionType.fade, const JoinCompany());
                                },);
                              }
                            },
                          ),
                          DashWidget(color: help, text: "Help",iconData: FeatherIcons.info,onTap: (){},)
                        ],
                      ),
                      SizedBox(height: 20.h),
                      //////AVAILABLE JOBS
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('jobs').where("assignedTo",isEqualTo: "").where("isAdvertised",isEqualTo: true).where("companyId",isEqualTo: context.read<DashProvider>().activeCompany).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DashWidget(color: availJobs,isLarge: true, count:  snapshot.data!.size.toString(),text: "Available Jobs",iconData: FeatherIcons.briefcase,onTap: (){
                              AppRoutes.push(context, PageTransitionType.fade, const AvailableJobs());
                            },);
                          } else {
                            return DashWidget(color: availJobs,isLarge: true, count:  "0",text: "Available Jobs",iconData: FeatherIcons.briefcase,onTap: (){
                              AppRoutes.push(context, PageTransitionType.fade, const AvailableJobs());
                            },);
                          }
                        },
                      ),

                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //////ACTIVE JOBS
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('jobs').where("assignedTo",isEqualTo: Globals.uid.toString()).where("isPicked",isEqualTo: true).where("isComplete",isEqualTo: false).where("companyId",isEqualTo: context.read<DashProvider>().activeCompany).snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DashWidget(color: activeJobs, count:   snapshot.data!.size.toString(),text: "Active Jobs",iconData: FeatherIcons.truck,onTap: (){
                                  AppRoutes.push(context, PageTransitionType.fade, const ActiveJobs());
                                },);
                              } else {
                                return DashWidget(color: activeJobs, count:  "0",text: "Active Jobs",iconData: FeatherIcons.truck,onTap: (){
                                  AppRoutes.push(context, PageTransitionType.fade, const ActiveJobs());
                                },);
                              }
                            },
                          ),
                          //////JOBS TO DO
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('jobs').where("assignedTo",isEqualTo: Globals.uid.toString()).where("isPicked",isEqualTo: false).where("companyId",isEqualTo: context.read<DashProvider>().activeCompany).snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DashWidget(color: toDo, count:  snapshot.data!.size.toString(),text: " Jobs To Do ",iconData: FeatherIcons.rotateCcw,onTap: (){
                                  AppRoutes.push(context, PageTransitionType.fade, const JobsTodo());
                                },);
                              } else {
                                return DashWidget(color: toDo, count:  "0",text: " Jobs To Do ",iconData: FeatherIcons.rotateCcw,onTap: (){
                                  AppRoutes.push(context, PageTransitionType.fade, const JobsTodo());
                                },);
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          //////COMPLETED JOBS
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('drivers').doc(Globals.uid).collection("completedJobs").snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DashWidget(color: completed, count:   snapshot.data!.size.toString(),text: "Completed Jobs",iconData: FeatherIcons.checkCircle,onTap: (){
                                  AppRoutes.push(context, PageTransitionType.fade, const CompletedJobs());
                                },);
                              } else {
                                return DashWidget(color: completed, count:  "0",text: "Completed Jobs",iconData: FeatherIcons.checkCircle,onTap: (){
                                  AppRoutes.push(context, PageTransitionType.fade, const CompletedJobs());
                                },);
                              }
                            },
                          ),
                          //////CANCELLED JOBS
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('drivers').doc(Globals.uid).collection("cancelledJobs").snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DashWidget(color: cancelled, count:   snapshot.data!.size.toString(),text: "Cancelled Jobs",iconData: FeatherIcons.xCircle,onTap: (){
                                  AppRoutes.push(context, PageTransitionType.fade, const CancelledJobs());
                                },);
                              } else {
                                return DashWidget(color: cancelled, count:  "0",text: "Cancelled Jobs",iconData: FeatherIcons.xCircle,onTap: (){
                                  AppRoutes.push(context, PageTransitionType.fade, const CancelledJobs());
                                },);
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      DashWidget(color: messages,isLarge: true, count: "",text: "Messages",iconData: FeatherIcons.messageCircle,onTap: (){
                        AppRoutes.push(context, PageTransitionType.fade, UserChatList());
                      },),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}
