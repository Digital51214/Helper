import 'package:flutter/material.dart';
import 'package:helper/auth_screen/login.dart';
import 'package:helper/auth_screen/privacy_policy.dart';
import 'package:helper/auth_screen/termscondition.dart';
import 'package:helper/bottom_screens/bottom_navigation_screen.dart';
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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  bool _obsecureText = true;
  bool _obsecureConfirmPassword = true;
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final baseSize = size.shortestSide;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: w * 0.03, right: w * 0.03, top: h * 0.04),
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
                          height: h * 0.18,
                          width: h * 0.18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: baseSize * 0.065,
                    ),
                  ),
                  SizedBox(height: h * 0.005),
                  Text(
                    'Sign Up using your details',
                    style: TextStyle(fontSize: baseSize * 0.035),
                  ),
                  SizedBox(height: h * 0.015),
                  CustomTextformField(
                    title: 'UserName',
                    controller: _userNameController,
                    keyBoardType: TextInputType.text,
                  ),
                  SizedBox(height: h * 0.015),
                  CustomTextformField(
                    title: 'Email Address',
                    controller: _emailController,
                    keyBoardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: h * 0.015),
                  CustomTextformField(
                    sufixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obsecureText = !_obsecureText;
                        });
                      },
                      icon: Icon(
                        _obsecureText ? Icons.visibility : Icons.visibility_off,
                        color: Color(0xFFC6C6C6),
                      ),
                    ),
                    obsecureText: _obsecureText,
                    title: 'Password',
                    controller: _passwordController,
                    keyBoardType: TextInputType.text,
                  ),
                  SizedBox(height: h * 0.015),
                  CustomTextformField(
                    sufixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obsecureConfirmPassword = !_obsecureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _obsecureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xFFC6C6C6),
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
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                          fontSize: baseSize * 0.0304,
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
                            fontSize: baseSize * 0.0304,
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
                          fontSize: baseSize * 0.0304,
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
                            fontSize: baseSize * 0.0304,
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
                    title: 'Sign Up',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen()),
                      );
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  Row(
                    children: [
                      Expanded(child: Divider(thickness: 1, color: Colors.grey)),
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
                      Expanded(child: Divider(thickness: 1.25, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: h * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(w * 0.012),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFCDCDCD),
                            width: 1,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: w * 0.065,
                          backgroundImage:
                          const AssetImage('assets/images/signup2.png'),
                        ),
                      ),
                      SizedBox(width: w * 0.07),
                      Container(
                        padding: EdgeInsets.all(w * 0.012),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFCDCDCD),
                            width: 1,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: w * 0.065,
                          backgroundColor: Colors.white,
                          backgroundImage:
                          const AssetImage('assets/images/signup3.png'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h*0.05),
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
                            MaterialPageRoute(builder: (context) => Login()),
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
