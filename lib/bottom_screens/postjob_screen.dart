import 'package:flutter/material.dart';
import 'package:helper/bottom_screens/bottom_navigation_screen.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PostjobScreen extends StatefulWidget {
  const PostjobScreen({super.key});

  @override
  State<PostjobScreen> createState() => _PostjobScreenState();
}

class _PostjobScreenState extends State<PostjobScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  void nextPage() {
    if (currentPage < 3) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
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
            // 🔹 Back Button
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  if (currentPage > 0) {
                    // Agar Step 2,3,4 pe hai, pehle page pe chala jao
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // Agar Step 1 pe hai, BottomNavigationScreen ke index 0 pe navigate karo
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavigationScreen(currentIndex: 0),
                      ),
                    );
                  }
                },
                child: Container(
                  height: h * 0.13,
                  width: w * 0.13,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4F9FF),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: w * 0.025),
                    child: const Icon(Icons.arrow_back_ios,
                        size: 20, color: Color(0xFF2A8DA7)),
                  ),
                ),
              ),
            ),


            // 🔹 Step Text
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

            // 🔹 Indicators
            Row(
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: w * 0.012),
                  height: h * 0.005,
                  width: w * 0.201,
                  decoration: BoxDecoration(
                    color: index <= currentPage
                        ? Color(0xFF2A8DA7)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),

            SizedBox(height: h * 0.03),

            // 🔹 Pages
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  StepOnePage(),
                  StepTwoPage(),
                  StepThreePage(),
                  StepFourPage(),
                ],
              ),
            ),
          ],
        ),
      ),

      // 🔹 Bottom Next / Finish Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05, // horizontal padding responsive
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: h * 0.035), // bottom padding responsive
            child: GestureDetector(
              onTap: () {
                if (currentPage < 3) {
                  // Next page in PageView
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Last page -> Navigate to BottomNavigationScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavigationScreen(currentIndex: 3),
                    ),
                  );
                }
              },
              child: Container(
                height: h*0.072, // responsive height
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                  child: Text(
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

///Step1
///Step1
class StepOnePage extends StatefulWidget {
  const StepOnePage({super.key});

  @override
  State<StepOnePage> createState() => _StepOnePageState();
}

class _StepOnePageState extends State<StepOnePage> {
  int selectedIndex = -1; // -1 = koi select nahi

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    Widget buildOption(
        int index,
        String label,
        String status,
        Color color,
        Widget icon,
        ) {
      bool isSelected = selectedIndex == index;

      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          height: h * 0.155,
          width: w * 0.435,
          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xFF2A8DA7).withOpacity(0.09)
                : Colors.white,
            border: Border.all(
              color:
              isSelected ? Color(0xFF2A8DA7) : const Color(0xFFCDCDCD),
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
                  style: TextStyle(
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
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

                    /// First Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildOption(
                          0,
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
                          1,
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

                    /// Second Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildOption(
                          2,
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
                          3,
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
            ),
          ),
        );
      },
    );
  }
}


class StepTwoPage extends StatefulWidget {
  const StepTwoPage({super.key});

  @override
  State<StepTwoPage> createState() => _StepTwoPageState();
}

class _StepTwoPageState extends State<StepTwoPage> {
  List<File> selectedImages = [];

