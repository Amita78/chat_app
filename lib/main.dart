import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/test/bottom_nav_test.dart';
import 'package:chat_app/test/keyboard_screen.dart';
import 'package:chat_app/test/test_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyDyEzoSGpjrRlrnYUUMo9MjrhQoZm5wOlg",
    appId: "1:386063463179:android:04db2f30b2f64167e1280e",
    messagingSenderId: "386063463179",
    projectId: "chat-app-ef2b0",
  ));
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
