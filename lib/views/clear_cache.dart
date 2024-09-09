import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/utils/loading_animation.dart';
import 'package:parcelroo_driver_app/views/dashboard/controller/dash_provider.dart';
import 'package:provider/provider.dart';

import '../enums/color_constants.dart';
import '../widgets/drawerWidget.dart';
import '../widgets/text_widget.dart';

class ClearCache extends StatelessWidget {
  const ClearCache({Key? key}) : super(key: key);

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
        title: myText(text: "Clear Cache", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
        centerTitle: true,
      ),
      body: LoadingAnimation(
    inAsyncCall: context.watch<DashProvider>().clearing,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(flex: 1,),
            myText(text: "Clearing the cache simply clears temporary files. Please note it will NOT delete your Login credentials or Job history. This will fix loading issues and is recommended to do this as often as possible",
              fontFamily: "Poppins", size: 18.sp,
              fontWeight: FontWeight.w400, color: whiteColor,textAlign: TextAlign.center,),
            const Spacer(flex: 2,),
            GestureDetector(
              onTap: ()=> context.read<DashProvider>().clearCache(context),
              child: myText(text: "Clear cache",
                  textDecoration:TextDecoration.underline,
                  fontFamily: "Poppins", size: 25.sp,
                  fontWeight: FontWeight.w600, color: const Color(0xFF70D930),textAlign: TextAlign.center),
            ),
            const Spacer(flex: 2,),
          ],
        ),
      )
      ),
    );
  }
}