  /// 🔹 Pick Multiple Images from gallery
  Future<void> pickImage() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        selectedImages.addAll(pickedFiles.map((e) => File(e.path)).toList());
      });
    }
  }

  /// 🔹 Open Image in Centered Container with Close Button
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Title
          Text(
            'Job Details',
            style: TextStyle(
              fontSize: w * 0.06,
              fontFamily: 'B',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: h * 0.01),

          /// 🔹 Subtitle
          Text(
            'Enter all the required details',
            style: TextStyle(
              fontSize: base * 0.046,
              fontFamily: 'L',
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: h * 0.03),

          /// 🔹 Job Title Field
          SizedBox(
            height: h*0.058,
            child: TextFormField(
              cursorColor: Color(0xFFA4A4A4),
              style: TextStyle(
                fontFamily: 'R',
                fontSize: base * 0.034,
                color: Color(0xFFA4A4A4),
              ),
              decoration: InputDecoration(
                hintText: 'Job Title...',
                hintStyle: TextStyle(
                  fontSize: base * 0.034,
                  color: Color(0xFFA4A4A4),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'R',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFA4A4A4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFA4A4A4)),
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.014),

          /// 🔹 Description Field
          SizedBox(
            height: h*0.15,
            child: TextFormField(
              cursorColor: Color(0xFFA4A4A4),
              maxLines: 4,
              style: TextStyle(
                fontFamily: 'R',
                fontSize: base * 0.034,
                color: Color(0xFFA4A4A4),
              ),
              decoration: InputDecoration(
                hintText: 'Description...',
                hintStyle: TextStyle(
                  fontSize: base * 0.034,
                  color: Color(0xFFA4A4A4),
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
                  borderSide: const BorderSide(color: Color(0xFFA4A4A4)),
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.02),

          /// 🔹 Add Photos Text
          Text(
            'Add Photos',
            style: TextStyle(
              fontSize: base * 0.035,
              fontFamily: 'M',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: h * 0.017),

          /// 🔹 Dotted Border Upload Container
          GestureDetector(
            onTap: () {
              pickImage(); // Har click par new images add hongi
            },
            child: SizedBox(
              height: h*0.15,
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
                              SizedBox(height: 8),
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
                                  crossAxisCount: 3, // 3 columns
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6,
                                  childAspectRatio: 1,
                                ),
                            itemBuilder: (context, index) {
                              // 🔹 Last Item = Add Button
                              if (index == selectedImages.length) {
                                return GestureDetector(
                                  onTap: () {
                                    pickImage();
                                  },
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

                              // 🔹 Image Item with Remove Button
                              return Stack(
                                children: [
                                  /// 🔹 Image
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

                                  /// 🔹 Close Button
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedImages.removeAt(index);
                                        });
                                      },
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

/// 🔹 Dotted Border Painter
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
        final extractPath = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 🔹 STEP 3
class StepThreePage extends StatefulWidget {
  const StepThreePage({super.key});

  @override
  State<StepThreePage> createState() => _StepThreePageState();
}

class _StepThreePageState extends State<StepThreePage> {
  TextEditingController scheduleController = TextEditingController();
  String selectedPriceType = "Fixed Price";

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

        /// 🔹 Subtitle
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

        /// 🔹 Job Title Field
        SizedBox(
          height: h*0.058,
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
              contentPadding: EdgeInsets.symmetric(vertical: 2,horizontal: 8),
              filled: true,
              fillColor: const Color(0xFF2A8DA7).withOpacity(0.09),
              hintText: selectedPriceType.isEmpty ? 'Select Price Type' : null,
              hintStyle: TextStyle(
                fontSize: base * 0.034,
                color: const Color(0xFFA4A4A4),
                fontWeight: FontWeight.w400,
                fontFamily: 'R',
              ),

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

                /// 👇 full se thori kam width
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
          height: h*0.058,
          child: TextFormField(
            keyboardType: TextInputType.number,
            cursorColor: Color(0xFFA4A4A4),
            style: TextStyle(
              fontFamily: 'R',
              fontSize: base * 0.034,
              color: Color(0xFFA4A4A4),
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2,horizontal: 8),
              hintText: 'Amount...',
              hintStyle: TextStyle(
                fontSize: base * 0.034,
                color: Color(0xFFA4A4A4),
                fontWeight: FontWeight.w400,
                fontFamily: 'R',
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFFA4A4A4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFFA4A4A4)),
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

        // Pehle controller create karo
        SizedBox(
          height: h*0.058,
          child: TextFormField(
            controller: scheduleController,
            readOnly: true,
            // User direct type na kare, sirf picker se select kare
            cursorColor: Color(0xFFA4A4A4),
            style: TextStyle(
              fontFamily: 'R',
              fontSize: base * 0.034,
              color: Color(0xFFA4A4A4),
            ),
            decoration: InputDecoration(
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 2,horizontal: 8),
              fillColor: Color(0xFF2A8DA7).withOpacity(0.09),
              hintText: 'Schedule',
              hintStyle: TextStyle(
                fontSize: base * 0.034,
                color: Color(0xFFA4A4A4),
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
                          colorScheme: ColorScheme.light(
                            primary: Color(0xFF2A8DA7),
                            // ✅ Selected date circle color
                            onPrimary: Colors.white,
                            // ✅ Selected date number color
                            onSurface: Colors.black, // ✅ Unselected dates color
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Color(
                                0xFF2A8DA7,
                              ), // ✅ Buttons color (Cancel, OK)
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    scheduleController.text =
                        "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(11.0),
                  child: Image.asset(
                    'assets/images/calender.png',
                    height: h * 0.03,
                    width: w * 0.03,
                  ),
                ),
              ),

              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:  BorderSide(color:Color(0xFF2A8DA7).withOpacity(0.09)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:  BorderSide(color: Color(0xFF2A8DA7).withOpacity(0.09)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 🔹 STEP 4
class StepFourPage extends StatefulWidget {
  const StepFourPage({super.key});

  @override
  State<StepFourPage> createState() => _StepFourPageState();
}

class _StepFourPageState extends State<StepFourPage> {
  @override
  Widget build(BuildContext context) {
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

          /// 🔹 Subtitle
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
          Image(image: AssetImage('assets/images/step6.png')),
          SizedBox(height: h * 0.02),
          SizedBox(
            height: h*0.058,
            child: TextFormField(
              cursorColor: Color(0xFFA4A4A4),
              style: TextStyle(
                fontFamily: 'R',
                fontSize: base * 0.034,
                color: Color(0xFFA4A4A4),
              ),
              decoration: InputDecoration(
                hintText: 'Enter your location...',
                hintStyle: TextStyle(
                  fontSize: base * 0.034,
                  color: Color(0xFFA4A4A4),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'R',
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage('assets/images/locationicon.png'),
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
                  borderSide: const BorderSide(color: Color(0xFFA4A4A4)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
