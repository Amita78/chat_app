import 'dart:async';

import 'package:chat_app/controller/home_controller.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final homeController = Get.put(HomeController());
  late StreamSubscription subscription;
  RxBool isDeviceConnected = false.obs;
  RxBool isAlertDialog = false.obs;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      homeController.changeOpacity();
    });
    getConnectivity();
    super.initState();
  }

  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async{
       isDeviceConnected.value = await InternetConnectionChecker().hasConnection;
       if(!isDeviceConnected.value && isAlertDialog.value == false){
         showDialogBox();
         isAlertDialog.value = true;
       }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
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
          Obx(() {
            return AnimatedPositioned(
                duration: const Duration(seconds: 1),
                top: MediaQuery
                    .of(context)
                    .size
                    .height / 10,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 1.5,
                right: homeController.isAnimated.value ? MediaQuery
                    .of(context)
                    .size
                    .width / 6 : -MediaQuery.of(context).size.width * .5,
                child: Image.asset("assets/images/chat.png"));
          }),
          Positioned(
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * .15,
              left: MediaQuery
                  .of(context)
                  .size
                  .width * .05,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .9,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.07,
              child: ElevatedButton.icon(
                icon: Image.asset("assets/images/google.png",
                  fit: BoxFit.scaleDown,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * .1,
                ),
                label: const Text('Log In with Google'),
                onPressed: () {
                   Utils.showProgressBar(context);
                   homeController.signInWithGoogle(context);
                },
              )),
        ],
      ),
    );
  }

  showDialogBox() => showDialog(context: context, builder: (context){
    return AlertDialog(
      title: const Text('No Connection'),
      content: const Text("Please check your internet connection"),
      actions: [
        TextButton(onPressed: (){
          Get.back();
          isAlertDialog.value = false;
          if(!isDeviceConnected.value){
            showDialogBox();
            isAlertDialog.value = true;
          }

        }, child: const Text("Ok"))
      ],
    );
  });
}
