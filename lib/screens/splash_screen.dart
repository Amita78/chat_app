import 'package:chat_app/apis/apis.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      if(APIs.auth.currentUser != null){
        Get.offAll(() => const HomeScreen());
      }else {
        Get.offAll(() => const LoginScreen());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Chat App"),
        centerTitle: true,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned(

              top: MediaQuery
                  .of(context)
                  .size
                  .height / 10,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.5,
              right:  MediaQuery
                  .of(context)
                  .size
                  .width / 6 ,
              child: Image.asset("assets/images/chat.png")),
          Positioned(
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * .15,
              width: MediaQuery
                  .of(context)
                  .size
                  .width ,
              child: const Text("Welcome in the app",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),)),
        ],
      ),
    );
  }
}
