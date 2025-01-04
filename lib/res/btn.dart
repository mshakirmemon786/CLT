import 'dart:io';

import 'package:flutter/material.dart';

import '../controller/colors.dart';

SizedBox reusablebtn(
  BuildContext context,
  String btntext,
  Color clr,
  double width,
  Function ontap,
) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        onPressed: () {
          ontap();
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: clr),
        child: Text(btntext,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: colorController.loginbtnclr)),
      ));
}

SizedBox reusablebtnwithimage(
  BuildContext context,
  String btntext,
  String imgpath,
  Color clr,
  double width,
  Function ontap,
) {
  return SizedBox(
      width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton.icon(
        onPressed: () {
          ontap();
        },
        icon: Image.asset("assets/$imgpath"),
        label: Text(btntext,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: colorController.loginbtnclr)),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: clr),
      ));
}

Container reusabledropdown(BuildContext context, Widget widget) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    height: MediaQuery.of(context).size.height * 0.067,
    padding: EdgeInsets.only(right: 10),
    margin: EdgeInsets.only(bottom: 5),
    decoration: BoxDecoration(
        // color: colorController.normalgreenbtnclr,
        border:
            Border.all(color: colorController.normalgreenbtnclr, width: 1.5),
        borderRadius: BorderRadius.circular(5)),
    child: Center(child: widget),
  );
}

InkWell reusableselectimgbtn(
    BuildContext context,
    bool img_or_not,
    var fil_or_not,
    bool selected_or_not,
    String imgpath,
    String text,
    IconData icn,
    Function ontap) {
  return InkWell(
    onTap: () {
      ontap();
    },
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
              // color: colorController.normalgreenbtnclr,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected_or_not == true
                    ? Colors.blue
                    : colorController
                        .normalgreenbtnclr, // Set your desired border color
                width: 2.0, // Set your desired border width
              )),
          child: Container(
              margin: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                color: colorController.normalgreenbtnclr,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: img_or_not == true
                          ? selected_or_not == true
                              ? Image.file(
                                  File(imgpath == null ? " " : imgpath))
                              : Text(
                                  "No Image \n Selected",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey.shade300),
                                )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  icn,
                                  size: 70,
                                  color: Colors.white,
                                ),
                                Text(
                                  text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: 12),
                                )
                              ],
                            )))),
        ),
        Text(
          fil_or_not == false && selected_or_not == false
              ? "This Field is Required"
              : "",
          textAlign: TextAlign.start,
          style:
              TextStyle(color: colorController.rederrortextclr, fontSize: 12),
        )
      ],
    ),
  );
}

InkWell reusableselectvidebtn(
    BuildContext context,
    bool img_or_not,
    var fil_or_not,
    bool selected_or_not,
    String imgpath,
    String text,
    IconData icn,
    Function ontap) {
  return InkWell(
    onTap: () {
      ontap();
    },
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected_or_not == true
                    ? Colors.blue
                    : colorController
                        .normalgreenbtnclr, // Set your desired border color
                width: 2.0, // Set your desired border width
              )),
          child: Container(
              margin: EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.19,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: img_or_not == true
                          ? selected_or_not == true
                              ? Image.file(
                                  File(imgpath == null ? " " : imgpath))
                              : Text(
                                  "No Image \n Selected",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey.shade300),
                                )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  icn,
                                  size: 70,
                                  color: colorController.normalgreenbtnclr,
                                ),
                                Text(
                                  text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: colorController.normalgreenbtnclr,
                                      fontSize: 13),
                                )
                              ],
                            )))),
        ),
        Text(
          fil_or_not == false && selected_or_not == false
              ? "This Field is Required"
              : "",
          textAlign: TextAlign.start,
          style:
              TextStyle(color: colorController.rederrortextclr, fontSize: 12),
        )
      ],
    ),
  );
}
 progresscounter(BuildContext context, String titletxt,
    String progresscounter, IconData icn) {
  return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
    Container(
        margin: EdgeInsets.only(top: 5),
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.12,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 2.0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icn,
              size: 35,
              color: colorController.normalgreenbtnclr,
            ),
            Text(
              progresscounter.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorController.normalgreenbtnclr,
              ),
            ),
            Text(
              titletxt,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorController.normalgreenbtnclr,
              ),
            ),
          ],
        ))
    // Container(
    //   margin: EdgeInsets.only(top: 18, left: 8, right: 8, bottom: 10),
    //   height: MediaQuery.of(context).size.height * 0.1,
    //   width: MediaQuery.of(context).size.width * 0.2,
    //   decoration: BoxDecoration(
    //       shape: BoxShape.circle, border: Border.all(color: colorController.normalgreenbtnclr,width: 2)),
    //   child: Center(
    //       child: Text(
    //     progresscounter.toString(),
    //     style: TextStyle(color: colorController.normalgreenbtnclr,fontWeight: FontWeight.bold),
    //   )),
    // ),
    // Text(
    //   titletxt,
    //   style: TextStyle(color: colorController.normalgreenbtnclr,fontWeight: FontWeight.bold),
    // )
  ]);
}
assignmentreusablewidget(BuildContext context,Widget widget){
  return  Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 2.0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           Container(
            alignment: Alignment.center,
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.03,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 2.0,
              spreadRadius: 0,
            ),
          ],
        
        ),
        child:
        Text("Assignments Record",style: TextStyle(color: colorController.normalgreenbtnclr,fontSize: 18),),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height*0.14,
          width: MediaQuery.of(context).size.width*0.9,
          child: widget)
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       progresscounter(context, "Pending", 03, Icons.timelapse),
          //       progresscounter(context, "Complete", 02, Icons.done),
          //       progresscounter(context, "Total", 01, Icons.timeline),

          //     ],
          //   ),
          // ),
        ]));
}
reusableboxcontainer(BuildContext context,double heigh,double width,Widget widget){
  return  Container(
    // alignment: Alignment.center,
        margin: EdgeInsets.only(top: 5),
        width: MediaQuery.of(context).size.width * width,
        height: MediaQuery.of(context).size.height * heigh,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 2.0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: widget);
}
