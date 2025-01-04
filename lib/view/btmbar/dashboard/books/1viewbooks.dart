import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_notifications/res/bg.dart';
import 'package:flutter_firebase_notifications/res/offline.dart';
import 'package:http/http.dart' as http;

import '../../../../controller/colors.dart';
import '../../../../local/sharedprefencevalues.dart';
import '../../../../res/veiwbooksbtn.dart';
import '../../btmbr.dart';
import '2viewchapter.dart';

class TeacherViewBooks extends StatefulWidget {
  TeacherViewBooks({required this.cource_id, required this.appbar_or_not});
  String cource_id;
  bool appbar_or_not;

  @override
  State<TeacherViewBooks> createState() => _TeacherViewBooksState(
      cource_id: cource_id, appbar_or_not: appbar_or_not);
}

class _TeacherViewBooksState extends State<TeacherViewBooks> {
  _TeacherViewBooksState(
      {required this.cource_id, required this.appbar_or_not});
  String cource_id;
  bool appbar_or_not;

  Future<List<Map<String, dynamic>>> fetchdata() async {
    final apiUrl =
        // "https://admin.cltpk.com/CLT/api/book.php?user_id=143&course_id=9";
        '${MySharedPrefrence().get_api_path().toString()}api/book.php';

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        "user_id": MySharedPrefrence().get_user_id(),
        'course_id': cource_id
      });

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

  // bool appbar_or_not = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            // backgroundColor: Colors.green.shade50,

            appBar: appbar_or_not == true
                ? AppBar(
                    centerTitle: true,
                    iconTheme: IconThemeData(color: Colors.white),
                    leading: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeacherBtmbar()));
                        },
                        child: Icon(Icons.arrow_back_ios)),
                    title:
                        Text("Books  ", style: TextStyle(color: Colors.white)),
                    backgroundColor: colorController.normalgreenbtnclr,
                  )
                : null,
            body: Stack(
              children: [
                VitalBackgroundImage(),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchdata(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: colorController.normalgreenbtnclr,
                      ));
                    } else if (snapshot.hasError) {
                      return reusbaleofflinepage(context, () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => TeacherBtmbar()));
                      });
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No data available.');
                    } else {
                      final List<Map<String, dynamic>>? data = snapshot.data;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.58),
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return
                              // Text("adfa");
                              Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: viewbooksbtn(
                                context,
                                '0',
                                false,
                                item["book_lock"],
                                index <= 8
                                    ? "0${(index + 1).toInt()}"
                                    : "${(index + 1).toInt()}",
                                item['book_name'],
                                "",
                                item['book_image'], () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TeacherViewChapter(
                                          book_id:
                                              item["book_id"].toString())));
                              // TeacherChapter(
                              //   book_id:item["book_id"])));
                            }),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            )));
  }
}
