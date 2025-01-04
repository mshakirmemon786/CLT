import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/colors.dart';
import '../../../local/sharedprefencevalues.dart';
import 'package:http/http.dart' as http;

import '../../res/bg.dart';
import '../btmbar/btmbr.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  void social_link_connect(var linkmedia) async {
    String url = '$linkmedia';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        VitalBackgroundImage(),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => TeacherBtmbar()));
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: colorController.normalgreenbtnclr,
                      )),
                ],
              ),
              Text(
                "About Us",
                style: TextStyle(
                    color: colorController.normalgreenbtnclr,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              Divider(
                thickness: 2,
                color: colorController.normalgreenbtnclr,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height * 0.9,
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
                padding: EdgeInsets.all(10),
                // width: MediaQuery.of(context).size.width*0.9,
                // height: MediaQuery.of(context).size.height*0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "1st time in Pakistan Become a Certified Literacy Teacher!\n\nIntroducing the Certified Literacy Teacher app, a groundbreaking App now available in Pakistan! Unlock the power of expert guidance to enhance your literacy teaching skills. Most user-friendly App with one-on-one mentoring. Embark on the journey with us today!",
                        textAlign: TextAlign.justify,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                social_link_connect(
                                    "https://cltpk.com/about-us/");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("View more",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color:
                                            colorController.normalgreenbtnclr,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17)),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )));
  }
}
