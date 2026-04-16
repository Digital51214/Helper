import 'package:flutter/material.dart';
import 'package:helper/auth_screen/login.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
      );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Pages
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              children: const [
                OnboardPage(
                  image: "assets/images/onbdng1.png",
                  title: "page1",
                  subtitle:
                  "Post everyday tasks and connect with\ntrusted people in your area ,quickly\nand safely.",
                ),
                OnboardPage(
                  image: "assets/images/onbdng2.png",
                  title: "page2",
                  subtitle:
                  "Browse nearby jobs, choose what fits\nyou, and get paid for helping others",
                ),
                OnboardPage3(),
              ],
            ),
          ),

          // Bottom Row (Skip + Indicator) only for first 2 pages
          if (currentPage != 2)
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05,
                  vertical: h * 0.034,
                ),
                child: Row(
                  children: [TextButton(
                      onPressed: () => _controller.jumpToPage(2),
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: w * 0.045,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Circular Progress Button
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 150),
                      tween: Tween<double>(
                        begin: 0,
                        end: currentPage == 0 ? 0.5 : 1,
                      ),
                      builder: (context, value, _) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Progress Circle
                            SizedBox(
                              height: h * 0.07,
                              width: h * 0.07,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                value: value,
                                strokeWidth: 2,
                              ),
                            ),

                            // Inner Button
                            GestureDetector(
                              onTap: nextPage,
                              child: Container(
                                height: h * 0.06,
                                width: h * 0.06,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: h * 0.03,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Page 1 & 2
class OnboardPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.06,
        vertical: h * 0.05,
      ),
      child: Column(
        children: [
          SizedBox(height: h * 0.03),
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
                      color: const Color(0xFFF1EAFF),
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
          SizedBox(height: h * 0.03),
          Image.asset(image, height: h * 0.32, fit: BoxFit.contain),
          SizedBox(height: h * 0.032),

          // Title
          Row(
            children: [
              Expanded(
                child: title == "page1"
                    ? RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Local ",
                        style: TextStyle(
                          color: const Color(0xFF2A8DA7),
                          fontWeight: FontWeight.w700,
                          fontSize: w * 0.067,
                          fontFamily: 'B',
                        ),
                      ),
                      TextSpan(
                        text: "Help, When\nYou",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: w * 0.067,
                          fontFamily: 'R',
                        ),
                      ),
                      TextSpan(
                        text: " Need It",
                        style: TextStyle(
                          color: const Color(0xFF2A8DA7),
                          fontWeight: FontWeight.w700,
                          fontSize: w * 0.068,
                          fontFamily: 'B',
                        ),
                      ),
                    ],
                  ),
                )
                    : RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Earn ",
                        style: TextStyle(
                          color: const Color(0xFF2A8DA7),
                          fontWeight: FontWeight.w700,
                          fontSize: w * 0.067,
                          fontFamily: 'B',
                        ),
                      ),
                      TextSpan(
                        text: "On Your Own\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: w * 0.067,
                          fontFamily: 'R',
                        ),
                      ),
                      TextSpan(
                        text: "Terms",
                        style: TextStyle(
                          color: const Color(0xFF2A8DA7),
                          fontWeight: FontWeight.w700,
                          fontSize: w * 0.068,
                          fontFamily: 'B',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.012),

          // Subtitle
          Row(
            children: [
              Text(
                subtitle,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'L',
                  fontSize: w * 0.039,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Page 3
class OnboardPage3 extends StatefulWidget {
  const OnboardPage3({super.key});

  @override
  State<OnboardPage3> createState() => _OnboardPage3State();
}

class _OnboardPage3State extends State<OnboardPage3> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: h * 0.15,
          left: w * 0.04,
          right: w * 0.04,
          bottom: h * 0.06,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Text
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: w * 0.067,
                      fontFamily: 'B',
                    ),
                    children: [
                      const TextSpan(
                        text: "What are you\n",
                        style: TextStyle(color: Colors.black, height: 0.5),
                      ),
                      TextSpan(
                        text: "looking for?",
                        style: TextStyle(color: const Color(0xFF2A8DA7)),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: w * 0.04),
                Image.asset(
                  'assets/images/welcom8.png',
                  height: h * 0.1,
                  width: w * 0.1,
                ),
              ],
            ),
            SizedBox(height: h * 0.04),

            // Image
            Center(
              child: Image.asset(
                "assets/images/onbdng3.png",
                height: h * 0.34,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: h * 0.08),

            // Bottom Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Post a Job
                GestureDetector(
                  onTap: () => setState(() => selectedIndex = 0),
                  child: Container(
                    height: h * 0.055,
                    width: w * 0.40,
                    decoration: BoxDecoration(
                      color: selectedIndex == 0 ? Colors.black : Colors.transparent,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: h * 0.028,
                          width: w * 0.055,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Center(
                            child: Icon(Icons.add, size: h * 0.023),
                          ),
                        ),
                        SizedBox(width: w * 0.02),
                        Text(
                          "Post A Job!",
                          style: TextStyle(
                            fontFamily: 'SB',
                            color: selectedIndex == 0 ? Colors.white : Colors.black,
                            fontSize: w * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: w*0.03),

                // Find Work
                GestureDetector(
                  onTap: () => setState(() => selectedIndex = 1),
                  child: Container(
                    height: h * 0.055,
                    width: w * 0.4,
                    decoration: BoxDecoration(
                      color: selectedIndex == 1 ? Colors.black : Colors.transparent,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: h * 0.032,
                          width: w * 0.07,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/onbdng5.png',
                              height: h * 0.048,
                              width: w * 0.048,
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.02),
                        Text(
                          "Find Work",
                          style: TextStyle(
                            fontFamily: 'SB',
                            color: selectedIndex == 1 ? Colors.white : Colors.black,
                            fontSize: w * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.06),

            // Continue Button
            Center(
              child: Container(
                width: double.infinity,
                height: h * 0.065,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                  onPressed: () {
                    if (selectedIndex == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select an option first"),
                        ),
                      );
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const Login()),
                            (route) => false,
                      );
                    }
                  },

                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontFamily: 'SB',
                      color: Colors.white,
                      fontSize: w * 0.045,
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
}
