import 'package:flutter/material.dart';

import '../controller/colors.dart';
import '../local/sharedprefencevalues.dart';

String _truncateTitle(String title) {
  List<String> words = title.split(' ');
  if (words.length <= 6) {
    return title;
  } else {
    // Join the first four words and add three dots
    return '${words.sublist(0, 5).join(' ')}...';
  }
}

InkWell viewbooksbtn(
    BuildContext context,
    String verfied_or_not,
    bool row_or_column,
    String lock_or_not,
    String index,
    String title,
    String description,
    String imagepath,
    Function ontap) {
  return InkWell(
    onTap: () {
      lock_or_not == "0" ? null : ontap();
    },
    child: Container(
      margin: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
      padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 2.0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: row_or_column == true
          ? Container(
              padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorController.normalgreenbtnclr,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 7, bottom: 6, top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                                backgroundColor:
                                    colorController.normalgreenbtnclr,
                                backgroundImage:
                                    AssetImage("assets/demoimg.png")),
                            lock_or_not == "0"
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        Color.fromARGB(180, 61, 61, 61),
                                  )
                                : Container()
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  '${title.length > 30 ? '${title.substring(0, 30)}...' : title}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: lock_or_not == "0"
                                          ? Colors.grey.shade500
                                          : Colors.black,
                                      fontWeight: lock_or_not == "0"
                                          ? FontWeight.normal
                                          : FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  '${description.length > 26 ? 'Topic: ...${description.substring(0, 26)}' : "Topic: $description"}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: lock_or_not == "0"
                                          ? Colors.grey.shade500
                                          : Colors.black,
                                      fontWeight: lock_or_not == "0"
                                          ? FontWeight.normal
                                          : FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chapter",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: lock_or_not == "0"
                                        ? Colors.grey.shade500
                                        : Colors.black,
                                    fontWeight: lock_or_not == "0"
                                        ? FontWeight.normal
                                        : FontWeight.bold),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                width:
                                    MediaQuery.of(context).size.width * 0.065,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: lock_or_not == "1"
                                        ? Color.fromARGB(255, 8, 57, 129)
                                        : Color.fromARGB(165, 8, 57, 129)),
                                child: Text(
                                  "$index",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: lock_or_not == "0"
                                          ? Colors.grey.shade300
                                          : Colors.white),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5, top: 10),
                                child: lock_or_not == "0"
                                    ? Icon(
                                        Icons.lock_sharp,
                                        color: Color.fromARGB(255, 94, 34, 34),
                                      )
                                    : verfied_or_not == '1'
                                        ? Image.asset(
                                            "assets/check.png",
                                            height: 25,
                                          )
                                        : Icon(
                                            Icons.lock_open,
                                            color: Colors.green,
                                          ),
                              )
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width * 0.7,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Column(
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             children: [
                        //               SizedBox(
                        //                 width:
                        //                     MediaQuery.of(context).size.width *
                        //                         0.5,
                        //                 child: Text(
                        //                   '${title.length > 23 ? '${title.substring(0, 23)}...' : title}',

                        //                   //  ${_truncateTitle(title)}',
                        //                   // 'Title: $title',
                        //                   textAlign: TextAlign.left,
                        //                   style: TextStyle(
                        //                       fontSize: 12,
                        //                       // fontWeight: FontWeight.bold,
                        //                       color: lock_or_not == "0"
                        //                           ? Colors.grey.shade500
                        //                           : Colors.black,
                        //                       fontWeight: lock_or_not == "0"
                        //                           ? FontWeight.normal
                        //                           : FontWeight.bold),
                        //                 ),
                        //               ),
                        //               SizedBox(
                        //                 width:
                        //                     MediaQuery.of(context).size.width *
                        //                         0.5,
                        //                 child: Row(
                        //                   children: [
                        //                     Text(
                        //                       'Topic:   ',
                        //                       style: TextStyle(
                        //                           fontSize: 14,
                        //                           color: lock_or_not == "0"
                        //                               ? Colors.grey.shade500
                        //                               : Colors.black,
                        //                           fontWeight: lock_or_not == "0"
                        //                               ? FontWeight.normal
                        //                               : FontWeight.bold),
                        //                     ),
                        //                     SizedBox(
                        //                       width: MediaQuery.of(context)
                        //                               .size
                        //                               .width *
                        //                           0.42,
                        //                       child: Column(
                        //                         children: [
                        //                           Text(
                        //                             '$description',
                        //                             style: TextStyle(
                        //                                 fontSize: 14,
                        //                                 color: lock_or_not ==
                        //                                         "0"
                        //                                     ? Colors
                        //                                         .grey.shade500
                        //                                     : Colors.black,
                        //                                 fontWeight:
                        //                                     lock_or_not == "0"
                        //                                         ? FontWeight
                        //                                             .normal
                        //                                         : FontWeight
                        //                                             .bold),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceAround,
                        //             children: [
                        //               Text(
                        //                 "Chapter",
                        //                 textAlign: TextAlign.right,
                        //                 style: TextStyle(
                        //                     // fontWeight: FontWeight.bold,
                        //                     color: lock_or_not == "0"
                        //                         ? Colors.grey.shade500
                        //                         : Colors.black,
                        //                     fontWeight: lock_or_not == "0"
                        //                         ? FontWeight.normal
                        //                         : FontWeight.bold),
                        //               ),
                        //               Container(
                        //                 margin: EdgeInsets.only(left: 5),
                        //                 alignment: Alignment.center,
                        //                 height:
                        //                     MediaQuery.of(context).size.height *
                        //                         0.03,
                        //                 width:
                        //                     MediaQuery.of(context).size.width *
                        //                         0.065,
                        //                 decoration: BoxDecoration(
                        //                     borderRadius:
                        //                         BorderRadius.circular(5),
                        //                     color: lock_or_not == "1"
                        //                         ? Color.fromARGB(
                        //                             255, 8, 57, 129)
                        //                         : Color.fromARGB(
                        //                             165, 8, 57, 129)),
                        //                 child: Text(
                        //                   "$index",
                        //                   textAlign: TextAlign.right,
                        //                   style: TextStyle(
                        //                       fontWeight: FontWeight.bold,
                        //                       color: lock_or_not == "0"
                        //                           ? Colors.grey.shade300
                        //                           : Colors.white),
                        //                 ),
                        //               ),
                        //               Container(
                        //                 margin:
                        //                     EdgeInsets.only(left: 5, top: 10),
                        //                 child: lock_or_not == "0"
                        //                     ? Icon(
                        //                         Icons.lock_sharp,
                        //                         color: Color.fromARGB(
                        //                             255, 94, 34, 34),
                        //                       )
                        //                     : verfied_or_not == '1'
                        //                         ? Image.asset(
                        //                             "assets/check.png",
                        //                             height: 25,
                        //                           )
                        //                         : Icon(
                        //                             Icons.lock_open,
                        //                             color: Colors.green,
                        //                           ),
                        //               )
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorController.normalgreenbtnclr,
                  width: 1,
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Book",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: lock_or_not == "0"
                                      ? Colors.grey.shade500
                                      : Colors.black,
                                  fontWeight: lock_or_not == "0"
                                      ? FontWeight.normal
                                      : FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.03,
                              width: MediaQuery.of(context).size.width * 0.065,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: lock_or_not == "1"
                                      ? Color.fromARGB(255, 8, 57, 129)
                                      : Color.fromARGB(165, 8, 57, 129)),
                              child: Text(
                                "$index",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: lock_or_not == "0"
                                        ? Colors.grey.shade300
                                        : Colors.white),
                              ),
                            )
                          ],
                        ),
                        Icon(
                          lock_or_not == "0" ? Icons.lock : Icons.lock_open,
                          color: lock_or_not == "0"
                              ? Color.fromARGB(255, 94, 34, 34)
                              : Colors.green,
                        )
                      ],
                    ),
                    imagepath == null || imagepath == ""
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset("assets/nobook.jpg")))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              children: [
                                Image.network(loadingBuilder:
                                    (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                        child: LinearProgressIndicator());
                                  }
                                }, "${MySharedPrefrence().get_api_path().toString()}$imagepath"),
                                lock_or_not == "0"
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        color: Color.fromARGB(100, 61, 61, 61),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                    Text(
                      '$title',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: lock_or_not == "0"
                              ? Colors.grey.shade500
                              : Colors.black,
                          fontWeight: lock_or_not == "0"
                              ? FontWeight.normal
                              : FontWeight.bold),
                    ),
                  ]),
            ),
    ),
  );
}

InkWell assignmentbooktopic(
    BuildContext context,
    bool icn_or_not,
    bool complete_topic_or_not,
    bool disable_or_not,
    bool description_or_not,
    String title,
    Function ontap) {
  return InkWell(
      onTap: () {
        disable_or_not == false ? ontap() : null;
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorController.normalgreenbtnclr,
              width: 2.0,
            )),
        child: icn_or_not == true
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.green)),
                child: ListTile(
                  leading: Icon(Icons.check_circle_outline,
                      color: disable_or_not == false
                          ? complete_topic_or_not == true
                              ? Colors.green
                              : Colors.grey
                          : colorController.disablebtncolor),
                  title: Text(
                    title,
                    style: TextStyle(
                        color: disable_or_not == true
                            ? colorController.disablebtncolor
                            : Colors.black),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: disable_or_not == true
                        ? colorController.disablebtncolor
                        : Colors.grey,
                  ),
                ),
              )
            : ListTile(
                title: description_or_not == true
                    ? Text(
                        "$title",
                      )
                    : Text(""),
                trailing: Icon(
                  Icons.expand_more_outlined,
                  size: 38,
                ),
                // trailing: Icon(Icons.arrow_back),
              ),
      ));
}
