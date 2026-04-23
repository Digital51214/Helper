import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/chat%20message%20service.dart';
import 'package:helper/Authontication_Services/send%20message%20service.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/Models/chat%20message%20model.dart';
import 'bottom_navigation_screen.dart';

class MessageScreen extends StatefulWidget {
  final int otherUserId;
  final String otherUserName;

  const MessageScreen({
    Key? key,
    required this.otherUserId,
    required this.otherUserName,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<ChatMessageModel> messages = [];

  bool isTyping = false;
  bool isPlaying = false;
  bool isLoading = true;
  bool isSending = false;

  int currentUserId = 1;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String? currentlyPlayingUrl;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _setupAudioListeners();
    _initializeMessages();
    _startAutoRefresh();
  }

  void _setupAudioListeners() {
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
          currentlyPlayingUrl = null;
        });
      }
    });
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadMessages(showLoader: false);
    });
  }

  Future<void> _initializeMessages() async {
    currentUserId = await SessionManager.getUserId();
    print('MessageScreen: currentUserId = $currentUserId');
    await _loadMessages();
  }

  Future<void> _loadMessages({bool showLoader = true}) async {
    try {
      if (showLoader && mounted) {
        setState(() => isLoading = true);
      }

      final data = await ChatMessagesService.getMessages(
        userId: currentUserId,
        otherUserId: widget.otherUserId,
      );

      if (mounted) {
        setState(() {
          messages = data;
          isLoading = false;
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      print('MessageScreen load error: $e');
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load messages: $e')),
        );
      }
    }
  }

  Future<void> _sendTextMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || isSending) return;

    try {
      setState(() => isSending = true);
      print('MessageScreen: sending text = $text');

      final response = await SendMessageService.sendTextMessage(
        senderId: currentUserId,
        receiverId: widget.otherUserId,
        message: text,
      );

      print('MessageScreen send text success = ${response.success}');

      if (response.success) {
        _controller.clear();
        setState(() {
          isTyping = false;
        });
        await _loadMessages(showLoader: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message send failed')),
        );
      }
    } catch (e) {
      print('MessageScreen send text error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isSending = false);
      }
    }
  }

  Future<void> _sendDummyAudioMessage() async {
    if (isSending) return;

    try {
      setState(() => isSending = true);

      // Yahan apne real recorder ka base64 lagana hai
      const dummyBase64Audio = 'BASE64_STRING_OF_AUDIO_HERE';

      print('MessageScreen: sending audio message');

      final response = await SendMessageService.sendAudioMessage(
        senderId: currentUserId,
        receiverId: widget.otherUserId,
        base64Audio: dummyBase64Audio,
        message: 'Voice Note',
      );

      print('MessageScreen send audio success = ${response.success}');

      if (response.success) {
        await _loadMessages(showLoader: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Audio send failed')),
        );
      }
    } catch (e) {
      print('MessageScreen send audio error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send audio: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isSending = false);
      }
    }
  }

  Future<void> _toggleAudio(String url) async {
    try {
      if (currentlyPlayingUrl == url && isPlaying) {
        await _audioPlayer.pause();
        if (mounted) {
          setState(() => isPlaying = false);
        }
      } else {
        print('Playing audio url = $url');
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(url));
        if (mounted) {
          setState(() {
            currentlyPlayingUrl = url;
            isPlaying = true;
          });
        }
      }
    } catch (e) {
      print('Audio play error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio play failed: $e')),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _controller.dispose();
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
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
                      widget.otherUserName,
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
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF2A8DA7),
                  ),
                )
                    : messages.isEmpty
                    ? const Center(
                  child: Text(
                    'No messages found',
                    style: TextStyle(
                      fontFamily: 'R',
                      color: Colors.black54,
                    ),
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: () => _loadMessages(showLoader: false),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.fromLTRB(
                      16 * wScale,
                      18 * hScale,
                      16 * wScale,
                      20 * hScale,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];

                      if (msg.type == 'audio') {
                        return _buildAudioMessage(
                          msg,
                          wScale,
                          hScale,
                          tScale,
                        );
                      }

                      return _buildTextMessage(
                        msg,
                        wScale,
                        hScale,
                        tScale,
                      );
                    },
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
                    onPressed: () {
                      print('Attachment button tapped');
                    },
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
                    height: 40 * scale,
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
                        hintText: 'Type message...',
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
                          child: Icon(
                            Icons.attach_file,
                            size: 18 * scale,
                            color: Colors.black54,
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
                GestureDetector(
                  onTap: isTyping ? _sendTextMessage : _sendDummyAudioMessage,
                  child: SizedBox(
                    width: 42 * scale,
                    height: 42 * scale,
                    child: isSending
                        ? const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF2A8DA7),
                        ),
                      ),
                    )
                        : Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isTyping)
                          Icon(
                            Icons.send,
                            color: const Color(0xFF2A8DA7),
                            size: 34 * tScale,
                          )
                        else
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextMessage(
      ChatMessageModel msg,
      double wScale,
      double hScale,
      double tScale,
      ) {
    final isMine = msg.isMine;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 14 * hScale),
        constraints: BoxConstraints(maxWidth: 230 * wScale),
        padding: EdgeInsets.fromLTRB(
          14 * wScale,
          12 * hScale,
          14 * wScale,
          10 * hScale,
        ),
        decoration: BoxDecoration(
          color: isMine
              ? Colors.black
              : const Color(0xFFEFB32C).withOpacity(0.10),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18 * tScale),
            topRight: Radius.circular(18 * tScale),
            bottomLeft: isMine ? Radius.circular(18 * tScale) : Radius.zero,
            bottomRight: isMine ? Radius.zero : Radius.circular(18 * tScale),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Align(
              alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                msg.message,
                style: TextStyle(
                  fontFamily: 'R',
                  fontSize: 12 * tScale,
                  color: isMine ? Colors.white : Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 8 * hScale),
            Text(
              msg.time,
              style: TextStyle(
                fontFamily: 'R',
                fontSize: 9 * tScale,
                color: isMine ? Colors.white70 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioMessage(
      ChatMessageModel msg,
      double wScale,
      double hScale,
      double tScale,
      ) {
    final isMine = msg.isMine;
    final isCurrent = currentlyPlayingUrl == msg.fileUrl && isPlaying;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 14 * hScale),
        constraints: BoxConstraints(maxWidth: 280 * wScale),
        padding: EdgeInsets.fromLTRB(
          12 * wScale,
          12 * hScale,
          12 * wScale,
          10 * hScale,
        ),
        decoration: BoxDecoration(
          color: isMine
              ? Colors.black
              : const Color(0xFFEFB32C).withOpacity(0.10),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18 * tScale),
            topRight: Radius.circular(18 * tScale),
            bottomLeft: isMine ? Radius.circular(18 * tScale) : Radius.zero,
            bottomRight: isMine ? Radius.zero : Radius.circular(18 * tScale),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 10 * wScale,
                vertical: 8 * hScale,
              ),
              decoration: BoxDecoration(
                color: isMine
                    ? const Color(0xFFBDB782)
                    : const Color(0xFFDDE3E7),
                borderRadius: BorderRadius.circular(8 * tScale),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: msg.fileUrl == null
                        ? null
                        : () => _toggleAudio(msg.fileUrl!),
                    child: Icon(
                      isCurrent ? Icons.pause : Icons.play_arrow,
                      color: const Color(0xFF2A8DA7),
                      size: 22 * tScale,
                    ),
                  ),
                  SizedBox(width: 10 * wScale),
                  Expanded(
                    child: Text(
                      msg.message.isEmpty ? 'Voice Note' : msg.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12 * tScale,
                        fontFamily: 'R',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8 * hScale),
            Text(
              msg.time,
              style: TextStyle(
                fontFamily: 'R',
                fontSize: 9 * tScale,
                color: isMine ? Colors.white70 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}