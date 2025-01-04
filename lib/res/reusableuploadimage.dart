import 'package:flutter/material.dart';
import 'package:flutter_firebase_notifications/res/profileline.dart';
import 'package:flutter_firebase_notifications/res/reusableassetimage.dart';
Widget  reusableuplaodimage(BuildContext context, double radius, Function ontap){
  return InkWell(
    onTap: (){
      ontap();
    },
    child: Stack(
      children: [
        reusableimgornot(context, 150),
        Positioned(
            bottom: 0,
            left: 70,
            child:reusableassetimg(context, "editprofile.png", 0.3, 0.040, BoxFit.contain),
        ),
      ],
    ),
  );
}