import 'package:flutter/material.dart';
import 'package:helper/bottom_screens/postjob_screen.dart';
import 'package:helper/bottom_screens/myjobs.dart';
import 'package:helper/bottom_screens/profile_screen.dart';
import 'chat_screen.dart';
import 'home_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  final int currentIndex;

  const BottomNavigationScreen({
    super.key,
    this.currentIndex = 0,
  });

  @override
  State<BottomNavigationScreen> createState() =>
      _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  late int currentIndex;

  final List<Widget> pages = [
    HomeScreen(),
    ChatScreen(),
    Myjobs(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final wScale = size.width / 375;
    final hScale = size.height / 812;
    final tScale = (wScale + hScale) / 2;

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          setState(() {
            currentIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostjobScreen(),
              ),
            );
          },
          backgroundColor: Colors.black,
          shape: const CircleBorder(),
          child: Image.asset(
            'assets/images/homeicon8.png',
            height: 21 * tScale,
            width: 21 * tScale,
          ),
          elevation: 4,
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8 * hScale,
          child: SizedBox(
            height: 65 * hScale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navItemWidget(
                  'assets/images/homeicon.png',
                  "Home",
                  0,
                  tScale,
                ),
                navItemWidget(
                  'assets/images/homeicon2.png',
                  "Chat",
                  1,
                  tScale,
                ),
                SizedBox(width: 40 * wScale),
                navItemWidgetIcon(
                  Icons.manage_search_rounded,
                  "My jobs",
                  2,
                  tScale,
                ),
                navItemWidgetIcon(
                  Icons.person,
                  "Profile",
                  3,
                  tScale,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navItemWidget(String imagePath, String title, int index, double tScale) {
    bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12 * tScale),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6 * tScale),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 24 * tScale,
              height: 24 * tScale,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            SizedBox(height: 4 * tScale),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 10 * tScale,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItemWidgetIcon(
      IconData icon, String title, int index, double tScale) {
    bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12 * tScale),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4 * tScale),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: index == 3 ? 28 * tScale : 24 * tScale, // 👈 index 3 bigger
              color: isSelected ? Colors.white : Colors.grey,
            ),
            SizedBox(height: 4 * tScale),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 10 * tScale,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
