import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_notifications/controller/colors.dart';
import 'package:flutter_firebase_notifications/res/reusableassetimage.dart';

import '../local/sharedprefencevalues.dart';

Widget reusableloadingrow(BuildContext context) {
  return Row(
    children: [
      Stack(
        children: [
          Row(
            children: [
              CircularProgressIndicator(color: colorController.normalgreenbtnclr,),
              Text(
                '   Please Wait ...',
                style: TextStyle(
                    color: colorController.normalgreenbtnclr,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
            ],
          ),
          Padding(
                padding: const EdgeInsets.only(top:6,left: 2,),
            
            child: reusableassetimg(
              context,
              "logo.png",
              0.08,
              0.029,
              BoxFit.contain,
            ),
          ),
        ],
      ),
    ],
  );
}
