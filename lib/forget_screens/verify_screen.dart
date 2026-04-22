import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helper/Authontication_Services/Authorization_services.forgetpassword.dart';
import 'package:helper/Authontication_Services/session_manager2.forgetpassword.dart';
import 'package:helper/change_password.dart';
import 'package:helper/components/container_button.dart';
import 'package:helper/components/custom_widgets.dart';

class VerifyScreen extends StatefulWidget {
  final String sentTo;
  final bool isPhone;

  const VerifyScreen({
    super.key,
    required this.sentTo,
    required this.isPhone,
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(6, (index) => FocusNode());

  final ForgotPasswordService _forgotPasswordService =
  ForgotPasswordService();

  bool _isLoading = false;
  bool _isResending = false;

  Timer? _timer;
  int _secondsRemaining = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _checkOtpStateOnOpen();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _secondsRemaining = 0;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      }
    });
  }

  Future<void> _checkOtpStateOnOpen() async {
    final isExpired = await SessionManager.isForgotOtpExpired();
    final isConsumed = await SessionManager.isForgotOtpConsumed();
    final userId = await SessionManager.getForgotUserId();

    if (!mounted) return;

    if (userId == null || userId == 0 || isExpired || isConsumed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP expired. Please request a new OTP.'),
        ),
      );
      _clearOtpFields();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();

    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _clearOtpFields() {
    for (final c in _controllers) {
      c.clear();
    }
    if (_focusNodes.isNotEmpty) {
      FocusScope.of(context).requestFocus(_focusNodes.first);
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyOtp() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    final enteredOtp = _controllers.map((e) => e.text).join().trim();

    if (enteredOtp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete 6 digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final int? savedOtp = await SessionManager.getForgotOtp();
      final int? userId = await SessionManager.getForgotUserId();
      final bool isExpired = await SessionManager.isForgotOtpExpired();
      final bool isConsumed = await SessionManager.isForgotOtpConsumed();

      if (!mounted) return;

      if (userId == null || userId == 0 || savedOtp == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please request a new OTP.'),
          ),
        );
        return;
      }

      if (isExpired) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP has expired. Please resend OTP.'),
          ),
        );
        _clearOtpFields();
        return;
      }

      if (isConsumed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This OTP has already been used. Please resend OTP.'),
          ),
        );
        _clearOtpFields();
        return;
      }

      if (enteredOtp != savedOtp.toString()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP'),
          ),
        );
        return;
      }

      await SessionManager.markForgotOtpVerified(true);
      await SessionManager.markForgotOtpConsumed();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UpdatePasswordScreen(
            otp: enteredOtp,
            userId: userId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_secondsRemaining > 0 || _isResending) return;

    setState(() => _isResending = true);

    try {
      final response = await _forgotPasswordService.sendForgotPasswordOtp(
        email: widget.isPhone ? null : widget.sentTo,
        phone: widget.isPhone ? widget.sentTo : null,
      );

      if (!mounted) return;

      if (response.success) {
        await SessionManager.saveForgotPasswordSession(
          userId: response.userId,
          otp: response.otp,
          sentTo: widget.sentTo,
          isPhone: widget.isPhone,
        );

        _clearOtpFields();
        _startTimer();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message.isNotEmpty
                  ? response.message
                  : 'Failed to resend OTP',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  Widget _buildOtpBox({
    required int index,
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width * 0.12,
      height: height * 0.065,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: TextStyle(
          fontSize: width * 0.045,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.03),
            borderSide: const BorderSide(color: Color(0xFF95CC81)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.03),
            borderSide: const BorderSide(color: Color(0xFF95CC81)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.03),
            borderSide: const BorderSide(color: Color(0xFF95CC81)),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index + 1 < _focusNodes.length) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            if (index - 1 >= 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return WillPopScope(
      onWillPop: () async {
        final isVerified = await SessionManager.isForgotOtpVerified();

        if (isVerified) {
          await SessionManager.markForgotOtpConsumed();
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.04,
                  right: width * 0.04,
                  top: height * 0.07,
                ),
                child: Column(
                  children: [
                    CustomWidgets(title: 'Verify'),
                    SizedBox(height: height * 0.03),
                    Image(
                      image: const AssetImage('assets/images/forget1.png'),
                      height: height * 0.25,
                      width: width * 0.45,
                    ),
                    SizedBox(height: height * 0.05),
                    Row(
                      children: [
                        Text(
                          'Enter Code',
                          style: TextStyle(
                            fontFamily: 'B',
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.054,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.isPhone
                                ? 'Enter code sent to your phone'
                                : 'Enter code sent to your email',
                            style: TextStyle(
                              fontFamily: 'R',
                              fontWeight: FontWeight.w400,
                              fontSize: width * 0.03,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.sentTo,
                            style: TextStyle(
                              fontFamily: 'SB',
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.033,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                            (index) => _buildOtpBox(
                          index: index,
                          width: width,
                          height: height,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.025),

                    if (_secondsRemaining > 0)
                      Text(
                        'OTP Expire in ${_formatTime(_secondsRemaining)}sec',
                        style: TextStyle(
                          fontFamily: 'R',
                          fontSize: width * 0.035,
                          color: Colors.grey.shade700,
                        ),
                      )
                    else
                      Row(
                        children: [
                          Text("OTP Expired!",
                            style: TextStyle(
                              fontFamily: 'R',
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),),
                          Spacer(),
                          GestureDetector(
                            onTap: _isResending ? null : _resendOtp,
                            child: Text(
                              _isResending ? 'Resending...' : 'Resend OTP',
                              style: TextStyle(
                                fontFamily: 'SB',
                                fontWeight: FontWeight.w600,
                                fontSize: width * 0.038,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: height * 0.04),
                    ContainerButton(
                      title: _isLoading ? 'Please Wait...' : 'Verify',
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _verifyOtp,
                    ),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            ),
            if (_isLoading || _isResending)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}