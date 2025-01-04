
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';
import 'package:http/http.dart' as http;

import '../../controller/colors.dart';
import '../../local/sharedprefencevalues.dart';
import '../../main.dart';
import '../../res/btn.dart';
import '../../res/drawer.dart';
import '../../res/profileline.dart';
import '../../res/textfield.dart';
import '../profile/profile.dart';
import 'dashboard/books/1viewbooks.dart';
import 'dashboard/dashboard.dart';
import 'dashboard/notifications.dart';

class TeacherBtmbar extends StatefulWidget {
  const TeacherBtmbar({super.key});

  @override
  State<TeacherBtmbar> createState() => _TeacherBtmbarState();
}

class _TeacherBtmbarState extends State<TeacherBtmbar> {
  final _pageControlller = PageController();
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

  @override
  void dispose() {
    _pageControlller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: colorController.normalgreenbtnclr,
          leading: Builder(
            builder: (BuildContext context) {
              return InkWell(
                // iconSize: 30,
                child: reusableappbarimge(context, 200),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: Text(
              MySharedPrefrence().get_user_name().toString().toUpperCase(),style:TextStyle(color:Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsPage()));
              },
              icon:
                  // Badge(
                  //   // label: Text("3"),
                  //   // badgeContent:
                  //   // Text('5', style: TextStyle(color: Colors.white)),
                  //   child: Icon(
                  //     Icons.notifications,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  Icon(Icons.notifications_outlined,
                      size: 25, color: Colors.white),
            ),
          ],
        ),
        drawer: drawerwidget(context, () {
          newpswrd.clear();
          cnfmpswrd.clear();
          _showBottomSheet(context);
        }, () {
          MySharedPrefrence().logout();
          // googleSignOut();
          setState(() {});
          print(MySharedPrefrence());
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        }),
        body: PageView(
          controller: _pageControlller,
          children: [
            TeacherDashboard(),
            TeacherViewBooks(
              cource_id: "9",
              appbar_or_not: false,
            ),
            TeacherProfile()
            
            // TeacherDashboard(),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: RollingBottomBar(
          itemColor: Colors.white,
          color: colorController.normalgreenbtnclr,
          controller: _pageControlller,
          flat: false,
          useActiveColorByDefault: false,
          items: const [
            RollingBottomBarItem(Icons.home,
                label: 'HOME', activeColor: Colors.white),
            RollingBottomBarItem(Icons.article_outlined,
                label: 'JUGNOO', activeColor: Colors.white),
            RollingBottomBarItem(Icons.person_2_sharp,
                label: 'PROFILE', activeColor: Colors.white),
          ],
          enableIconRotation: true,
          onTap: (index) {
            _pageControlller.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          },
        ),
      ),
    );
  }
}
