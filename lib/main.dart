import 'dart:convert';
import 'dart:developer';

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
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    _initializeFirebase();
    WidgetsFlutterBinding.ensureInitialized();
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
  int _notificationCount = 0;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static User? get user => auth.currentUser;
  static ChatUser me = ChatUser(
    id: user?.uid ?? '',
    name: user?.displayName?.toString() ?? '',
    email: user?.email?.toString() ?? '',
    about: "Hey, I'm using We Chat!",
    image: user?.photoURL?.toString() ?? '',
    createdAt: 'cxvbfcgbf',
    isOnline: false,
    lastActive: 'ghjhjhj',
    pushToken: 'hbgfhgfhgfh',
  );

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        print('Push Token : $t');
        MySharedPrefrence().set_push_token(t.toString());
        print(MySharedPrefrence().get_push_token());
      }
    });
    String getConversationID(String id) => user!.uid.hashCode <= id.hashCode
        ? '${user!.uid}_$id'
        : '${id}_${user!.uid}';

    Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
      final time = DateTime.now().millisecondsSinceEpoch.toString();
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
  }

  var msg;

  static Future<void> sendPushNotification(chatUser, String msg) async {
    try {

      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.name,
          "body": msg,
        },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAUCZdmis:APA91bEm5cjt8AePkSQTCwlR4ySPppu7IS7eMbJhb91Kh1boFKJh2Uk3d1GJ7clKwThou93ArxCl_6-Rfhnt3RLJyR8qASfNx9Nc_UQ08xmtiyqXq703eaZkXb-fFscH8Kvwcn994499'
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
        body: Stack(
          children: [Splash(tokenpush: MySharedPrefrence().get_push_token())],
        ),
      ),
    );
  }
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

// import 'dart:convert';
// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_notification_channel/flutter_notification_channel.dart';
// import 'package:flutter_notification_channel/notification_importance.dart';
// import 'package:http/http.dart';
// import 'fire_user.dart';
// import 'firebase_options_.dart';
// import 'local/sharedprefencevalues.dart';
// import 'splash.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
//     (value) async {
//       _initializeFirebase();
//       WidgetsFlutterBinding.ensureInitialized();
//       await Firebase.initializeApp();
//       runApp(const MyApp());
//     },
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _notificationCount = 0;
//   static FirebaseAuth auth = FirebaseAuth.instance;
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;
//   static FirebaseStorage storage = FirebaseStorage.instance;
//   static User? get user => auth.currentUser;
//   static ChatUser me = ChatUser(
//     id: user?.uid ?? '',
//     name: user?.displayName?.toString() ?? '',
//     email: user?.email?.toString() ?? '',
//     about: "Hey, I'm using We Chat!",
//     image: user?.photoURL?.toString() ?? '',
//     createdAt: 'cxvbfcgbf',
//     isOnline: false,
//     lastActive: 'ghjhjhj',
//     pushToken: 'hbgfhgfhgfh',
//   );

//   static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

//   @override
//   void initState() {
//     super.initState();
//     _configureFirebaseMessaging();
//   }

//   void _configureFirebaseMessaging() {
//     fMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         _incrementNotificationCount();
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         // Handle launch scenario
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         // Handle resume scenario
//       },
//     );
//   }

//   void _incrementNotificationCount() {
//     setState(() {
//       _notificationCount++;
//     });
//   }

//   // Rest of your code...

//   var msg;
// static Future<void> getFirebaseMessagingToken() async {
//     await fMessaging.requestPermission();
//     await fMessaging.getToken().then((t) {
//       if (t != null) {
//         me.pushToken = t;
//         print('Push Token : $t');
//         MySharedPrefrence().set_push_token(t.toString());
//         print(MySharedPrefrence().get_push_token());
//       }
//     });
//     String getConversationID(String id) => user!.uid.hashCode <= id.hashCode
//         ? '${user!.uid}_$id'
//         : '${id}_${user!.uid}';

