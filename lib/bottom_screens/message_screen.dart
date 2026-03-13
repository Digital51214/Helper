import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'bottom_navigation_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreen();
}

class _MessageScreen extends State<MessageScreen> {
  late final size = MediaQuery.of(context).size;
  late final w = size.width;
  late final h = size.height;
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => position = p);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  Future<void> toggleAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource('audio/record.mp3'));
    }
    setState(() => isPlaying = !isPlaying);
  }

  String formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final wScale = size.width / 375;
    final hScale = size.height / 812;
    final tScale = (wScale + hScale) / 2;
    final w = MediaQuery.of(context).size.width;

    // ✅ Responsive scale (NO INCREASE)
    final scale = (w / 390).clamp(0.75, 1.0);
    double rs(num v) => (v * scale).toDouble();

    return Scaffold(
      backgroundColor: Color(0xFFEDECEC),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.only(top: 15 * wScale),
        child: Stack(
          children: [
            /// 🔹 HEADER
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10 * wScale,
                    vertical: 40 * hScale,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4F9FF),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BottomNavigationScreen(currentIndex: 1),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          icon: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 18 * tScale,
                            ),
                          ),
                          color: const Color(0xFF2A8DA7),
                        ),
                      ),
                      SizedBox(width: 10 * wScale),
                      Text(
                        'Chloe',
                        style: TextStyle(
                          fontFamily: 'B',
                          fontSize: 20 * tScale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 48 * hScale,
                        width: 48 * wScale,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.phone, color: Colors.white),
                      ),
                      SizedBox(width: 3 * wScale),
                      Container(
                        height: 48 * hScale,
                        width: 48 * wScale,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4F9FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.more_horiz,
                          color: Color(0xFF2A8DA7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// 🔹 MESSAGES AREA
            Positioned(
              top: 110 * hScale,
              // Adjust this value to move the container up or down
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 8 * wScale,
                          right: 8 * wScale,
                          top: 8 * wScale,
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 108 * hScale,
                                  width: 257 * wScale,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15 * tScale),
                                      topRight: Radius.circular(15 * tScale),
                                      bottomRight: Radius.circular(15 * tScale),
                                    ),
                                    color: Color(
                                      0xFFEFB32C1A,
                                    ).withOpacity(0.09),
                                  ),
                                  padding: EdgeInsets.only(
                                    left: 10 * wScale,
                                    top: 70 * hScale,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Of course, let me know if you're on your way",
                                            style: TextStyle(
                                              fontFamily: 'R',
                                              fontSize: 10 * tScale,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "16:06",
                                            style: TextStyle(
                                              fontFamily: 'R',
                                              fontSize: 8 * tScale,
                                              color: Colors.black26,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(10 * wScale),
                              child: Container(
                                height: 60 * hScale,
                                width: 237 * wScale,
                                decoration: BoxDecoration(
                                  color: Color(0xFF2A8DA7).withOpacity(0.09),
                                  borderRadius: BorderRadius.circular(
                                    7 * tScale,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5 * wScale,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2A8DA7),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10 * tScale),
                                          bottomLeft: Radius.circular(
                                            10 * tScale,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(8 * wScale),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'You',
                                                  style: TextStyle(
                                                    fontSize: 10 * tScale,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF2A8DA7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5 * hScale),
                                            Row(
                                              children: [
                                                Text(
                                                  'Can I come over?',
                                                  style: TextStyle(
                                                    fontFamily: 'R',
                                                    fontSize: 10 * tScale,
                                                    fontWeight: FontWeight.w600,
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
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10 * hScale),

                      Padding(
                        padding: EdgeInsets.all(8 * wScale),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 64 * hScale,
                              width: 111 * wScale,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15 * tScale),
                                  topRight: Radius.circular(15 * tScale),
                                  bottomLeft: Radius.circular(15 * tScale),
                                ),
                              ),
                              padding: EdgeInsets.only(
                                left: 13 * wScale,
                                top: 10 * hScale,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'K, I am on my way',
                                    style: TextStyle(
                                      fontFamily: 'R',
                                      fontSize: 10 * tScale,
                                      color: Colors.white,
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 15 * hScale,
                                      left: 72 * wScale,
                                    ),
                                    child: Text(
                                      '16.50',
                                      style: TextStyle(
                                        fontFamily: 'R',
                                        fontSize: 8 * tScale,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2 * hScale),

                      Padding(
                        padding: EdgeInsets.all(8 * wScale),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 77 * hScale,
                              width: 159 * wScale,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15 * tScale),
                                  topRight: Radius.circular(15 * tScale),
                                  bottomLeft: Radius.circular(15 * tScale),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top:
                                          MediaQuery.of(context).size.height *
                                          0.01,
                                      left:
                                          MediaQuery.of(context).size.width *
                                          0.02,
                                      right:
                                          MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: rs(38),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFBDB782),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: rs(2)),
                                          GestureDetector(
                                            onTap: toggleAudio,
                                            child: Icon(
                                              isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              color: Color(0xFF2A8DA7),
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(width: rs(5)),
                                          Text(
                                            formatTime(position),
                                            style: const TextStyle(
                                              color: Color(0xFF2A8DA7),
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(width: rs(15)),

                                          /// Waveform
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(20, (
                                                index,
                                              ) {
                                                final randomHeight =
                                                    Random(index).nextInt(30) +
                                                    10;

                                                final isActive =
                                                    duration.inSeconds > 0 &&
                                                    index <
                                                        (position.inSeconds /
                                                                duration
                                                                    .inSeconds *
                                                                20)
                                                            .floor();

                                                return Container(
                                                  width: 2.5,
                                                  height: randomHeight
                                                      .toDouble(),
                                                  decoration: BoxDecoration(
                                                    color: isActive
                                                        ? Color(0xFF2A8DA7)
                                                        : Color(
                                                            0xFF2A8DA7,
                                                          ).withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          2,
                                                        ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                          SizedBox(width: rs(2)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: 8 * wScale,
                                      ),
                                      child: Text(
                                        '09.13',
                                        style: TextStyle(
                                          fontFamily: 'R',
                                          fontSize: 8 * tScale,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8 * hScale),

                      Padding(
                        padding: EdgeInsets.only(
                          left: 15 * wScale,
                          right: 8 * wScale,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 60 * hScale,
                              width: 200 * wScale,
                              decoration: BoxDecoration(
                                color: Color(0xFFEFB32C1A).withOpacity(0.09),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15 * tScale),
                                  topRight: Radius.circular(15 * tScale),
                                  bottomRight: Radius.circular(15 * tScale),
                                ),
                              ),
                              // Container ka color set kar diya hai
                              child: SizedBox(
                                width: 191 * wScale,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 10 * wScale,
                                    top: 10 * hScale,
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Good morning, did you sleep well?',
                                            style: TextStyle(
                                              fontFamily: 'R',
                                              fontSize: 10 * tScale,
                                            ),
                                          ),
                                          SizedBox(height: 5 * hScale),
                                          Text(
                                            '09:05',
                                            style: TextStyle(
                                              fontFamily: 'R',
                                              fontSize: 8 * tScale,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Container(
            height: 90 * hScale,
            padding: EdgeInsets.symmetric(horizontal: 8 * wScale),
            decoration: BoxDecoration(color: Colors.black),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add,
                    color: Color(0xFF2A8DA7),
                    size: 24 * tScale,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        isTyping = value.trim().isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'B',
                        color: Colors.black,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image(
                          image: AssetImage('assets/images/attachments.png'),
                          height: h * 0.02,
                        ),
                      ),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10 * wScale),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.send,
                      color: Color(0xFF2A8DA7),
                      size: 36 * tScale,
                    ),
                    if (!isTyping)
                      Container(
                        height: 45 * hScale,
                        width: 45 * wScale,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A8DA7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 26 * tScale,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
