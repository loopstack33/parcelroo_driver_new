import 'package:flutter/cupertino.dart';

class CancelledJobController extends ChangeNotifier{
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  changeDay(day1,day2){
    selectedDay = day1;
    focusedDay = day2;
    notifyListeners();
  }
}