//     Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
//       final time = DateTime.now().millisecondsSinceEpoch.toString();
//       final Message message = Message(
//           toId: chatUser.id,
//           msg: msg,
//           read: '',
//           type: type,
//           fromId: user!.uid,
//           sent: time);

//       final ref = firestore
//           .collection('chats/${getConversationID(chatUser.id)}/messages/');
//       await ref.doc(time).set(message.toJson()).then((value) =>
//           sendPushNotification(chatUser, type == Type.text ? msg : 'image'));

//     }
//   }

//   static Future<void> sendPushNotification(chatUser, String msg) async {
//     try {
//       final body = {
//         "to": chatUser.pushToken,
//         "notification": {
//           "title": me.name,
//           "body": msg,
//         },
//       };

//       var res = await post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization':
//               'key=AAAAUCZdmis:APA91bEm5cjt8AePkSQTCwlR4ySPppu7IS7eMbJhb91Kh1boFKJh2Uk3d1GJ7clKwThou93ArxCl_6-Rfhnt3RLJyR8qASfNx9Nc_UQ08xmtiyqXq703eaZkXb-fFscH8Kvwcn994499'
//         },
//         body: jsonEncode(body),
//       );
//       log('Response status: ${res.statusCode}');
//       log('Response body: ${res.body}');
//     } catch (e) {
//       log('\nsendPushNotificationE: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     sendPushNotification;
//     getFirebaseMessagingToken();
//     _initializeFirebase();

//     var notificationListTile = ListTile(
//       title: Text("pushToken"),
//       subtitle: Text("name"),
//     );

//     return MaterialApp(
//       title: 'We Chat',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         appBarTheme: const AppBarTheme(
//           centerTitle: true,
//           elevation: 1,
//           iconTheme: IconThemeData(color: Color.fromARGB(255, 252, 249, 249)),
//           titleTextStyle: TextStyle(
//             color: Color.fromARGB(255, 243, 240, 240),
//             fontWeight: FontWeight.normal,
//             fontSize: 19,
//           ),
//           backgroundColor: Colors.white,
//         ),
//       ),
//       home: Scaffold(
//         body: Stack(
//           children: [Splash(tokenpush: MySharedPrefrence().get_push_token())],
//         ),
//       ),
//     );
//   }
// }

// _initializeFirebase() async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   var result = await FlutterNotificationChannel.registerNotificationChannel(
//     description: 'For Showing Message Notification',
//     id: 'chats',
//     importance: NotificationImportance.IMPORTANCE_HIGH,
//     name: 'Chats',
//   );
//   log('\nNotification Channel Result: $result');
// }

// import 'dart:convert';
// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_notification_channel/flutter_notification_channel.dart';
// import 'package:flutter_notification_channel/notification_importance.dart';
// import 'package:http/http.dart';
// import 'fire_user.dart';
// import 'firebase_options_.dart';
// import 'local/sharedprefencevalues.dart';
// import 'splash.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   SystemChrome.setPreferredOrientations(
//     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
//   ).then(
//     (value) async {
//       _initializeFirebase();
//       WidgetsFlutterBinding.ensureInitialized();
//       await Firebase.initializeApp();
//       runApp(const MyApp());
//     },
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   static final GlobalKey<_MyAppState> myAppStateKey = GlobalKey<_MyAppState>();
//   int _notificationCount = 0;
//   static FirebaseAuth auth = FirebaseAuth.instance;
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;
//   static FirebaseStorage storage = FirebaseStorage.instance;
//   static User? get user => auth.currentUser;
//   static ChatUser me = ChatUser(
//     id: user?.uid ?? '',
//     name: user?.displayName?.toString() ?? '',
//     email: user?.email?.toString() ?? '',
//     about: "Hey, I'm using We Chat!",
//     image: user?.photoURL?.toString() ?? '',
//     createdAt: 'cxvbfcgbf',
//     isOnline: false,
//     lastActive: 'ghjhjhj',
//     pushToken: 'hbgfhgfhgfh',
//   );

//   static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

