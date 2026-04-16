import 'package:flutter/material.dart';
import 'bottom_navigation_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obsecureOldPassword = true;
  bool _obsecureNewPassword = true;
  bool _obsecureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.08,
        ),
        child: Column(
          children: [
            /// 🔹 Header
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE4F9FF),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BottomNavigationScreen(currentIndex: 4),
                        ),
                            (Route<dynamic> route) => false,
                      );
                    },
                    icon: Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02),
                      child: Icon(Icons.arrow_back_ios, size: width * 0.045),
                    ),
                    color: Color(0xFF2A8DA7),
                  ),
                ),
                SizedBox(width: width * 0.05),
                Text(
                  'Change Password',
                  style: TextStyle(
                    fontFamily: 'B',
                    fontWeight: FontWeight.w700,
                    fontSize: width * 0.06,
                  ),
                ),
              ],
            ),

            SizedBox(height: height * 0.03),

            /// 🔹 Image
            Image.asset(
              'assets/images/verify.png',
              height: width * 0.4,
              width: width * 0.4,
            ),

            SizedBox(height: height * 0.05),

            /// 🔹 Old Password
            _buildPasswordField(
              width,
              _obsecureOldPassword,
              'Enter Old Password',
                  (val) {
                setState(() {
                  _obsecureOldPassword = !_obsecureOldPassword;
                });
              },
            ),

            SizedBox(height: height * 0.01),

            /// 🔹 New Password
            _buildPasswordField(
              width,
              _obsecureNewPassword,
              'Enter New Password',
                  (val) {
                setState(() {
                  _obsecureNewPassword = !_obsecureNewPassword;
                });
              },
            ),

            SizedBox(height: height * 0.01),

            /// 🔹 Confirm Password
            _buildPasswordField(
              width,
              _obsecureConfirmPassword,
              'Enter Confirm Password',
                  (val) {
                setState(() {
                  _obsecureConfirmPassword = !_obsecureConfirmPassword;
                });
              },
            ),

            SizedBox(height: height * 0.03),

            /// 🔹 Change Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationScreen(),
                  ),
                );
              },
              child: Container(
                height: height * 0.058,
                width: width * 0.89,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(width: 2,
                        color: Colors.white.withOpacity(0.158)
                    ),
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Center(
                  child: Text(
                    'Change',
                    style: TextStyle(
                      fontFamily: 'SB',
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      double width,
      bool obscure,
      String hintText,
      Function onTap,
      ) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
          hintStyle: TextStyle(
            fontFamily: 'R',
            fontSize: width * 0.034,
            fontWeight: FontWeight.w400,
            color: Color(0xFFA4A4A4),
          ),
          suffixIcon: IconButton(
            onPressed: () => onTap(null),
            icon: Icon(
              obscure ? Icons.visibility : Icons.visibility_off,color: Color(0xFFCDCDCD),
              size: width * 0.06,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Color(0xFFCDCDCD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Color(0xFFCDCDCD)),
          ),
        ),
      ),
    );
  }
}
