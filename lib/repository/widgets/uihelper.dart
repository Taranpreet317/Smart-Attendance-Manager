import 'package:flutter/material.dart';


class Uihelper {
  static CustomText({
    required String text,
    required Color color,
    required FontWeight fontweight,
    required double fontsize,
    String? fontfamily,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontweight,
        fontSize: fontsize,
        fontFamily: fontfamily,
      ),
    );
  }

  static Widget CustomButton({
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    required double width,
    required double height,
    required double fontsize,
    FontWeight? fontweight,
    IconData? icon,
    Color? iconColor,
    double? iconSize,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: iconColor, size: iconSize),
            if (icon != null) SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontsize,
                fontWeight: fontweight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget CustomTextField({
    required TextEditingController controller,
    required hintText,
    bool? Obscure,
    required textColor,
    required fillColor,
    required double borderRadius,
    Widget? suffixIcon,
    Widget? prefixIcon,
    required TextStyle hintStyle,
    Border? enabledBorder,
    Border? focusedBorder,
    Color? focusedBorderColor,
    Color? enabledBorderColor,
    TextInputType? keyboardType,
    bool? obscureText,
  }) {
    return TextField(
      style: TextStyle(color: textColor),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor ?? Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }

  static Widget CustomContainer({
    required icon,
    required text1,
    required text2,
    required circlecolor,
    required iconcolor,
    required containercolor,
  }) {
    return Container(
      height: 150,
      width: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: containercolor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: circlecolor,
            child: Icon(icon, color: iconcolor),
          ),
          SizedBox(height: 10),
          Text(text1, style: TextStyle(color: Colors.black, fontSize: 14)),
          Text(
            text2,
            style: TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
