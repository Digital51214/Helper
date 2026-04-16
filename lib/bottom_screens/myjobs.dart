import 'package:flutter/material.dart';
import 'package:helper/bottom_screens/postjob_screen.dart';

class Myjobs extends StatefulWidget {
  const Myjobs({super.key});

  @override
  State<Myjobs> createState() => _MyjobsState();
}

class _MyjobsState extends State<Myjobs> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    return Scaffold(
      backgroundColor: const Color(0xFF0FFEDECEC),
      body: Column(
        children: [
          SizedBox(height: h * 0.08),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Text(
                'My Jobs',
                style: TextStyle(
                  fontFamily: 'B',
                  fontWeight: FontWeight.w700,
                  fontSize: base * 0.065,
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.04),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    // 🔹 First Job Card
                    Container(
                      height: h*0.225,
                      decoration: BoxDecoration(
                          color: Color(0xFFEAF4F6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFFCDCDCD))
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: h*0.215,
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
                                        height: base * 0.15,
                                        width: base * 0.15,
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
                                                fontSize: base * 0.038,
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
                                                      base * 0.028,
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

                                  SizedBox(height: h * 0.018),

                                  /// 🔹 Second Row
                                  Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
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
                                        image: AssetImage(
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
                                      Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFD7EBDC),
                                          borderRadius:
                                          BorderRadius.circular(7),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical:w * 0.01,horizontal: w*0.03),
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          color: Colors.black,
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: w*0.02,horizontal: w*0.03),
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
                    SizedBox(height: h *0.01),
                    Container(
                      height: h*0.225,
                      decoration: BoxDecoration(
                          color: Color(0xFFFDF7EA),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFFCDCDCD))
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: h*0.215,
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
                                        height: base * 0.15,
                                        width: base * 0.15,
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
                                                fontSize: base * 0.038,
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
                                                      base * 0.028,
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

                                  SizedBox(height: h * 0.018),

                                  /// 🔹 Second Row
                                  Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
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
                                        image: AssetImage(
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
                                      Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE2DDD3),
                                          borderRadius:
                                          BorderRadius.circular(7),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical:w * 0.01,horizontal: w*0.03),
                                        child: Center(
                                          child: Text(
                                            'InActive',
                                            style: TextStyle(
                                              fontWeight:
                                              FontWeight.w500,
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          color: Color(0xFF959595),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: w*0.02,horizontal: w*0.03),
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
                    // 👇 Responsive Add New Job Button

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
