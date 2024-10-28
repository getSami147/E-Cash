// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/assets/strings.dart';
import 'package:muzahir_fyp/utils/colors.dart';

class BuildButton extends StatefulWidget {
  bool loading;
  var height, width;
  String? text;
  VoidCallback? onPressed;
  Color backgrounDColor;
  Color textcolor;
  BuildButton({
    super.key,
    this.loading = false,
    this.height = size50,
    this.width = double.infinity,
    this.textcolor = Colors.white,
    this.backgrounDColor = primaryColor,
    required this.onPressed,
    required this.text,
  });

  @override
  State<BuildButton> createState() => _BuildButtonState();
}

class _BuildButtonState extends State<BuildButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12), // Set your desired radius here
            ),
            backgroundColor: widget.backgrounDColor,
          ),
          child: widget.loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  widget.text.toString(),
                  style: TextStyle(
                      color: widget.textcolor,
                      fontFamily: font_montserrat,
                      fontSize: size15,
                      fontWeight: FontWeight.w500),
                )),
    );
  }
}
