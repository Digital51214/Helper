import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helper/Models/job%20model.dart';

class JobDetailScreen extends StatelessWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

  List<String> getJobImages() {
    if (job.images.trim().isEmpty) return [];

    List<String> rawImages = [];

    try {
      final decoded = jsonDecode(job.images);

      if (decoded is List) {
        rawImages = decoded.map((e) => e.toString()).toList();
      } else if (decoded is String) {
        rawImages = [decoded];
      }
    } catch (e) {
      rawImages = job.images
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('"', '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return rawImages.map((image) {
      final cleanImage = image.trim();

      if (cleanImage.startsWith("http")) {
        return cleanImage;
      }

      return "https://helpr.digital/$cleanImage";
    }).toList();
  }
  void openImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: InteractiveViewer(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return const SizedBox(
                          height: 250,
                          child: Center(
                            child: Icon(Icons.broken_image, size: 60),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = getJobImages();

    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    return Scaffold(
      backgroundColor: const Color(0xFFFEDECEC),
      body: Column(
        children: [
          SizedBox(height: h * 0.06),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: h * 0.055,
                    width: h * 0.055,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE4F9FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF2A8DA7),
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(width: w * 0.04),
                Text(
                  "Job Details",
                  style: TextStyle(
                    fontFamily: 'B',
                    fontWeight: FontWeight.w700,
                    fontSize: base * 0.06,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.03),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(w * 0.05),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      job.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'B',
                        fontWeight: FontWeight.w700,
                        fontSize: base * 0.055,
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    Text(
                      "Rs ${job.amount}",
                      style: TextStyle(
                        fontFamily: 'SB',
                        color: const Color(0xFF2A8DA7),
                        fontSize: base * 0.045,
                      ),
                    ),
                    SizedBox(height: h * 0.025),

                    detailTile("Category", job.category),
                    detailTile("Description", job.description),
                    detailTile("Schedule", job.schedule),
                    detailTile("Location", job.location),
                    detailTile("Status", job.status),

                    if (images.isNotEmpty) ...[
                      SizedBox(height: h * 0.005),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Job Photos",
                          style: TextStyle(
                            fontFamily: 'M',
                            fontWeight: FontWeight.w500,
                            fontSize: base * 0.04,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.012),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: images.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: w * 0.025,
                          mainAxisSpacing: h * 0.012,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              openImagePreview(context, images[index]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF4F6),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE1E1E1),
                                ),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                images[index],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return job.categoryIcon.isNotEmpty
                                      ? Image.network(
                                    job.categoryIcon,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) {
                                      return const Icon(
                                        Icons.broken_image,
                                        size: 35,
                                        color: Colors.grey,
                                      );
                                    },
                                  )
                                      : const Icon(
                                    Icons.broken_image,
                                    size: 35,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: h * 0.015),
                    ],

                    detailTile("Posted", job.postedAt),
                    detailTile("Created At", job.createdAt),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailTile(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE1E1E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'M',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value.isEmpty ? "N/A" : value,
            style: const TextStyle(
              fontFamily: 'R',
              color: Color(0xFF747474),
            ),
          ),
        ],
      ),
    );
  }
}