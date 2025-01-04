import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/colors.dart';
import 'package:http/http.dart' as http;

import '../../local/sharedprefencevalues.dart';
import '../../main.dart';
import '../../res/bg.dart';
import '../../res/btn.dart';
import 'login/login.dart';

class AccountLoginOrRegister extends StatefulWidget {
  AccountLoginOrRegister(
      {required this.tokenpush,
      required this.pushtoken_or_null,
      required this.home_or_login});
  String tokenpush;
  bool pushtoken_or_null;
  bool home_or_login;
  @override
  _AccountLoginOrRegisterState createState() => _AccountLoginOrRegisterState(
      tokenpush: tokenpush,
      pushtoken_or_null: pushtoken_or_null,
      home_or_login: home_or_login);
}

class _AccountLoginOrRegisterState extends State<AccountLoginOrRegister> {
  _AccountLoginOrRegisterState(
      {required this.tokenpush,
      required this.pushtoken_or_null,
      required this.home_or_login});
  String tokenpush;
  bool pushtoken_or_null;
  bool home_or_login;
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return true;
  }

  Future<String> fetchCltUrl() async {
    final response = await http
        .get(Uri.parse('https://ideazshuttle.com/super_app/api/clt.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String cltUrl = data['clt_url'];

      print(cltUrl);
      // MySharedPrefrence().set_api_path(data['clt_url'].toString());
      MySharedPrefrence().set_api_path("https://admin.cltpk.com/CLT/");

      print(MySharedPrefrence().get_api_path().toString());

      return cltUrl;
    } else {
      throw Exception('Failed to fetch clt_url');
    }
  }

  @override
  void Initstate() {
    super.initState();
    MySharedPrefrence().get_push_token();
    setState(() {});
    checkInternetConnectivity();

    fetchCltUrl();
    // pushtoken().get_push_token();
    // print(MySharedPrefrence().get_push_token());
  }

  // void showdialog() {
  //   showDialog(builder: (context) {
  //     return AlertDialog(
  //       // title: Text('Inter'),
  //       content: Image.asset(
  //           'assets/nointernet.png'), // Replace 'your_image.png' with your image path
  //       actions: <Widget>[
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) =>
  //                         AccountLoginOrRegister())); // Close the dialog
  //           },
  //           child: Text('OK'),
  //         ),
  //       ],
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                VitalBackgroundImage(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 18, left: 18, right: 15, bottom: 40),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: AssetImage("assets/clt.png"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    // Text(pushtoken().get_push_token()==null?"restart":"token"),
                    Text(
                      'Discover your \nDream job Here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          color: colorController.normalgreenbtnclr),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 40),
                      child: Text(
                        '"Welcome to the CLT Certified Literacy Teacher Learning App: Begin Your Journey Toward Excellence in Literacy Education - Register or Login to Your Account"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: colorController.normalgreenbtnclr),
                      ),
                    ),
                    // MySharedPrefrence().get_push_token() == null ||
                    //         MySharedPrefrence().get_push_token() == "" ||
                    //         tokenpush == "" ||
                    //         tokenpush == null
                    //     ?

                    reusablebtn(
                        context, 
                        home_or_login==true?
                        "Home":'Login', colorController.normalgreenbtnclr, 0.9,
                        () {
                      fetchCltUrl();
                      setState(() {});
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => 

                              home_or_login==true?
                              AccountLoginOrRegister(
                                    home_or_login: false,
                                    pushtoken_or_null: false,
                                    tokenpush: '',
                                  ):TeacherLogin(tokenpush: tokenpush)));
                    })
                    // : reusablebtn(context, "Login",
                    //     colorController.normalgreenbtnclr, 0.9, () {
                    //     fetchCltUrl();
                    //     setState(() {});
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>
                    //                 TeacherLogin(tokenpush: tokenpush)));
                    //   })
                    // Stack(
                    //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Align(
                    //         alignment: Alignment.center,
                    //         child: Padding(
                    //           padding: EdgeInsets.only(left: 100.0),
                    //           child: reusablebtn(
                    //             context,
                    //             'Login',
                    //             Color.fromARGB(255, 183, 182, 184),
                    //             0.4,
                    //             () {
                    //               // print(pushtoken().get_push_token());

                    //               fetchCltUrl();
                    //               setState(() {});
                    //               Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (context) => TeacherLogin(
                    //                           tokenpush: tokenpush)));
                    //             },
                    //           ),
                    //         )),
                    //     Positioned(
                    //       left: 55,
                    //       child: reusablebtn(
                    //         context,
                    //         'Register',
                    //         colorController.normalgreenbtnclr,
                    //         0.4,
                    //         () {
                    //           fetchCltUrl();
                    //           setState(() {});
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => TeacherRegister(
                    //                       tokenpush: tokenpush)));
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            )
            // : FutureBuilder<bool>(
            //     future: checkInternetConnectivity(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         // While waiting for the future to complete, you can show a loading indicator
            //         return Container();
            //       } else if (snapshot.hasError) {
            //         // Handle any errors that occur during connectivity check
            //         return Text('Error: ${snapshot.error}');
            //       } else if (snapshot.data == true) {
            //         // Internet is available, navigate to the homepage
            //         return Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Container(
            //               margin: EdgeInsets.only(
            //                   top: 18, left: 18, right: 15, bottom: 40),
            //               height: MediaQuery.of(context).size.height * 0.5,
            //               width: MediaQuery.of(context).size.width,
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(30),
            //                 image: DecorationImage(
            //                     image: AssetImage("assets/clt.png"),
            //                     fit: BoxFit.cover),
            //               ),
            //             ),
            //             // Text(pushtoken().get_push_token()==null?"restart":"token"),
            //             Text(
            //               'Discover your \nDream job Here',
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                   fontSize: 24,
            //                   color: colorController.normalgreenbtnclr),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(
            //                   top: 20, left: 15, right: 15, bottom: 40),
            //               child: Text(
            //                 '"Welcome to the CLT Certified Literacy Teacher Learning App: Begin Your Journey Toward Excellence in Literacy Education - Register or Login to Your Account"',
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(
            //                     fontSize: 15,
            //                     color: colorController.normalgreenbtnclr),
            //               ),
            //             ),
            //             Stack(
            //               // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: [
            //                 Align(
            //                     alignment: Alignment.center,
            //                     child: Padding(
            //                       padding: EdgeInsets.only(left: 100.0),
            //                       child: reusablebtn(
            //                         context,
            //                         'Login',
            //                         Color.fromARGB(255, 183, 182, 184),
            //                         0.4,
            //                         () {
            //                           print(pushtoken().get_push_token());

            //                           fetchCltUrl();
            //                           setState(() {});
            //                           Navigator.push(
            //                               context,
            //                               MaterialPageRoute(
            //                                   builder: (context) =>
            //                                       TeacherLogin(
            //                                           tokenpush:
            //                                               tokenpush)));
            //                         },
            //                       ),
            //                     )),
            //                 Positioned(
            //                   left: 55,
            //                   child: reusablebtn(
            //                     context,
            //                     'Register',
            //                     colorController.normalgreenbtnclr,
            //                     0.4,
            //                     () {
            //                       fetchCltUrl();
            //                       setState(() {});
            //                       Navigator.push(
            //                           context,
            //                           MaterialPageRoute(
            //                               builder: (context) =>
            //                                   TeacherRegister(
            //                                       tokenpush: tokenpush)));
            //                     },
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         );
            //       } else {
            //         // No internet connection, show a message
            //         return reusbaleofflinepage(context, () {
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) => MyApp()));
            //         });
            //       }
            //     },
            //   )
            // : reusbaleofflinepage(context, () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => MyApp()));
            //   })),
            ));
  }
}
