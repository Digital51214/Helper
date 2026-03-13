import 'package:flutter/material.dart';
import 'package:helper/on_boarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// ⚡ Image shifted toward circle button
          Positioned(
            right: w * 0.12,   // 👈 right edge se thoda left
            bottom: h * 0.08,  // 👈 bottom se responsive offset
            child: Container(
              width: w * 0.55,   // responsive width
              height: h * 0.5,  // responsive height
              child: Image.asset(
                'assets/images/homeicon3.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          /// Column Content
          Padding(
            padding: EdgeInsets.only(top: h * 0.07, left: w * 0.035, right: w * 0.035),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top-right circle icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: h * 0.06,
                          width: h * 0.06,
                          decoration: BoxDecoration(
                            color: Color(0xFFF1EAFF),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Image.asset(
                          'assets/images/homeicon1.png',
                          height: h * 0.075,
                          width: w * 0.075,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: h * 0.04),

                /// Title + small image
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Earn',
                            style: TextStyle(
                                fontFamily: 'B',
                                fontSize: w * 0.07,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2A8DA7)),
                          ),
                          TextSpan(
                            text: ' More\nOr Get Help\n',
                            style: TextStyle(
                              fontFamily: 'M',
                              fontSize: w * 0.07,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'Nearby',
                            style: TextStyle(
                                fontFamily: 'B',
                                fontWeight: FontWeight.w700,
                                fontSize: w * 0.07,
                                color: Color(0xFF2A8DA7)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: w * 0.04),
                    Image.asset(
                      'assets/images/welcom8.png',
                      height: h * 0.13,
                      width: w * 0.13,
                    ),
                  ],
                ),
                SizedBox(height: h * 0.016),

                /// Description
                Text(
                  'A smarter way to post local\ntasks or earn from nearby\njobs',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontFamily: 'L',
                    fontSize: w * 0.045,
                  ),
                ),
                SizedBox(height: h * 0.04),

                /// Next Button
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: h * 0.075,
                          width: h * 0.075,
                          child: const CircularProgressIndicator(
                            color: Colors.black,
                            value: 0.33,
                            strokeWidth: 1.5,
                          ),
                        ),
                        Container(
                          height: h * 0.065,
                          width: h * 0.065,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const OnBoardingScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
