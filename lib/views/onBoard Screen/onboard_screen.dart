import 'package:flutter/material.dart';
import 'package:message_wise/views/onboard%20Screen/components/body.dart';
import 'package:message_wise/size_config.dart';

class OnBoardScreen extends StatelessWidget {
  static String routeName = "/onboarding";

  const OnBoardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
    );
  }
}
