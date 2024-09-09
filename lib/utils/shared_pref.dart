import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  static saveEmail(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', username);
    log(username.toString());
  }

  static getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('email');
    return username;
  }

  static saveUserPassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', password);
  }

  static getUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('password');
    return value;
  }

  static saveUserID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', id);
  }

  static getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('uid');
    return value;
  }

  static saveIsLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', value);
  }

  static getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool('isLoggedIn');
    return boolValue;
  }

  static saveRememberMe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('remember_me', value);
  }

  static getRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool('remember_me');
    return boolValue;
  }

}
