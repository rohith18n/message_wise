import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:message_wise/components/custom_surfix_icon.dart';
import 'package:message_wise/util.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.hintText,
      required this.svgIcon,
      required this.validator,
      this.obscureText,
      this.keyboardType});
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String svgIcon;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      style: GoogleFonts.poppins(color: colorblack),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: svgIcon),
      ),
    );
  }
}
