import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/colors.dart';
import '../../local/sharedprefencevalues.dart';
import '../../res/bg.dart';
import '../../res/btn.dart';
import '../../res/crcleimage.dart';
import '../../res/profileline.dart';
import '../../res/reusablebottomsheet.dart';
import '../../res/reusableloadingrow.dart';
import '../../res/reusableuploadimage.dart';
import '../../res/textfield.dart';
import '../btmbar/btmbr.dart';
import '../btmbar/dashboard/notifications.dart';
import 'about.dart';
import 'basicinfo.dart';
import 'package:http/http.dart' as http;

import 'contact.dart';

class TeacherProfile extends StatefulWidget {
  const TeacherProfile({super.key});

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  TextEditingController newpswrd = TextEditingController();
  TextEditingController cnfmpswrd = TextEditingController();
  final form = GlobalKey<FormState>();
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.45,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Change Password",
                  style: TextStyle(
                      color: colorController.normalgreenbtnclr,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                reusabletextfield(context, newpswrd, true, "Enter New Password",
                    Icons.lock, true, 0.07, 0.10),
                reusabletextfield(context, cnfmpswrd, true,
                    "Enter Confirm Password", Icons.lock, true, 0.07, 0.10),
                reusablebtn(context, "Change Password",
                    colorController.normalgreenbtnclr, 0.85, () {
                  // changpassword();
                  //  final form = GlobalKey<FormState>();
                  if (form.currentState!.validate()) {
                    // changpassword();
                    if (newpswrd.text == cnfmpswrd.text) {
                      changpassword();
                      Navigator.pop(context);
                      // SizedBox(width: MediaQuery.of(context).size.width*0.8,);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // width: MediaQuery.of(context).size.width*0.8,
                          // margin: EdgeInsets.all(30),
                          backgroundColor: colorController.normalgreenbtnclr,
                          content: Text("Password Change Successfully."),
                        ),
                      );
                    } else if (newpswrd.text != cnfmpswrd.text) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Passwords are different'),
                          content: Text('Type Same password'),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                })
              ],
            ),
          ),
        );
      },
    );
  }

  File? _imageupdateprofileimage;
  bool updateprofileimage = false;
  String base64updateprofileimage = 'noimage';
  bool isLoading = false;
  // Future googleSignOut() async {
  //   try {
  //     await GoogleSignInService.logout();
  //     // log('Sign Out Success');
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(const SnackBar(content: Text('Sign Out Success')));
  //     }
  //   } catch (exception) {
  //     // log(exception.toString());
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(const SnackBar(content: Text('Sign Out Failed')));
  //     }
  //   }
  // }

  Future<void> changpassword() async {
    final String apiUrl =
        '${MySharedPrefrence().get_api_path().toString()}api/password_update.php';

    http.post(Uri.parse(apiUrl), body: {
      'admin_id': MySharedPrefrence().get_user_id(),
      'password': newpswrd.text,
    }).then((response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Response: ' + response.body);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text('An error occurred while trying to log in.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

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

  Future<void> selectupdateprofileimage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageupdateprofileimage = File(pickedFile.path);

        // Convert the image file to base64
        List<int> imageBytes = _imageupdateprofileimage!.readAsBytesSync();
        base64updateprofileimage = base64Encode(imageBytes);

        // Print the base64 string
        print('Base64 Image: $base64updateprofileimage');
        updateprofileimage = true;

        // Show the dialog
        if (updateprofileimage) {
          showUpdateProfileImageDialog();
        }
      } else {
        print('No image selected.');
      }
    });
  }

  void showUpdateProfileImageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile Image Updated'),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            image: DecorationImage(
              image: FileImage(_imageupdateprofileimage!),
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(5),
            child: reusablebtn(
                context, "Cancel", colorController.normalgreenbtnclr, 0.3, () {
              Navigator.pop(context);
            }),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: reusablebtn(
                context, "Submit", colorController.normalgreenbtnclr, 0.3, () {
              setState(() {
                updateProfileImage();
              });
              // Navigator.pop(context);
              Navigator.pop(context);
            }),
          ),
        ],
      ),
    );
  }

  Future<void> updateProfileImage() async {
    // final apiUrl = '${MySharedPrefrence().get_api_path().toString()}profile_update.php';
    final apiUrl =
        "${MySharedPrefrence().get_api_path()}api/profile_update.php";
    //  Constant().updateprofilegapi;
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        'admin_id': MySharedPrefrence().get_user_id(),
        'image': base64updateprofileimage,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == 1) {
          print(data['image']);
          MySharedPrefrence().set_user_image(data['image']);
          print("object");

          print("Image Updated Sucessfully");
          setState(() {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TeacherBtmbar()));
          });

          // reusablesnackbarcontroller.snackbarfunction(
          //     context, "Image Update Successfully");
        } else {
          print("Image not Updated Sucessfully");
          // reusablesnackbarcontroller.snackbarfunction(context, data['message']);
          // print('API Error: ${data['message']}');
        }
      } else {
        print("Image not Updated Sucessfully");
        // reusablesnackbarcontroller.snackbarfunction(
        //     context, "Something Went Wrong");

        print('Error: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

//     @override
// void dispose() {

//   super.dispose();
// }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            VitalBackgroundImage(),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(11),
                    margin: EdgeInsets.all(18),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          10), // Add rounded corners if desired
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, // Shadow color
                          offset: Offset(
                              0, 2), // Shadow position (horizontal, vertical)
                          blurRadius: 2.0, // Shadow blur radius
                          spreadRadius: 0, // Shadow spread radius
                        ),
                      ],
                      color: Colors.grey.shade200,
                    ),
                    //   borderRadius: BorderRadius.circular(20),
                    // ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // reusableimgornot(context, 150,),
                          reusableuplaodimage(context, 150, () {
                            reuablebottomsheet(context, "Choose Profile Image",
                                () {
                              selectupdateprofileimage(ImageSource.gallery);
                            }, () {
                              selectupdateprofileimage(ImageSource.camera);
                            });
                          })
                        ]),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
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
                      reusableprofilerow(
                          context, Icons.info_outline, "Basic Info", () {
                        print("MySharedPrefrence().get_user_image()");

                        print(MySharedPrefrence().get_api_path());

                        print(MySharedPrefrence().get_user_image());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TeacherProfileBasicInfo()));
                      }),
                      reusableprofilerow(
                          context, Icons.notifications, "Notification List",
                          () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationsPage()));
                      }),
                      //  Html(data: '<img src="${MySharedPrefrence().get_certificate_link().toString()}" />'),

                      reusablecertificate(context, () {
                        social_link_connect(
                            MySharedPrefrence().get_certificate_link());
                      }),

                      reusableprofilerow(context, Icons.lock, "Change Password",
                          () {
                        newpswrd.clear();
                        cnfmpswrd.clear();
                        _showBottomSheet(context);
                      }),
                      reusableprofilerow(context, Icons.info, "About", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutApp()));
                      }),
                      reusableprofilerow(context, Icons.contact_mail, "Contact",
                          () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactinfoSchool()));
                      }),

                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: getsociallinks(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: colorController.normalgreenbtnclr,
                              ));
                            } else if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: reusablebtn(
                                    context,
                                    "Check Internet Try Again",
                                    Colors.orange,
                                    0.9, () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TeacherBtmbar()));
                                }),
                              );
                            } else if (snapshot.hasData) {
                              final List<Map<String, dynamic>> data =
                                  snapshot.data!;

                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  final item = data[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        cicleiamgereusable(
                                            context, 25, "insta.png", () {
                                          social_link_connect(
                                              item['instagram']);
                                        }),
                                        cicleiamgereusable(
                                            context, 25, "link.png", () {
                                          social_link_connect(item['linkedin']);
                                        }),
                                        cicleiamgereusable(
                                            context, 25, "youtube.png", () {
                                          social_link_connect(item['youtube']);
                                        }),
                                        cicleiamgereusable(
                                            context, 25, "facebook.png", () {
                                          social_link_connect(item['facebook']);
                                        }),
                                        cicleiamgereusable(
                                            context, 25, "gmail.png", () {
                                          social_link_connect(item['gmail']);
                                        }),
                                        cicleiamgereusable(
                                            context, 25, "call.png", () {
                                          social_link_connect(
                                              'https://wa.me/${item['call']}');
                                        }),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(child: Text('No data available'));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            isLoading == true
                ? AlertDialog(title: reusableloadingrow(context))
                : Container(),
          ],
        ),
      ),
    );
  }
}
