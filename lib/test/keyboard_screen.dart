import 'package:flutter/material.dart';
import 'package:virtual_keyboard_custom_layout/virtual_keyboard_custom_layout.dart';

class KeyboardScreen extends StatefulWidget {
  const KeyboardScreen({super.key});

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {

  bool isKeyBoard = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            setState(() {
              isKeyBoard = true;
            });
          },
          child:Text("Keyboard")
        ),
      ),
      bottomNavigationBar: (isKeyBoard == true)? // Wrap the keyboard with Container to set background color.
      Container(
        // Keyboard is transparent
        color: Colors.deepPurple,
        child: VirtualKeyboard(
          // Default height is 300
            height: 350,
            // Default height is will screen width
            // Default is black
            textColor: Colors.white,
            // Default 14
            fontSize: 20,
            // the layouts supported

            // [A-Z, 0-9]
            type: VirtualKeyboardType.Custom,
            keys: const [
              ["T", "E", "S", "T"],
              ["C", "U", "S", "T", "O", "M"],
              ["L", "A", "Y", "O", "U", "T"],
              ["RETURN", "SHIFT", "BACKSPACE", "SPACE"],
            ],
            // Callback for key press event
            onKeyPress: (val){
            }, defaultLayouts: [VirtualKeyboardDefaultLayouts.Custom],),
      ):SizedBox(),
    );
  }
}
