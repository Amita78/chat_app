import 'dart:developer';
import 'dart:io';

import 'package:chat_app/apis/apis.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeController extends GetxController {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly'
  ]);

  RxBool isAnimated = false.obs;

  RxBool isSearching = false.obs;
  RxString image = ''.obs;

  void changeOpacity() {
    isAnimated.value = true;
  }

  signInWithGoogle(context) async {
    try {
      Get.back();
      await InternetAddress.lookup("google.com");
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      final cred = (await APIs.auth.signInWithCredential(credential)).user!;
      final tokenId = await cred.getIdToken(true);
      if (tokenId != '') {
        if ((await APIs.userExist())) {
          Get.offAll(() => const HomeScreen());
        } else {
          await createUser().then((value) {
            Get.offAll(() => const HomeScreen());
          });
        }
      }
      log("____________token form google__________ $tokenId");
    } on FirebaseAuthException catch (e) {
      log("Google error$e");
      Utils.showSnackBar(context, "Google error$e");
    } catch (e) {
      log("Google error$e");
      Utils.showSnackBar(context, "Google error$e");
    }
  }

  Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final data = ChatUser(
      id: APIs.auth.currentUser!.uid,
      name: APIs.auth.currentUser!.displayName,
      email: APIs.auth.currentUser!.email,
      image: APIs.auth.currentUser!.photoURL,
      createdAt: time,
      lastActive: time,
      isOnline: false,
      pushToken: '',
      about: "Hi, I am using Chat App",
    );
    await APIs.createUser(data.toJson());
  }
}
