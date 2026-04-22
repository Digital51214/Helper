import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/changepasswordservice.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/bottom_screens/bottom_navigation_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obsecureOldPassword = true;
  bool _obsecureNewPassword = true;
  bool _obsecureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    final oldPassword = _oldPasswordController.text; // trim nahi karna
    final newPassword = _newPasswordController.text; // trim nahi karna
    final confirmPassword = _confirmPasswordController.text; // trim nahi karna

    print('===== CHANGE PASSWORD BUTTON PRESSED =====');
    print('OLD PASSWORD LENGTH: ${oldPassword.length}');
    print('NEW PASSWORD LENGTH: ${newPassword.length}');
    print('CONFIRM PASSWORD LENGTH: ${confirmPassword.length}');

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all password fields')),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password must be at least 6 characters'),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password and confirm password do not match'),
        ),
      );
      return;
    }

    if (oldPassword == newPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password must be different from old password'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final int userId = await SessionManager.getUserId();

      print('===== SESSION USER ID FOR CHANGE PASSWORD =====');
      print('USER ID: $userId');

      if (userId == 0) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User session not found. Please login again.'),
          ),
        );
        return;
      }

      final result = await ChangePasswordService.changePassword(
        userId: userId,
        currentPassword: oldPassword,
        newPassword: newPassword,
      );

      print('===== CHANGE PASSWORD FINAL RESULT =====');
      print(result);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Password changed successfully'),
            backgroundColor: Colors.green,
          ),
        );

        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigationScreen(currentIndex: 4),
          ),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Failed to change password',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      print('===== CHANGE PASSWORD SCREEN EXCEPTION =====');
      print(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.08,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE4F9FF),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const BottomNavigationScreen(currentIndex: 4),
                            ),
                                (Route<dynamic> route) => false,
                          );
                        },
                        icon: Padding(
                          padding: EdgeInsets.only(left: width * 0.02),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: width * 0.045,
                          ),
                        ),
                        color: const Color(0xFF2A8DA7),
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    Text(
                      'Change Password',
                      style: TextStyle(
                        fontFamily: 'B',
                        fontWeight: FontWeight.w700,
                        fontSize: width * 0.06,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Image.asset(
                  'assets/images/verify.png',
                  height: width * 0.4,
                  width: width * 0.4,
                ),
                SizedBox(height: height * 0.05),
                _buildPasswordField(
                  width: width,
                  controller: _oldPasswordController,
                  obscure: _obsecureOldPassword,
                  hintText: 'Enter Old Password',
                  onTap: () {
                    setState(() {
                      _obsecureOldPassword = !_obsecureOldPassword;
                    });
                  },
                ),
                SizedBox(height: height * 0.01),
                _buildPasswordField(
                  width: width,
                  controller: _newPasswordController,
                  obscure: _obsecureNewPassword,
                  hintText: 'Enter New Password',
                  onTap: () {
                    setState(() {
                      _obsecureNewPassword = !_obsecureNewPassword;
                    });
                  },
                ),
                SizedBox(height: height * 0.01),
                _buildPasswordField(
                  width: width,
                  controller: _confirmPasswordController,
                  obscure: _obsecureConfirmPassword,
                  hintText: 'Enter Confirm Password',
                  onTap: () {
                    setState(() {
                      _obsecureConfirmPassword = !_obsecureConfirmPassword;
                    });
                  },
                ),
                SizedBox(height: height * 0.03),
                GestureDetector(
                  onTap: _isLoading ? null : _changePassword,
                  child: Container(
                    height: height * 0.058,
                    width: width * 0.89,
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
                        _isLoading ? 'Please Wait...' : 'Change',
                        style: TextStyle(
                          fontFamily: 'SB',
                          fontSize: width * 0.05,
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required double width,
    required TextEditingController controller,
    required bool obscure,
    required String hintText,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          hintStyle: TextStyle(
            fontFamily: 'R',
            fontSize: width * 0.034,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFA4A4A4),
          ),
          suffixIcon: IconButton(
            onPressed: onTap,
            icon: Icon(
              obscure ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFFCDCDCD),
              size: width * 0.06,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
          ),
        ),
      ),
    );
  }
}