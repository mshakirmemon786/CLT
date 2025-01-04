import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/colors.dart';
import '../../../local/sharedprefencevalues.dart';
import 'package:http/http.dart' as http;

import '../../res/bg.dart';
import '../../res/btn.dart';
import '../../res/contactbox.dart';
import '../../res/crcleimage.dart';
import '../btmbar/btmbr.dart';

class ContactinfoSchool extends StatefulWidget {
  const ContactinfoSchool({super.key});

  @override
  State<ContactinfoSchool> createState() => _ContactinfoSchoolState();
}

class _ContactinfoSchoolState extends State<ContactinfoSchool> {
  Future<List<Map<String, dynamic>>> getsociallinks() async {
    final apiUrl =
        '${MySharedPrefrence().get_api_path().toString()}api/social_links.php';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            json.decode(response.body).cast<Map<String, dynamic>>();
        return data;
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

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
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => TeacherBtmbar()));
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: colorController.normalgreenbtnclr,
                        )),
                  ],
                ),
                Text(
                  "Contact Us",
                  style: TextStyle(
                      color: colorController.normalgreenbtnclr,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                Divider(
                  thickness: 2,
                  color: colorController.normalgreenbtnclr,
                ),
                Text(
                  "Feel free to get in touch with us using the contact information below.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                ),
                // reusablecontactbox(
                //   context,
                // ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: getsociallinks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: colorController.normalgreenbtnclr,
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: reusablebtn(context, "Check Internet Try Again",
                            Colors.orange, 0.9, () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => TeacherBtmbar()));
                        }),
                      );
                    } else if (snapshot.hasData) {
                      final List<Map<String, dynamic>> data = snapshot.data!;

                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10, bottom: 20),
                                    child: Text(
                                      "Social Media",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color:
                                              colorController.normalgreenbtnclr,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  reusablesocialrowcontact(
                                      context, "Facebook", "facebook.png", () {
                                    social_link_connect(item['facebook']);
                                  }),
                                  reusablesocialrowcontact(
                                      context, "Instagram", "insta.png", () {
                                    social_link_connect(item['instagram']);
                                  }),
                                  reusablesocialrowcontact(
                                      context, "Youtube", "youtube.png", () {
                                    social_link_connect(item['youtube']);
                                  }),
                                  reusablesocialrowcontact(
                                      context, "Linkedn", "link.png", () {
                                    social_link_connect(item['linkedin']);
                                  }),
                                  reusablesocialrowcontact(
                                      context, "Twitter", "twitter.png", () {
                                    social_link_connect(item['twitter']);
                                  }),
                                ],
                              );
                              // reusablecontactboxsocial(
                              //   context,
                              //   0.47,
                              //   0.9,
                              //   "insta.png",
                              //   "Instagram",
                              //   "",
                              //   () {
                              //     social_link_connect(item['instagram']);
                              //   },
                              //   "link.png",
                              //   "Linkedin",
                              //   "",
                              //   // item['linkedin']
                              //   () {
                              //     social_link_connect(item['linkedin']);
                              //   },
                              //   "youtube.png",
                              //   "Youtube",
                              //   "",
                              //   //item['youtube']
                              //   () {
                              //     social_link_connect(item['youtube']);
                              //   },
                              //   "facebook.png",
                              //   "Facebook",
                              //   "",
                              //   // item['facebook']
                              //   () {
                              //     social_link_connect(item['facebook']);
                              //   },
                              //   "twitter.png",
                              //   "Twitter",
                              //   "",
                              //   // item['facebook']
                              //   () {
                              //     // social_link_connect(item['twitter']);
                              //   },
                              // );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
                // reusablecontactboxsocial(
                //   context,
                //   0.47,
                //   0.9,
                //   Icons.phone_forwarded,
                //   "+920123456789",
                //   "+920123456789",
                //   Icons.phone_forwarded,
                //   "+920123456789",
                //   "+920123456789",
                //   Icons.phone_forwarded,
                //   "+920123456789",
                //   "+920123456789",
                //   Icons.phone_forwarded,
                //   "+920123456789",
                //   "+920123456789",
                // )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
