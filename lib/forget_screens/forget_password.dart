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
  int selectedIndex = 0; // 0 = Email, 1 = Phone
  final TextEditingController _valueController = TextEditingController();
  bool _isLoading = false;

  final ForgotPasswordService _forgotPasswordService =
  ForgotPasswordService();

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  }

  /// Converts common PK number formats into +923001234567
  String _normalizePhone(String input) {
    String phone = input.trim();

    // remove spaces, dashes, brackets etc but keep +
    phone = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // Case 1: 03001234567 -> +923001234567
    if (phone.startsWith('03') && phone.length == 11) {
      return '+92${phone.substring(1)}';
    }

    // Case 2: 3001234567 -> +923001234567
    if (!phone.startsWith('0') &&
        !phone.startsWith('92') &&
        !phone.startsWith('+92') &&
        phone.length == 10) {
      return '+92$phone';
    }

    // Case 3: 923001234567 -> +923001234567
    if (phone.startsWith('92') && phone.length == 12) {
      return '+$phone';
    }

    // Case 4: +923001234567 -> same
    if (phone.startsWith('+92') && phone.length == 13) {
      return phone;
    }

    return phone;
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^\+92[0-9]{10}$').hasMatch(phone);
  }

  Future<void> _findAccount() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    final rawValue = _valueController.text.trim();

    print('===== FIND ACCOUNT BUTTON PRESSED =====');
    print('SELECTED INDEX: $selectedIndex');
    print('INPUT VALUE: $rawValue');

    if (rawValue.isEmpty) {
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

    String? email;
    String? phone;

    if (selectedIndex == 0) {
      if (!_isValidEmail(rawValue)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid email address'),
          ),
        );
        return;
      }
      email = rawValue.trim().toLowerCase();
    } else {
      final normalizedPhone = _normalizePhone(rawValue);

      print('NORMALIZED PHONE: $normalizedPhone');

      if (!_isValidPhone(normalizedPhone)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Enter valid phone number e.g. 03001234567 or +923001234567',
            ),
          ),
        );
        return;
      }

      phone = normalizedPhone;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _forgotPasswordService.forgotPassword(
      email: email,
      phone: phone,
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
          content: Text(
            result['message']?.toString() ?? 'OTP has been sent successfully.',
          ),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyScreen(
            userId: result['user_id'],
            sentTo: selectedIndex == 0 ? email! : phone!,
            isPhone: selectedIndex == 1,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message']?.toString() ?? 'Failed to send OTP',
          ),
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
                  CustomWidgets(title: 'Forget Password'),

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
                      Expanded(
                        child: Text(
                          selectedIndex == 0
                              ? 'Enter email to find your account'
                              : 'Enter phone to find your account',
                          style: TextStyle(
                            fontFamily: 'R',
                            fontWeight: FontWeight.w400,
                            fontSize: ws.width * 0.03,
                          ),
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
                              _valueController.clear();
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
                              _valueController.clear();
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
                    controller: _valueController,
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

                  SizedBox(height: ws.height * 0.02),
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