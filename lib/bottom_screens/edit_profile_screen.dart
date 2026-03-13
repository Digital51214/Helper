import 'package:flutter/material.dart';
import 'package:helper/auth_screen/login.dart';
import 'package:helper/bottom_screens/profile_screen.dart';
import 'bottom_navigation_screen.dart';
import 'image_picker_screen.dart'; // Custom ImagePickerScreen

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final wScale = size.width / 375; // base width
    final hScale = size.height / 812; // base height
    final tScale = (wScale + hScale) / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(10 * wScale),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50 * hScale),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE4F9FF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BottomNavigationScreen(currentIndex: 4),
                          ),
                              (Route<dynamic> route) => false,
                        );
                      },
                      icon: Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: Icon(Icons.arrow_back_ios, size: 18 * tScale),
                      ),
                      color: Color(0xFF2A8DA7),
                    ),
                  ),
                  SizedBox(width: 30 * wScale),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'B',
                      fontWeight: FontWeight.w700,
                      fontSize: 18 * tScale,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30 * hScale),

            // 🔹 Image picker widget
            ImagePickerScreen(
              onPickImage: (pickedImage) {
                setState(() {});
              },
            ),
            SizedBox(height: 60 * hScale),

            // Name TextField
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Rehan R',
                hintStyle: TextStyle(
                  fontFamily: 'SB',
                  fontSize: 12 * tScale,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30 * tScale),
                  borderSide: BorderSide(color: Color(0xFFCDCDCD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30 * tScale),
                  borderSide: BorderSide(color: Color(0xFFCDCDCD)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16 * hScale,
                  horizontal: 20 * wScale,
                ),
              ),
            ),
            SizedBox(height: 10 * hScale),

            // Email TextField
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Example@mail.com',
                hintStyle: TextStyle(
                  fontFamily: 'SB',
                  fontSize: 12 * tScale,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30 * tScale),
                  borderSide: BorderSide(color: Color(0xFFCDCDCD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30 * tScale),
                  borderSide: BorderSide(color: Color(0xFFCDCDCD)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16 * hScale,
                  horizontal: 20 * wScale,
                ),
              ),
            ),
            SizedBox(height: 15 * hScale),

            // Update Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>Login(),
                  ),
                );
              },
              child: Container(
                height: 50 * hScale, // better height
                width: 373 * wScale, // better width
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    width: 2,
                    color: Colors.white.withOpacity(0.158),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontFamily: 'SB',
                      fontSize: 18 * tScale, // use tScale for text scaling
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
