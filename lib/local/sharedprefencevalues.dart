import 'dart:core';

import 'package:get_storage/get_storage.dart';



class MySharedPrefrence {
  static var preferences;

  static MySharedPrefrence? _instance;

  MySharedPrefrence._() {
    preferences = () => GetStorage('values');
  }

  factory MySharedPrefrence() {
    _instance ??= new MySharedPrefrence._();
    // since you are sure you will return non-null value, add '!' operator
    return _instance!;
  }
  void set_push_token(String? pushtoken) {
    ''.val('push_token', getBox: preferences).val = pushtoken ?? '';
  }

  String get_push_token() {
    return ''.val('push_token', getBox: preferences).val;
  }
  void set_api_path(String? user_name) {
    ''.val('api_path', getBox: preferences).val = user_name ?? '';
  }

  String get_api_path() {
    return ''.val('api_path', getBox: preferences).val;
  }

  bool getUserLoginStatus() {
    return false.val('user_login_status', getBox: preferences).val;
  }

  void setUserLoginStatus(bool? alarmStatus) {
    false.val('user_login_status', getBox: preferences).val =
        alarmStatus ?? false;
  }

  void set_user_id(String? user_id) {
    ''.val('user_id', getBox: preferences).val = user_id ?? '';
  }


 
  String get_user_id() {
    return ''.val('user_id', getBox: preferences).val;
  }

  void set_user_name(String? userCurrentLocation) {
    ''.val('user_name', getBox: preferences).val = userCurrentLocation ?? '';
  }

  String get_user_name() {
    return ''.val('user_name', getBox: preferences).val;
  }

  void set_user_contact(String? userCurrentLocation) {
    ''.val('contact', getBox: preferences).val = userCurrentLocation ?? '';
  }

  String get_user_contact() {
    return ''.val('contact', getBox: preferences).val;
  }

  void set_user_image(String? userCurrentLocation) {
    ''.val('image', getBox: preferences).val = userCurrentLocation ?? '';
  }

  String get_user_image() {
    return ''.val('image', getBox: preferences).val;
  }
void set_clt_contact(String?User_clt_contact) {
    ''.val('clt_contact', getBox: preferences).val = User_clt_contact?? '';
  }

  String get_clt_contact() {
    return ''.val('clt_contact', getBox: preferences).val;
  }

  void set_clt_email(String? User_clt_email) {
    ''.val('User_clt_email', getBox: preferences).val = User_clt_email?? '';
  }

  String get_clt_email() {
    return ''.val('User_clt_email', getBox: preferences).val;
  }
  void set_certificate_status(String?certificate_status) {
    '0'.val('certificate_status', getBox: preferences).val = certificate_status?? '0';
  }

  String get_certificate_status() {
    return '0'.val('certificate_status', getBox: preferences).val;
  }

  void set_certificate_link(String? certificate_link) {
    '0'.val('certificate_link', getBox: preferences).val = certificate_link?? '0';
  }

  String get_certificate_link() {
    return '0'.val('certificate_link', getBox: preferences).val;
  }

 void set_login_code(String? setlogincode) {
    ''.val('login_code', getBox: preferences).val = setlogincode ?? '';
  }

  String get_login_code() {
    return ''.val('login_code', getBox: preferences).val;
  }


  void logout() {
    preferences().erase();
  }
}
