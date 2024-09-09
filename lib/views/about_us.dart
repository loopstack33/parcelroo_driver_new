import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/utils/app_routes.dart';

import '../enums/color_constants.dart';
import '../widgets/drawerWidget.dart';
import '../widgets/text_widget.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: dashColor,
        drawer:const DrawerMobileWidget(),
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
          title: myText(text: "About us & Version", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(flex: 1,),
              myText(text: "Our Journey we got fucked by many pakistanis until an angel named samii came along and made this happen",
                fontFamily: "Poppins", size: 20.sp,
                fontWeight: FontWeight.w400, color: whiteColor,textAlign: TextAlign.center,),
              const Spacer(flex: 2,),
              myText(text: "Version 1.0.0",
                  fontFamily: "Poppins", size: 22.sp,
                  fontWeight: FontWeight.w500, color: whiteColor,textAlign: TextAlign.center),
              const Spacer(flex: 2,),
            ],
          ),
        )
    );
  }
}
