import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helper/Authontication_Services/chat%20list%20service.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/Models/chat%20list%20model.dart';
import 'package:helper/bottom_screens/message_screen.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<ChatListModel> allChats = [];
  List<ChatListModel> filteredChats = [];

  bool isLoading = true;
  int currentUserId = 1;

  @override
  void initState() {
    super.initState();
    _initializeChatList();
  }

  Future<void> _initializeChatList() async {
    try {
      setState(() => isLoading = true);

      currentUserId = await SessionManager.getUserId();
      print('ChatScreen: currentUserId = $currentUserId');

      final chats =
      await ChatListService.getChatList(userId: currentUserId);

      if (mounted) {
        setState(() {
          allChats = chats;
          filteredChats = chats;
          isLoading = false;
        });
      }
    } catch (e) {
      print('ChatScreen Error: $e');
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load chats: $e')),
        );
      }
    }
  }

  void _filterChats(String value) {
    print('Search: $value');

    setState(() {
      filteredChats = allChats.where((chat) {
        final name = chat.username.toLowerCase();
        final msg = chat.lastMessage.toLowerCase();
        final query = value.toLowerCase();

        return name.contains(query) || msg.contains(query);
      }).toList();
    });
  }

  String _getMessagePrefix(String message) {
    if (message.toLowerCase().contains('audio')) {
      return 'Audio message';
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    final avatarSize = (w < h ? w : h) * 0.11;

    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      body: Padding(
        padding: EdgeInsets.only(top: h * 0.085),
        child: Column(
          children: [
            SizedBox(height: h * 0.01),

            /// Title
            Padding(
              padding: EdgeInsets.only(left: w * 0.04),
              child: Row(
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(
                      fontFamily: 'B',
                      fontWeight: FontWeight.w700,
                      fontSize: w * 0.06,
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
                  /// Main Container
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
                          SizedBox(height: h * 0.04),

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

                          /// CHAT LIST
                          Expanded(
                            child: isLoading
                                ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2A8DA7),
                              ),
                            )
                                : filteredChats.isEmpty
                                ? ListView(
                              children: const [
                                SizedBox(height: 120),
                                Center(
                                  child: Text('No chats found'),
                                ),
                              ],
                            )
                                : RefreshIndicator(
                              onRefresh: _initializeChatList,
                              child: SlidableAutoCloseBehavior(
                                child: ListView.builder(
                                  padding: EdgeInsets.only(
                                      bottom: safeBottom + 8),
                                  itemCount:
                                  filteredChats.length,
                                  itemBuilder: (context, index) {
                                    final chat =
                                    filteredChats[index];

                                    return _chatTile(
                                      image: chat.profilePic,
                                      name: chat.username,
                                      message: _getMessagePrefix(
                                          chat.lastMessage),
                                      time: chat.time,
                                      unread:
                                      chat.unreadCount,
                                      isRead:
                                      chat.unreadCount == 0,
                                      userId: chat.userId,
                                      w: w,
                                      avatarSize: avatarSize,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Search
                  Positioned(
                    top: 0,
                    left: w * 0.04,
                    right: w * 0.04,
                    child: Container(
                      height: h * 0.058,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(w * 0.08),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: _filterChats,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: const Color(0xFFA4A4A4),
                            size: w * 0.06,
                          ),
                          hintText: 'Search',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(w * 0.08),
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

  Widget _chatTile({
    required String? image,
    required String name,
    required String message,
    required String time,
    required int unread,
    required bool isRead,
    required int userId,
    required double w,
    required double avatarSize,
  }) {
    return Slidable(
      key: ValueKey(userId),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.15,
        children: [
          CustomSlidableAction(
            onPressed: (_) {
              print('Delete tapped for $userId');
            },
            child: Container(
              margin: EdgeInsets.all(w * 0.02),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE7E5),
                borderRadius:
                BorderRadius.circular(w * 0.08),
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
          print('Open chat with userId = $userId');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageScreen(
                otherUserId: userId,
                otherUserName: name,
              ),
            ),
          ).then((_) => _initializeChatList());
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: w * 0.01,
          ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(w * 0.05),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: const Color(0xFFE4F9FF),
              backgroundImage: image != null && image.isNotEmpty
                  ? NetworkImage(image)
                  : null,
              child: (image == null || image.isEmpty)
                  ? Text(
                name.isNotEmpty
                    ? name[0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  color: const Color(0xFF2A8DA7),
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.045,
                ),
              )
                  : null,
            ),
            title: Text(
              name,
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: w * 0.04,
              ),
            ),
            subtitle: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(time),
                if (unread > 0)
                  CircleAvatar(
                    radius: w * 0.022,
                    backgroundColor:
                    const Color(0xFF2A8DA7),
                    child: Text(
                      unread.toString(),
                      style: TextStyle(
                        fontSize: w * 0.025,
                        color: Colors.white,
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
}