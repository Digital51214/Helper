import 'package:flutter/material.dart';
import 'package:helper/auth_screen/Sign_up.dart';
import 'package:helper/bottom_screens/bottom_navigation_screen.dart';
import 'package:helper/components/container_button.dart';
import 'package:helper/components/custom_textformfield.dart';
import 'package:helper/forget_screens/forget_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obsecureText = true;
  bool checked = false;

  @override
  void dispose() {
    _emailController.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    // Clear controllers before navigating
    _emailController.clear();
    _password.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavigationScreen(),
      ),
    );
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
          left: w * 0.03,
          right: w * 0.03,
          top: h * 0.09,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage('assets/images/signup1.png'),
                    height: h * 0.18,
                    width: h * 0.18,
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(left: w*0.02),
                child: Row(
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontFamily: 'B',
                        fontSize: baseSize * 0.065,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: w*0.02,top: h*0.006),
                child: Row(
                  children: [
                    Text(
                      'Welcome Back! Enter Your Account Details',
                      style: TextStyle(
                        fontFamily: 'R',
                        fontSize: baseSize * 0.037,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.015),
              CustomTextformField(
                title: 'EmailAddress',
                controller: _emailController,
                keyBoardType: TextInputType.emailAddress,
              ),
              SizedBox(height: h * 0.015),
              CustomTextformField(
                obsecureText: _obsecureText,
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
                title: 'Password',
                controller: _password,
                keyBoardType: TextInputType.visiblePassword,
              ),
              SizedBox(height: h * 0.015),
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
                    "Remember Me",
                    style: TextStyle(
                      fontFamily: 'R',
                      fontWeight: FontWeight.w400,
                      fontSize: baseSize * 0.038,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetPassword(),
                        ),
                      );
                    },
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        fontFamily: 'B',
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: baseSize * 0.038,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.015),
              ContainerButton(
                title: 'Sign In',
                onPressed: _login,
              ),
              SizedBox(height: h * 0.02),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: const Color(0xFFCDCDCD),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: const Color(0xFFA4A4A4),
                        fontSize: baseSize * 0.038,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1.25,
                      color: const Color(0xFFCDCDCD),
                    ),
                  ),
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
                      backgroundImage: const AssetImage(
                        'assets/images/signup2.png',
                      ),
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
                      backgroundImage: const AssetImage(
                        'assets/images/signup3.png',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account?  ',
                    style: TextStyle(
                      fontFamily: 'R',
                      fontSize: baseSize * 0.038,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      'Sign Up',
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
            ],
          ),
        ),
      ),
    );
  }
}
