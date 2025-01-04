
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/colors.dart';
import '../local/sharedprefencevalues.dart';
import '../view/btmbar/dashboard/notifications.dart';
import '../view/profile/about.dart';
import '../view/profile/basicinfo.dart';
import '../view/profile/contact.dart';
import 'btn.dart';
import 'profileline.dart';
void social_link_connect(var linkmedia) async {
    String url = '$linkmedia';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
Container drawerwidget(
    BuildContext context, Function changepasswordontap, Function logoutontap) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    color: Colors.white,
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(18),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.green
              ], // Specify your gradient colors
            ),
            // color: Colors.green.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                reusableimgornot(context, 150),
                Text(
                  MySharedPrefrence().get_user_name().toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorController.normalgreenbtnclr,
                      fontSize: 20),
                ),
              ]),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30),
              child: Text(
                "User Details",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorController.normalgreenbtnclr,
                    fontSize: 22),
              ),
            ),
          ],
        ),
        Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            reusableprofilerow(context, Icons.info_outline, "Basic Info", () {
              print("MySharedPrefrence().get_user_image()");

              print(MySharedPrefrence().get_api_path());

              print(MySharedPrefrence().get_user_image());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeacherProfileBasicInfo()));
            }),
            reusableprofilerow(
                context, Icons.notifications, "Notification List", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()));
            }),
     reusablecertificate(context,(){
                                      social_link_connect(MySharedPrefrence().get_certificate_link());

                }),
            // reusableprofilerow(context, Icons.lock, "Change Password", () {
            //   changepasswordontap();
            //   // newpswrd.clear();
            //   // cnfmpswrd.clear();
            //   // _showBottomSheet(context);
            // }),
            reusableprofilerow(context, Icons.info, "About", () {
               Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                  AboutApp()));
            }),
            reusableprofilerow(context, Icons.contact_mail, "Contact", () {
               Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                ContactinfoSchool()));
            }),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: reusablebtn(
                  context, "Logout", colorController.normalgreenbtnclr, 0.70,
                  () {
                logoutontap();
                // MySharedPrefrence().logout();
                // googleSignOut();
                // setState(() {});
                // print(MySharedPrefrence());
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //       builder: (context) => AccountLoginOrRegister()),
                // );
              }),
            )
            // Padding(
            //   padding: const EdgeInsets.only(left:20,right: 20,bottom: 20),
            //   child: reusabledropdown(context, InkWell(onTap: (){
            //       MySharedPrefrence().logout();
            //       setState(() {

            //       });
            //       print(MySharedPrefrence());
            //       Navigator.of(context).pushReplacement(
            //                         MaterialPageRoute(
            //                             builder: (context) => AccountLoginOrRegister()),
            //                       );
            //     }, child: Text("Logout",style: TextStyle(color: Colors.white),)),
            //   ),
            // )
          ],
        ),
      ],
    ),
  );
}
