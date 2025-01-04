import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_notifications/res/reusableloadingrow.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/colors.dart';
import '../../../local/sharedprefencevalues.dart';
import '../../../res/bg.dart';
import '../../../res/btn.dart';
import '../../../res/textfield.dart';
import '../../btmbar/btmbr.dart';

class TeacherLogin extends StatefulWidget {
  TeacherLogin({required this.tokenpush});
  String tokenpush;

  @override
  _TeacherLoginState createState() => _TeacherLoginState(tokenpush: tokenpush);
}

class _TeacherLoginState extends State<TeacherLogin> {
  _TeacherLoginState({required this.tokenpush});
  String tokenpush;
  final TextEditingController login_email = TextEditingController();

  final TextEditingController login_password = TextEditingController();

  var user_id;
  late final responseData;
  bool isLoading = false;
  @override
  void initstate() {
    super.initState();
    MySharedPrefrence().set_api_path("https://admin.cltpk.com/CLT/");

    MySharedPrefrence().get_api_path().toString();
  }

  Future<void> loginfunction(BuildContext context) async {
    // Show loading indicator
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: SizedBox(
    //       height: MediaQuery.of(context).size.height * 0.05,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Row(
    //             children: [
    //               CircularProgressIndicator(),
    //               Text("    Please Wait"),
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    final String apiUrl =
        '${MySharedPrefrence().get_api_path().toString()}api/login.php';
    final String username = login_email.text;
    final String password = login_password.text;

    setState(() {
      isLoading = true;
    });

    try {
      // Check Internet Connection
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        _showErrorDialog(
            context, 'Connection Error', 'Internet is not connected.');
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': username,
          'password': password,
          'cell_token': tokenpush == null || tokenpush == ""
              ? MySharedPrefrence().get_push_token()
              : tokenpush
        },
      );

      // Navigator.pop(context); // Close loading indicator

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Response: ' + response.body);

        if (data['success'] == 1) {
          MySharedPrefrence().setUserLoginStatus(true);
          MySharedPrefrence().set_user_id(data['admin_id'].toString());
          MySharedPrefrence().set_user_name(data['first_name'].toString());
          MySharedPrefrence().set_user_image(data['image'].toString());
          MySharedPrefrence().set_clt_contact(data['clt_contact'].toString());
          MySharedPrefrence().set_clt_email(data['clt_email'].toString());
          MySharedPrefrence().set_login_code(data['login_code'].toString());

          print(MySharedPrefrence().get_login_code());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(    
              builder: (context) => TeacherBtmbar(),
            ),
          );
        } else {
          _showErrorDialog(context, 'Login Failed', '${data['message']}');
        }
      } else {
        _showErrorDialog(context, 'Login Failed',
            'An error occurred while trying to log in.');
      }
    } catch (error) {
      // Close loading indicator after a delay
      Future.delayed(Duration(milliseconds: 500), () {
        // Navigator.pop(context);
      });

      print('Error: $error');
      _showErrorDialog(
          context, 'Login Failed', 'Something Went wrong Restart Application');
    }

    finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Colors.red),
          ),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              isDefaultAction: true,
              child: Text(
                'Back ',
                style: TextStyle(color: colorController.normalgreenbtnclr),
              ),
            ),
          ],
        );
      },
    );
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text(
    //       title,
    //       style: TextStyle(color: Colors.red),
    //     ),
    //     content: Text(content),
    //     actions: [
    //       ElevatedButton(
    //         onPressed: () =>
    //         Navigator.pop(context),
    //         // Navigator.pushReplacement(
    //         //     context,
    //         //     MaterialPageRoute(
    //         //         builder: (context) => TeacherLogin(tokenpush: tokenpush))),
    //         child: Text('OK'),
    //       ),
    //     ],
    //   ),
    // );
  }

// Future<void> loginfunction(BuildContext context) async {
//   final String apiUrl =
//       '${MySharedPrefrence().get_api_path().toString()}api/login.php';
//   final String username = login_email.text;
//   final String password = login_password.text;

