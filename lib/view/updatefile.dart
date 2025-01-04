import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_notifications/local/sharedprefencevalues.dart';
import 'package:flutter_firebase_notifications/main.dart';
import 'package:flutter_firebase_notifications/res/reusableloadingrow.dart';
import 'package:flutter_firebase_notifications/res/video.dart';
import 'package:flutter_firebase_notifications/view/account/account.dart';
import 'package:flutter_firebase_notifications/view/btmbar/btmbr.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppPage extends StatefulWidget {
  @override
  _UpdateAppPageState createState() => _UpdateAppPageState();
}

class _UpdateAppPageState extends State<UpdateAppPage> {
  AppUpdateInfo? _updateInfo;
  bool _isLoggedIn = false;

  bool isLoadingupdateapp = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        if (_updateInfo?.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          showUpdateAvailableNotification();
        } else {
          navigateToHomeScreen();
        }
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void showUpdateAvailableNotification() {
    if (_scaffoldKey.currentContext != null) {
      // _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
      //     ? () {
      _launchURL("https://play.google.com/store/apps/details?id=com.ideaz.clt");
      // InAppUpdate.performImmediateUpdate().catchError((e) {
      //   showSnack(e.toString());
      //   return AppUpdateResult.inAppUpdateFailed;
      // });
      //   }
      // : Container();
      // ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      //   SnackBar(
      //     content: Text("Update available. Please update the app."),
      //     action: SnackBarAction(
      //       label: 'Update',
      //       onPressed: () {
      //         InAppUpdate.performImmediateUpdate().catchError((e) {
      //           showSnack(e.toString());
      //           return AppUpdateResult.inAppUpdateFailed;
      //         });
      //       },
      //     ),
      //   ),
      // );
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void navigateToHomeScreen() {
    checkLoginStatus();
    Timer(Duration(seconds: 3), () {
      if (wheretogo(context)) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WillPopScope(
                  onWillPop: () async => false, child: TeacherBtmbar()
                  // UpdateAppPage()
                  ),
            ));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WillPopScope(
                  onWillPop: () async => false,
                  child: AccountLoginOrRegister(
                      home_or_login: true,
                      tokenpush: "",
                      pushtoken_or_null: false)
                  // UpdateAppPage()
                  )),
        );
      }
    });
    // ScaffoldMessenger.of(_scaffoldKey.currentContext!)
    //     .showSnackBar(SnackBar(content: Text("Goto home page")));
  }

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      setState(() {
        isLoadingupdateapp = false;
      });
    });
    checkForUpdate();
  }

  Future<void> checkLoginStatus() async {
    bool isLoggedIn = await MySharedPrefrence().getUserLoginStatus();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
    Timer(Duration(seconds: 5), () {
      navigateToScreen();
    });
  }

  void navigateToScreen() {
    if (_isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TeacherBtmbar()
            // UpdateAppPage()
            ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  }

  void showUpdateDialog(BuildContext context) {
    CupertinoAlertDialog(
      title: Row(
        children: [
          Icon(
            CupertinoIcons.info,
            color: Colors.blue,
            size: 28.0,
          ),
          SizedBox(width: 8.0),
          Text('Update Available'),
        ],
      ),
      content: Column(
        children: [
          SizedBox(height: 16.0),
          Image.asset(
            'assets/app_logo.png', // Replace with your app logo asset
            height: 50.0,
            width: 50.0,
          ),
          SizedBox(height: 16.0),
          Text(
            'A new version of the app is available. Please update for the best experience.',
          ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('Update Now'),
          onPressed: () {
            InAppUpdate.performImmediateUpdate().catchError((e) {
              // Handle update error
            });
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text('Later'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: isLoadingupdateapp == false
            ? _scaffoldKey.currentContext != null
                ? CupertinoAlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          CupertinoIcons.info,
                          color: Colors.blue,
                          size: 28.0,
                        ),
                        SizedBox(width: 8.0),
                        Text('Update Available'),
                      ],
                    ),
                    content: Column(
                      children: [
                        SizedBox(height: 16.0),
                        Image.asset(
                          'assets/logo.png', // Replace with your app logo asset
                          height: 50.0,
                          width: 50.0,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'A new version of the app is available. Please update for the best experience.',
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      _scaffoldKey.currentContext != null
                          ? CupertinoDialogAction(
                              child: Text('Update Now'),
                              onPressed: () {
                                _launchURL(
                                    "https://play.google.com/store/apps/details?id=com.ideaz.clt");
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()),
                                );
                                // navigateToHomeScreen();
                                // InAppUpdate.performImmediateUpdate().catchError((e) {
                                //   // Handle update error
                                // });
                              },
                            )
                          : CupertinoDialogAction(
                              child: Text('Reload'),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()),
                                );
                              },
                            )
                    ],
                  )
                : CupertinoAlertDialog(title: reusableloadingrow(context))
            : CupertinoAlertDialog(title: reusableloadingrow(context))
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Column(
        //     children: <Widget>[
        //       ElevatedButton(
        //         child: Text('Check for Update'),
        //         onPressed: () => checkForUpdate(),
        //       ),
        //       ElevatedButton(
        //         child: Text('Perform immediate update'),
        //         onPressed: _updateInfo?.updateAvailability ==
        //                 UpdateAvailability.updateAvailable
        //             ? () {
        //                 InAppUpdate.performImmediateUpdate().catchError((e) {
        //                   showSnack(e.toString());
        //                   return AppUpdateResult.inAppUpdateFailed;
        //                 });
        //               }
        //             : null,
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}

bool wheretogo(BuildContext context) {
  return MySharedPrefrence().getUserLoginStatus();
}
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//       ),
//       body: Center(
//         child: Text('Welcome to the Home Screen!'),
//       ),
//     );
//   }
// }
