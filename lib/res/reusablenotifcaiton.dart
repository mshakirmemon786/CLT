import 'package:flutter/material.dart';
import 'package:flutter_firebase_notifications/controller/colors.dart';

Widget reusablenotionlist(
    BuildContext context, String title, String subtitle, String date) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(top: 5, bottom: 5),
    margin: EdgeInsets.all(12),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 2),
          blurRadius: 2.0,
          spreadRadius: 0,
        ),
      ],
      color: Colors.grey.shade200,
    ),
    child: ListTile(
        leading: Icon(
          Icons.message,
          color: colorController.normalgreenbtnclr,
          size: 40,
        ),
        title: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(color: colorController.normalgreenbtnclr),
        ),
        subtitle: Text(
          subtitle,
          textAlign: TextAlign.left,
          style: TextStyle(color: colorController.normalgreenbtnclr),
        ),
        trailing: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.2,
          child: Text(
            date,
            style: TextStyle(color: colorController.normalgreenbtnclr),
          ),
        )),
  );
}
