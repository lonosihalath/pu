import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:purer/screen/home/homepage.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:purer/screen/signin_signup/user/controller/controller_binding.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firsebasemessing(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('lonooooooooooo!!!!!! ${message.messageId}');
}

Future<String> _getToken() async {
  String? _deviceToken = '@';

  try {
    _deviceToken = await FirebaseMessaging.instance.getToken();
    print('DeviceToken ======>: ' + _deviceToken.toString());
  } catch (lono) {
    print('no');
    print(lono.toString());
  }
  return _deviceToken.toString();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _getToken();
  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  await Geolocator.getLastKnownPosition();
  FirebaseMessaging.onBackgroundMessage(_firsebasemessing);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
 if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  const IOSInitializationSettings initializationSettings =
      IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true);
  const AndroidInitializationSettings initializationSettingsandroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings1 = InitializationSettings(
      iOS: initializationSettings, android: initializationSettingsandroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings1);
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: Text(''),
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Purer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialBinding: ControllerBindings(),
        home: Homepage());
  }
}
