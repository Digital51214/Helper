import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/Authorization_services.signup.dart';
import 'package:helper/auth_screen/login.dart';
import 'package:helper/session_manager.dart';
import 'package:helper/auth_screen/privacy_policy.dart';
import 'package:helper/auth_screen/termscondition.dart';
import 'package:helper/components/custom_textformfield.dart';
import '../components/container_button.dart';

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
    final username = _userNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    print('===== SIGNUP BUTTON PRESSED =====');
    print('USERNAME: $username');
    print('EMAIL: $email');
    print('PHONE: $phone');
    print('PASSWORD: $password');
    print('CONFIRM PASSWORD: $confirmPassword');
    print('CHECKED TERMS: $checked');

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
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

    final result = await _authService.signup(
      username: username,
      email: email,
      phone: phone,
      password: password,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    print('===== FINAL SIGNUP RESULT =====');
    print(result);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Signup successful'),
        ),
      );
      await SessionManager.saveLoginSession();

      _userNameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Signup failed'),
        ),
      );
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
      body: Stack(
        children: [
          Padding(
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
                              image:
                              const AssetImage('assets/images/signup1.png'),
                              height: h * 0.17,
                              width: h * 0.17,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: h * 0.03),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: baseSize * 0.06,
                          fontFamily: "B",
                        ),
                      ),
                      SizedBox(height: h * 0.001),
                      Text(
                        'Sign Up using your details',
                        style: TextStyle(fontSize: baseSize * 0.035),
                      ),
                      SizedBox(height: h * 0.02),

                      CustomTextformField(
                        title: 'UserName',
                        controller: _userNameController,
                        keyBoardType: TextInputType.text,
                      ),
                      SizedBox(height: h * 0.01),

                      CustomTextformField(
                        title: 'Email Address',
                        controller: _emailController,
                        keyBoardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: h * 0.01),

                      CustomTextformField(
                        title: 'Phone Number',
                        controller: _phoneController,
                        keyBoardType: TextInputType.phone,
                      ),
                      SizedBox(height: h * 0.01),

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
                      SizedBox(height: h * 0.01),

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
                      SizedBox(height: h * 0.01),

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
                                checked = value!;
                              });
                            },
                            fillColor: MaterialStateProperty.resolveWith(
                                  (states) => states.contains(MaterialState.selected)
                                  ? const Color(0xFF000000)
                                  : Colors.transparent,
                            ),
                            checkColor: Colors.white,
                          ),
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
                                fontSize: baseSize * 0.02,
                                fontFamily: 'B',
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.black,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            " and",
                            style: TextStyle(
                              fontSize: baseSize * 0.024,
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
                              " Privacy Policy",
                              style: TextStyle(
                                fontSize: baseSize * 0.025,
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

                      SizedBox(height: h * 0.015),

                      ContainerButton(
                        title: _isLoading ? 'Please Wait...' : 'Sign Up',
                        isLoading: _isLoading,
                        onPressed: _signUp,
                      ),

                      SizedBox(height: h * 0.02),

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
                            child: Divider(
                              thickness: 1.25,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.012),

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
                              radius: w * 0.05,
                              backgroundColor: Colors.white,
                              backgroundImage: const AssetImage(
                                'assets/images/signup2.png',
                              ),
                            ),
                          ),
                          SizedBox(width: w * 0.05),
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
                              radius: w * 0.05,
                              backgroundColor: Colors.white,
                              backgroundImage: const AssetImage(
                                'assets/images/signup3.png',
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.05),

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