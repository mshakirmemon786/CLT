import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../../../main.dart';
import '../../../res/offline.dart';
import '../login/login.dart';
import 'login_api.dart';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../controller/colors.dart';
import '../../../local/sharedprefencevalues.dart';
import '../../../res/btn.dart';
import '../../../res/textfield.dart';

class City {
  final int c_id;
  final String name;

  City({required this.name, required this.c_id});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['city_name'],
      c_id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'c_id': c_id,
      'c_name': name,
    };
  }
}

class TeacherRegister extends StatefulWidget {
  TeacherRegister({required this.tokenpush});
  String tokenpush;

  @override
  _TeacherRegisterState createState() =>
      _TeacherRegisterState(tokenpush: tokenpush);
}

class _TeacherRegisterState extends State<TeacherRegister> {
  _TeacherRegisterState({required this.tokenpush});
  String tokenpush;
  List<dynamic> cities = []; // List to store city data from the API
  int? selectedCityId; // To store the selected city ID

  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController contact = TextEditingController();
  final TextEditingController refferal = TextEditingController();
  // final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final form = GlobalKey<FormState>();

  bool passToggle = true;

  File? _image1;
  String base64Image1 = "IAMGE1";
  bool selectimage1 = false;
  var imagePath1;

  var status = "";
  bool imgstatus = true;
  Future<List<City>>? _cityList;

