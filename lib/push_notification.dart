import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    //request permissions if we are on android
    if(Platform.isIOS){
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(

      onMessage: (Map<String,dynamic>message) async {
        print('onMessage: $message');
       

      },
       onLaunch: (Map<String,dynamic>message) async {
        print('onMessage: $message');

      },
       onResume: (Map<String,dynamic>message) async {
        print('onMessage: $message');

      }
    );

  }
}