import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import '../enums/color_constants.dart';
import '../utils/app_routes.dart';

class CloseWidget extends StatelessWidget {
  const CloseWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ()=> AppRoutes.pop(context),
        child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(FeatherIcons.x,color: dashColor,size: 20,),
                  SizedBox(width: 10),
                  Text("Close",style: TextStyle(fontSize:14,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: dashColor)),
                ],
              ),
            )
        )
    );
  }
}
