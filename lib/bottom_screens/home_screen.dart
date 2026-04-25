import 'package:flutter/material.dart';
import 'package:helper/Authontication_Services/session_manager.dart';
import 'package:helper/Authontication_Services/jobs_apis%20service.dart';
import 'package:helper/Authontication_Services/session%20manager%20for%20post%20jobs.dart';
import 'package:helper/Models/job%20model.dart';
import 'package:helper/bottom_screens/postjob_screen.dart';
import 'package:helper/job_Detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String _profilePic = '';
  bool _isProfileLoading = true;

  bool isJobsLoading = true;
  List<JobModel> allJobs = [];

  @override
  void initState() {
    super.initState();
    refreshHomeData();
  }

  Future<void> refreshHomeData() async {
    await _loadProfilePic();
    await fetchJobs();
  }

  Future<void> _loadProfilePic() async {
    try {
      final profilePic = await SessionManager.getProfilePic();

      if (!mounted) return;

      setState(() {
        _profilePic = SessionManager.normalizeProfilePic(profilePic);
        _isProfileLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isProfileLoading = false;
      });
    }
  }

  Future<void> fetchJobs() async {
    if (mounted) {
      setState(() => isJobsLoading = true);
    }

    try {
      final clientId = await SessionManager4.getClientId();

      if (clientId == null || clientId == 0) {
        if (mounted) {
          setState(() {
            allJobs = [];
          });
        }
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
      print("HOME JOBS ERROR: $e");

      if (mounted) {
        setState(() {
          allJobs = [];
        });
      }
    } finally {
      if (mounted) {
        setState(() => isJobsLoading = false);
      }
    }
  }

  Widget _buildTopProfileAvatar(double radius) {
    if (_isProfileLoading) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_profilePic.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(_profilePic),
        onBackgroundImageError: (_, __) {
          print('===== HOME SCREEN IMAGE LOAD ERROR =====');
          print('FAILED URL: $_profilePic');
        },
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      backgroundImage: const AssetImage('assets/images/home1.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final base = size.shortestSide;

    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      body: Stack(
        children: [
          Positioned(
            top: h * 0.34,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.06,
                vertical: h * 0.03,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(base * 0.08),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: h * 0.012),
                child: Column(
                  children: [
                    SizedBox(height: w * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Jobs",
                          style: TextStyle(
                            fontFamily: 'M',
                            fontSize: base * 0.048,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PostjobScreen(),
                              ),
                            ).then((_) => refreshHomeData());
                          },
                          child: const Icon(
                            Icons.add_circle,
                            color: Color(0xFF2A8DA7),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: w * 0.05),
                    Expanded(
                      child: isJobsLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2A8DA7),
                        ),
                      )
                          : allJobs.isEmpty
                          ? RefreshIndicator(
                        color: const Color(0xFF2A8DA7),
                        onRefresh: refreshHomeData,
                        child: ListView(
                          physics:
                          const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: h * 0.18),
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
                        onRefresh: refreshHomeData,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            bottom: h * 0.09,
                          ),
                          itemCount: allJobs.length,
                          itemBuilder: (context, index) {
                            return HomeJobCard(job: allJobs[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              children: [
                SizedBox(height: h * 0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTopProfileAvatar(base * 0.06),
                    Container(
                      height: base * 0.135,
                      width: base * 0.135,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.notifications,
                          size: base * 0.07,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.04),
                Row(
                  children: [
                    Text(
                      "Find Your\nPerfect Help!",
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontSize: base * 0.06,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: w * 0.07),
                    Image.asset("assets/images/home3.png", height: h * 0.09),
                  ],
                ),
                SizedBox(height: h * 0.035),
                Container(
                  height: h * 0.058,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(base * 0.08),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: base * 0.04,
                        offset: Offset(0, h * 0.006),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    cursorColor: const Color(0xFFA4A4A4),
                    style: TextStyle(fontSize: base * 0.035),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(base * 0.04),
                        child: Image.asset(
                          'assets/images/searchicon.png',
                          height: h * 0.005,
                          fit: BoxFit.contain,
                        ),
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: base * 0.03,
                        fontFamily: 'R',
                        color: const Color(0xFFA4A4A4),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: h * 0.022),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeJobCard extends StatelessWidget {
  final JobModel job;

  const HomeJobCard({super.key, required this.job});

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
                                      fontWeight: FontWeight.w400,
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
                          fontWeight: FontWeight.w400,
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
                          fontWeight: FontWeight.w400,
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