import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> with SingleTickerProviderStateMixin {
  int _tabIndex = 1;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.person, color: Colors.deepPurple),
          Icon(Icons.home, color: Colors.deepPurple),
          Icon(Icons.favorite, color: Colors.deepPurple),
        ],
        inactiveIcons: const [
          Text("My"),
          Text("Home"),
          Text("Like"),
        ],
        color: Colors.white,
        height: 60,
        circleWidth: 60,
        activeIndex: tabIndex,
        onTap: (index) {
          tabIndex = index;
          pageController.jumpToPage(tabIndex);
        },
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex = v;
        },
        children: [
          Container(width: double.infinity, height: double.infinity, color: Colors.blue),
          Container(width: double.infinity, height: double.infinity, color: Colors.purple),
          Container(width: double.infinity, height: double.infinity, color: Colors.amber),
        ],
      ),
    );
  }
}

class BottomNavCircleWidget extends StatelessWidget {
  final IconData icon;
  const BottomNavCircleWidget({
    super.key, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
        width: 75,
        decoration: const BoxDecoration(
          shape: BoxShape.circle
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(100),
                        topLeft: Radius.circular(100)),
                      shape: BoxShape.rectangle,
                    color: Color(0xff40083B),
                  ),
                  height: 37.5,

                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color(0xffFF8906),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(100),
                        bottomLeft: Radius.circular(100)),
                    shape: BoxShape.rectangle,
                  ),
                  height: 37.5,

                ),
              ],
            ),
            Center(
              child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                  ),
                  child: Icon(icon, color: const Color(0xff40083B),size: 23,)),
            ),
          ],
        ));
  }
}