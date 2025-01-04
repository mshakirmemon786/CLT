import 'package:flutter/material.dart';

import '../controller/colors.dart';

Container fieldreusablebtn(BuildContext context, double topsize, double btmsize,
    double height, Widget widget) {
  return Container(
    // margin: EdgeInsets.only(top: topsize,bottom: btmsize),
    height: MediaQuery.of(context).size.height * height,
    width: MediaQuery.of(context).size.width * 0.94,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: colorController
              .normalgreenbtnclr, // Set your desired border color
          width: 2.0, // Set your desired border width
        )),
    padding:
        EdgeInsets.only(top: topsize, left: 10, bottom: btmsize, right: 10),
    child: widget,
  );
}

SizedBox reusablestutus(BuildContext context, String imagepath, String txt) {
  return SizedBox(
    //  height: MediaQuery.of(context).size.height*0.3,

    child: fieldreusablebtn(
        context,
        0,
        0,
        0.45,
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(

                // margin: EdgeInsets.only(top: 18,left: 8,right: 8,bottom:1),
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white)),
                child: Image.asset("assets/$imagepath")),
            Center(
                child: Text(
              txt.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: colorController.normalgreenbtnclr, fontSize: 25),
            ))
          ],
        )),
  );
}
