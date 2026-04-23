import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/Authorization_services.signup.dart';
import 'package:helper/auth_screen/login.dart';
import 'package:helper/bottom_screens/bottom_navigation_screen.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/auth_screen/privacy_policy.dart';
import 'package:helper/auth_screen/termscondition.dart';
import 'package:helper/components/custom_textformfield.dart';
import 'package:helper/components/container_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _obsecureText = true;
  bool _obsecureConfirmPassword = true;
  bool checked = false;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    final username = _userNameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    if (phone.length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
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

    if (!checked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms & Conditions and Privacy Policy'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.signup(
        username: username,
        email: email,
        phone: phone,
        password: password,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        final int userId = result['user_id'] is int
            ? result['user_id']
            : int.tryParse(result['user_id']?.toString() ?? '0') ?? 0;

        final String savedEmail =
        (result['email']?.toString().isNotEmpty ?? false)
            ? result['email'].toString().trim().toLowerCase()
            : email;

        final String savedUsername =
        (result['username']?.toString().isNotEmpty ?? false)
            ? result['username'].toString().trim()
            : username;

        final String profilePic = result['profile_pic']?.toString() ?? '';

        await SessionManager.saveLoginSession(
          userId: userId,
          email: savedEmail,
          username: savedUsername,
          profilePic: profilePic,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Signup successful'),
          ),
        );

        _userNameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigationScreen(),
          ),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Signup failed'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final baseSize = size.shortestSide;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          left: w * 0.04,
          right: w * 0.04,
          top: h * 0.04,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: h - h * 0.04),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage('assets/images/signup1.png'),
                          height: h * 0.16,
                          width: h * 0.16,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.0325),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: baseSize * 0.055,
                      fontFamily: "B",
                    ),
                  ),
                  SizedBox(height: h * 0.0009),
                  Text(
                    'Sign Up using your details',
                    style: TextStyle(fontSize: baseSize * 0.032),
                  ),
                  SizedBox(height: h * 0.02),

                  CustomTextformField(
                    title: 'UserName',
                    controller: _userNameController,
                    keyBoardType: TextInputType.text,
                  ),
                  SizedBox(height: h * 0.009),

                  CustomTextformField(
                    title: 'Email Address',
                    controller: _emailController,
                    keyBoardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: h * 0.009),

                  CustomTextformField(
                    title: 'Phone Number',
                    controller: _phoneController,
                    keyBoardType: TextInputType.phone,
                  ),
                  SizedBox(height: h * 0.009),

                  CustomTextformField(
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
                    obsecureText: _obsecureText,
                    title: 'Password',
                    controller: _passwordController,
                    keyBoardType: TextInputType.text,
                  ),
                  SizedBox(height: h * 0.009),

                  CustomTextformField(
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
                    obsecureText: _obsecureConfirmPassword,
                    title: 'Confirm Password',
                    controller: _confirmPasswordController,
                    keyBoardType: TextInputType.text,
                  ),
                  SizedBox(height: h * 0.009),

                  Row(
                    children: [
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                        shape: const CircleBorder(),
                        value: checked,
                        onChanged: (value) {
                          setState(() {
                            checked = value ?? false;
                          });
                        },
                        fillColor: MaterialStateProperty.resolveWith(
                              (states) => states.contains(MaterialState.selected)
                              ? const Color(0xFF000000)
                              : Colors.transparent,
                        ),
                        checkColor: Colors.white,
                      ),
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "I agree with all ",
                              style: TextStyle(
                                fontSize: baseSize * 0.022,
                                fontFamily: 'R',
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Termscondition(),
                                  ),
                                );
                              },
                              child: Text(
                                "Terms & Conditions",
                                style: TextStyle(
                                  fontSize: baseSize * 0.022,
                                  fontFamily: 'B',
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.black,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              " and ",
                              style: TextStyle(
                                fontSize: baseSize * 0.022,
                                fontFamily: 'R',
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrivacyPolicy(),
                                  ),
                                );
                              },
                              child: Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  fontSize: baseSize * 0.022,
                                  fontFamily: 'B',
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.black,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.015),

                  ContainerButton(
                    title: _isLoading ? 'Please Wait...' : 'Sign Up',
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _signUp,
                  ),

                  SizedBox(height: h * 0.018),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(0.6),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: baseSize * 0.035,
                          ),
                        ),
                      ),
                      Expanded(
                        child: const Divider(
                          thickness: 1.25,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.009),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(w * 0.012),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFCDCDCD),
                            width: 1,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: w * 0.048,
                          backgroundColor: Colors.white,
                          backgroundImage: const AssetImage(
                            'assets/images/signup2.png',
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.045),
                      Container(
                        padding: EdgeInsets.all(w * 0.012),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFCDCDCD),
                            width: 1,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: w * 0.048,
                          backgroundColor: Colors.white,
                          backgroundImage: const AssetImage(
                            'assets/images/signup3.png',
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontFamily: 'R',
                          fontSize: baseSize * 0.035,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: baseSize * 0.045,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}