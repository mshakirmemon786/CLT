import 'package:flutter/material.dart';
Widget reusableassetimg(BuildContext context, String imgpath, double width,
    double height, BoxFit boxFit) {
  return Image.asset(
    "assets/$imgpath",
    fit: boxFit,
    width: MediaQuery.of(context).size.width * width,
    height: MediaQuery.of(context).size.height * height,
  );
}