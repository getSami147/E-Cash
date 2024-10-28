
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:muzahir_fyp/assets/spacing.dart';
import 'package:muzahir_fyp/assets/strings.dart';
import 'package:muzahir_fyp/utils/colors.dart';

import 'package:nb_utils/nb_utils.dart';

import 'Constant.dart';

// Elevated button .....................................>>>
// ignore: must_be_immutable
class elevatedButton extends StatelessWidget {
  VoidCallback? onPress;
  var isStroked = false;
  double? elevation;
  Widget? child;
  ValueChanged? onFocusChanged;
  Color backgroundColor;
  Color bodersideColor;
  var height;
  var width;
  var borderRadius;
  var loading;

  elevatedButton(
    BuildContext context, {
    Key? key,
    this.loading = false,
    var this.isStroked = false,
    this.onFocusChanged,
    required var this.onPress,
    this.elevation,
    var this.child,
    var this.backgroundColor = primaryColor,
    var this.bodersideColor = primaryColor,
    var this.borderRadius = 10.0,
    var this.height = 50.0,
    var this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          onFocusChange: onFocusChanged,
          onPressed: onPress,
          style: isStroked
              ? ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder())
              : ElevatedButton.styleFrom(
                  elevation: elevation,
                  side: BorderSide(color: bodersideColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius)),
                  backgroundColor: backgroundColor,
                ),
          child: loading
              ? const CircularProgressIndicator(
                  color: color_white,
                  strokeWidth: 2,
                )
              : child),
    );
  }
}

// Elevated button .....................................>>>Finished

class textButton extends StatelessWidget {
  VoidCallback? ontap;
  String? text;
  Color? color;

  textButton({
    this.ontap,
    this.color = primaryColor,
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: ontap,
        child: Text(
          text.toString(),
          style: TextStyle(
              fontSize: size15,
              color: color,
              fontWeight: FontWeight.w400,
              fontFamily: font_montserrat),
        ));
  }
} 

class CustomDropdownButton extends StatelessWidget {
  final String hint;
 final List<DropdownMenuItem<String>>? items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  // final TextStyle textStyle;
  // final EdgeInsets padding;
  final String? value;

  const CustomDropdownButton({
    required this.hint,
    this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    // required this.textStyle,
    // required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 4),
                spreadRadius: 0,
                color: const Color(0xff000000).withOpacity(.1))
          ]),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 10),
        border: InputBorder.none,),
        hint: text(hint),
        value: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

  //formatNumber ammout formatter
String ammoutFormatter(int number) {
  final formatter = NumberFormat('#,##0');
  return formatter.format(number);
}
  // Function to format DateTime
String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  return DateFormat("dd MMMM y 'at' hh:mm a").format(dateTime);
}
// Helper function to capitalize the first letter
String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
// Text widget .....................................>>>Start
Widget text(String? text,
    {var fontSize = textSizeMedium,
    Color? textColor,
    TextStyle? googleFonts,
    var fontFamily = 'Poppins',
    var isCentered = false,
    var maxLine = 1,
    TextOverflow? overflow,
    var latterSpacing = 0.5,
    bool textAllCaps = false,
    var isLongText = false,
    bool lineThrough = false,
    var fontWeight = FontWeight.w400}) {
  return Text(
    textAllCaps ? text!.toUpperCase() : capitalizeFirstLetter(text!),
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: overflow,
    style: googleFonts ??
        TextStyle(
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: textColor ?? textprimaryColor,
          height: 1.5,
          letterSpacing: latterSpacing,
          decoration:
              lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
        ),
  );
}

class utils {
  // toastMethod .....................
  void toastMethod(message,
      {backgroundColor = primaryColor, textColor = Colors.white}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0);
  }



  // FormFocusChange.....................
  void formFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

// Text TextFromFeild...........................................>>>
class CustomTextFormField extends StatelessWidget {
  final VoidCallback? onPressed;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final ValueChanged<String>? onFieldSubmitted;

  final double height;
  final String? hintText;
  final Color filledColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final BorderSide? borderSide;
  final bool?isborderSide;
  final bool isPassword;
  final bool isSecure;
  final double fontSize;
  final Color textColor;
  final String? fontFamily;
  final String? text;
  final double suffixWidth;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;

  CustomTextFormField(
    BuildContext context, {
    Key? key,
    this.focusNode,
    this.onFieldSubmitted,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onSaved,
    this.minLines,
    this.onChanged,
    this.height = 80.0,
    this.onPressed,
    this.suffixWidth = 50.0,
    this.hintText,
    this.filledColor = Colors.white,
    this.prefixIcon,
    this.suffixIcon,
    this.borderSide,
    this.isborderSide=true,
    this.fontFamily,
    this.fontSize = 14.0,
    this.isPassword = false,
    this.isSecure = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.text,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 4),
                spreadRadius: 0,
                color: const Color(0xff000000).withOpacity(.1),
              ),
            ],
          ),
          child: TextFormField(
            maxLines: maxLines,
            maxLength:maxLength ,
            focusNode: focusNode,
            minLines: minLines,
            keyboardType: keyboardType,
            onFieldSubmitted: onFieldSubmitted,
            controller: controller,
            obscureText: obscureText,
            onTap: onPressed,
            onSaved: onSaved,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0), // Text ke andar ka space kam karein
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              suffixIconConstraints: BoxConstraints(
                maxHeight: 30,
                maxWidth: suffixWidth,
              ),
              filled: true,
              fillColor: Colors.white,
              border:isborderSide==true? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ): OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none
              ),
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14.0),
            ),
          ),
        ),
      ],
    );
  }
}

// Text TextFromFeild end...........................................>>>
