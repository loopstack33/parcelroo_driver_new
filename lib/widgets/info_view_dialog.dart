// ignore_for_file: must_be_immutable, file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'close_widget.dart';


class InfoViewDialog extends StatelessWidget {
  final String image;
  const InfoViewDialog({Key? key,required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        elevation: 10,
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: whiteColor,
        child: Container(
            width:MediaQuery.of(context).size.width*0.9,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xffdfe0eb), width: 1, ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x192f80ed),
                  blurRadius: 40,
                  offset: Offset(5, 5),
                ),
              ],
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              padding:const EdgeInsets.all(10),
              child:  Column(
                children: [
                  const CloseWidget(),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(image.toString(),
                      width: MediaQuery.of(context).size.width*0.9,
                      height: MediaQuery.of(context).size.height*0.4,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Padding(
                            padding:const EdgeInsets.all(8),
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                                color: dashColor,
                                strokeWidth: 2,
                              ),
                            )
                        );
                      },
                      errorBuilder: (context, url, error) =>
                          Image.asset(
                              "assets/images/dummy.jpeg",width: 120,height: 120),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
        )
    );
  }

}
