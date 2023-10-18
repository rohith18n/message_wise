import 'package:flutter/material.dart';
import 'package:message_wise/constants.dart';
import 'package:message_wise/size_config.dart';

class CustomOtpField extends StatelessWidget {
  const CustomOtpField(
      {super.key,
      required this.controller,
      required this.onChanged,
      this.focusNode});
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(40),
      height: getProportionateScreenWidth(45),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        obscureText: true,
        style: const TextStyle(fontSize: 14),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: otpInputDecoration,
        onChanged: onChanged,
      ),
    );
  }
}
