import 'package:flutter/material.dart';
import 'package:message_wise/size_config.dart';
import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";

  const OtpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("OTP Verification")),
      ),
      body: const Body(),
    );
  }
}