//   @override
//   void initState() {
//     super.initState();
//     _configureFirebaseMessaging();
//   }

//   void _configureFirebaseMessaging() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("onMessage: $message");
//       _incrementNotificationCount();
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("onMessageOpenedApp: $message");
//       // Handle when the app is opened from a terminated state
//     });

//     _getFirebaseMessagingToken();
//   }

//   void _getFirebaseMessagingToken() async {
//     await fMessaging.requestPermission();
//     await fMessaging.getToken().then((t) {
//       if (t != null) {
//         me.pushToken = t;
//         print('Push Token : $t');
//         MySharedPrefrence().set_push_token(t.toString());
//         print(MySharedPrefrence().get_push_token());
//       }
//     });
//   }

//   void _incrementNotificationCount() {
//     setState(() {
//       _notificationCount++;
//     });
//   }

//   // Rest of your code...
// static Future<void> getFirebaseMessagingToken() async {
//     await fMessaging.requestPermission();
//     await fMessaging.getToken().then((t) {
//       if (t != null) {
//         me.pushToken = t;
//         print('Push Token : $t');
//         MySharedPrefrence().set_push_token(t.toString());
//         print(MySharedPrefrence().get_push_token());
//       }
//     });
//     String getConversationID(String id) => user!.uid.hashCode <= id.hashCode
//         ? '${user!.uid}_$id'
//         : '${id}_${user!.uid}';

//     Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
//       final time = DateTime.now().millisecondsSinceEpoch.toString();
//       final Message message = Message(
//           toId: chatUser.id,
//           msg: msg,
//           read: '',
//           type: type,
//           fromId: user!.uid,
//           sent: time);

//       final ref = firestore
//           .collection('chats/${getConversationID(chatUser.id)}/messages/');
//       await ref.doc(time).set(message.toJson()).then((value) =>
//           sendPushNotification(chatUser, type == Type.text ? msg : 'image'));

//     }
//   }
//   var msg;

//   static Future<void> sendPushNotification(chatUser, String msg) async {
//     try {
//       final body = {
//         "to": chatUser.pushToken,
//         "notification": {
//           "title": me.name,
//           "body": msg,
//         },
//       };

//       var res = await post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization':
//               'key=AAAAUCZdmis:APA91bEm5cjt8AePkSQTCwlR4ySPppu7IS7eMbJhb91Kh1boFKJh2Uk3d1GJ7clKwThou93ArxCl_6-Rfhnt3RLJyR8qASfNx9Nc_UQ08xmtiyqXq703eaZkXb-fFscH8Kvwcn994499'
//         },
//         body: jsonEncode(body),
//       );
//       log('Response status: ${res.statusCode}');
//       log('Response body: ${res.body}');
//     } catch (e) {
//       log('\nsendPushNotificationE: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     sendPushNotification;
//     getFirebaseMessagingToken();
//     _initializeFirebase();

//     var notificationListTile = ListTile(
//       title: Text("pushToken"),
//       subtitle: Text("name"),
//     );
//     return MaterialApp(
//       title: 'We Chat',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         appBarTheme: const AppBarTheme(
//           centerTitle: true,
//           elevation: 1,
//           iconTheme: IconThemeData(color: Color.fromARGB(255, 252, 249, 249)),
//           titleTextStyle: TextStyle(
//             color: Color.fromARGB(255, 243, 240, 240),
//             fontWeight: FontWeight.normal,
//             fontSize: 19,
//           ),
//           backgroundColor: Colors.white,
//         ),
//       ),
//       home: Scaffold(
//         body: Stack(
//           children: [Splash(tokenpush: MySharedPrefrence().get_push_token())],
//         ),
//       ),
//     );
//   }
// }

// _initializeFirebase() async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   var result = await FlutterNotificationChannel.registerNotificationChannel(
//     description: 'For Showing Message Notification',
//     id: 'chats',
//     importance: NotificationImportance.IMPORTANCE_HIGH,
//     name: 'Chats',
//   );
//   log('\nNotification Channel Result: $result');
// }
