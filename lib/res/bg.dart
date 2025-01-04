import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VitalBackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset('assets/bg.jpg', fit: BoxFit.cover),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color:  Color.fromARGB(240, 255, 255, 255),
        )
      ],
    );
  }
}