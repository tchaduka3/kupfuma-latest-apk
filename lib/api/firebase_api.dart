import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kupfuma/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kupfuma/pages/home_page.dart';



Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );
  void handleMessage(RemoteMessage? message){
    if(message==null) return;

    navigatorKey.currentState?.pushNamed(
      NotificationScreen.route,
      arguments:message,
    );
  }
  Future<void> initPushNotifications() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge:true,
      sound:true,
    );
    
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  }
  
  Future<void> initNotifications() async{
  
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initPushNotifications();
  }
}