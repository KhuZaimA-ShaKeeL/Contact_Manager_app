import 'package:flutter/material.dart';
class Mytextfield extends StatelessWidget {
  IconData? prefixIcon;
  String? hintText;
  TextInputType ?textInputType;

  TextEditingController controller;
   Mytextfield({super.key,this.prefixIcon,this.hintText,required this.controller,this.textInputType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(

          prefixIcon: Icon(prefixIcon),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
      ),
    );
  }
}
