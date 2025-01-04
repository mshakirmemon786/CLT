import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_notifications/res/bg.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../controller/colors.dart';
import '../../../../local/sharedprefencevalues.dart';
import '../../../../res/assignmentpage.dart';
import '../../../../res/btn.dart';
import '../../../../res/textfield.dart';
import '../../../../res/veiwbooksbtn.dart';
import '../../../../res/video.dart';
import '../../btmbr.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TeacherAssignment extends StatefulWidget {
  TeacherAssignment(
      {required this.chapter_id,
      required this.chapter_title,
      required this.chapter_video_url,
      required this.chapter_description});
  String chapter_id;
  String chapter_title;
  String chapter_video_url;
  String chapter_description;

  @override
  State<TeacherAssignment> createState() => _TeacherAssignmentState(
        chapter_id: chapter_id,
        chapter_title: chapter_title,
        chapter_video_url: chapter_video_url,
        chapter_description: chapter_description,
      );
}

class _TeacherAssignmentState extends State<TeacherAssignment> {
  _TeacherAssignmentState(
      {required this.chapter_id,
      required this.chapter_title,
      required this.chapter_video_url,
      required this.chapter_description});
  String chapter_id;
  String chapter_title;
  String chapter_video_url;
  String chapter_description;

  TextEditingController remarks = TextEditingController();
  Future<List<Map<String, dynamic>>> fetchdata() async {
    final apiUrl =
        '${MySharedPrefrence().get_api_path().toString()}api/assignment_user.php';

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        "user_id": MySharedPrefrence().get_user_id(),
        'chapter_id': chapter_id
      });

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            json.decode(response.body).cast<Map<String, dynamic>>();
        // status = data['staus'] as;
        final responseData = json.decode(response.body);
        status = responseData[0]['status'] as int;
        setState(() {});

        return data;
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  bool selectvideo = false;
  var videopath;
  int status = 0;
  bool videostatus = true;
  File? selectedVideo;
  double uploadProgress = 0.0;
  bool isUploading = false;
  var progress;
  XFile? videogallary;

  void pickVideo() async {
    final picker = ImagePicker();
    try {
      videogallary = await picker.pickVideo(source: ImageSource.gallery);

      if (videogallary != null) {
        String videoPath = videogallary!.path;
        selectedVideo = File(videogallary!.path);
        uploadProgress = 0.0;
        isUploading = false;
        selectvideo = true;

        setState(() {
          videopath = videogallary!.path;
        });
        setState(() {});

        print('Selected video path: $videoPath');
      } else {
        print('No video selected');
      }
    } catch (e) {
      print('Error picking video: $e');
    }
  }

  void RecordVideo() async {
    final picker = ImagePicker();
    try {
      videogallary = await picker.pickVideo(source: ImageSource.camera);

      if (videogallary != null) {
        String videoPath = videogallary!.path;
        selectedVideo = File(videogallary!.path);
        uploadProgress = 0.0;
        isUploading = false;
        selectvideo = true;

        setState(() {
          videopath = videogallary!.path;
        });
        setState(() {});
        print('Selected video path: $videoPath');
      } else {
        print('No video selected');
      }
    } catch (e) {
      print('Error picking video: $e');
    }
  }

  Future<void> uploadtoapi() async {
    if (selectedVideo == null || isUploading) {
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '${MySharedPrefrence().get_api_path().toString()}api/assignment.php'),
    );
    request.fields['user_id'] = MySharedPrefrence().get_user_id().toString();
    request.fields['chapter_id'] = chapter_id;
    request.fields['remarks'] = remarks.text;
    request.files.add(await http.MultipartFile.fromPath(
      'video',
      selectedVideo!.path,
    ));

    setState(() {
      isUploading = true;
    });

    var streamedResponse = await request.send();
    var totalBytes = streamedResponse.contentLength ?? 0;
    var uploadedBytes = 0;

    streamedResponse.stream.listen(
      (data) {
        uploadedBytes += data.length;
        progress = uploadedBytes / totalBytes;
        setState(() {
          uploadProgress = progress;
        });
      },
      onDone: () async {
        setState(() {
          isUploading = false;
        });
        if (streamedResponse.statusCode == 200) {
          // // Read the response content from the stream
          // var responseContent = await http.Response.fromStream(streamedResponse);

          // // Print the response content as a string
          // print('API Response: ${responseContent.body}');

          print('Uploaded successfully');
        } else {
          print(
              'Failed to upload video. Status code: ${streamedResponse.statusCode}');
        }
      },
      onError: (e) {
        setState(() {
          isUploading = false;
        });
        print('Error uploading video: $e');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
    // status = fetchdata() as int?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        leading: InkWell(
            onTap: () {
              isUploading == false ? Navigator.pop(context) : null;
            },
            child: Icon(Icons.arrow_back_ios)),
        backgroundColor: colorController.normalgreenbtnclr,
        title: Text('Video Lesson', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          VitalBackgroundImage(),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 10, left: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fieldreusablebtn(
                      context,
                      10,
                      5,
                      0.06,
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Title: $chapter_title",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: colorController.normalgreenbtnclr),
                            ),
                          ],
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(bottom: 8, top: 5),
                      height: MediaQuery.of(context).size.height * 0.26,
                      width: MediaQuery.of(context).size.width * 0.94,
                      child: HomeScreen(videolink: chapter_video_url)),
                  chapter_description == ""
                      ? Text("")
                      : Text(
                          '${chapter_description.length > 26 ? 'Topic: ...${chapter_description.substring(0, 26)}' : "Topic: $chapter_description"}',
                          // "Description: $chapter_description",
                          style: TextStyle(
                              color: colorController.normalgreenbtnclr),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 5),
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchdata(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                        // Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: reusablebtn(
                              context,
                              "Check Internet Try Again",
                              Colors.orange,
                              0.9, () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => TeacherBtmbar()));
                          }),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No data available.');
                      } else {
                        final List<Map<String, dynamic>>? data = snapshot.data;

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.0,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              // childAspectRatio: 0.59
                            ),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              final item = data![index];
                              status = item['status'];
                              setState(() {
                                status = item['status'];
                              });
                              // return
                            },
                          ),
                        );
                      }
                    },
                  ),
                  Row(
                    children: [
                      if (status == 0) ...{
                        fieldreusablebtn(
                          context,
                          0,
                          5,
                          0.38,
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Upload Demo Video Here",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                // reusabletextfield(
                                //     context,
                                //     remarks,
                                //     true,
                                //     'Remarks: Type Remarks',
                                //     Icons.comment,
                                //     false,
                                //     0.05,
                                //     0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(children: [
                                      reusableselectvidebtn(
                                          context,
                                          false,
                                          videostatus,
                                          selectvideo,
                                          "",
                                          "Upload  Video",
                                          Icons.video_file_outlined, () {
                                        pickVideo();
                                      }),
                                      selectedVideo != null
                                          ? Text("Video is Selected",
                                              style: TextStyle(
                                                  color: colorController
                                                      .normalgreenbtnclr))
                                          : Container()
                                    ]),
                                    selectedVideo != null
                                        ? isUploading
                                            ? SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: Column(
                                                  children: [
                                                    // Text('Assignment\nUploading'),
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.12,
                                                        child: Image.asset(
                                                            ("assets/loading.webp"))),
                                                    Text('Please Wait...'),
                                                  ],
                                                ),
                                              )
                                            : Container()
                                        : Container()
                                  ],
                                ),
                                reusablebtn(
                                  context,
                                  "Submit Assignment",
                                  selectedVideo != null
                                      ? colorController.normalgreenbtnclr
                                      : colorController.greytextfieldlableclr,
                                  0.95,
                                  () {
                                     selectedVideo != null?
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: Text(selectvideo == true
                                              ? 'Submit Your Assignment'
                                              : 'Assignment Alert'),
                                          content: Text('Select video Firstly'),
                                          actions: [
                                            CupertinoDialogAction(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Dismiss the dialog
                                              },
                                              child: Text(  
                                                  selectvideo == true
                                                      ? 'No'
                                                      : "Back",
                                                  style: TextStyle(
                                                      color: colorController
                                                          .rederrortextclr)),
                                            ),
                                            selectvideo == true
                                                ? CupertinoDialogAction(
                                                    onPressed: () {
                                                      uploadtoapi();

                                                      Navigator.of(context)
                                                          .pop(); // Dismiss the dialog
                                                    },
                                                    isDefaultAction: true,
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: colorController
                                                              .normalgreenbtnclr),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        );
                                      },
                                    ):null;

                                    if (selectvideo == true) {
                                      if (isUploading == false) {}
                                    } else
                                      null;
                                    if (selectvideo == false) {
                                      setState(() {
                                        videostatus = false;
                                      });
                                    } else {
                                      setState(() {
                                        videostatus = true;
                                      });
                                    }
                                  },
                                ),
                              ]),
                        ),
                      } else if (status == 1) ...{
                        reusablestutus(context, "pending.png",
                            "Your Assignment \nhas been Submitted\n Waiting for Approve")
                      } else if (status == 2) ...{
                        reusablestutus(context, "complete.png",
                            "Your Assignment \nhas been Approved")
                      }
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
