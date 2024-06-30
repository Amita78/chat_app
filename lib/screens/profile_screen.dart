import 'dart:io';

import 'package:chat_app/apis/apis.dart';
import 'package:chat_app/controller/home_controller.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final homeController = Get.put(HomeController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Stack(
                    children: [
                      Obx(
                            () => homeController.image.value.isEmpty
                            ? CircleAvatar(
                          radius: 60,
                          backgroundImage:
                          NetworkImage(widget.user.image ?? ''),
                        )
                            : CircleAvatar(
                          radius: 60,
                          backgroundImage:
                          FileImage(File(homeController.image.value)),
                        ),
                      ),
                      Positioned(
                          bottom: 2,
                          right: -12,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder()),
                              onPressed: () {
                                modelSheet();
                              },
                              child: const Icon(Icons.edit)))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(widget.user.email ?? ''),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  initialValue: widget.user.name,
                  onSaved: (val) => APIs.me.name = val,
                  validator: (val) =>
                  val != null && val.isNotEmpty ? null : "Required Field",
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      label: const Text("User Name"),
                      prefixIcon: const Icon(Icons.person)),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: widget.user.about,
                  onSaved: (val) => APIs.me.about = val,
                  validator: (val) =>
                  val != null && val.isNotEmpty ? null : "Required Field",
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      label: const Text(""
                          "About"),
                      prefixIcon: const Icon(Icons.info_outline)),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Utils.showProgressBar(context);
                      await APIs.updateUserInfo().then((value) {
                        Get.back();
                        Utils.showSnackBar(
                            context, "Profile updated successfully");
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: const Size(150, 50)),
                  icon: const Icon(
                    Icons.edit,
                    size: 30,
                  ),
                  label: const Text(
                    "UPDATE",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Utils.showProgressBar(context);
          await APIs.updateActiveStatus(false);
          await APIs.auth.signOut().then((value) async {
            await GoogleSignIn().signOut().then((value) {
              Get.back();
              APIs.auth = FirebaseAuth.instance;
              Get.offAll(() => const LoginScreen());
            });
          });
        },
        icon: const Icon(Icons.logout),
        label: const Text("LogOut"),
      ),
    );
  }

  void modelSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            children: [
              const Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          minimumSize: const Size(60, 60)),
                      onPressed: () async {
                        final ImagePicker image = ImagePicker();
                        final pickImage =
                        await image.pickImage(source: ImageSource.gallery);
                        homeController.image.value = pickImage!.path;
                        // APIs.updateUserProfilePicture(
                        //File(homeController.image.value));
                        Get.back();
                      },
                      child: const Image(
                        height: 40,
                        width: 40,
                        image: AssetImage(
                          "assets/images/picture.png",
                        ),
                        fit: BoxFit.fill,
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          minimumSize: const Size(60, 60)),
                      onPressed: () async {
                        final ImagePicker image = ImagePicker();
                        final pickImage =
                        await image.pickImage(source: ImageSource.camera);
                        homeController.image.value = pickImage!.path;
                        // APIs.updateUserProfilePicture(
                        //     File(homeController.image.value));
                        Get.back();
                      },
                      child: const Image(
                        height: 40,
                        width: 40,
                        image: AssetImage(
                          "assets/images/camera.png",
                        ),
                        fit: BoxFit.fill,
                      )),
                ],
              )
            ],
          );
        });
  }
}

