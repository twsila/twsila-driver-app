import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';

import '../resources/global_key.dart';

import 'notification_popup.dart';

class FirebaseMessagingHelper extends ChangeNotifier {
  static final _fbm = FirebaseMessaging.instance;
  static ValueNotifier<int> notificationCounter = ValueNotifier(0);
  static final AppPreferences appPreferences = instance<AppPreferences>();
  final player = AudioPlayer(); // Create a player

  // // set up the buttons
  // Widget cancelButton = TextButton(
  //   child: Text(AppStrings.cancel.tr()),
  //   onPressed: () {
  //     Navigator.pop(NavigationService.navigatorKey.currentState!.context);
  //   },
  // );
  // Widget continueButton = TextButton(
  //   child: Text(AppStrings.ok.tr()),
  //   onPressed: () {
  //     Navigator.pop(NavigationService.navigatorKey.currentState!.context);
  //   },
  // );

  Future<void> configure(BuildContext context) async {
    _fbm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    _fbm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      // If the application has been opened from a terminated state via a RemoteMessage (containing a Notification), it will be returned, otherwise it will be null.
      // Once the RemoteMessage has been consumed, it will be removed and further calls to getInitialMessage will be null.

      if (message != null) {
        dynamic notification = message.data;
        debugPrint('[FCM] Initial message: ${message.messageId}');
        FirebaseMessagingHelper.navigateToNotifications(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      notificationCounter.value += 1;
      // if (Get.context == null) return;

      final duration = await player.setAsset(
          'assets/sound/notification-sound.mp3'); // Schemes: (https: | file: | asset: )
      player.play();

      DialogUtils.showNotificationPopup(
          NavigationService.navigatorKey.currentState!.context,
          message.data["title"] ?? "Twsila Notification",
          message.data["body"] ?? "there's a new update!");
      return;
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await navigateToNotifications(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await setFcmToken();
  }

  static Future<void> navigateToNotifications(RemoteMessage message) async {
    await SharedPreferences.getInstance();

    debugPrint('[FCM] Navigate to notification: ${message.messageId}');
  }

  static Future<void> setFcmToken() async {
    await _fbm.getToken().then((token) {
      log("FCM token : $token");
      FirebaseMessagingHelper.appPreferences.setFCMToken(token!);
    }).onError((error, stackTrace) {
      debugPrint('[FCM] Token error: $error');
    });
  }

  static _showDialog(String message, BuildContext context) {}

  static _hideDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] Background message: ${message.messageId}');
  FirebaseMessagingHelper.notificationCounter.value += 1;
}

void _showCustomNotification(
    {required BuildContext context,
    required String title,
    required String body}) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: 50.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6.0,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        body,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    // overlayEntry.remove(); // Remove the notification
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  // Insert the overlay
  Overlay.of(Get.context!).insert(overlayEntry);

  // Automatically remove after 3 seconds
  Future.delayed(Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}
