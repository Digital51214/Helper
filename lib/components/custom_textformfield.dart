import 'package:flutter/material.dart';

class CustomTextformField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool obsecureText;
  final Widget? sufixIcon;
  final TextInputType keyBoardType;

  const CustomTextformField({
    super.key,
    required this.title,
    required this.controller,
    this.obsecureText = false,
    this.sufixIcon,
    required this.keyBoardType,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height*0.058,
      child: TextFormField(
        keyboardType: keyBoardType,
        obscureText: obsecureText,
        controller: controller,
        cursorColor: Colors.grey,
        style: TextStyle(color: Colors.grey),
        decoration: InputDecoration(
          hintText: title,
          hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
          suffixIcon: sufixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
              color: Color(0xFFCDCDCD)
          )
          ),
          focusedBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Color(0xFFCDCDCD)
              )
          ),
        ),
      ),
    );
  }
}
