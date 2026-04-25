import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/jobs_apis%20service.dart';
import 'package:helper/Authontication_Services/session%20manager%20for%20post%20jobs.dart';
import 'package:helper/Models/job%20model.dart';
import 'package:helper/bottom_screens/postjob_screen.dart';
import 'package:helper/job_Detail_screen.dart';

class Myjobs extends StatefulWidget {
  const Myjobs({super.key});

  @override
  State<Myjobs> createState() => _MyjobsState();
}

class _MyjobsState extends State<Myjobs> {
  bool isLoading = true;
  List<JobModel> allJobs = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    try {
      final clientId = await SessionManager4.getClientId();

      if (clientId == null || clientId == 0) {
        if (mounted) {
          setState(() {
            allJobs = [];
          });
        }
        print("CLIENT ID NOT FOUND. User login/register client_id save nahi hua.");
        return;
      }

      final response = await JobService.getClientHome(clientId: clientId);

      if (response["success"] == true) {
        final List activeRawList =
        response["active_jobs"] is List ? response["active_jobs"] : [];

        final List inactiveRawList =
        response["inactive_jobs"] is List ? response["inactive_jobs"] : [];

        final activeList = activeRawList
            .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e)))
            .where((job) => job.clientId == clientId)
            .toList();

        final inactiveList = inactiveRawList
            .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e)))
            .where((job) => job.clientId == clientId)
            .toList();

        final Map<int, JobModel> uniqueJobs = {};

        for (final job in activeList) {
          uniqueJobs[job.id] = job;
        }

        for (final job in inactiveList) {
          uniqueJobs[job.id] = job;
        }

        if (mounted) {
          setState(() {
            allJobs = uniqueJobs.values.toList();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            allJobs = [];
          });
        }
      }
    } catch (e) {
      print("MY JOBS ERROR: $e");

      if (mounted) {
        setState(() {
          allJobs = [];
        });
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    return Scaffold(
      backgroundColor: const Color(0xFFFEDECEC),
      body: Column(
        children: [
          SizedBox(height: h * 0.08),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Jobs',
                  style: TextStyle(
                    fontFamily: 'B',
                    fontWeight: FontWeight.w700,
                    fontSize: base * 0.065,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PostjobScreen()),
                    ).then((_) => fetchJobs());
                  },
                  child: const Icon(
                    Icons.add_circle,
                    color: Color(0xFF2A8DA7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.04),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2A8DA7),
                ),
              )
                  : allJobs.isEmpty
                  ? RefreshIndicator(
                color: const Color(0xFF2A8DA7),
                onRefresh: fetchJobs,
                child: ListView(
                  children: [
                    SizedBox(height: h * 0.28),
                    Center(
                      child: Text(
                        "No jobs found",
                        style: TextStyle(
                          fontFamily: 'M',
                          fontSize: base * 0.045,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                color: const Color(0xFF2A8DA7),
                onRefresh: fetchJobs,
                child: ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: allJobs.length,
                  itemBuilder: (context, index) {
                    return JobCard(job: allJobs[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final JobModel job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    final bool isActive = job.status.toLowerCase() == "active";

    final Color mainColor =
    isActive ? const Color(0xFF2A8DA7) : const Color(0xFFEFB32C);

    final Color bgColor =
    isActive ? const Color(0xFFEAF4F6) : const Color(0xFFFDF7EA);

    return Container(
      margin: EdgeInsets.only(bottom: h * 0.012),
      height: h * 0.225,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCDCDCD)),
      ),
      child: Row(
        children: [
          Container(
            height: h * 0.215,
            width: w * 0.02,
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                topLeft: Radius.circular(18),
              ),
            ),
          ),
          SizedBox(width: w * 0.03),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: w * 0.02,
                right: w * 0.02,
                top: h * 0.02,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: base * 0.15,
                        width: base * 0.15,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: job.fullJobImage.isNotEmpty
                              ? Image.network(
                            job.fullJobImage,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return job.categoryIcon.isNotEmpty
                                  ? Image.network(
                                job.categoryIcon,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                    Image.asset(
                                      'assets/images/home6.png',
                                    ),
                              )
                                  : Image.asset(
                                'assets/images/home6.png',
                              );
                            },
                          )
                              : job.categoryIcon.isNotEmpty
                              ? Image.network(
                            job.categoryIcon,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                Image.asset(
                                  'assets/images/home6.png',
                                ),
                          )
                              : Image.asset(
                            'assets/images/home6.png',
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title,
                              style: TextStyle(
                                fontSize: base * 0.038,
                                fontFamily: 'SB',
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: h * 0.005),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: const Color(0xFF959595),
                                  size: base * 0.045,
                                ),
                                SizedBox(width: w * 0.01),
                                Expanded(
                                  child: Text(
                                    job.location,
                                    style: TextStyle(
                                      fontSize: base * 0.028,
                                      fontFamily: 'R',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.018),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/home5.png',
                        height: base * 0.05,
                        width: base * 0.05,
                      ),
                      SizedBox(width: w * 0.005),
                      Text(
                        job.postedAt,
                        style: TextStyle(
                          fontSize: base * 0.02,
                          fontFamily: 'R',
                        ),
                      ),
                      SizedBox(width: w * 0.032),
                      Image.asset(
                        'assets/images/home4.png',
                        height: base * 0.05,
                        width: base * 0.05,
                      ),
                      SizedBox(width: w * 0.01),
                      Text(
                        job.appliedCount,
                        style: TextStyle(
                          fontSize: base * 0.02,
                          fontFamily: 'R',
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFD7EBDC)
                              : const Color(0xFFE2DDD3),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: w * 0.01,
                          horizontal: w * 0.03,
                        ),
                        child: Text(
                          isActive ? "Active" : "InActive",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'M',
                            fontSize: base * 0.03,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.022),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobDetailScreen(job: job),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isActive
                                ? Colors.black
                                : const Color(0xFF959595),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: w * 0.02,
                            horizontal: w * 0.03,
                          ),
                          child: Text(
                            'See Details',
                            style: TextStyle(
                              fontFamily: 'B',
                              fontWeight: FontWeight.w700,
                              fontSize: base * 0.03,
                              color: Colors.white,
                            ),
                          ),
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
    );
  }
}