import 'dart:async';
import 'package:chat_app/apis/apis.dart';
import 'package:chat_app/controller/home_controller.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());
  List<ChatUser> data = [];
  RxList<ChatUser> searchList = <ChatUser>[].obs;
  late StreamSubscription subscription;
  RxBool isDeviceConnected = false.obs;
  RxBool isAlertDialog = false.obs;

  @override
  void initState() {
    getConnectivity();
    APIs.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
    super.initState();
  }

  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async{
      isDeviceConnected.value = await InternetConnectionChecker().hasConnection;
      if(!isDeviceConnected.value && isAlertDialog.value == false){
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
        title: Obx(() => homeController.isSearching.value
            ? TextFormField(
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: "Name, Email..."),
          autofocus: true,
          onChanged: (val) {
            searchList.value = [];
            searchList.value = data
                .where((element) =>
            element.name!
                .toLowerCase()
                .contains(val.toLowerCase()) ||
                element.email!
                    .toLowerCase()
                    .contains(val.toLowerCase()))
                .toList();
          },
          onTapOutside: (po) {
            FocusScope.of(context).unfocus();
          },
        )
            : const Text("Chat App")),
        centerTitle: true,
        elevation: 1,
        leading: const Icon(CupertinoIcons.home),
        actions: [
          Obx(
                () => IconButton(
                onPressed: () {
                  homeController.isSearching.value =
                  !homeController.isSearching.value;
                },
                icon: Icon(homeController.isSearching.value
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search)),
          ),
          IconButton(
              onPressed: () {
                Get.to(() => ProfileScreen(
                  user: APIs.me,
                ));
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: StreamBuilder(
        stream: APIs.getAllUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              data = snapshot.data?.docs
                  .map((e) => ChatUser.fromJson(e.data()))
                  .toList() ??
                  [];
              if (data.isNotEmpty) {
                return Obx(
                      () => ListView.builder(
                      itemCount: homeController.isSearching.value
                          ? searchList.length
                          : data.length,
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: homeController.isSearching.value
                              ? searchList[index]
                              : data[index],
                        );
                      }),
                );
              } else {
                return const Center(
                  child: Text(
                    "No connections found",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                );
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          APIs.auth.signOut();
        },
        child: const Icon(Icons.add_comment_rounded),
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

