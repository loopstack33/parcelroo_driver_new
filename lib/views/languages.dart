import 'package:country_picker/country_picker.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parcelroo_driver_app/controller/language_controller.dart';
import 'package:provider/provider.dart';
import '../enums/color_constants.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/drawerWidget.dart';
import '../widgets/text_widget.dart';

class Languages extends StatelessWidget {
  const Languages({Key? key}) : super(key: key);

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
        title: myText(text: "Language", fontFamily: "Poppins",fontWeight: FontWeight.w700, size: 24.sp, color: whiteColor),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myText(text: "Please Select One Language",
                fontFamily: "Poppins", size: 18.sp,
                fontWeight: FontWeight.w400, color: whiteColor,textAlign: TextAlign.center,),
            SizedBox(height: 30.h),
              myText(text: "Current Languages",
                  fontFamily: "Poppins", size: 20.sp,
                  fontWeight: FontWeight.w600, color: whiteColor,textAlign: TextAlign.center),
              SizedBox(height: 50.h),
              GestureDetector(
                onTap: (){
                  showCountryPicker(
                    context: context,
                    countryFilter: <String>['GB','IN','PK'],
                    showPhoneCode: false,
                    onSelect: (Country country) {
                      context.read<LanguageProvider>().changeCountry(country);
                    },
                    countryListTheme: CountryListThemeData(
                      bottomSheetHeight: MediaQuery.of(context).size.height*0.5,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontFamily: "Poppins"
                      ),
                      // Optional. Styles the search field.
                      inputDecoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Start typing to search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                      // Optional. Styles the text in the search field
                      searchTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontFamily: "Poppins"
                      ),
                    ),
                  );
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child:CustomTextField(controller: context.read<LanguageProvider>().languageController, hint: context.read<LanguageProvider>().country.name.toString(),
                    prefixIcon: IconButton(
                      icon: Text(context.watch<LanguageProvider>().country.flagEmoji,style: TextStyle(fontSize: 20.sp),), onPressed: () {  },
                    ),
                    suffixIcon: Icon(
                      FeatherIcons.chevronDown,
                      size: 20.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

            ],
          ),
        )
    );
  }
}
