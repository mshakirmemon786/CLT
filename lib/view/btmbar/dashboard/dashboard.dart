import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/services.dart';
import 'package:flutter_firebase_notifications/res/bg.dart';
import 'package:http/http.dart' as http;

import '../../../controller/colors.dart';
import '../../../local/sharedprefencevalues.dart';
import '../../../main.dart';
import '../../../model/dashboardmodel.dart';
import '../../../model/slidermodel.dart';
import '../../../res/btn.dart';
import '../../../res/video.dart';
import '../btmbr.dart';
import 'books/1viewbooks.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final CarouselController carouselController = CarouselController();
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    getCertificate(); // Fetch image URLs when the widget is initialized
  }

  Future<void> fetchData() async {
    final response = await http.post(Uri.parse(
        '${MySharedPrefrence().get_api_path().toString()}api/slider.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> urls = List<String>.from(data.map((item) => item['image']));

      setState(() {
        imageUrls = urls;
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<List<dashboardmodeljugnu>> getcourse() async {
    var url = Uri.parse(
      "${MySharedPrefrence().get_api_path().toString()}api/course.php",
    );
    final response = await http.post(url, body: {
      "user_id": MySharedPrefrence().get_user_id().toString(),
      "category_id": "41",
    });
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => dashboardmodeljugnu.fromJson(data))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  // Future<List<dashboardrecordmodel>> getrecord() async {
  //   var url = Uri.parse(
  //     "${MySharedPrefrence().get_api_path().toString()}api/result.php",
  //   );
  //   final response = await http.post(url, body: {
  //     "user_id": MySharedPrefrence().get_user_id().toString(),
  //     'cell_token': MySharedPrefrence().get_push_token()
  //   });
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     List jsonResponse = json.decode(response.body);
  //     return jsonResponse
  //         .map((data) => dashboardrecordmodel.fromJson(data))
  //         .toList();
  //   } else {
  //     throw Exception('Unexpected error occured!');
  //   }
  // }

  Future<List<dashboardrecordmodel>> getrecord() async {
    var url = Uri.parse(
      "${MySharedPrefrence().get_api_path().toString()}api/result.php",
    );
    final response = await http.post(url, body: {
      "user_id": MySharedPrefrence().get_user_id().toString(),
      'cell_token': MySharedPrefrence().get_push_token(),
      'login_code': MySharedPrefrence().get_login_code().toString()
    });
    if (response.statusCode == 200) {
      print(response.body);
      List jsonResponse = json.decode(response.body);
      print(MySharedPrefrence().get_login_code().toString());
      // Assuming jsonResponse is a list with a single element
      if (jsonResponse.isNotEmpty) {
        final data = jsonResponse.first;
        final loginCheck = data['login_check'];

        if (loginCheck == 0) {
          print("logout");
          MySharedPrefrence().logout();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WillPopScope(onWillPop: () async => false, child: MyApp()),
              ));
        } else {
          print("login");
        }
      }

      return jsonResponse
          .map((data) => dashboardrecordmodel.fromJson(data))
          .toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  Future<List<dashboardmodelvideo>> videolink() async {
    var url = Uri.parse(
      "${MySharedPrefrence().get_api_path().toString()}api/vide_link.php",
    );
    final response = await http.post(
      url,
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => dashboardmodelvideo.fromJson(data))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> getCertificate() async {
    try {
      final response = await http.post(
        Uri.parse('https://admin.cltpk.com/CLT/api/certificate.php'),
        body: {
          'user_id': MySharedPrefrence().get_user_id(),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        for (final dynamic data in dataList) {
          final String link = data['link'];
          final int status = data['status'];
          MySharedPrefrence().set_certificate_status(data['status'].toString());
          MySharedPrefrence().set_certificate_link(data['link'].toString());
          setState(() {
            MySharedPrefrence()
                .set_certificate_status(data['status'].toString());
            MySharedPrefrence().set_certificate_link(data['link'].toString());
          });
          setState(() {
            MySharedPrefrence()
                .set_certificate_status(data['status'].toString());
            MySharedPrefrence().set_certificate_link(data['link'].toString());
          });
          setState(() {});

          print('Link: ${MySharedPrefrence().get_certificate_status()}');
          print('Status: ${MySharedPrefrence().get_certificate_link()}');

          if (status == 1) {
            print('Your certificate link: $link');
          } else {
            print('Your certificate is not ready.');
          }
        }
      } else {
        throw Exception('Failed to load certificate status');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          // Handle the back button press here
          // You can add your logic to determine whether to allow going back or not
          // For example, you might want to close the app in certain conditions.
          if (MySharedPrefrence().get_user_id() == '') {
            // Close the app
            SystemNavigator.pop();
            return false;
          } else {
            // Allow going back
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: Stack(
            children: [
              VitalBackgroundImage(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    FutureBuilder<List<dashboardrecordmodel>>(
                      future: getrecord(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            // padding: EdgeInsets.all(5),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return reusableboxcontainer(
                                    context,
                                    0.19,
                                    0.9,
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            reusableboxcontainer(
                                                context,
                                                0.03,
                                                0.8,
                                                Center(
                                                    child: Text(
                                                        "Assignment Record"))),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                progresscounter(
                                                    context,
                                                    "Pending",
                                                    snapshot
                                                        .data![index].pending
                                                        .toString(),
                                                    Icons.timelapse),
                                                progresscounter(
                                                    context,
                                                    "Complete",
                                                    snapshot
                                                        .data![index].complete
                                                        .toString(),
                                                    Icons.done),
                                                progresscounter(
                                                    context,
                                                    "Total",
                                                    snapshot.data![index].total
                                                        .toString(),
                                                    Icons.timeline),
                                              ],
                                            ),
                                          ],
                                        )),
                                  );
                                }),
                          );
                        }

                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: colorController.normalgreenbtnclr,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    FutureBuilder<List<dashboardmodeljugnu>>(
                      future: getcourse(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: EdgeInsets.all(5),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return reusableboxcontainer(
                                    context,
                                    0.18,
                                    0.9,
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          print(
                                            MySharedPrefrence().get_user_name(),
                                          );

                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TeacherViewBooks(
                                                        // true,
                                                        cource_id: snapshot
                                                            .data![index]
                                                            .course_id,
                                                        appbar_or_not: true,
                                                      )));
                                        },
                                        child: Container(
                                          // height: MediaQuery.of(context).size.height *
                                          //     0.15,
                                          // width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                200, 255, 255, 255),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "${MySharedPrefrence().get_api_path()}${snapshot.data![index].image}"),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }

                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: colorController.normalgreenbtnclr,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    FutureBuilder<List<dashboardmodelvideo>>(
                      future: videolink(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            // height: MediaQuery.of(context).size.height * 0.235,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: EdgeInsets.all(5),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return reusableboxcontainer(
                                    context,
                                    0.237,
                                    0.10,
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: HomeScreen(
                                          videolink:
                                              snapshot.data![index].videolink),
                                    ),
                                  );
                                }),
                          );
                        }

                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: colorController.normalgreenbtnclr,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    imageUrls.isEmpty
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: colorController.normalgreenbtnclr,
                                ),
                              ],
                            ),
                          )
                        : reusableboxcontainer(
                            context,
                            0.13,
                            0.9,
                            Container(
                              // margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.12,
                              child: carousel_slider.CarouselSlider.builder(
                                itemCount: imageUrls.length,
                                itemBuilder: (BuildContext context, int index,
                                    int realIndex) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                      top: 0,
                                      left: 5,
                                      right: 5,
                                      bottom: 0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        "${MySharedPrefrence().get_api_path().toString()}/${imageUrls[index]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                                options: carousel_slider.CarouselOptions(
                                  scrollPhysics: BouncingScrollPhysics(),
                                  autoPlay: true,
                                  height: MediaQuery.of(context).size.height *
                                      0.12, // Adjust the height as needed
                                  viewportFraction:
                                      0.29, // Display a fraction of the slide
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
