import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/Authorization_services.login.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/Authontication_Services/session%20manager%20for%20post%20jobs.dart';
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
  final TextEditingController _passwordController = TextEditingController();

  bool _obsecureText = true;
  bool checked = false;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        final int userId = result['user_id'] is int
            ? result['user_id']
            : int.tryParse(result['user_id']?.toString() ?? '0') ?? 0;

        final int clientId = result['client_id'] is int
            ? result['client_id']
            : int.tryParse(result['client_id']?.toString() ?? '0') ?? userId;

        final String savedEmail =
        (result['email']?.toString().isNotEmpty ?? false)
            ? result['email'].toString().trim().toLowerCase()
            : email;

        final String username = result['username']?.toString() ?? '';
        final String profilePic = result['profile_pic']?.toString() ?? '';

        if (userId == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful but user id not found from API'),
            ),
          );
          return;
        }

        await SessionManager.saveLoginSession(
          userId: userId,
          clientId: clientId,
          email: savedEmail,
          username: username,
          profilePic: profilePic,
        );

        await SessionManager4.saveClientId(clientId);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Login successful'),
          ),
        );

        _emailController.clear();
        _passwordController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigationScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Invalid Login Credentials'),
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
                    height: h * 0.16,
                    width: h * 0.16,
                  ),
                ],
              ),
              SizedBox(height: h * 0.0325),
              Padding(
                padding: EdgeInsets.only(left: w * 0.02),
                child: Row(
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontFamily: 'B',
                        fontSize: baseSize * 0.055,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: w * 0.02, top: h * 0.001),
                child: Row(
                  children: [
                    Text(
                      'Welcome Back! Enter Your Account Details',
                      style: TextStyle(
                        fontFamily: 'R',
                        fontSize: baseSize * 0.028,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.02),
              CustomTextformField(
                title: 'EmailAddress',
                controller: _emailController,
                keyBoardType: TextInputType.emailAddress,
              ),
              SizedBox(height: h * 0.009),
              CustomTextformField(
                obsecureText: _obsecureText,
                controller: _passwordController,
                keyBoardType: TextInputType.visiblePassword,
                sufixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obsecureText = !_obsecureText;
                    });
                  },
                  icon: Icon(
                    _obsecureText ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFFC6C6C6),
                  ),
                ),
                title: 'Password',
              ),
              SizedBox(height: h * 0.013),
              Row(
                children: [
                  Checkbox(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                  Text(
                    "Remember Me",
                    style: TextStyle(
                      fontFamily: 'R',
                      fontWeight: FontWeight.w400,
                      fontSize: baseSize * 0.038,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPassword(),
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
              SizedBox(height: h * 0.03),
              ContainerButton(
                title: _isLoading ? 'Please Wait...' : 'Sign In',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _login,
              ),
              SizedBox(height: h * 0.018),
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
              SizedBox(height: h * 0.013),
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
                      backgroundImage: const AssetImage(
                        'assets/images/signup2.png',
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
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
              SizedBox(height: h * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account?  ',
                    style: TextStyle(
                      fontFamily: 'R',
                      fontSize: baseSize * 0.034,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: baseSize * 0.042,
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