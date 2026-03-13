import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final ws = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: ws.width * 0.04,
            right: ws.width * 0.04,
            top: ws.height * 0.07,
          ),
          child: Column(
            children: [
              CustomWidgets(title: 'ForgetPassword'),

              SizedBox(height: ws.height * 0.02),

              Image(
                image: AssetImage('assets/images/forget1.png'),
                height: ws.height * 0.25,
                width: ws.height * 0.25,
              ),

              SizedBox(height: ws.height * 0.04),

              Row(
                children: [
                  Text(
                    'Verify Your Identity',
                    style: TextStyle(
                      fontFamily: 'B',
                      fontWeight: FontWeight.w700,
                      fontSize: ws.width * 0.06,
                    ),
                  ),
                ],
              ),

              SizedBox(height: ws.height * 0.01),

              Row(
                children: [
                  Text(
                    'Enter email to find your account',
                    style: TextStyle(
                      fontFamily: 'R',
                      fontWeight: FontWeight.w400,
                      fontSize: ws.width * 0.035,
                    ),
                  ),
                ],
              ),

              SizedBox(height: ws.height * 0.02),

              Container(
                height: ws.height * 0.055,
                width: ws.width * 0.65,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [

                    /// EMAIL
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
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

                    /// PHONE
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
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

              SizedBox(height: ws.height * 0.03),

              ContainerButton(
                title: 'Find your account',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerifyScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
