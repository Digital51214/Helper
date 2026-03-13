import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({
    super.key,
    required this.onPickImage,
  });

  final void Function(File pickedImage) onPickImage;

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? pickedImageFile;
  final ImagePicker _picker = ImagePicker();

  // Pick image from Camera or Gallery
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage == null) return;

    final imageFile = File(pickedImage.path);

    setState(() {
      pickedImageFile = imageFile;
    });

    widget.onPickImage(imageFile);
  }

  // Show dialog to choose image source
  void _showPickOptionsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt,color: Color(0xFF692226),),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,color: Color(0xFF692226),),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final wScale = size.width / 375; // base width
    final hScale = size.height / 812; // base height
    final tScale = (wScale + hScale) / 2;

    return Center(
      child: Stack(
        children: [
          // CircleAvatar
          GestureDetector(
            onTap: _showPickOptionsDialog,
            child: Container(
              padding: EdgeInsets.all(2 * wScale), // Border thickness
              decoration: const BoxDecoration(
                color: Color(0xFF2A8DA7), // Border color
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundImage: const AssetImage('assets/images/chatscreen4.png'),
                radius: 45 * wScale, // Responsive radius
                foregroundImage:
                pickedImageFile != null ? FileImage(pickedImageFile!) : null,
              ),
            ),
          ),

          // Camera icon overlay
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showPickOptionsDialog,
              child: Container(
                decoration: BoxDecoration(
                  color:Colors.black,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8 * wScale),
                child: Icon(
                  Icons.camera_alt,
                  size: 15 * tScale,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
