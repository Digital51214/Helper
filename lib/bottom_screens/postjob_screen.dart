import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/jobs_apis%20service.dart';
import 'package:helper/Authontication_Services/session%20manager%20for%20post%20jobs.dart';
import 'package:helper/bottom_screens/bottom_navigation_screen.dart';
import 'package:image_picker/image_picker.dart';

class PostjobScreen extends StatefulWidget {
  const PostjobScreen({super.key});

  @override
  State<PostjobScreen> createState() => _PostjobScreenState();
}

class _PostjobScreenState extends State<PostjobScreen> {
  final PageController _controller = PageController();

  int currentPage = 0;
  bool isLoading = false;

  String selectedCategory = "Cleaning";

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController scheduleController = TextEditingController();
  final TextEditingController locationController =
  TextEditingController(text: "Multan Cantt");

  List<File> selectedImages = [];

  @override
  void dispose() {
    _controller.dispose();
    titleController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    scheduleController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage < 3) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> submitJob() async {
    if (isLoading) return;
    if (titleController.text.trim().isEmpty) {
      showMsg("Please enter job title");
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      showMsg("Please enter description");
      return;
    }

    if (amountController.text.trim().isEmpty) {
      showMsg("Please enter amount");
      return;
    }

    if (scheduleController.text.trim().isEmpty) {
      showMsg("Please select schedule");
      return;
    }

    setState(() => isLoading = true);

    try {
      final clientId = await SessionManager4.getClientId();

      if (clientId == null || clientId == 0) {
        showMsg("User session not found. Please login again.");
        return;
      }
      String imageBase64 = "";

      if (selectedImages.isNotEmpty) {
        final bytes = await selectedImages.first.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }
      print("========== POST JOB START ==========");
      print("client_id: $clientId");
      print("category: $selectedCategory");
      print("title: ${titleController.text.trim()}");
      print("description: ${descriptionController.text.trim()}");
      print("amount: ${amountController.text.trim()}");
      print("schedule: ${scheduleController.text.trim()}");
      print("location: ${locationController.text.trim()}");
      print("image selected: ${selectedImages.isNotEmpty}");

      final response = await JobService.createJob(
        clientId: clientId,
        category: selectedCategory,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imageBase64: imageBase64,
        amount: int.parse(amountController.text.trim()),
        schedule: scheduleController.text.trim(),
        location: locationController.text.trim().isEmpty
            ? "Multan Cantt"
            : locationController.text.trim(),
      );
      print("POST JOB FINAL RESPONSE: $response");
      print("========== POST JOB END ==========");

      if (response["success"] == true) {
        showMsg(response["message"] ?? "Job Posted successfully!");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BottomNavigationScreen(currentIndex: 3),
          ),
        );
      } else {
        showMsg(response["message"] ?? "Something went wrong");
      }
    } catch (e) {
      print("POST JOB ERROR: $e");
      showMsg("Error: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          left: w * 0.05,
          right: w * 0.05,
          top: h * 0.035,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: isLoading
                    ? null
                    : () {
                  if (currentPage > 0) {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BottomNavigationScreen(currentIndex: 0),
                      ),
                    );
                  }
                },
                child: Container(
                  height: h * 0.13,
                  width: w * 0.13,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE4F9FF),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: w * 0.025),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Color(0xFF2A8DA7),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "Step ${currentPage + 1} of 4",
                  style: TextStyle(
                    fontFamily: 'R',
                    color: const Color(0xFF747474),
                    fontWeight: FontWeight.w400,
                    fontSize: w * 0.045,
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.015),
            Row(
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: w * 0.012),
                  height: h * 0.005,
                  width: w * 0.201,
                  decoration: BoxDecoration(
                    color: index <= currentPage
                        ? const Color(0xFF2A8DA7)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
            SizedBox(height: h * 0.03),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  StepOnePage(
                    selectedCategory: selectedCategory,
                    onCategorySelected: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  StepTwoPage(
                    titleController: titleController,
                    descriptionController: descriptionController,
                    selectedImages: selectedImages,
                    onImagesChanged: (images) {
                      setState(() {
                        selectedImages = images;
                      });
                    },
                  ),
                  StepThreePage(
                    amountController: amountController,
                    scheduleController: scheduleController,
                  ),
                  StepFourPage(
                    locationController: locationController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Padding(
            padding: EdgeInsets.only(bottom: h * 0.035),
            child: GestureDetector(
              onTap: isLoading
                  ? null
                  : () {
                if (currentPage < 3) {
                  nextPage();
                } else {
                  submitJob();
                }
              },
              child: Container(
                height: h * 0.072,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                    : Text(
                  currentPage == 3 ? "Continue" : "Next",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SB',
                    color: Colors.white,
                    fontSize: base * 0.045,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StepOnePage extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const StepOnePage({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    Widget buildOption(
        String label,
        String status,
        Color color,
        Widget icon,
        ) {
      final bool isSelected = selectedCategory == label;

      return GestureDetector(
        onTap: () => onCategorySelected(label),
        child: Container(
          height: h * 0.155,
          width: w * 0.435,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2A8DA7).withOpacity(0.09)
                : Colors.white,
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2A8DA7)
                  : const Color(0xFFCDCDCD),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: w * 0.03, top: h * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: base * 0.13,
                  width: base * 0.13,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.09),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: icon,
                ),
                SizedBox(height: h * 0.008),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'M',
                    color: Colors.black,
                  ),
                ),
                Text(
                  isSelected ? "Selected" : status,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'M',
                    fontSize: base * 0.03,
                    color: const Color(0xFF2A8DA7),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What do you\nneed help with?',
              style: TextStyle(
                fontSize: w * 0.06,
                fontFamily: 'B',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: h * 0.01),
            Text(
              'Select a category that best describes\nyour task?',
              style: TextStyle(
                fontSize: base * 0.038,
                fontFamily: 'L',
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: h * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildOption(
                  'Cleaning',
                  'Available',
                  Colors.black,
                  Image.asset(
                    'assets/images/step1.png',
                    height: base * 0.08,
                    width: base * 0.08,
                  ),
                ),
                SizedBox(width: w * 0.03),
                buildOption(
                  'Delivery',
                  'Available',
                  const Color(0xFFEFB32C),
                  Image.asset(
                    'assets/images/step2.png',
                    height: base * 0.08,
                    width: base * 0.08,
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildOption(
                  'Repair',
                  'Available',
                  const Color(0xFFB11B1C),
                  Image.asset(
                    'assets/images/step3.png',
                    height: base * 0.08,
                    width: base * 0.08,
                  ),
                ),
                SizedBox(width: w * 0.03),
                buildOption(
                  'Other',
                  'Available',
                  const Color(0xFF2A8DA7),
                  const Icon(
                    Icons.more_horiz,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StepTwoPage extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final List<File> selectedImages;
  final Function(List<File>) onImagesChanged;

  const StepTwoPage({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedImages,
    required this.onImagesChanged,
  });

  @override
  State<StepTwoPage> createState() => _StepTwoPageState();
}

class _StepTwoPageState extends State<StepTwoPage> {
  Future<void> pickImage() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      final updatedImages = [
        ...widget.selectedImages,
        ...pickedFiles.map((e) => File(e.path)),
      ];

      widget.onImagesChanged(updatedImages);
    }
  }

  void openImageDialog(File image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: FileImage(image),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void removeImage(int index) {
    final updatedImages = [...widget.selectedImages];
    updatedImages.removeAt(index);
    widget.onImagesChanged(updatedImages);
  }

  @override
  Widget build(BuildContext context) {
    final selectedImages = widget.selectedImages;

    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Details',
            style: TextStyle(
              fontSize: w * 0.06,
              fontFamily: 'B',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: h * 0.01),
          Text(
            'Enter all the required details',
            style: TextStyle(
              fontSize: base * 0.046,
              fontFamily: 'L',
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: h * 0.03),
          SizedBox(
            height: h * 0.058,
            child: TextFormField(
              controller: widget.titleController,
              cursorColor: const Color(0xFFA4A4A4),
              style: TextStyle(
                fontFamily: 'R',
                fontSize: base * 0.034,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Job Title...',
                hintStyle: TextStyle(
                  fontSize: base * 0.034,
                  color: const Color(0xFFA4A4A4),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'R',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFA4A4A4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFF2A8DA7)),
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.014),
          SizedBox(
            height: h * 0.15,
            child: TextFormField(
              controller: widget.descriptionController,
              cursorColor: const Color(0xFFA4A4A4),
              maxLines: 4,
              style: TextStyle(
                fontFamily: 'R',
                fontSize: base * 0.034,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Description...',
                hintStyle: TextStyle(
                  fontSize: base * 0.034,
                  color: const Color(0xFFA4A4A4),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'R',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFA4A4A4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFF2A8DA7)),
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.02),
          Text(
            'Add Photos',
            style: TextStyle(
              fontSize: base * 0.035,
              fontFamily: 'M',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: h * 0.017),
          GestureDetector(
            onTap: pickImage,
            child: SizedBox(
              height: h * 0.15,
              width: double.infinity,
              child: CustomPaint(
                painter: DottedBorderPainter(),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: selectedImages.isEmpty
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/step5.png',
                          height: h * 0.05,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Upload Photos",
                          style: TextStyle(
                            fontFamily: 'M',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF013E89),
                          ),
                        ),
                      ],
                    )
                        : GridView.builder(
                      padding: const EdgeInsets.all(6),
                      itemCount: selectedImages.length + 1,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        if (index == selectedImages.length) {
                          return GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          );
                        }

                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                openImageDialog(selectedImages[index]);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  selectedImages[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: GestureDetector(
                                onTap: () => removeImage(index),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.03),
        ],
      ),
    );
  }
}

class StepThreePage extends StatefulWidget {
  final TextEditingController amountController;
  final TextEditingController scheduleController;

  const StepThreePage({
    super.key,
    required this.amountController,
    required this.scheduleController,
  });

  @override
  State<StepThreePage> createState() => _StepThreePageState();
}

class _StepThreePageState extends State<StepThreePage> {
  String selectedPriceType = "Fixed Price";

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Schedule',
            style: TextStyle(
              fontSize: w * 0.06,
              fontFamily: 'B',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: h * 0.01),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Provide the details',
            style: TextStyle(
              fontSize: base * 0.046,
              fontFamily: 'L',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        SizedBox(height: h * 0.03),
        SizedBox(
          height: h * 0.058,
          child: TextFormField(
            readOnly: true,
            controller: TextEditingController(text: selectedPriceType),
            cursorColor: const Color(0xFFA4A4A4),
            style: TextStyle(
              fontFamily: 'R',
              fontSize: base * 0.034,
              color: const Color(0xFFA4A4A4),
            ),
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              filled: true,
              fillColor: const Color(0xFF2A8DA7).withOpacity(0.09),
              suffixIcon: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF2A8DA7),
                ),
                offset: const Offset(0, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                elevation: 8,
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                onSelected: (value) {
                  setState(() {
                    selectedPriceType = value;
                  });
                },
                itemBuilder: (context) {
                  final options = ["Fixed Price", "Horal Price"]
                      .where((opt) => opt != selectedPriceType)
                      .toList();

                  return options.map((opt) {
                    return PopupMenuItem<String>(
                      value: opt,
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          child: Text(
                            opt,
                            style: TextStyle(
                              fontFamily: 'R',
                              fontSize: base * 0.04,
                              color: const Color(0xFFA4A4A4),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: const Color(0xFF2A8DA7).withOpacity(0.09),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: const Color(0xFF2A8DA7).withOpacity(0.09),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: h * 0.01),
        SizedBox(
          height: h * 0.058,
          child: TextFormField(
            controller: widget.amountController,
            keyboardType: TextInputType.number,
            cursorColor: const Color(0xFFA4A4A4),
            style: TextStyle(
              fontFamily: 'R',
              fontSize: base * 0.034,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              hintText: 'Amount...',
              hintStyle: TextStyle(
                fontSize: base * 0.034,
                color: const Color(0xFFA4A4A4),
                fontWeight: FontWeight.w400,
                fontFamily: 'R',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFFA4A4A4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFF2A8DA7)),
              ),
            ),
          ),
        ),
        SizedBox(height: h * 0.01),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Schedule',
            style: TextStyle(
              fontSize: w * 0.05,
              fontFamily: 'M',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: h * 0.01),
        SizedBox(
          height: h * 0.058,
          child: TextFormField(
            controller: widget.scheduleController,
            readOnly: true,
            cursorColor: const Color(0xFFA4A4A4),
            style: TextStyle(
              fontFamily: 'R',
              fontSize: base * 0.034,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              fillColor: const Color(0xFF2A8DA7).withOpacity(0.09),
              hintText: 'Schedule',
              hintStyle: TextStyle(
                fontSize: base * 0.034,
                color: const Color(0xFFA4A4A4),
                fontWeight: FontWeight.w400,
                fontFamily: 'R',
              ),
              suffixIcon: GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF2A8DA7),
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF2A8DA7),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    widget.scheduleController.text = formatDate(pickedDate);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Image.asset(
                    'assets/images/calender.png',
                    height: h * 0.03,
                    width: w * 0.03,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: const Color(0xFF2A8DA7).withOpacity(0.09),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: const Color(0xFF2A8DA7).withOpacity(0.09),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StepFourPage extends StatelessWidget {
  final TextEditingController locationController;

  const StepFourPage({
    super.key,
    required this.locationController,
  });

  @override
  Widget build(BuildContext context) {
    if (locationController.text.trim().isEmpty) {
      locationController.text = "Multan Cantt";
    }

    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Location ',
              style: TextStyle(
                fontSize: w * 0.06,
                fontFamily: 'B',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: h * 0.01),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Enter your location',
              style: TextStyle(
                fontSize: base * 0.046,
                fontFamily: 'L',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(height: h * 0.02),
          const Image(image: AssetImage('assets/images/step6.png')),
          SizedBox(height: h * 0.02),
          SizedBox(
            height: h * 0.058,
            child: TextFormField(
              controller: locationController,
              cursorColor: const Color(0xFFA4A4A4),
              style: TextStyle(
                fontFamily: 'R',
                fontSize: base * 0.034,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your location...',
                hintStyle: TextStyle(
                  fontSize: base * 0.034,
                  color: const Color(0xFFA4A4A4),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'R',
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/locationicon.png',
                    height: h * 0.008,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFA4A4A4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFF2A8DA7)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A8DA7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const dashWidth = 6;
    const dashSpace = 4;

    final rRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(20),
    );

    final path = Path()..addRRect(rRect);

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;

      while (distance < metric.length) {
        final extractPath = metric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}