import 'package:flutter/material.dart';
import 'package:helper/auth_screen/login.dart';
import 'package:helper/bottom_screens/change_password_screen.dart';
import 'package:helper/bottom_screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onGoToProfileTab;

  const ProfileScreen({super.key, this.onGoToProfileTab});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final baseSize = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      backgroundColor: const Color(0xFF0FFEDECEC),
      body: Column(
        children: [
          SizedBox(height: h * 0.1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: Row(
              children: [
                Text(
                  'Profile Screen',
                  style: TextStyle(
                    fontFamily: 'B',
                    fontWeight: FontWeight.w700,
                    fontSize: baseSize * 0.065,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.02),

          /// FULL BACKGROUND CONTAINER
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                physics:BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.03),
                    CircleAvatar(
                      radius: w * 0.13,
                      backgroundImage: const AssetImage(
                        'assets/images/chatscreen4.png',
                      ),
                    ),
                    SizedBox(height: h * 0.012),
                    Text(
                      'Henry wick',
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontSize: baseSize * 0.05,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: h * 0.0042),
                    Text(
                      'Exmple@mail.com',
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontWeight: FontWeight.w700,
                        fontSize: baseSize * 0.04,
                        color: const Color(0xFF9B9B9B),
                      ),
                    ),
                    SizedBox(height: h * 0.012),

                    /// Edit Profile
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: h * 0.055,
                        width: w * 0.42,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(h * 0.03),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: const AssetImage(
                                'assets/images/editprofile.png',
                              ),
                              height: h * 0.03,
                              width: w * 0.05,
                            ),
                            SizedBox(width: w * 0.01),
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontFamily: 'B',
                                fontWeight: FontWeight.w700,
                                fontSize: baseSize * 0.035,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.027),

                    /// Change Password (Tap Fixed)
                    _settingTile(
                      context,
                      imagePath: 'assets/images/verify.png',
                      title: 'Change Password',
                      baseSize: baseSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),


                    SizedBox(height: h * 0.012),

                    /// Location Toggle
                    Container(
                      height: h * 0.07,
                      width: w * 0.9,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF1313131A)),
                        borderRadius: BorderRadius.circular(h * 0.02),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                        child: Row(
                          children: [
                            _iconCircle('assets/images/locationicon.png', h),
                            SizedBox(width: w * 0.02),
                            Text(
                              'Location',
                              style: TextStyle(
                                fontFamily: 'R',
                                fontSize: baseSize * 0.035,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF777777),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isToggled = !isToggled;
                                });
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: w * 0.12,
                                    height: h * 0.025,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isToggled
                                          ? Colors.black
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 300),
                                    top: -h * 0.005,
                                    left: isToggled ? w * 0.065 : -h * 0.005,
                                    child: Container(
                                      width: h * 0.035,
                                      height: h * 0.035,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color(0xFF000000),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.012),
                    _settingTile(
                      context,
                      imagePath: 'assets/images/wallet.png',
                      title: 'Wallet',
                      baseSize: baseSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: h * 0.012),
                    _settingTile(
                      context,
                      imagePath: 'assets/images/worker.png',
                      title: 'Switch to Worker',
                      baseSize: baseSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: h * 0.02),

                    /// Logout
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: const Text(
                                  'Logout',
                                  textAlign: TextAlign.center,
                                ),
                                content: const Text(
                                  'Are you sure you want to logout?',
                                ),
                                actionsAlignment:
                                    MainAxisAlignment.spaceBetween,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Color(0xFF692226),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF692226),
                                    ),
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontFamily: 'SB',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: h * 0.06,
                        width: w * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFB11B1C)),
                          borderRadius: BorderRadius.circular(h * 0.03),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: const AssetImage(
                                  'assets/images/logout.png',
                                ),
                                height: h * 0.03,
                                width: w * 0.09,
                              ),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: const Color(0xFFB11B1C),
                                  fontFamily: 'SB',
                                  fontWeight: FontWeight.w600,
                                  fontSize: baseSize * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h*0.2)
                  ],
                ),

              ),
            ),
          ),
        ],
      ),

    );
  }

  /// IMAGE-ONLY CIRCLE
  Widget _iconCircle(String imagePath, double h) {
    return Container(
      height: h * 0.045,
      width: h * 0.045,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF2A8DA7)),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          height: h * 0.025,
          width: h * 0.025,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _settingTile(
    BuildContext context, {
    required String imagePath,
    required String title,
    required double baseSize,
    required VoidCallback onTap,
  }) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: h * 0.07,
        width: w * 0.9,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1313131A)),
          borderRadius: BorderRadius.circular(h * 0.02),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.03),
          child: Row(
            children: [
              _iconCircle(imagePath, h),
              SizedBox(width: w * 0.02),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'R',
                  fontSize: baseSize * 0.035,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF777777),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: baseSize * 0.045,
              ),
            ],
          ),
        ),
      ),
    );

  }
}
