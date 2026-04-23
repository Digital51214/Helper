import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:helper/Authontication_Services/edit%20profile%20service.dart';
import 'package:helper/Authontication_Services/profile_service.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/Models/profile_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  bool _isProfileLoading = true;

  File? _selectedImageFile;
  String _networkImage = '';
  int _userId = 0;

  String _initialUsername = '';
  String _initialEmail = '';
  String _initialProfilePic = '';

  final ImagePicker _picker = ImagePicker();

  static const String _defaultProfileAsset = 'assets/images/defaultpic.png';

  @override
  void initState() {
    super.initState();
    _loadInitialProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialProfile() async {
    setState(() {
      _isProfileLoading = true;
    });

    try {
      final userId = await SessionManager.getUserId();
      final sessionUsername = await SessionManager.getUserName();
      final sessionEmail = await SessionManager.getUserEmail();
      final sessionProfilePic = await SessionManager.getProfilePic();

      _userId = userId;

      print('===== EDIT PROFILE INITIAL LOAD =====');
      print('SESSION USER ID: $_userId');
      print('SESSION USERNAME: $sessionUsername');
      print('SESSION EMAIL: $sessionEmail');
      print('SESSION PROFILE PIC: $sessionProfilePic');

      _initialUsername = sessionUsername;
      _initialEmail = sessionEmail;
      _initialProfilePic = SessionManager.normalizeProfilePic(sessionProfilePic);

      _usernameController.text = sessionUsername;
      _emailController.text = sessionEmail;
      _networkImage = SessionManager.normalizeProfilePic(sessionProfilePic);

      if (_userId != 0) {
        final result = await ProfileViewService.fetchProfile(userId: _userId);

        print('===== EDIT PROFILE PROFILE API RESULT =====');
        print(result);

        if (result['success'] == true && result['user'] != null) {
          final ProfileUserModel user = result['user'];

          _initialUsername = user.username;
          _initialEmail = user.email;
          _initialProfilePic = SessionManager.normalizeProfilePic(user.profilePic);

          _usernameController.text = user.username;
          _emailController.text = user.email;
          _networkImage = SessionManager.normalizeProfilePic(user.profilePic);

          await SessionManager.updateProfileData(
            username: user.username,
            email: user.email,
            profilePic: user.profilePic,
          );
        }
      }
    } catch (e) {
      print('===== EDIT PROFILE LOAD ERROR =====');
      print(e.toString());
    }

    if (!mounted) return;

    setState(() {
      _isProfileLoading = false;
    });
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedImage != null) {
        setState(() {
          _selectedImageFile = File(pickedImage.path);
        });

        print('===== IMAGE PICKED =====');
        print('SOURCE: ${source.name}');
        print('PATH: ${pickedImage.path}');
      }
    } catch (e) {
      print('===== IMAGE PICK ERROR =====');
      print(e.toString());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image'),
        ),
      );
    }
  }

  Future<void> _showImageSourceBottomSheet() async {
    final size = MediaQuery.of(context).size;
    final wScale = size.width / 375;
    final hScale = size.height / 812;
    final tScale = (wScale + hScale) / 2;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            20 * wScale,
            18 * hScale,
            20 * wScale,
            24 * hScale,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46 * wScale,
                  height: 5 * hScale,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                SizedBox(height: 18 * hScale),
                Text(
                  'Choose Profile Photo',
                  style: TextStyle(
                    fontSize: 18 * tScale,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'B',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 6 * hScale),
                Text(
                  'Select image source',
                  style: TextStyle(
                    fontSize: 12 * tScale,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'R',
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 22 * hScale),
                Row(
                  children: [
                    Expanded(
                      child: _bottomSheetOptionCard(
                        icon: Icons.camera_alt_rounded,
                        title: 'Camera',
                        subtitle: 'Take photo now',
                        onTap: () async {
                          Navigator.pop(bottomSheetContext);
                          await _pickImageFromSource(ImageSource.camera);
                        },
                        tScale: tScale,
                        hScale: hScale,
                        wScale: wScale,
                      ),
                    ),
                    SizedBox(width: 14 * wScale),
                    Expanded(
                      child: _bottomSheetOptionCard(
                        icon: Icons.photo_library_rounded,
                        title: 'Gallery',
                        subtitle: 'Choose from phone',
                        onTap: () async {
                          Navigator.pop(bottomSheetContext);
                          await _pickImageFromSource(ImageSource.gallery);
                        },
                        tScale: tScale,
                        hScale: hScale,
                        wScale: wScale,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bottomSheetOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required double tScale,
    required double hScale,
    required double wScale,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(
          vertical: 18 * hScale,
          horizontal: 14 * wScale,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBFC),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE1EEF2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 54 * hScale,
              width: 54 * hScale,
              decoration: const BoxDecoration(
                color: Color(0xFFE4F9FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2A8DA7),
                size: 26 * tScale,
              ),
            ),
            SizedBox(height: 12 * hScale),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'B',
                fontWeight: FontWeight.w700,
                fontSize: 14 * tScale,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4 * hScale),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'R',
                fontWeight: FontWeight.w500,
                fontSize: 11 * tScale,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _convertImageToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _updateProfile() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();

    print('===== UPDATE PROFILE BUTTON PRESSED =====');
    print('USER ID: $_userId');
    print('USERNAME: $username');
    print('EMAIL: $email');

    if (_userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User session not found. Please login again.'),
        ),
      );
      return;
    }

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username')),
      );
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email')),
      );
      return;
    }

    final bool isUsernameChanged = username != _initialUsername;
    final bool isEmailChanged = email != _initialEmail;
    final bool isImageChanged = _selectedImageFile != null;

    print('===== PROFILE CHANGE CHECK =====');
    print('USERNAME CHANGED: $isUsernameChanged');
    print('EMAIL CHANGED: $isEmailChanged');
    print('IMAGE CHANGED: $isImageChanged');

    if (!isUsernameChanged && !isEmailChanged && !isImageChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes found'),
        ),
      );
      return;
    }

    String? profilePicBase64;

    if (_selectedImageFile != null) {
      profilePicBase64 = await _convertImageToBase64(_selectedImageFile!);
      print('===== PROFILE PIC BASE64 READY =====');
      print('BASE64 LENGTH: ${profilePicBase64.length}');
    } else {
      print('===== NO NEW PROFILE IMAGE SELECTED =====');
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await EditProfileService.updateProfile(
        userId: _userId,
        username: username,
        email: email,
        profilePicBase64: profilePicBase64 ?? '',
      );

      print('===== UPDATE PROFILE FINAL RESULT =====');
      print(result);

      if (!mounted) return;

      if (result['success'] == true && result['user'] != null) {
        final ProfileUserModel user = result['user'];
        final normalizedPic = SessionManager.normalizeProfilePic(user.profilePic);

        await SessionManager.updateProfileData(
          username: user.username,
          email: user.email,
          profilePic: normalizedPic,
        );

        _initialUsername = user.username;
        _initialEmail = user.email;
        _initialProfilePic = normalizedPic;
        _networkImage = normalizedPic;
        _selectedImageFile = null;

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Profile Updated Successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      print('===== UPDATE PROFILE SCREEN ERROR =====');
      print(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildProfileImage(
      double size,
      double tScale,
      double hScale,
      double wScale,
      ) {
    Widget avatar;

    if (_selectedImageFile != null) {
      avatar = CircleAvatar(
        radius: size,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: FileImage(_selectedImageFile!),
      );
    } else if (_networkImage.isNotEmpty) {
      avatar = CircleAvatar(
        radius: size,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: NetworkImage(_networkImage),
        onBackgroundImageError: (_, __) {
          print('===== EDIT PROFILE IMAGE LOAD ERROR =====');
          print('FAILED URL: $_networkImage');
        },
      );
    } else {
      avatar = CircleAvatar(
        radius: size,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: const AssetImage(_defaultProfileAsset),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(4 * wScale),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE4F9FF),
              width: 3,
            ),
          ),
          child: avatar,
        ),
        Positioned(
          right: -2 * wScale,
          bottom: 2 * hScale,
          child: GestureDetector(
            onTap: _showImageSourceBottomSheet,
            child: Container(
              height: 34 * hScale,
              width: 34 * hScale,
              decoration: BoxDecoration(
                color: const Color(0xFF2A8DA7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 17 * tScale,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final wScale = size.width / 375;
    final hScale = size.height / 812;
    final tScale = (wScale + hScale) / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isProfileLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: EdgeInsets.all(10 * wScale),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50 * hScale),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE4F9FF),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
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
                    SizedBox(width: 30 * wScale),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontFamily: 'B',
                        fontWeight: FontWeight.w700,
                        fontSize: 18 * tScale,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30 * hScale),
              Column(
                children: [
                  _buildProfileImage(48 * tScale, tScale, hScale, wScale),
                  SizedBox(height: 12 * hScale),
                  Text(
                    'Change profile photo',
                    style: TextStyle(
                      fontFamily: 'R',
                      fontSize: 12 * tScale,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40 * hScale),
              SizedBox(
                height: size.height * 0.058,
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Enter username',
                    hintStyle: TextStyle(
                      fontFamily: 'SB',
                      fontSize: 12 * tScale,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30 * tScale),
                      borderSide: const BorderSide(
                        color: Color(0xFFCDCDCD),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30 * tScale),
                      borderSide: const BorderSide(
                        color: Color(0xFF2A8DA7),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16 * hScale,
                      horizontal: 20 * wScale,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                height: size.height * 0.058,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Example@mail.com',
                    hintStyle: TextStyle(
                      fontFamily: 'SB',
                      fontSize: 12 * tScale,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30 * tScale),
                      borderSide: const BorderSide(
                        color: Color(0xFFCDCDCD),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30 * tScale),
                      borderSide: const BorderSide(
                        color: Color(0xFF2A8DA7),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16 * hScale,
                      horizontal: 20 * wScale,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              GestureDetector(
                onTap: _isLoading ? null : _updateProfile,
                child: Container(
                  height: size.height * 0.058,
                  width: 373 * wScale,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      width: 2,
                      color: Colors.white.withOpacity(0.158),
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: _isLoading
                        ? SizedBox(
                      height: 20 * hScale,
                      width: 20 * hScale,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                        : Text(
                      'Update',
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontSize: 14 * tScale,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}