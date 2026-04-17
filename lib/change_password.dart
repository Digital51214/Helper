import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/Authorization_services.resetpassword.dart';
import 'package:helper/auth_screen/login.dart';
import 'package:helper/components/container_button.dart';
import 'package:helper/components/custom_textformfield.dart';
import 'package:helper/components/custom_widgets.dart';

class ChangePassword extends StatefulWidget {
  final int userId;
  final String otp;

  const ChangePassword({
    super.key,
    required this.userId,
    required this.otp,
  });

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obsecurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final ResetPasswordService _resetPasswordService = ResetPasswordService();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final otp = widget.otp.replaceAll(RegExp(r'[^0-9]'), '');

    print('===== CHANGE PASSWORD BUTTON PRESSED =====');
    print('USER ID: ${widget.userId}');
    print('OTP: $otp');
    print('PASSWORD LENGTH: ${password.length}');
    print('CONFIRM PASSWORD LENGTH: ${confirmPassword.length}');

    if (otp.isEmpty || otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP. Please verify and try again.'),
        ),
      );
      return;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill both password fields')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password and Confirm Password do not match'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _resetPasswordService.resetPassword(
      userId: widget.userId,
      otp: otp,
      password: password,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    print('===== FINAL CHANGE PASSWORD RESULT =====');
    print(result);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message']?.toString() ?? 'Password reset successfully',
          ),
        ),
      );

      _passwordController.clear();
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
            result['message']?.toString() ??
                'Wrong OTP kindly put correct OTP',
          ),
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
            child: Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
                right: width * 0.04,
                top: height * 0.07,
              ),
              child: Column(
                children: [
                  CustomWidgets(title: 'Change password'),

                  SizedBox(height: height * 0.03),

                  Image(
                    image: const AssetImage('assets/images/verify.png'),
                    height: height * 0.25,
                    width: width * 0.5,
                  ),

                  SizedBox(height: height * 0.05),

                  Row(
                    children: [
                      Text(
                        'Change Password',
                        style: TextStyle(
                          fontFamily: 'B',
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.054,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.025),

                  CustomTextformField(
                    obsecureText: _obsecurePassword,
                    sufixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obsecurePassword = !_obsecurePassword;
                        });
                      },
                      icon: Icon(
                        _obsecurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFFC6C6C6),
                      ),
                    ),
                    title: 'New Password',
                    controller: _passwordController,
                    keyBoardType: TextInputType.visiblePassword,
                  ),

                  SizedBox(height: height * 0.01),

                  CustomTextformField(
                    obsecureText: _obscureConfirmPassword,
                    title: 'Confirm Password',
                    sufixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFFC6C6C6),
                      ),
                    ),
                    controller: _confirmPasswordController,
                    keyBoardType: TextInputType.visiblePassword,
                  ),

                  SizedBox(height: height * 0.04),

                  ContainerButton(
                    title: _isLoading ? 'Please Wait...' : 'Change',
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _changePassword,
                  ),

                  SizedBox(height: height * 0.02),
                ],
              ),
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