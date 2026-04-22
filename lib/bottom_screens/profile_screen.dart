import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/profile_service.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/Models/profile_model.dart';
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
  bool _isLoading = true;

  int _userId = 0;
  String _username = '';
  String _email = '';
  String _profilePic = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _userId = await SessionManager.getUserId();
      _username = await SessionManager.getUserName();
      _email = await SessionManager.getUserEmail();
      _profilePic = await SessionManager.getProfilePic();

      print('===== PROFILE SCREEN SESSION DATA =====');
      print('USER ID: $_userId');
      print('USERNAME: $_username');
      print('EMAIL: $_email');
      print('PROFILE PIC: $_profilePic');

      if (_userId != 0) {
        final result = await ProfileViewService.fetchProfile(userId: _userId);

        print('===== PROFILE SCREEN API RESULT =====');
        print(result);

        if (result['success'] == true && result['user'] != null) {
          final ProfileUserModel user = result['user'];

          _username = user.username;
          _email = user.email;
          _profilePic = SessionManager.normalizeProfilePic(user.profilePic);
          await SessionManager.updateProfileData(
            username: _username,
            email: _email,
            profilePic: _profilePic,
          );
        }
      }
    } catch (e) {
      print('===== PROFILE SCREEN LOAD ERROR =====');
      print(e.toString());
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );

    if (updated == true) {
      await _loadProfile();
    }
  }

  Future<void> _logout() async {
    print('===== LOGOUT STARTED =====');

    await SessionManager.clearSession();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
          (route) => false,
    );
  }

  Widget _buildProfileAvatar(double radius) {
    if (_profilePic.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: NetworkImage(_profilePic),
        onBackgroundImageError: (_, __) {
          print('===== PROFILE SCREEN IMAGE LOAD ERROR =====');
          print('FAILED URL: $_profilePic');
        },
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      child: const Icon(Icons.person, size: 40, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final baseSize = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.03),
                    _buildProfileAvatar(w * 0.13),
                    SizedBox(height: h * 0.012),
                    Text(
                      _username.isNotEmpty ? _username : 'No Username',
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontSize: baseSize * 0.05,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: h * 0.0042),
                    Text(
                      _email.isNotEmpty ? _email : 'No Email',
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontWeight: FontWeight.w700,
                        fontSize: baseSize * 0.04,
                        color: const Color(0xFF9B9B9B),
                      ),
                    ),
                    SizedBox(height: h * 0.012),
                    GestureDetector(
                      onTap: _openEditProfile,
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
                    _settingTile(
                      context,
                      imagePath: 'assets/images/verify.png',
                      title: 'Change Password',
                      baseSize: baseSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: h * 0.01),
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
                    SizedBox(height: h * 0.01),
                    _settingTile(
                      context,
                      imagePath: 'assets/images/wallet.png',
                      title: 'Wallet',
                      baseSize: baseSize,
                      onTap: () {},
                    ),
                    SizedBox(height: h * 0.01),
                    _settingTile(
                      context,
                      imagePath: 'assets/images/worker.png',
                      title: 'Switch to Worker',
                      baseSize: baseSize,
                      onTap: () {},
                    ),
                    SizedBox(height: h * 0.02),
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
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await _logout();
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
                    SizedBox(height: h * 0.2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconCircle(String imagePath, double h) {
    return Container(
      height: h * 0.045,
      width: h * 0.045,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2A8DA7)),
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
        height: h * 0.072,
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