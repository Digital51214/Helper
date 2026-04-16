import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/Authorization_services.forgetpassword.dart';
import 'package:helper/components/container_button.dart';
import 'package:helper/components/custom_textformfield.dart';
import 'package:helper/components/custom_widgets.dart';
import 'package:helper/forget_screens/verify_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  int selectedIndex = 0; // 0 = Email , 1 = Phone
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  final ForgotPasswordService _forgotPasswordService =
  ForgotPasswordService();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _findAccount() async {
    final value = _emailController.text.trim();

    print('===== FIND ACCOUNT BUTTON PRESSED =====');
    print('SELECTED INDEX: $selectedIndex');
    print('INPUT VALUE: $value');

    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            selectedIndex == 0
                ? 'Please enter email address'
                : 'Please enter phone number',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _forgotPasswordService.forgotPassword(
      email: selectedIndex == 0 ? value : null,
      phone: selectedIndex == 1 ? value : null,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    print('===== FINAL FORGOT PASSWORD RESULT =====');
    print(result);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'OTP has been sent successfully.'),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyScreen(
            userId: result['user_id'],
            sentTo: value,
            isPhone: selectedIndex == 1,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to send OTP'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ws = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: ws.width * 0.04,
                right: ws.width * 0.04,
                top: ws.height * 0.07,
              ),
              child: Column(
                children: [
                  CustomWidgets(title: 'ForgetPassword'),

                  SizedBox(height: ws.height * 0.03),

                  Image(
                    image: const AssetImage('assets/images/forget1.png'),
                    height: ws.height * 0.25,
                    width: ws.height * 0.25,
                  ),

                  SizedBox(height: ws.height * 0.05),

                  Row(
                    children: [
                      Text(
                        'Verify Your Identity',
                        style: TextStyle(
                          fontFamily: 'B',
                          fontWeight: FontWeight.w700,
                          fontSize: ws.width * 0.054,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: ws.height * 0.01),

                  Row(
                    children: [
                      Text(
                        selectedIndex == 0
                            ? 'Enter email to find your account'
                            : 'Enter phone to find your account',
                        style: TextStyle(
                          fontFamily: 'R',
                          fontWeight: FontWeight.w400,
                          fontSize: ws.width * 0.03,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: ws.height * 0.03),

                  Container(
                    height: ws.height * 0.055,
                    width: ws.width * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = 0;
                              _emailController.clear();
                            });
                          },
                          child: Container(
                            height: ws.height * 0.055,
                            width: ws.width * 0.325,
                            decoration: BoxDecoration(
                              color: selectedIndex == 0
                                  ? Colors.black
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontFamily: 'SB',
                                  fontWeight: FontWeight.w600,
                                  fontSize: ws.width * 0.045,
                                  color: selectedIndex == 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                              _emailController.clear();
                            });
                          },
                          child: Container(
                            height: ws.height * 0.055,
                            width: ws.width * 0.325,
                            decoration: BoxDecoration(
                              color: selectedIndex == 1
                                  ? Colors.black
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                'Phone',
                                style: TextStyle(
                                  fontFamily: 'SB',
                                  fontWeight: FontWeight.w600,
                                  fontSize: ws.width * 0.045,
                                  color: selectedIndex == 1
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ws.height * 0.035),

                  CustomTextformField(
                    title: selectedIndex == 0
                        ? 'Email Address'
                        : 'Phone Number',
                    controller: _emailController,
                    keyBoardType: selectedIndex == 0
                        ? TextInputType.emailAddress
                        : TextInputType.phone,
                  ),

                  SizedBox(height: ws.height * 0.035),

                  ContainerButton(
                    title: _isLoading ? 'Please Wait...' : 'Find Your Account',
                    isLoading: _isLoading,
                    onPressed: _findAccount,
                  ),
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