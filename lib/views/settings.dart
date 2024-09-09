import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../enums/color_constants.dart';
import '../widgets/drawerWidget.dart';
import '../widgets/text_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{

  bool isSwitched = true;

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
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
          title: myText(text: "Settings", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
          centerTitle: true,
        ),
        body:  Padding(
          padding:const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myText(text: "Notification Alerts On ", fontFamily: "Poppins",fontWeight: FontWeight.w500, size: 20.sp, color: whiteColor),
              Transform.scale(
                  scale:0.8,
                  child: CupertinoSwitch(
                      onChanged: toggleSwitch,
                      value: isSwitched,
                      activeColor: switchColor,
                      trackColor: greyDark,
                      thumbColor:whiteColor
                  )
              ),
            ],
          ),
        )
    );
  }

}
