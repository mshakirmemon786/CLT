import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_notifications/res/bg.dart';
import 'package:http/http.dart' as http;
import '../../../../controller/colors.dart';
import '../../../../local/sharedprefencevalues.dart';
import '../../../../res/offline.dart';
import '../../../../res/veiwbooksbtn.dart';

import '../../btmbr.dart';
import '3assignment.dart';

class TeacherViewChapter extends StatefulWidget {
  TeacherViewChapter({required this.book_id});
  String book_id;

  @override
  State<TeacherViewChapter> createState() =>
      _TeacherViewChapterState(book_id: book_id);
}

class _TeacherViewChapterState extends State<TeacherViewChapter> {
  _TeacherViewChapterState({required this.book_id});
  String book_id;

  Future<List<Map<String, dynamic>>> fetchdata() async {
    final apiUrl =
        '${MySharedPrefrence().get_api_path().toString()}api/chapter.php';

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        "user_id": MySharedPrefrence().get_user_id(),
        'book_id': book_id
      });

      if (response.statusCode == 200) {
        print(response.body);
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
    return Scaffold(
      // backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        backgroundColor: colorController.normalgreenbtnclr,
        title: Text('Video Lessons', style: TextStyle(color: Colors.white)),
      ),
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
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => TeacherBtmbar()));
                });
              } else if (snapshot.hasData) {
                final List<Map<String, dynamic>> data = snapshot.data!;

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    return Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: viewbooksbtn(
                          context,
                          item['verify_status'].toString(),
                          true,
                          item['lock_status'].toString(),
                          index <= 8 ? "0${index + 1}" : "${index + 1}",
                          item['chapter_name'],
                          item['chapter_description'],
                          item['chapter_image'], () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TeacherAssignment(
                                      chapter_id: item['chapter_id'] == null
                                          ? ""
                                          : item['chapter_id'],
                                      chapter_title:
                                          item['chapter_name'] == null ||
                                                  item['chapter_name'] == ""
                                              ? "No Title Available"
                                              : item['chapter_name'],
                                      chapter_video_url:
                                          item['chapter_video_url'],
                                      chapter_description:
                                          item['chapter_description'] == null ||
                                                  item['chapter_description'] ==
                                                      ""
                                              ? "No Description Available"
                                              : item['chapter_description'],
                                    )));
                      }),
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
    );
  }
}
