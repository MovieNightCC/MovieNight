// // import 'dart:io';

// // import 'package:firebase_messaging/firebase_messaging.dart';

// // class PushNotificationsService {
// //   final FirebaseMessaging _fcm = FirebaseMessaging();

// //   Future initialise() async {
// //     _fcm.configure(onMessage: (Map<String, dynamic> message) async {
// //       print('onMessage: $message');
// //     }, onLaunch: (Map<String, dynamic> message) async {
// //       print('onMessage: $message');
// //     }, onResume: (Map<String, dynamic> message) async {
// //       print('onMessage: $message');
// //     });
// //   }
// // }

// import 'package:firebase_messaging/firebase_messaging.dart';

// class PushNotificationsManager {
//   PushNotificationsManager._();

//   factory PushNotificationsManager() => _instance;

//   static final PushNotificationsManager _instance =
//       PushNotificationsManager._();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   bool _initialized = false;

//   Future<void> init() async {
//     if (!_initialized) {
//       // For iOS request permission first.
//       _firebaseMessaging.requestNotificationPermissions();
//       _firebaseMessaging.configure();

//       // For testing purposes print the Firebase Messaging token
//       String token = await _firebaseMessaging.getToken();
//       print("FirebaseMessaging token: $token");

//       _initialized = true;
//     }
//   }
// }
