import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/Authorization_services.resetpassword.dart';
import 'package:helper/auth_screen/login.dart';
import 'package:helper/components/container_button.dart';
import 'package:helper/components/custom_textformfield.dart';
import 'package:helper/components/custom_widgets.dart';

class VerifyScreen extends StatefulWidget {
  final int? userId;
  final String sentTo;
  final bool isPhone;

  const VerifyScreen({
    super.key,
    required this.userId,
    required this.sentTo,
    required this.isPhone,
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(6, (index) => FocusNode());

  final TextEditingController _newPasswordController =
  TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obsecureText = true;
  bool _obsecureConfirmPassword = true;
  bool _isLoading = false;

  final ResetPasswordService _resetPasswordService = ResetPasswordService();

  @override
  void initState() {
    super.initState();
    print('===== VERIFY SCREEN OPENED =====');
    print('USER ID: ${widget.userId}');
    print('SENT TO: ${widget.sentTo}');
    print('IS PHONE: ${widget.isPhone}');
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((e) => e.text).join();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    print('===== VERIFY BUTTON PRESSED =====');
    print('USER ID: ${widget.userId}');
    print('OTP: $otp');
    print('NEW PASSWORD: $newPassword');
    print('CONFIRM PASSWORD: $confirmPassword');

    if (widget.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID not found'),
        ),
      );
      return;
    }

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete 6 digit OTP'),
        ),
      );
      return;
    }

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter new password and confirm password'),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New Password and Confirm Password do not match'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _resetPasswordService.resetPassword(
      userId: widget.userId!,
      otp: otp,
      password: newPassword,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    print('===== FINAL VERIFY RESULT =====');
    print(result);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Password reset successfully'),
        ),
      );

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
            result['message'] ?? 'Invalid OTP. Please verify and try again.',
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
                  CustomWidgets(title: 'Verify'),

                  SizedBox(height: height * 0.03),

                  Image(
                    image: const AssetImage('assets/images/forget1.png'),
                    height: height * 0.25,
                    width: width * 0.45,
                  ),

                  SizedBox(height: height * 0.05),

                  Row(
                    children: [
                      Text(
                        'Enter Code',
                        style: TextStyle(
                          fontFamily: 'B',
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.054,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.01),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.isPhone
                              ? 'Enter code sent to your phone'
                              : 'Enter code sent to your mail',
                          style: TextStyle(
                            fontFamily: 'R',
                            fontWeight: FontWeight.w400,
                            fontSize: width * 0.03,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: width * 0.12,
                        height: height * 0.065,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(width * 0.03),
                              borderSide: const BorderSide(
                                color: Color(0xFF95CC81),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(width * 0.03),
                              borderSide: const BorderSide(
                                color: Color(0xFF95CC81),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(width * 0.03),
                              borderSide: const BorderSide(
                                color: Color(0xFF95CC81),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.length == 1) {
                              if (index + 1 < _focusNodes.length) {
                                FocusScope.of(context)
                                    .requestFocus(_focusNodes[index + 1]);
                              } else {
                                FocusScope.of(context).unfocus();
                              }
                            } else if (value.isEmpty) {
                              if (index - 1 >= 0) {
                                FocusScope.of(context)
                                    .requestFocus(_focusNodes[index - 1]);
                              }
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: height * 0.03),

                  CustomTextformField(
                    title: 'New Password',
                    controller: _newPasswordController,
                    obsecureText: _obsecureText,
                    keyBoardType: TextInputType.visiblePassword,
                    sufixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obsecureText = !_obsecureText;
                        });
                      },
                      icon: Icon(
                        _obsecureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFFC6C6C6),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  CustomTextformField(
                    title: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obsecureText: _obsecureConfirmPassword,
                    keyBoardType: TextInputType.visiblePassword,
                    sufixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obsecureConfirmPassword =
                          !_obsecureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _obsecureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFFC6C6C6),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.04),

                  ContainerButton(
                    title: _isLoading ? 'Please Wait...' : 'Verify',
                    isLoading: _isLoading,
                    onPressed: _verifyOtp,
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