import 'package:flutter/material.dart';
import 'package:helper/auth_screen/login.dart';
import 'package:helper/components/container_button.dart';
import 'package:helper/components/custom_textformfield.dart';
import 'components/custom_widgets.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _obsecurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                image: AssetImage('assets/images/verify.png'),
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
                    color: Color(0xFFC6C6C6),
                  ),
                ),
                title: 'Password',
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
                    color: Color(0xFFC6C6C6),
                  ),
                ),
                controller: _confirmPassword,
                keyBoardType: TextInputType.visiblePassword,
              ),

              SizedBox(height: height * 0.04),

              ContainerButton(
                title: 'Change',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
              ),

              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
