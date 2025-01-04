import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:http/http.dart';
import 'fire_user.dart';
import 'firebase_options_.dart';
import 'local/sharedprefencevalues.dart';
import 'splash.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    _initializeFirebase();
    WidgetsFlutterBinding.ensureInitialized(); // Required for Firebase.initializeApp()
  await Firebase.initializeApp();
    runApp(const MyApp());
  });
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;


static User? get user => auth.currentUser;

static ChatUser me = ChatUser(
  id: user?.uid ?? '', // Use an empty string as a default value if user is null
  name: user?.displayName?.toString() ?? '',
  email: user?.email?.toString() ?? '',
  about: "Hey, I'm using We Chat!",
  image: user?.photoURL?.toString() ?? '',
  createdAt: 'cxvbfcgbf',
  isOnline: false,
  lastActive: 'ghjhjhj',
  pushToken: 'hbgfhgfhgfh',
);
  // for storing self information
  // static ChatUser me = ChatUser(
  //     id: user.uid,
  //     name: user.displayName.toString(),
  //     email: user.email.toString(),
  //     about: "Hey, I'm using We Chat!",
  //     image: user.photoURL.toString(),
  //     createdAt: 'cxvbfcgbf',
  //     isOnline: false,
  //     lastActive: 'ghjhjhj',
  //     pushToken: 'hbgfhgfhgfh');

  // // to return current user
  // static User get user => auth.currentUser!;

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        print('Push Token : $t');
        
       
        MySharedPrefrence().set_push_token(t.toString());
        print(MySharedPrefrence().get_push_token());
        // log('Push Token: $t');
      }
    });
 String getConversationID(String id) => user!.uid.hashCode <= id.hashCode
      ? '${user!.uid}_$id'
      : '${id}_${user!.uid}';

     Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user!.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }


    // for handling foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }
var msg;
  // for sending push notification
  static Future<void> sendPushNotification(
       chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.name, //our name should be send
          "body": msg,
          // "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':'key=AAAAUCZdmis:APA91bEm5cjt8AePkSQTCwlR4ySPppu7IS7eMbJhb91Kh1boFKJh2Uk3d1GJ7clKwThou93ArxCl_6-Rfhnt3RLJyR8qASfNx9Nc_UQ08xmtiyqXq703eaZkXb-fFscH8Kvwcn994499'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }


 @override
Widget build(BuildContext context) {
  sendPushNotification; 
  getFirebaseMessagingToken();
  _initializeFirebase();
  
  
  var notificationListTile = ListTile(
    title: Text("pushToken"),    
    subtitle: Text("name"), 
  );

  return MaterialApp(
    title: 'We Chat',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 252, 249, 249)),
        titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 243, 240, 240),
          fontWeight: FontWeight.normal,
          fontSize: 19,
        ),
        backgroundColor: Colors.white,
      ),
    ),
    home: Scaffold(
      // appBar: AppBar(
      //   title: Text("Your App Title"), // Replace with your app's title
      // ),
      body: Stack(
        children: [
          // if (MySharedPrefrence().get_push_token() == null||MySharedPrefrence().get_push_token()=="") ...{
          //     reusbaleofflinepage(context, () {
          //       MySharedPrefrence().set_api_path("https://clt.turk.pk/CLT/");
          //       Navigator.push(
          //           context, MaterialPageRoute(builder: (context) => MyApp()));
          //     })
          //   } else ...{
              // pushtoken().set_push_token(tokenpush)
              // setState(() {});
              Splash(
                tokenpush: MySharedPrefrence().get_push_token()
                )
            // }
          // ListView(
          //   children: [
          //     notificationListTile, // Display the notification ListTile here
          //     // Add more ListTiles for additional notifications if needed
          //   ],
          // ),
        ],
      ),
    ),
  );
} 
         
        // Scaffold(body: InkWell(onTap: (){
        //   Navigator.push(context, MaterialPageRoute(builder: (context)=>newdemo()));
        // },),));

}



_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats');
  log('\nNotification Channel Result: $result');
}
