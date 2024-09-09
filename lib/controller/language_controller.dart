import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier{
  TextEditingController languageController = TextEditingController();

  Country _country = Country.parse("GB");
  Country get country => _country;

  changeCountry(value){
    _country = value;
    notifyListeners();
  }

}