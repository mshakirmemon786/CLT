import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../controller/colors.dart';
import '../local/sharedprefencevalues.dart';

reusablecontactbox(
  BuildContext context,
) {
  return Container(
    margin: EdgeInsets.only(top: 30, bottom: 30),
    width: MediaQuery.of(context).size.width * 0.9,
    // height: MediaQuery.of(context).size.height * 0.2,
    decoration: BoxDecoration(
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.grey,
      //     offset: Offset(0, 2),
      //     blurRadius: 2.0,
      //     spreadRadius: 0,
      //   ),
      // ],
      border: Border.all(),
      borderRadius: BorderRadius.circular(20),
      // gradient: LinearGradient(
      //   begin: Alignment.topCenter,
      //   end: Alignment.bottomCenter,
      // color: Colors.white,
      //  Colors.green.shade300, Colors.green.shade400],
      // ),
    ),
    child: Column(
      children: [
        // ListTile(
        //   leading: Icon(
        //     Icons.phone_forwarded,
        //     color: colorController.normalgreenbtnclr,
        //   ),
        //   title: Text(
        //     "Contact",
        //     style: TextStyle(
        //         color: colorController.normalgreenbtnclr,
        //         fontWeight: FontWeight.bold),
        //   ),
        //   subtitle: Text(
        //     MySharedPrefrence().get_clt_contact(),
        //     style: TextStyle(
        //         color: colorController.normalgreenbtnclr,
        //         fontWeight: FontWeight.bold),
        //   ),
        // ),
        ListTile(
          leading: Icon(
            Icons.email,
            color: colorController.normalgreenbtnclr,
          ),
          title: Text(
            "Email",
            style: TextStyle(
                color: colorController.normalgreenbtnclr,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            MySharedPrefrence().get_clt_email(),
            style: TextStyle(
                color: colorController.normalgreenbtnclr,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

Widget reusablesocialrowcontact(
    BuildContext context, String txt1, String imgpath1, Function ontap1) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 25),
    child: InkWell(
      onTap: () {
        ontap1();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // MainAxisAlignmet
          Row(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Image.asset("assets/$imgpath1")),
              Text(
                "     $txt1",
                style: TextStyle(
                    color: colorController.normalgreenbtnclr,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: colorController.normalgreenbtnclr,
          )
        ],
      ),
    ),
  );
}

Widget reusablecontactboxsocial(
  BuildContext context,
  double height,
  double width,
  String imgpath1,
  String txt1,
  String sbtxt1,
  Function ontap1,
  String imgpath2,
  String txt2,
  String sbtxt2,
  Function ontap2,
  String imgpath3,
  String txt3,
  String sbtxt3,
  Function ontap3,
  String imgpath4,
  String txt4,
  String sbtxt4,
  Function ontap4,
  String imgpath5,
  String txt5,
  String sbtxt5,
  Function ontap5,
) {
  return Container(
    margin: EdgeInsets.only(top: 0, bottom: 30),
    width: MediaQuery.of(context).size.width * width,
    height: MediaQuery.of(context).size.height * height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: Text(
            "Social Media",
            style: TextStyle(
                color: colorController.normalgreenbtnclr,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
            onTap: () {
              ontap1();
            },
            leading: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Image.asset("assets/$imgpath1")),
            title: Text(
              txt1,
              style: TextStyle(
                  color: colorController.normalgreenbtnclr,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              sbtxt1,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorController.normalgreenbtnclr,
            )),
        ListTile(
            onTap: () {
              ontap2();
            },
            leading: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Image.asset("assets/$imgpath2")),
            title: Text(
              txt2,
              style: TextStyle(
                  color: colorController.normalgreenbtnclr,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              sbtxt2,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorController.normalgreenbtnclr,
            )),
        ListTile(
            onTap: () {
              ontap3();
            },
            leading: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Image.asset("assets/$imgpath3")),
            title: Text(
              txt3,
              style: TextStyle(
                  color: colorController.normalgreenbtnclr,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              sbtxt3,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorController.normalgreenbtnclr,
            )),
        ListTile(
            onTap: () {
              ontap4();
            },
            leading: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Image.asset("assets/$imgpath4")),
            title: Text(
              txt4,
              style: TextStyle(
                  color: colorController.normalgreenbtnclr,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              sbtxt4,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorController.normalgreenbtnclr,
            )),
        ListTile(
            onTap: () {
              ontap5();
            },
            leading: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Image.asset("assets/$imgpath5")),
            title: Text(
              txt5,
              style: TextStyle(
                  color: colorController.normalgreenbtnclr,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              sbtxt5,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: colorController.normalgreenbtnclr,
            )),
      ],
    ),
  );
}
