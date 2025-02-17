import 'package:flutter/material.dart';

InkWell cicleiamgereusable(
    BuildContext context, double radius, String imgpath, Function ontap) {
  return InkWell(
    onTap: () {
      ontap();
    },
    child: CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(left: 5),
          width: MediaQuery.of(context).size.width * 0.5,
          child: Image.asset("assets/$imgpath")),
      // backgroundImage:
      // AssetImage("assets/$imgpath"),
    ),
  );
}