//   try {
//     // Check Internet Connection
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       print('Internet is not connected');
//       showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Connection Error'),
//           content: Text('Internet is not connected.'),
//           actions: [
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//       return;
//     }

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       body: {
//         'email': username,
//         'password': password,
//         'cell_token': tokenpush == null || tokenpush == ""
//             ? MySharedPrefrence().get_push_token()
//             : tokenpush
//       },
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       print('Response: ' + response.body);

//       if (data['success'] == 1) {
//         MySharedPrefrence().setUserLoginStatus(true);
//         MySharedPrefrence().set_user_id(data['admin_id'].toString());
//         MySharedPrefrence().set_user_name(data['first_name'].toString());
//         MySharedPrefrence().set_user_image(data['image'].toString());

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TeacherBtmbar(),
//           ),
//         );
//       } else {
//         showDialog(
//           barrierDismissible: false,
//           context: context,
//           builder: (context) => AlertDialog(
//                     title: Text('Login Failed',style: TextStyle(color: Colors.red),),

//             content: Text('${data['message']}'),
//             actions: [
//               ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     } else {
//       showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Login Failed',style: TextStyle(color: Colors.red),),
//           content: Text('An error occurred while trying to log in.'),
//           actions: [
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   } catch (error) {
//     print('Error: $error');
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Login Failed',style: TextStyle(color: Colors.red),),
//         content: Text('Incorrect Username Or Password'),
//         actions: [
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }

  // Future<void> loginfunction() async {
  //   final String apiUrl =
  //       '${MySharedPrefrence().get_api_path().toString()}api/login.php';
  //   final String username = login_email.text;
  //   final String password = login_password.text;

  //   http.post(Uri.parse(apiUrl), body: {
  //     'email': username,
  //     'password': password,
  //     'cell_token':tokenpush==null||tokenpush==""?MySharedPrefrence().get_push_token():tokenpush
  //     // 'ehKguz13Q5e2OYOxoTzz7k:APA91bFKo9zPrNvl8WLfRCZy5KUgJNoVklfiqnl1GMvkbiNx088haZHQrbBa3hRKiAEMjC6Qz6DoKvJ4yGlyr5XWkP8uOkP357bLhx4zw8qQjKZ2cuaj-sxLcYQ9Aw1chc519MED4eLc',
  //   }).then((response) {
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);
  //       print('Response: ' + response.body);
  //       if (data['success'] == 1) {
  //         MySharedPrefrence().setUserLoginStatus(true);
  //         MySharedPrefrence().set_user_id(data['admin_id'].toString());
  //         MySharedPrefrence().set_user_name(data['first_name'].toString());

  //         MySharedPrefrence().set_user_image(data['image'].toString());
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => TeacherBtmbar(),
  //           ),
  //         );
  //       } else {
  //         showDialog(
  //           barrierDismissible: false,
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: Text('Login Failed'),
  //             content: Text('${data['message']}'),
  //             actions: [
  //               ElevatedButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: Text('OK'),
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     } else {
  //       showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text('Login Failed'),
  //           content: Text('An error occurred while trying to log in.'),
  //           actions: [
  //             ElevatedButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   });
  // }

  void openGmailLoginPage() async {
    const url = 'https://mail.google.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final form = GlobalKey<FormState>();
  bool passToggle = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
              VitalBackgroundImage(),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 40),
              // key: form,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  // Text(MySharedPrefrence().get_push_token()),
                  Text(
                    'Hello Again!',
                    style: TextStyle(
                        color: colorController.normalgreenbtnclr,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 50),
                    child: Text(
                      "Welcome back you've been missed",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: colorController.normalgreenbtnclr, fontSize: 33),
                    ),
                  ),
                  Form(
                    key: form,
                    child: Column(
                      children: [
                        reusabletextfield(context, login_email, true, 'Enter Email',
                            Icons.email, true, 0.078, 10),
                        reusablepasswordtextfield(
                            login_password, "Enter Password", passToggle, () {
                          setState(() {
                            passToggle = !passToggle;
                          });
                        }, true),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  reusablebtn(
                    context,
                    "Login",
                    colorController.normalgreenbtnclr,
                    0.9,
                    () {
                      if (form.currentState!.validate()) {
                        loginfunction(context);
                      }
                    },
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 25, right: 10, bottom: 40),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Text(
                  //         "Not a member? ",
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: colorController.normalgreenbtnclr,
                  //         ),
                  //       ),
                  //       InkWell(
                  //         onTap: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       TeacherRegister(tokenpush: tokenpush)));
                  //         },
                  //         child: Text(
                  //           'Register now',
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //               color: colorController.normalgreenbtnclr,
                  //               fontSize: 20),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Text(MySharedPrefrence().get_push_token()),
                  // Text("\nadfa\n\n"),

                  // Text(tokenpush)
                ],
              )),
            ),
            isLoading==true?
            CupertinoAlertDialog(title: reusableloadingrow(context)):Container(),
            
          ],
        ),
      ),
    );
  }
}
