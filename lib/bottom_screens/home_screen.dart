import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/bottom_screens/postjob_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _profilePic = '';
  bool _isProfileLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfilePic();
  }

  Future<void> _loadProfilePic() async {
    try {
      final profilePic = await SessionManager.getProfilePic();

      print('===== HOME SCREEN PROFILE PIC LOAD =====');
      print('PROFILE PIC: $profilePic');

      if (!mounted) return;

      setState(() {
        _profilePic = SessionManager.normalizeProfilePic(profilePic);
        _isProfileLoading = false;
      });
    } catch (e) {
      print('===== HOME SCREEN PROFILE PIC ERROR =====');
      print(e.toString());

      if (!mounted) return;

      setState(() {
        _isProfileLoading = false;
      });
    }
  }

  Widget _buildTopProfileAvatar(double radius) {
    if (_isProfileLoading) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_profilePic.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(_profilePic),
        onBackgroundImageError: (_, __) {
          print('===== HOME SCREEN IMAGE LOAD ERROR =====');
          print('FAILED URL: $_profilePic');
        },
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      backgroundImage: const AssetImage('assets/images/home1.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      body: Stack(
        children: [
          Positioned(
            top: h * 0.34,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.06,
                vertical: h * 0.03,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(base * 0.08),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: h * 0.012),
                child: Column(
                  children: [
                    SizedBox(height: w * 0.01),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "My Jobs",
                        style: TextStyle(
                          fontFamily: 'M',
                          fontSize: base * 0.048,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: w * 0.05),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              height: h * 0.225,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF4F6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFCDCDCD)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: h * 0.215,
                                    width: w * 0.02,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2A8DA7),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(18),
                                        topLeft: Radius.circular(18),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: w * 0.03),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: w * 0.02,
                                        right: w * 0.02,
                                        top: h * 0.02,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: base * 0.15,
                                                width: base * 0.15,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/images/home6.png',
                                                    height: base * 0.1,
                                                    width: base * 0.1,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: w * 0.03),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Shopping Delivery',
                                                      style: TextStyle(
                                                        fontSize: base * 0.038,
                                                        fontFamily: 'SB',
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(height: h * 0.005),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on_rounded,
                                                          color: const Color(0xFF959595),
                                                          size: base * 0.045,
                                                        ),
                                                        SizedBox(width: w * 0.01),
                                                        Expanded(
                                                          child: Text(
                                                            'Road123, colony Z',
                                                            style: TextStyle(
                                                              fontSize: base * 0.028,
                                                              fontFamily: 'R',
                                                              fontWeight:
                                                              FontWeight.w400,
                                                            ),
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: h * 0.018),
                                          Row(
                                            children: [
                                              Image(
                                                image: const AssetImage(
                                                  'assets/images/home5.png',
                                                ),
                                                height: base * 0.05,
                                                width: base * 0.05,
                                              ),
                                              SizedBox(width: w * 0.005),
                                              Text(
                                                '12 min ago',
                                                style: TextStyle(
                                                  fontSize: base * 0.02,
                                                  fontFamily: 'R',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(width: w * 0.032),
                                              Image(
                                                image: const AssetImage(
                                                  'assets/images/home4.png',
                                                ),
                                                height: base * 0.05,
                                                width: base * 0.05,
                                              ),
                                              SizedBox(width: w * 0.01),
                                              Text(
                                                '50k + Applied',
                                                style: TextStyle(
                                                  fontSize: base * 0.02,
                                                  fontFamily: 'R',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFD7EBDC),
                                                  borderRadius:
                                                  BorderRadius.circular(7),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: w * 0.01,
                                                  horizontal: w * 0.03,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.bolt,
                                                      size: base * 0.055,
                                                      color: const Color(0xFFEFB32C),
                                                    ),
                                                    Text(
                                                      'Active',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: 'M',
                                                        fontSize: base * 0.03,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: h * 0.022),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: Colors.black,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: w * 0.02,
                                                  horizontal: w * 0.03,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'See Details',
                                                    style: TextStyle(
                                                      fontFamily: 'B',
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: base * 0.03,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: h * 0.01),
                            Container(
                              height: h * 0.225,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDF7EA),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFCDCDCD)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: h * 0.215,
                                    width: w * 0.02,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEFB32C),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(18),
                                        topLeft: Radius.circular(18),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: w * 0.03),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: w * 0.02,
                                        right: w * 0.02,
                                        top: h * 0.02,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: base * 0.15,
                                                width: base * 0.15,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/images/home6.png',
                                                    height: base * 0.1,
                                                    width: base * 0.1,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: w * 0.03),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Shopping Delivery',
                                                      style: TextStyle(
                                                        fontSize: base * 0.038,
                                                        fontFamily: 'SB',
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(height: h * 0.005),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on_rounded,
                                                          color: const Color(0xFF959595),
                                                          size: base * 0.045,
                                                        ),
                                                        SizedBox(width: w * 0.01),
                                                        Expanded(
                                                          child: Text(
                                                            'Road123, colony Z',
                                                            style: TextStyle(
                                                              fontSize: base * 0.028,
                                                              fontFamily: 'R',
                                                              fontWeight:
                                                              FontWeight.w400,
                                                            ),
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: h * 0.018),
                                          Row(
                                            children: [
                                              Image(
                                                image: const AssetImage(
                                                  'assets/images/home5.png',
                                                ),
                                                height: base * 0.05,
                                                width: base * 0.05,
                                              ),
                                              SizedBox(width: w * 0.005),
                                              Text(
                                                '12 min ago',
                                                style: TextStyle(
                                                  fontSize: base * 0.02,
                                                  fontFamily: 'R',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(width: w * 0.032),
                                              Image(
                                                image: const AssetImage(
                                                  'assets/images/home4.png',
                                                ),
                                                height: base * 0.05,
                                                width: base * 0.05,
                                              ),
                                              SizedBox(width: w * 0.01),
                                              Text(
                                                '50k + Applied',
                                                style: TextStyle(
                                                  fontSize: base * 0.02,
                                                  fontFamily: 'R',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFE2DDD3),
                                                  borderRadius:
                                                  BorderRadius.circular(7),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: w * 0.01,
                                                  horizontal: w * 0.03,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'InActive',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'M',
                                                      fontSize: base * 0.03,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: h * 0.022),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: const Color(0xFF959595),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: w * 0.02,
                                                  horizontal: w * 0.03,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'See Details',
                                                    style: TextStyle(
                                                      fontFamily: 'B',
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: base * 0.03,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: h * 0.09),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              children: [
                SizedBox(height: h * 0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTopProfileAvatar(base * 0.06),
                    Container(
                      height: base * 0.135,
                      width: base * 0.135,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.notifications,
                          size: base * 0.07,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.04),
                Row(
                  children: [
                    Text(
                      "Find Your\nPerfect Help!",
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontSize: base * 0.06,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: w * 0.07),
                    Image.asset("assets/images/home3.png", height: h * 0.09),
                  ],
                ),
                SizedBox(height: h * 0.035),
                Container(
                  height: h * 0.058,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(base * 0.08),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: base * 0.04,
                        offset: Offset(0, h * 0.006),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    cursorColor: const Color(0xFFA4A4A4),
                    style: TextStyle(fontSize: base * 0.035),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(base * 0.04),
                        child: Image.asset(
                          'assets/images/searchicon.png',
                          height: h * 0.005,
                          fit: BoxFit.contain,
                        ),
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: base * 0.03,
                        fontFamily: 'R',
                        color: const Color(0xFFA4A4A4),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: h * 0.022),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}