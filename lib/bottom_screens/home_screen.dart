import 'package:flutter/material.dart';
import 'package:helper/bottom_screens/postjob_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          /// 🔥 WHITE OVERLAY SECTION
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

                    SizedBox(height: h * 0.01),

                    /// Job Card
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              height: h * 0.225,
                              decoration: BoxDecoration(
                                color: Color(0xFFEAF4F6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Color(0xFFCDCDCD))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: h * 0.215,
                                    width: w * 0.02,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2A8DA7),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(18),
                                        topLeft: Radius.circular(18),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: w * 0.03),

                                  /// 🔥 FIXED PART
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: w * 0.02,
                                        right: w * 0.02,
                                        top: h * 0.02,
                                      ),
                                      child: Column(
                                        children: [
                                          /// 🔹 First Row
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: base * 0.16,
                                                width: base * 0.16,
                                                decoration: BoxDecoration(
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
                                                        fontSize: base * 0.045,
                                                        fontFamily: 'SB',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),

                                                    SizedBox(height: h * 0.005),

                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          color: Color(
                                                            0xFF959595,
                                                          ),
                                                          size: base * 0.045,
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.01,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            'Road123, colony Z',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  base * 0.035,
                                                              fontFamily: 'R',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: h * 0.02),

                                          /// 🔹 Second Row
                                          Row(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                  'assets/images/home5.png',
                                                ),
                                                height: base * 0.08,
                                                width: base * 0.08,
                                              ),

                                              SizedBox(width: w * 0.005),

                                              Text(
                                                '12 min ago',
                                                style: TextStyle(
                                                  fontSize: base * 0.03,
                                                  fontFamily: 'R',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),

                                              SizedBox(width: w * 0.03),

                                              Image(
                                                image: AssetImage(
                                                  'assets/images/home4.png',
                                                ),
                                                height: base * 0.055,
                                                width: base * 0.055,
                                              ),

                                              SizedBox(width: w * 0.01),

                                              Text(
                                                '50k + Applied',
                                                style: TextStyle(
                                                  fontSize: base * 0.03,
                                                  fontFamily: 'R',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                height: h * 0.04,
                                                width: w * 0.2,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFD7EBDC),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.bolt,
                                                      size: base * 0.055,
                                                      color: Color(0xFFEFB32C),
                                                    ),
                                                    Text(
                                                      'Active',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: 'M',
                                                        fontSize: base * 0.035,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: h * 0.022),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: h * 0.04,
                                                width: w * 0.24,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.black,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'See Details',
                                                    style: TextStyle(
                                                      fontFamily: 'B',
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: base * 0.035,
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
                            SizedBox(height: h *0.01),
                            Container(
                              height: h * 0.225,
                              decoration: BoxDecoration(
                                color: Color(0xFFFDF7EA),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Color(0xFFCDCDCD))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: h * 0.215,
                                    width: w * 0.02,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEFB32C),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(18),
                                        topLeft: Radius.circular(18),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: w * 0.03),

                                  /// 🔥 FIXED PART
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: w * 0.02,
                                        right: w * 0.02,
                                        top: h * 0.02,
                                      ),
                                      child: Column(
                                        children: [
                                          /// 🔹 First Row
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: base * 0.16,
                                                width: base * 0.16,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/images/home7.png',
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
                                                        fontSize: base * 0.045,
                                                        fontFamily: 'SB',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),

                                                    SizedBox(height: h * 0.005),

                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          color: Color(
                                                            0xFF959595,
                                                          ),
                                                          size: base * 0.045,
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.01,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            'Road123, colony Z',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  base * 0.035,
                                                              fontFamily: 'R',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: h * 0.02),

                                          /// 🔹 Second Row
                                          Row(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                  'assets/images/home5.png',
                                                ),
                                                height: base * 0.08,
                                                width: base * 0.08,
                                              ),

                                              SizedBox(width: w * 0.005),

                                              Text(
                                                '12 min ago',
                                                style: TextStyle(
                                                  fontSize: base * 0.03,
                                                  fontFamily: 'R',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),

                                              SizedBox(width: w * 0.03),

                                              Image(
                                                image: AssetImage(
                                                  'assets/images/home4.png',
                                                ),
                                                height: base * 0.055,
                                                width: base * 0.055,
                                              ),

                                              SizedBox(width: w * 0.01),

                                              Text(
                                                '50k + Applied',
                                                style: TextStyle(
                                                  fontSize: base * 0.03,
                                                  fontFamily: 'R',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                height: h * 0.04,
                                                width: w * 0.2,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFE2DDD3),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'InActive',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'M',
                                                      fontSize: base * 0.035,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: h * 0.022),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: h * 0.04,
                                                width: w * 0.25,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Color(0xFF959595)
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'See Details' ,
                                                    style: TextStyle(
                                                      fontFamily: 'B',
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: base * 0.035,
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
                            SizedBox(height: h * 0.09)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 🔹 TOP SECTION
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              children: [
                SizedBox(height: h * 0.07),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: base * 0.06,
                      backgroundImage: const AssetImage(
                        'assets/images/home1.png',
                      ),
                    ),
                    Container(
                      height: base * 0.135, // container ka size
                      width: base * 0.135,
                      decoration: BoxDecoration(
                        color: Colors.white, // background color
                        shape: BoxShape.circle, // circular shape
                        boxShadow: [ // optional: thodi shadow
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
                          color: Colors.black, // icon color
                        ),
                      ),
                    )

                  ],
                ),

                SizedBox(height: h * 0.04),

                Row(
                  children: [
                    Text(
                      "Find Your\nPerfect Help!",
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontSize: base * 0.07,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Image.asset("assets/images/home3.png", height: h * 0.09),
                  ],
                ),

                SizedBox(height: h * 0.035),

                /// Search Field
                Container(
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
                        fontSize: base * 0.04,
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
