import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'bottom_navigation_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ScrollController _scrollController = ScrollController();

  bool isTyping = false;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) {
        setState(() => duration = d);
      }
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) {
        setState(() => position = p);
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = false;
          position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> toggleAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      if (mounted) {
        setState(() => isPlaying = false);
      }
    } else {
      await _audioPlayer.play(AssetSource('audio/record.mp3'));
      if (mounted) {
        setState(() => isPlaying = true);
      }
    }
  }

  String formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final wScale = w / 375;
    final hScale = h / 812;
    final tScale = ((wScale + hScale) / 2).clamp(0.85, 1.0);
    final scale = (w / 390).clamp(0.80, 1.0);

    double rs(num v) => (v * scale).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * wScale,
                vertical: 12 * hScale,
              ),
              child: Row(
                children: [
                  Container(
                    height: 52 * scale,
                    width: 52 * scale,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE4F9FF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const BottomNavigationScreen(currentIndex: 1),
                          ),
                              (Route<dynamic> route) => false,
                        );
                      },
                      icon: Padding(
                        padding: EdgeInsets.only(left: 3 * wScale),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20 * tScale,
                          color: const Color(0xFF2A8DA7),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14 * wScale),
                  Expanded(
                    child: Text(
                      'Chloe',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'B',
                        fontSize: 22 * tScale,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 10 * wScale),
                  Container(
                    height: 52 * scale,
                    width: 52 * scale,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone, color: Colors.white),
                  ),
                  SizedBox(width: 10 * wScale),
                  Container(
                    height: 52 * scale,
                    width: 52 * scale,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE4F9FF),
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

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.fromLTRB(
                      16 * wScale,
                      18 * hScale,
                      16 * wScale,
                      20 * hScale,
                    ),
                    child: Column(
                      children: [
                        _buildReplyCard(wScale, hScale, tScale),
                        SizedBox(height: 18 * hScale),
                        _buildMyTextMessage(wScale, hScale, tScale),
                        SizedBox(height: 18 * hScale),
                        _buildMyAudioMessage(wScale, hScale, tScale, rs),
                        SizedBox(height: 18 * hScale),
                        _buildOtherTextMessage(wScale, hScale, tScale),
                        SizedBox(height: 20 * hScale),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          top: false,
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.fromLTRB(
              10 * wScale,
              12 * hScale,
              10 * wScale,
              16 * hScale,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 38 * scale,
                  child: IconButton(
                    onPressed: () {},
                    splashRadius: 20,
                    icon: Icon(
                      Icons.add,
                      color: const Color(0xFF2A8DA7),
                      size: 30 * tScale,
                    ),
                  ),
                ),
                SizedBox(width: 10 * wScale),
                Expanded(
                  child: SizedBox(
                    height: 40*scale,
                    child: TextFormField(
                      controller: _controller,
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            isTyping = value.trim().isNotEmpty;
                          });
                        }
                      },
                      style: TextStyle(
                        fontSize: 12 * tScale,
                        color: Colors.black,
                        fontFamily: 'R',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          fontSize: 12 * tScale,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'R',
                          color: Colors.black54,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16 * wScale,
                          vertical: 2 * hScale,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Image.asset(
                            'assets/images/attachments.png',
                            height: 18 * scale,
                            width: 18 * scale,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10 * wScale),
                SizedBox(
                  width: 42 * scale,
                  height: 42 * scale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.send,
                        color: const Color(0xFF2A8DA7),
                        size: 34 * tScale,
                      ),
                      if (!isTyping)
                        Container(
                          height: 42 * scale,
                          width: 42 * scale,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2A8DA7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.mic,
                            color: Colors.white,
                            size: 24 * tScale,
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
    );
  }

  Widget _buildReplyCard(double wScale, double hScale, double tScale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12 * wScale),
      decoration: BoxDecoration(
        color: const Color(0xFFEFB32C).withOpacity(0.10),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18 * tScale),
          topRight: Radius.circular(18 * tScale),
          bottomRight: Radius.circular(18 * tScale),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFDDE3E7),
              borderRadius: BorderRadius.circular(10 * tScale),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 5,
                  height: 70 * hScale,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A8DA7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10 * tScale),
                      bottomLeft: Radius.circular(10 * tScale),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12 * wScale,
                      vertical: 14 * hScale,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You',
                          style: TextStyle(
                            fontSize: 11 * tScale,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2A8DA7),
                          ),
                        ),
                        SizedBox(height: 8 * hScale),
                        Text(
                          'Can I come over?',
                          style: TextStyle(
                            fontFamily: 'R',
                            fontSize: 11 * tScale,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12 * hScale),
          Text(
            "Of course, let me know if you’re on your way",
            style: TextStyle(
              fontFamily: 'R',
              fontSize: 11.5 * tScale,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 11 * hScale),
          Text(
            "16:06",
            style: TextStyle(
              fontFamily: 'R',
              fontSize: 9 * tScale,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyTextMessage(double wScale, double hScale, double tScale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 190 * wScale),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              14 * wScale,
              12 * hScale,
              14 * wScale,
              10 * hScale,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18 * tScale),
                topRight: Radius.circular(18 * tScale),
                bottomLeft: Radius.circular(18 * tScale),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'K, I am on my way',
                  style: TextStyle(
                    fontFamily: 'R',
                    fontSize: 12 * tScale,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 18 * hScale),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '16.50',
                    style: TextStyle(
                      fontFamily: 'R',
                      fontSize: 9 * tScale,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyAudioMessage(
      double wScale,
      double hScale,
      double tScale,
      double Function(num) rs,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 290 * wScale),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              12 * wScale,
              12 * hScale,
              12 * wScale,
              10 * hScale,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18 * tScale),
                topRight: Radius.circular(18 * tScale),
                bottomLeft: Radius.circular(18 * tScale),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10 * wScale,
                    vertical: 8 * hScale,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBDB782),
                    borderRadius: BorderRadius.circular(8 * tScale),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleAudio,
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: const Color(0xFF2A8DA7),
                          size: 22 * tScale,
                        ),
                      ),
                      SizedBox(width: rs(8)),
                      Text(
                        duration == Duration.zero
                            ? '0:20'
                            : formatTime(position),
                        style: TextStyle(
                          color: const Color(0xFF2A8DA7),
                          fontSize: 12 * tScale,
                          fontFamily: 'R',
                        ),
                      ),
                      SizedBox(width: rs(14)),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(20, (index) {
                            final randomHeight =
                            (Random(index).nextInt(18) + 10).toDouble();

                            final activeBars = duration.inSeconds > 0
                                ? ((position.inSeconds /
                                duration.inSeconds.clamp(1, 9999)) *
                                20)
                                .floor()
                                .clamp(0, 20)
                                : 0;

                            final isActive = index < activeBars;

                            return Container(
                              width: 2.6,
                              height: randomHeight,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF2A8DA7)
                                    : const Color(0xFF2A8DA7).withOpacity(0.45),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10 * hScale),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '09.13',
                    style: TextStyle(
                      fontFamily: 'R',
                      fontSize: 9 * tScale,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherTextMessage(double wScale, double hScale, double tScale) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 230 * wScale),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              14 * wScale,
              14 * hScale,
              14 * wScale,
              12 * hScale,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFEFB32C).withOpacity(0.10),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18 * tScale),
                topRight: Radius.circular(18 * tScale),
                bottomRight: Radius.circular(18 * tScale),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning, did you sleep well?',
                  style: TextStyle(
                    fontFamily: 'R',
                    fontSize: 10 * tScale,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12 * hScale),
                Text(
                  '09:05',
                  style: TextStyle(
                    fontFamily: 'R',
                    fontSize: 9 * tScale,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}