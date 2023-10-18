import 'package:flutter/material.dart';
import 'package:message_wise/constants.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: 0.7, // Adjust the scale factor as needed
        child: const CircularProgressIndicator(
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