  City? _selectedCity;
  // var city_id_dropdown;
  var Email;
  @override
  void initState() {
    super.initState();
    checkInternetfetchcity().then((hasInternet) {
      if (hasInternet) {
        fetchCltUrl();
        setState(() {
          _cityList = fetchCities();
        });
        setState(() {});
        // fetchCltUrl();
        setState(() {});
        // _cityList = fetchCities();
      } else {
        reusbaleofflinepage(context, () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        });
      }
    });
    // fetchCities();
    // fetchCltUrl();
    // setState(() {
    // _cityList = fetchCities();
    // });
    // _cityList = fetchCities();
    setState(() {
      // _cityList = fetchCities();
    });
    // _cityList = fetchCities();
    setState(() {
      // _cityList = fetchCities();
    });
  }

  Future checkInternetfetchcity() async {
    //check intenet
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        _cityList = fetchCities();
      });
      _cityList = fetchCities();
      setState(() {});
    }
  }

  Future<List<City>> fetchCities() async {
    final response = await http.get(Uri.parse(
        '${MySharedPrefrence().get_api_path().toString()}/api/city.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<City> cities = data.map((item) => City.fromJson(item)).toList();
      return cities;
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future googleSignIn() async {
    try {
      final user = await GoogleSignInService.login();
      await user?.authentication;
      // log(user!.displayName.toString());
      // log(user.email);
      // log(user.id);
      // log(user.photoUrl.toString());

      setState(() {
        Email = user!.email;
      });

      if (context.mounted) {
        print(user!.email);

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Column(
        //   children: [
        //     Text(
        //         "Name: ${user.displayName}\nEmail: ${user.email}\nId: ${user.id}\nPhotoUrl: ${user.photoUrl}"),
        //     Image.network(user.photoUrl.toString()),
        //   ],
        // )));
      }
    } catch (exception) {
      // log(exception.toString());
    }
  }

  Future googleSignOut() async {
    try {
      await GoogleSignInService.logout();
      // log('Sign Out Success');
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sign Out Success')));
      }
    } catch (exception) {
      // log(exception.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sign Out Failed')));
      }
    }
  }

  Future<void> pickImage1() async {
    final picker = ImagePicker();
    final pickedImage1 = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage1 != null) {
        _image1 = File(pickedImage1.path);
        selectimage1 = true;

        setState(() {
          imagePath1 = pickedImage1.path;
        });
      }
    });
  }

  var cltUrl;
  Future<String> fetchCltUrl() async {
    final response = await http
        .get(Uri.parse('https://ideazshuttle.com/super_app/api/clt.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      cltUrl = data['clt_url'];

      print(cltUrl);
      MySharedPrefrence().set_api_path(data['clt_url'].toString());
      print(MySharedPrefrence().get_api_path().toString());

      return cltUrl;
    } else {
      throw Exception('Failed to fetch clt_url');
    }
  }

  Future<void> _upload() async {
    String base64Image1 = base64Encode(_image1!.readAsBytesSync());

    var response = await http.post(
        Uri.parse(
            "${MySharedPrefrence().get_api_path().toString()}api/add-teacher.php"),
        body: {
          'first_name': firstname.text,
          'last_name': lastname.text,
          'city_id': selectedCityId.toString(),
          'contact': contact.text,
          'address': address.text,
          'referral_code': refferal.text,
          'email':
              // 'mshakirmemon786@gmail.com',
              Email,
          'password': password.text,
          'image': base64Image1,
        });
    // if (response.statusCode == 200) {
    //   print(" uploaded successfully");
    //   print(response.body);

    // } else {
    //   print("Error uploading image");
    // }
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == 1) {
        MySharedPrefrence().setUserLoginStatus(true);
        MySharedPrefrence().set_user_id(responseData['user_id'].toString());
        MySharedPrefrence()
            .set_user_name(responseData['first_name'].toString());
        MySharedPrefrence().set_user_image(responseData['image'].toString());
        setState(() {});
        print("Uploaded successfully");
        print(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 42, 119, 44),
            content: Text("Registered Successfully"),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TeacherLogin(tokenpush: tokenpush)),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Register Faild'),
            content: Text('${responseData['message']}'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        print("Registration failed: ${responseData['message']}");
      }
    } else {
      print("Error uploading image");
    }
  }

  Future<bool> checkInternetConnection() async {
    //check intenet
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (firstname != null &&
          lastname != null &&
          address != null &&
          contact != null &&
          selectedCityId != null &&
          Email != null &&
          password != null &&
          selectimage1 == true) {
        _upload();
        // Navigator.push(contex/t, MaterialPageRoute(builder: (context)=>TeacherBtmbar()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Please the all fields ..."),
          ),
        );
      }

      // Navigator.push(context, MaterialPageRoute(builder: (context)=>TeacherBtmbar()));

      // Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Check your internet connection ..."),
        ),
      );
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
        child: cltUrl == null && _cityList == null
            ? reusbaleofflinepage(context, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeacherRegister(
                              tokenpush: tokenpush,
                            )));
              })
            : Form(
                key: form,
                child: Column(
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(
                          color: colorController.registerpagetextgreenclr,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 20, right: 40, left: 40),
                      child: Text(
                        "Welcome back you've been missed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: colorController.registerpagetextgreenclr,
                            fontSize: 18),
                      ),
                    ),

                    reusabletextfield(context, firstname, true,
                        'Enter First Name', Icons.person, true, 0.078, 10),
                    reusabletextfield(context, lastname, true, 'Enter Last',
                        Icons.person, true, 0.078, 10),
                    reusabletextfield(context, address, true, 'Enter Address',
                        Icons.home, true, 0.078, 10),
                    reusabletextfield(context, contact, true, 'Enter Contact',
                        Icons.phone, true, 0.078, 10),
                    reusabledropdown(
                        context,
                        FutureBuilder(
                          future: _cityList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<City> cities = snapshot.data as List<City>;

                              return DropdownButtonFormField<City>(
                                // dropdownColor: colorController.normalgreenbtnclr,
                                iconEnabledColor:
                                    colorController.normalgreenbtnclr,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.location_city,
                                        color:
                                            colorController.normalgreenbtnclr),
                                    border: InputBorder.none),
                                iconSize: 40,
                                // iconEnabledColor: Color(0xff48b58e),
                                iconDisabledColor: Color(0xff48b58e),
                                // icon: Icon(Icons.arrow_drop_down_sharp,size: 35,color:Color(0xff48b58e),),

                                alignment: AlignmentDirectional.centerStart,
                                hint: Text('Select City',
                                    style: TextStyle(
                                      color: colorController.normalgreenbtnclr,
                                    )),
                                value: _selectedCity,
                                items: cities.map((City city) {
                                  return DropdownMenuItem<City>(
                                    value: city,
                                    child: Text(
                                      city.name,
                                      textAlign: TextAlign.left,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (City? selectedCity) {
                                  setState(() {
                                    selectedCityId = selectedCity!.c_id;
                                    print(selectedCity.c_id);
                                    _selectedCity = selectedCity;
                                  });
                                  setState(() {});
                                },
                              );
                            }
                          },
                        )),
                    FutureBuilder<String>(
                      future: fetchCltUrl(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return Container();
                        } else {
                          // List<City> cities = snapshot.data as List<City>;

                          return Container();
                        }
                      },
                    ),
                    // FutureBuilder(
                    //   future: _cityList,
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return Center(child: CircularProgressIndicator());
                    //     } else if (snapshot.hasError) {
                    //       return Container();
                    //     } else {
                    //       // List<City> cities = snapshot.data as List<City>;

                    //       return
                    //     }
                    //   },
                    // ),
                    // reusabledropdown(
                    //     context,
                    //     FutureBuilder(
                    //       future: _cityList,
                    //       builder: (context, snapshot) {
                    //         if (snapshot.connectionState ==
                    //             ConnectionState.waiting) {
                    //           return Center(child: CircularProgressIndicator());
                    //         } else if (snapshot.hasError) {
                    //           return Center(
                    //               child: Text('Error: ${snapshot.error}'));
                    //         } else {
                    //           List<City> cities = snapshot.data as List<City>;

                    //           return DropdownButtonFormField<City>(
                    //             // dropdownColor: colorController.normalgreenbtnclr,
                    //             iconEnabledColor:
                    //                 colorController.normalgreenbtnclr,
                    //             decoration: InputDecoration(
                    //                 prefixIcon: Icon(Icons.location_city,
                    //                     color: colorController.normalgreenbtnclr),
                    //                 border: InputBorder.none),
                    //             iconSize: 40,
                    //             // iconEnabledColor: Color(0xff48b58e),
                    //             iconDisabledColor: Color(0xff48b58e),
                    //             // icon: Icon(Icons.arrow_drop_down_sharp,size: 35,color:Color(0xff48b58e),),

                    //             alignment: AlignmentDirectional.centerStart,
                    //             hint: Text('Select City',
                    //                 style: TextStyle(
                    //                   color: colorController.normalgreenbtnclr,
                    //                 )),
                    //             value: _selectedCity,
                    //             items: cities.map((City city) {
                    //               return DropdownMenuItem<City>(
                    //                 value: city,
                    //                 child: Text(
                    //                   city.name,
                    //                   textAlign: TextAlign.left,
                    //                 ),
                    //               );
                    //             }).toList(),
                    //             onChanged: (City? selectedCity) {
                    //               setState(() {
                    //                 selectedCityId = selectedCity!.c_id;
                    //                 print(selectedCity.c_id);
                    //                 _selectedCity = selectedCity;
                    //               });
                    //               setState(() {});
                    //             },
                    //           );
                    //         }
                    //       },
                    //     )),

                    // DropdownButtonFormField(
                    //   validator: (value) {
                    //     if (value == null) {
                    //       setState(() {
                    //         status = 'This Field is required.';
                    //       });
                    //     } else {
                    //       setState(() {
                    //         status = "";
                    //       });
                    //     }
                    //     return null;
                    //   },
                    //   // dropdownColor: colorController.normalgreenbtnclr,
                    //   iconEnabledColor: colorController.normalgreenbtnclr,
                    //   decoration: InputDecoration(
                    //       prefixIcon: Icon(Icons.location_city,
                    //           color: colorController.normalgreenbtnclr),
                    //       border: InputBorder.none),
                    //   value: selectedCityId,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       selectedCityId = value as int?;
                    //       print(selectedCityId);
                    //     });
                    //   },
                    //   items: cities.map((city) {
                    //     return DropdownMenuItem(
                    //       value: city['id'],
                    //       child: Text(
                    //         city['city_name'],
                    //         style: TextStyle(
                    //             color: colorController.normalgreenbtnclr,
                    //             fontSize: 15),
                    //       ),
                    //     );
                    //   }).toList(),
                    //   hint: Text(
                    //     'Select City',
                    //     style: TextStyle(color: colorController.normalgreenbtnclr),
                    //   ),
                    // ),

                    // status==""?"":status=="",

                    if (status != "") ...{
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "This Field is Required",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: colorController.rederrortextclr,
                                  fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    } else ...{
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                      )
                    },

                    reusabletextfield(
                        context,
                        refferal,
                        true,
                        'Enter Referral Code',
                        Icons.reduce_capacity_rounded,
                        false,
                        0.078,
                        10),

                    InkWell(
                      onTap: () {
                        googleSignIn();
                        // googleSignOut();
                        // openGmailLoginPage();
                      },
                      child: reusabledropdown(
                          context,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 8, top: 10, bottom: 10),
                                child: Image.asset("assets/googleemail.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  Email == null || Email == ""
                                      ? "Press to Login With Google"
                                      : Email,
                                  style: TextStyle(
                                      color: colorController.normalgreenbtnclr),
                                ),
                              )
                            ],
                          )),
                    ),
                    // Text(
                    //   Email == null || Email == ""
                    //       ? "Press to Login With Google"
                    //       : Email,
                    // ),
                    // reusabletextfield(context, email, true, 'Enter Email',
                    //     Icons.email, true, 0.078, 10),
                    reusablepasswordtextfield(
                        password, "Enter Password", passToggle, () {
                      setState(() {
                        passToggle = !passToggle;
                      });
                    }, true),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // reusableimgbtn(context, true,Icons.photo,imgstatus,(){
                        // pickImage1();
                        // }),

                        reusableselectimgbtn(context, false, imgstatus,
                            selectimage1, "", "Browse Image", Icons.photo, () {
                          pickImage1();
                        }),
                        reusableselectimgbtn(
                            context,
                            true,
                            imgstatus,
                            selectimage1,
                            imagePath1 == null ? " " : imagePath1,
                            "Browse Image",
                            Icons.photo,
                            () {}),

                        // reusbalenoimage(context,false,
                        //   Image.file(File(imagePath1))
                        // )
                      ],
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    reusablebtn(
                      context,
                      "Register",
                      colorController.normalgreenbtnclr,
                      0.9,
                      () {
                        print(Email);
                        print(MySharedPrefrence().get_push_token().toString());
                        if (form.currentState!.validate()) {
                          checkInternetConnection();
                        }
                        if (selectedCityId != null) {
                          status == "";
                        }
                        if (selectimage1 == false) {
                          imgstatus = false;
                        } else {
                          imgstatus = true;
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorController.normalgreenbtnclr,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TeacherLogin(tokenpush: tokenpush)));
                            },
                            child: Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorController.normalgreenbtnclr,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      )),
    );
  }
}
//       body: Center(
//         child: DropdownButtonFormField(
//             decoration: InputDecoration(prefixIcon: Icon(Icons.abc),

//             border: InputBorder.none),
//             // dropdownColor: Colors.blue,
//             value: selectedCityId,
//             onChanged: (value) {
//               setState(() {
//                 selectedCityId = value as int?;
//                 print(selectedCityId);
//               });
//             },
//             items: cities.map((city) {
//               return DropdownMenuItem(
//                 value: city['c_id'],
//                 child: Text(city['c_name']),
//               );
//             }).toList(),
//             hint: Text('Select City'),

//         ),
//       ),
//     );
//   }
// }
