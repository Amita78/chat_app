import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
    int length = 15;
   TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: length,
          shrinkWrap: true,
          itemBuilder: (context,index){
        return (index.isEven) ? leftContainer(length == (index+1)) : rightContainer(length == (index+1));
      }),
    );
  }
}

Widget leftContainer(bool isLast){
  return Container(
    height: 250,
    width: 360,
    padding: const EdgeInsets.only(
        left: 20,right: 20
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.yellow,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  offset: const Offset(0,4),
                  blurRadius: 9,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  offset: const Offset(0,17),
                  blurRadius: 17,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0,37),
                  blurRadius: 22,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  offset: const Offset(0,67),
                  blurRadius: 27,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.00),
                  offset: const Offset(0,104),
                  blurRadius: 29,
                  spreadRadius: 0,
                )
              ]
          ),
        ),
        (isLast == true)? SizedBox() : const Column(
          children: [
            SizedBox(
              height: 80,
            ),
            SizedBox(
                width: 60,
                child: Divider(
                  thickness: 3,
                )),
          ],
        ),
        (isLast == true)? SizedBox() : const Column(
          children: [
            SizedBox(
              height: 60,
            ),
            CircleAvatar(
              radius: 30,
            ),
            Expanded(child: VerticalDivider(
              thickness: 3,
            )),
          ],
        ),
        const SizedBox(
          width: 30,
        ),
      ],
    ),
  );
}

Widget rightContainer(bool isLast){
  return Container(
    height: 250,
    width: 360,
    padding: const EdgeInsets.only(
        left: 20,right: 20
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 30,
        ),
        (isLast == true)? SizedBox() :const Column(
          children: [
            SizedBox(
              height: 60,
            ),
            CircleAvatar(
              radius: 30,
            ),
            Expanded(child: VerticalDivider(
              thickness: 3,
            )),
          ],
        ),
        (isLast == true)? SizedBox() : const Column(
          children: [
            SizedBox(
              height: 80,
            ),
            SizedBox(
                width: 60,
                child: Divider(
              thickness: 3,
            )),
          ],
        ),
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.yellow,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  offset: const Offset(0,4),
                  blurRadius: 9,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  offset: const Offset(0,17),
                  blurRadius: 17,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0,37),
                  blurRadius: 22,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  offset: const Offset(0,67),
                  blurRadius: 27,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.00),
                  offset: const Offset(0,104),
                  blurRadius: 29,
                  spreadRadius: 0,
                )
              ]
          ),
        ),
      ],
    ),
  );
}
