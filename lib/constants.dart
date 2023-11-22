import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:message_wise/size_config.dart';

const kPrimaryColor = Colors.deepOrange;
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = GoogleFonts.poppins(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: getProportionateScreenHeight(1.5),
);
final appBarHeadingStyle = GoogleFonts.poppins(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: getProportionateScreenHeight(1.5),
);

const defaultDuration = Duration(milliseconds: 250);

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}

String currentTime() {
  final now = DateTime.now();
  final formatter = DateFormat('HH:mm');
  return formatter.format(now);
}
