
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_notifications/res/bg.dart';

import '../../../controller/colors.dart';
import '../../../local/sharedprefencevalues.dart';
import 'package:http/http.dart' as http;

import '../../../res/offline.dart';
import '../btmbr.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Future<List<Map<String, dynamic>>> getnotification() async {
    final apiUrl =
        '${MySharedPrefrence().get_api_path().toString()}api/notification.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
        "user_id":MySharedPrefrence().get_user_id().toString(),
        // "category_id":"41",
        }
      );

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios,color: colorController.normalgreenbtnclr,)),
          // backgroundColor: colorController.normalgreenbtnclr,
          title: Padding(
            padding: const EdgeInsets.only(right: 150),
            child: Text(
              "Notifications",
              // textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: colorController.normalgreenbtnclr, fontSize: 25),
            ),
          ),
        ),
        body: 
      Stack(
          children: [
              VitalBackgroundImage(),
          Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getnotification(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(  color: colorController.normalgreenbtnclr,));
                } else if (snapshot.hasError) {
                  return reusbaleofflinepage(context, (){
                      Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                    TeacherBtmbar()));
                                                    });
                } else if (snapshot.hasData) {
                  final List<Map<String, dynamic>> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      // final item = data[index];
                        final reversedIndex = snapshot.data!.length - 1 - index;
                        final item = data[reversedIndex];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (MySharedPrefrence().get_user_id() ==
                              item['user_id']) ...{
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                              
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                      
                                        Image.network('https://cdn-icons-png.flaticon.com/512/9145/9145748.png',height: 40,),
                                        // Icon(
                                        //   Icons.message,
                                        //   color:
                                        //       colorController.normalgreenbtnclr,
                                        //   size: 40,
                                        // ),
                                        Container(
                                          // padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.only(left: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *0.1,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.start,
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${item['message'].toString()}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.21,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: colorController
                                                  .normalgreenbtnclr,
                                            ),
                                            Text(
                                              "${item['datetime'].toString()}",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: colorController
                                                      .normalgreenbtnclr),
                                            ),
                                          ],
                                        ))
                                  ],
                                )
                                //  ListTile(
                                //   leading:

                                //   title:  Text("adsfklas;dfjkas;dfjaskdjfksakljdklfjklasjkdlfjksajkdfjjsakjfjsadkljf;jaksjfkjskljf;jsajfkl;sadr{item['message'].toString()}",
                                //   style: TextStyle(fontWeight: FontWeight.bold),
                                //   ),
                                //   trailing: SizedBox(
                                //     width: MediaQuery.of(context).size.width*0.19,
                                //     child: Column(
                                //       crossAxisAlignment: CrossAxisAlignment.center,
                                //       children: [
                                //         Icon(Icons.calendar_month,color: colorController.normalgreenbtnclr,),
                                //         Text("${item['datetime'].toString()}",textAlign: TextAlign.right,style: TextStyle(color: colorController.normalgreenbtnclr),),
                                //       ],
                                //     ))),
                                ),
                              ],
                            )
                          }
                        ],
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
    ));
  }
}
