import 'package:flutter/material.dart';
import 'package:helper/change_password.dart';
import 'package:helper/components/container_button.dart';
import 'package:helper/components/custom_widgets.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.07,
          ),
          child: Column(
            children: [
              CustomWidgets(title: 'Verify'),

              SizedBox(height: height * 0.02),

              Image(
                image: AssetImage('assets/images/forget1.png'),
                height: height * 0.25,
                width: width * 0.45,
              ),

              SizedBox(height: height * 0.04),

              Row(
                children: [
                  Text(
                    'Enter Code',
                    style: TextStyle(
                      fontFamily: 'B',
                      fontWeight: FontWeight.w700,
                      fontSize: width * 0.06,
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.01),

              Row(
                children: [
                  Text(
                    'Enter Code sent to your mail',
                    style: TextStyle(
                      fontFamily: 'R',
                      fontWeight: FontWeight.w400,
                      fontSize: width * 0.035,
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
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
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(width * 0.03),
                          borderSide:
                          BorderSide(color: Color(0xFF95CC81)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(width * 0.03),
                          borderSide:
                          BorderSide(color: Color(0xFF95CC81)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(width * 0.03),
                          borderSide:
                          BorderSide(color: Color(0xFF95CC81)),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1) {
                          if (index + 1 < _focusNodes.length) {
                            FocusScope.of(context)
                                .requestFocus(_focusNodes[index + 1]);
                          } else {
                            FocusScope.of(context).unfocus();
                          }
                        } else if (value.isEmpty) {
                          if (index - 1 >= 0) {
                            FocusScope.of(context)
                                .requestFocus(_focusNodes[index - 1]);
                          }
                        }
                      },
                    ),
                  );
                }),
              ),

              SizedBox(height: height * 0.04),

              ContainerButton(
                title: 'Verify',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePassword(),
                    ),
                  );
                },
              ),

              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
