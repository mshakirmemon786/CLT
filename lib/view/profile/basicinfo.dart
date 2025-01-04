import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../controller/colors.dart';
import '../../local/sharedprefencevalues.dart';
import '../../res/bg.dart';
import '../../res/offline.dart';
import '../../res/profileline.dart';
import '../btmbar/btmbr.dart';

class TeacherProfileBasicInfo extends StatefulWidget {
  const TeacherProfileBasicInfo({super.key});

  @override
  State<TeacherProfileBasicInfo> createState() =>
      _TeacherProfileBasicInfoState();
}

class _TeacherProfileBasicInfoState extends State<TeacherProfileBasicInfo> {
  Future<List<Map<String, dynamic>>> fetchdata() async {
    final apiUrl =
        '${MySharedPrefrence().get_api_path().toString()}api/profile.php';

    try {
      final response = await http.post(Uri.parse(apiUrl),
          body: {"user_id": MySharedPrefrence().get_user_id()});

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
        //  appBar: AppBar(title: Text("Teacher Info"),
        // backgroundColor:colorController.normalgreenbtnclr,

        // ),

        body: Stack(

          children: [
            VitalBackgroundImage(),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchdata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(  color: colorController.normalgreenbtnclr,));
                } else if (snapshot.hasError) {
                  return 
                  reusbaleofflinepage(context, (){
                      Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TeacherProfileBasicInfo()));
                  });
                  // Center(child: Text('Error: Reload the page'));
                } else if (snapshot.hasData) {
                  final List<Map<String, dynamic>> data = snapshot.data!;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];

                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(11),
                            margin: EdgeInsets.all(18),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10), // Add rounded corners if desired
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey, // Shadow color
                                  offset: Offset(0,
                                      2), // Shadow position (horizontal, vertical)
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Navigator.pop(context);
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TeacherBtmbar()));
                                        },
                                        //  child:
                                        // CircleAvatar(backgroundColor:colorController.normalgreenbtnclr,
                                        child: Icon(Icons.arrow_back_ios,
                                            color:
                                                colorController.normalgreenbtnclr),
                                        //  ),
                                      ),
                                      //  Text(" "),

                                      Text(
                                        'Profile Settings',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                colorController.normalgreenbtnclr,
                                            fontSize: 20),
                                      ),
                                      //  Text(" "),
                                      Text(" ")
                                    ],
                                  ),
                                  reusableimgornot(context, 150,),
                                  // Text("${MySharedPrefrence().get_api_path().toString()}${MySharedPrefrence().get_user_image()}"),
                                  //       Container(
                                  //         padding: EdgeInsets.all(5),
                                  // // width: MediaQuery.ofrf(context).size.height*0.3, // Adjust the size as needed
                                  // height:150,width:150,
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  //   shape: BoxShape.circle,
                                  //   border: Border.all(
                                  //     color: colorController.normalgreenbtnclr, // Set your desired border color
                                  //     width: 2.0, // Set your desired border width
                                  //   ),
                                  // ),
                                  //         child: cicleiamgereusable(159, "no.jpeg")
                                  //       ),
                                  Text(
                                    MySharedPrefrence().get_user_name(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colorController.normalgreenbtnclr,
                                        fontSize: 20),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //  ListTile(leading: Icon(Icons.person,color: colorController.normalgreenbtnclr),title:  Text("${item['last_name']==null?"":item['last_name']}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: colorController.normalgreenbtnclr),)),
                                ListTile(
                                    leading: Icon(Icons.phone,
                                        color: colorController.normalgreenbtnclr),
                                    title: Text(
                                      "${item['user_contact'] == null ? "" : item['user_contact']}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colorController.normalgreenbtnclr),
                                    )),
                                ListTile(
                                    leading: Icon(Icons.location_city,
                                        color: colorController.normalgreenbtnclr),
                                    title: Text(
                                      "${item['city'] == null ? "" : item['city']}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colorController.normalgreenbtnclr),
                                    )),
                                ListTile(
                                    leading: Icon(Icons.home,
                                        color: colorController.normalgreenbtnclr),
                                    title: Text(
                                      "${item['user_address'] == null ? "" : item['user_address']}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colorController.normalgreenbtnclr),
                                    )),
                                ListTile(
                                    leading: Icon(Icons.email,
                                        color: colorController.normalgreenbtnclr),
                                    title: Text(
                                      "${item['user_email'] == null ? "" : item['user_email']}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colorController.normalgreenbtnclr),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
