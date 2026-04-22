import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/Authorization_service.ResetPassword.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/Authontication_Services/session_manager2.forgetpassword.dart'
as forgot_session;
import 'package:helper/auth_screen/login.dart';

class UpdatePasswordScreen extends StatefulWidget {
  final String otp;
  final int userId;

  const UpdatePasswordScreen({
    super.key,
    required this.otp,
    required this.userId,
  });

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill both password fields'),
        ),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password and confirm password must be the same'),
        ),
      );
      return;
    }

    if (widget.userId == 0 || widget.otp.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid reset session. Please try again.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await ResetPasswordService.resetPassword(
      userId: widget.userId,
      otp: widget.otp,
      password: newPassword,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      await forgot_session.SessionManager.clearForgotPasswordSession();
      await SessionManager.clearSession();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] ??
                'Password reset successful! You can now login with your new password.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      _newPasswordController.clear();
      _confirmPasswordController.clear();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] ?? 'Unable to reset password.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildPasswordField({
    required double width,
    required TextEditingController controller,
    required bool obscure,
    required String hintText,
    required VoidCallback onToggle,
  }) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
          hintStyle: TextStyle(
            fontFamily: 'R',
            fontSize: width * 0.034,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFA4A4A4),
          ),
          suffixIcon: IconButton(
            onPressed: onToggle,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return WillPopScope(
      onWillPop: () async => !_isLoading,
      child: Scaffold(
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
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
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
                    controller: _newPasswordController,
                    obscure: _obscureNewPassword,
                    hintText: 'Enter New Password',
                    onToggle: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  SizedBox(height: height * 0.015),
                  _buildPasswordField(
                    width: width,
                    controller: _confirmPasswordController,
                    obscure: _obscureConfirmPassword,
                    hintText: 'Enter Confirm New Password',
                    onToggle: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  SizedBox(height: height * 0.04),
                  GestureDetector(
                    onTap: _isLoading ? null : _changePassword,
                    child: Container(
                      height: height * 0.058,
                      width: double.infinity,
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
      ),
    );
  }
}