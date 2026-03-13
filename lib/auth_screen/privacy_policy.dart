import 'package:flutter/material.dart';

import '../components/custom_widgets.dart';
class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  late final size = MediaQuery.of(context).size;
  late final w = size.width;
  late final h = size.height;
  late final safeBottom = MediaQuery.of(context).padding.bottom;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Padding(
      padding: EdgeInsets.only(left: w*0.03,right: w*0.03, top: h*0.07),
      child: Column(
        children: [
          CustomWidgets(title: 'Privacy Policy'),
          SizedBox(height: h*0.01),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curability in mattes ante. Nam ac diam quits dolor lobotomist euismod et get nun. Curability perambulator, nib vel sultriness commode, libero tort riviera veldt, sed elementum nun purus sed ante. Done sit amet biennium tells. Integer vehicular est quits Lauris euismod, dalesman c  Lorem ipsum dolor sit amet, consecrate adipiscing elit. Curability in mattes ante. Nam ac diam quits dolor lobotomist euismod et get nun. Curability perambulator, nibh vel ultricies commodo, libero tortor viverra velit, sed elementum nunc purus sed ante. Donec sit amet bibendum tellus. Integer vehicula est quis mauris euismod, malesuada c Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in mattis ante. Nam ac diam quis dolor lobortis euismod et eget nunc. Curabitur ullamcorper, nibh vel ultricies commodo, libero tortor viverra velit, sed elementum nunc purus sed ante. Donec sit amet bibendum tellus. Integer vehicula est quis mauris euismod, malesuada cLorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in mattis ante. Nam ac diam quis dolor lobortis euismod et eget nunc. Curabitur ullamcorper, nibh vel ultricies commodo, libero tortor viverra velit, sed elementum nunc purus sed ante. Donec sit amet bibendum tellus. Integer vehicula est quis mauris euismod, malesuada c    ',
                style: TextStyle(fontFamily: 'L',fontSize: 14,fontWeight: FontWeight.w300),
              ),
            ),
          ),
      ],),
      )
    );
  }
}
