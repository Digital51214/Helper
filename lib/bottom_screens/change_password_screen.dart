import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/changepasswordservice.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/bottom_screens/bottom_navigation_screen.dart';
import 'package:helper/components/password validator.dart';

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

  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String text, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  String? _validateOldPassword(String value) {
    if (value.isEmpty) {
      return 'Old password is required';
    }
    return null;
  }

  String? _validateNewPassword(String value) {
    if (value.isEmpty) {
      return 'New password is required';
    }
    if (value == _oldPasswordController.text) {
      return 'New password must be different from old password';
    }
    return PasswordValidator.validate(value);
  }

  String? _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _newPasswordController.text) {
      return 'New password and confirm password do not match';
    }
    return null;
  }

  bool _validateFields() {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final oldPasswordError = _validateOldPassword(oldPassword);
    final newPasswordError = _validateNewPassword(newPassword);
    final confirmPasswordError = _validateConfirmPassword(confirmPassword);

    setState(() {
      _oldPasswordError = oldPasswordError;
      _newPasswordError = newPasswordError;
      _confirmPasswordError = confirmPasswordError;
    });

    return oldPasswordError == null &&
        newPasswordError == null &&
        confirmPasswordError == null;
  }

  Future<void> _changePassword() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    if (!_validateFields()) {
      return;
    }

    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    print('===== CHANGE PASSWORD BUTTON PRESSED =====');
    print('OLD PASSWORD LENGTH: ${oldPassword.length}');
    print('NEW PASSWORD LENGTH: ${newPassword.length}');
    print('CONFIRM PASSWORD LENGTH: ${confirmPassword.length}');

    if (newPassword != confirmPassword) {
      _showMessage('New password and confirm password do not match');
      return;
    }

    if (oldPassword == newPassword) {
      _showMessage('New password must be different from old password');
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

        _showMessage('User session not found. Please login again.');
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
        _showMessage(
          result['message'] ?? 'Password changed successfully',
          isSuccess: true,
        );

        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        setState(() {
          _oldPasswordError = null;
          _newPasswordError = null;
          _confirmPasswordError = null;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigationScreen(currentIndex: 4),
          ),
              (route) => false,
        );
      } else {
        _showMessage(result['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      print('===== CHANGE PASSWORD SCREEN EXCEPTION =====');
      print(e.toString());

      _showMessage('Something went wrong. Please try again.');
    }
  }

  Widget _buildPasswordField({
    required double width,
    required TextEditingController controller,
    required bool obscure,
    required String hintText,
    required VoidCallback onTap,
    required String? errorText,
    required Function(String value) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.visiblePassword,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              errorText: null,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              hintStyle: TextStyle(
                fontFamily: 'R',
                fontSize: width * 0.024,
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
                borderSide: BorderSide(
                  color: errorText == null
                      ? const Color(0xFFCDCDCD)
                      : Colors.red,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: errorText == null
                      ? const Color(0xFF2A8DA7)
                      : Colors.red,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: errorText == null ? 0 : 6),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: Text(
              errorText,
              style: TextStyle(
                fontFamily: 'R',
                fontSize: width * 0.028,
                height: 1.2,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
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
                              const BottomNavigationScreen(
                                currentIndex: 4,
                              ),
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
                  errorText: _oldPasswordError,
                  onTap: () {
                    setState(() {
                      _obsecureOldPassword = !_obsecureOldPassword;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _oldPasswordError = _validateOldPassword(value);
                      if (_newPasswordController.text.isNotEmpty) {
                        _newPasswordError =
                            _validateNewPassword(_newPasswordController.text);
                      }
                    });
                  },
                ),

                SizedBox(height: height * 0.01),

                _buildPasswordField(
                  width: width,
                  controller: _newPasswordController,
                  obscure: _obsecureNewPassword,
                  hintText: 'Enter New Password',
                  errorText: _newPasswordError,
                  onTap: () {
                    setState(() {
                      _obsecureNewPassword = !_obsecureNewPassword;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _newPasswordError = _validateNewPassword(value);
                      if (_confirmPasswordController.text.isNotEmpty) {
                        _confirmPasswordError = _validateConfirmPassword(
                          _confirmPasswordController.text,
                        );
                      }
                    });
                  },
                ),

                SizedBox(height: height * 0.01),

                _buildPasswordField(
                  width: width,
                  controller: _confirmPasswordController,
                  obscure: _obsecureConfirmPassword,
                  hintText: 'Enter Confirm Password',
                  errorText: _confirmPasswordError,
                  onTap: () {
                    setState(() {
                      _obsecureConfirmPassword = !_obsecureConfirmPassword;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _confirmPasswordError = _validateConfirmPassword(value);
                    });
                  },
                ),

                SizedBox(height: height * 0.04),

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
}