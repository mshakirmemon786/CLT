import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controller/colors.dart';
import '../local/sharedprefencevalues.dart';

InkWell reusableprofilerow(
    BuildContext context, IconData icn, String title, Function ontap) {
  return InkWell(
    onTap: () {
      ontap();
    },
    child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icn, color: colorController.normalgreenbtnclr),
                Text("     $title"),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: colorController.normalgreenbtnclr,
            ),
          ],
        )),
  );
}

InkWell reusablecertificate(BuildContext context, Function ontap) {
  return InkWell(
    onTap: () {
      MySharedPrefrence().get_certificate_status() == '0'
          ? null
          : showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text(
                      '${MySharedPrefrence().get_user_name()} Certificate'),
                  content:
                      Text("\nYour Certificate Is Availble \nNow you can Download your certificate "),
                      // Html(data: '<img src="${MySharedPrefrence().get_certificate_link().toString()}" />'),
                      // Html(data: '<img src="${MySharedPrefrence().get_certificate_link().toString()}" />'),
// Image.network(
//             'https://admin.cltpk.com/CLT/user_certificate.php?id=erer',
//             loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//               if (loadingProgress == null) {
//                 return child;
//               } else {
//                 return CircularProgressIndicator();
//               }
//             },
//           ),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () {
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                      isDefaultAction: true,
                      child: Text(
                        'Back',
                        style:
                            TextStyle(color: colorController.normalgreenbtnclr),
                      ),
                    ),
                    CupertinoDialogAction(
                      onPressed: () {
                        ontap();

                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                      isDefaultAction: true,
                      child: Text(
                        'Download ',
                        style:
                            TextStyle(color: colorController.normalgreenbtnclr),
                      ),
                    ),
                  ],
                );
              },
            );
    },
    child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.card_membership_outlined,
                    color: colorController.normalgreenbtnclr),
                Text("     Certificate"),
              ],
            ),
            Row(
              children: [
                MySharedPrefrence().get_certificate_status() == '0'
                    ? Image.asset("assets/nocertificate.png",height: 25,)
                    : Image.asset("assets/check.png",height: 25,),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: colorController.normalgreenbtnclr,
                ),
              ],
            ),
          ],
        )),
  );
}

Container reusableimgornot(
  BuildContext context,
  double radius,
) {
  return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: MySharedPrefrence().get_user_image() == null ||
              MySharedPrefrence().get_user_image() == ""
          ? Container(
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorController
                      .normalgreenbtnclr, // Set your desired border color
                  width: 2.0, // Set your desired border width
                ),
              ),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: colorController.normalgreenbtnclr,
                backgroundImage: AssetImage("assets/no.jpeg"),
              ))
          : Container(
              padding: EdgeInsets.all(5),
              // width: MediaQuery.ofrf(context).size.height*0.3, // Adjust the size as needed
              height: radius,
              width: radius,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorController
                      .normalgreenbtnclr, // Set your desired border color
                  width: 2.0, // Set your desired border width
                ),
              ),
              child: CircleAvatar(
                  radius: radius,
                  backgroundColor: colorController.normalgreenbtnclr,
                  backgroundImage: NetworkImage(
                      "${MySharedPrefrence().get_api_path().toString()}${MySharedPrefrence().get_user_image()}"))));
}

Stack reusableappbarimge(BuildContext context, double radius) {
  return Stack(
    children: [
      Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: colorController
                  .normalgreenbtnclr, // Set your desired border color
              // width: 1.0, // Set your desired border width
            ),
          ),
          // margin: EdgeInsets.only(),
          child: MySharedPrefrence().get_user_image() == null ||
                  MySharedPrefrence().get_user_image() == ""
              ? CircleAvatar(
                  radius: radius,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/no.jpeg"),
                )
              : CircleAvatar(
                  radius: radius,
                  backgroundColor: colorController.normalgreenbtnclr,
                  backgroundImage: NetworkImage(
                      "${MySharedPrefrence().get_api_path().toString()}${MySharedPrefrence().get_user_image()}"))),
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
            padding: EdgeInsets.only(
              right: 3.8,
              bottom: 3.8,
            ),
            child: Container(
                padding: EdgeInsets.all(1),
                // width: MediaQuery.ofrf(context).size.height*0.3, // Adjust the size as needed
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorController
                        .normalgreenbtnclr, // Set your desired border color
                    width: 1.0, // Set your desired border width
                  ),
                ),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: colorController.normalgreenbtnclr,
                  child: Icon(
                    Icons.menu,
                    size: 15,
                    color: MySharedPrefrence().get_user_image() == null
                        ? Colors.white
                        : Colors.white,
                  ),
                  // backgroundImage: AssetImage("assets/no.jpeg"),
                )) // CircleAvatar(
            //   radius: 10,
            //   backgroundColor: Colors.white,
            //   child: Icon(
            //     Icons.menu,
            //     size: 20,
            //     color: MySharedPrefrence().get_user_image() == null
            //         ? Colors.white
            //         : Colors.white,
            //   ),
            // ),
            ),
      )
    ],
  );
}
