
import 'package:flutter/material.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:parcelroo_driver_app/widgets/text_widget.dart';

class TextContainer extends StatelessWidget {
  final String text;
  const TextContainer({Key? key,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding:const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: whiteColor,
        border: Border.all(color: const Color(0xFF6C6A6A))
      ),
      child: Center(
        child:  myText(text:text,
            fontFamily: "Poppins", size: 16,
            fontWeight: FontWeight.w400, color: drawerColor),
      ),
    );
  }
}
