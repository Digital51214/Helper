import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helper/bottom_screens/message_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    final avatarSize = (w < h ? w : h) * 0.11;

    return Scaffold(
      backgroundColor: Color(0xFFEDECEC),
      body: Padding(
        padding: EdgeInsets.only(top: h * 0.085),
        child: Column(
          children: [
            SizedBox(height: h * 0.010),

            Padding(
              padding: EdgeInsets.only(left: w * 0.04),
              child: Row(
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(
                      fontFamily: 'B',
                      fontWeight: FontWeight.w700,
                      fontSize: w * 0.07,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.04),

            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    top: h * 0.03,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(w * 0.05),
                          topRight: Radius.circular(w * 0.05),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: h * 0.06),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.04,
                              vertical: h * 0.02,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Recent chats',
                                  style: TextStyle(
                                    fontFamily: 'R',
                                    fontSize: w * 0.04,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: SlidableAutoCloseBehavior(
                              child: ListView(
                                padding: EdgeInsets.only(bottom: safeBottom + 8),
                                children: [

                                  buildSlidableChatTile(
                                    image: 'assets/images/charscreen1.png',
                                    name: 'Kaitlyn',
                                    message: 'Have a good one!',
                                    time: '3:02 PM',
                                    w: w,
                                    avatarSize: avatarSize,
                                    unread: 0,
                                    isRead: true,
                                  ),

                                  buildSlidableChatTile(
                                    image: 'assets/images/chatscreen3.png',
                                    name: 'Chloe',
                                    message:
                                    'Hello, Are you available for toni...',
                                    time: '3:02 PM',
                                    unread: 2,
                                    w: w,
                                    avatarSize: avatarSize,
                                    isRead: false,
                                  ),

                                  buildSlidableChatTile(
                                    image: 'assets/images/chatscreen4.png',
                                    name: 'Kaitlyn',
                                    message: 'Have a good one!',
                                    time: '3:02 PM',
                                    w: w,
                                    avatarSize: avatarSize,
                                    unread: 0,
                                    isRead: true,
                                  ),

                                  buildSlidableChatTile(
                                    image: 'assets/images/chatscreen5.png',
                                    name: 'Chloe',
                                    message:
                                    'Hello, Are you available for toni...',
                                    time: '3:02 PM',
                                    unread: 2,
                                    w: w,
                                    avatarSize: avatarSize,
                                    isRead: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: 0,
                    left: w * 0.04,
                    right: w * 0.04,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w * 0.08),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        cursorColor: const Color(0xFFA4A4A4),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: const Color(0xFFA4A4A4),
                            size: w * 0.06,
                          ),
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            fontFamily: 'R',
                            color: const Color(0xFFA4A4A4),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w * 0.08),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w * 0.08),
                            borderSide: BorderSide.none,
                          ),
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
    );
  }

  Widget buildSlidableChatTile({
    required String image,
    required String name,
    required String message,
    required String time,
    required double w,
    required double avatarSize,
    required bool isRead,
    int unread = 0,
  }) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.15,
        children: [
          CustomSlidableAction(
            onPressed: (_) {},
            child: Container(
              width: w * 0.11,
              height: w * 0.18,
              margin: EdgeInsets.all(w * 0.02),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE7E5),
                borderRadius: BorderRadius.circular(w * 0.08),
              ),
              child: Icon(
                Icons.delete,
                color: Colors.black,
                size: w * 0.06,
              ),
            ),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreen()));
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: w * 0.015,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(w * 0.05),
            color: Colors.white,
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: avatarSize / 2,
              child: ClipOval(
                child: Image.asset(
                  image,
                  width: avatarSize,
                  height: avatarSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              name,
              style: TextStyle(fontFamily: 'SB', fontSize: w * 0.04),
            ),

            /// ✅ YAHAN CHANGE KIYA GAYA HAI
            subtitle: Row(
              children: [
                if (isRead)
                  Padding(
                    padding: EdgeInsets.only(right: w * 0.015),
                    child: Image.asset(
                      'assets/images/chatscreen2.png',
                      width: w * 0.04,
                      height: w * 0.04,
                    ),
                  ),
                Expanded(
                  child: Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'R',
                      fontSize: w * 0.03,
                    ),
                  ),
                ),
              ],
            ),

            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(time, style: TextStyle(fontSize: w * 0.025)),
                if (unread > 0) ...[
                  SizedBox(height: w * 0.01),
                  CircleAvatar(
                    radius: w * 0.022,
                    backgroundColor: Color(0xFF2A8DA7),
                    child: Text(
                      unread.toString(),
                      style: TextStyle(
                        fontSize: w * 0.025,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}